//
//  EditPageView.swift
//  Luna
//
//  Created by Ned O'Rourke on 13/4/22.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore

struct EditPageView: View {
    
    @Binding var showEditPage: Bool
    @FocusState private var isFocused: Bool
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var pageManager : PageHandler
    @Binding var page: PageObj
    
    @State var showBanner = false
    @State var showLogo = false
    
    @State var bannerImage : UIImage?
    @State var logoImage : UIImage?
    
    @State var bannerChange : Bool = false
    @State var logoChange : Bool = false
    
    @State var adminsAdded: [String] = []
    @State var adminsRemoved: [String] = []
    
    @State var adminsObjectsAdded: [UserObj] = []
    @State var adminsObjectsRemoved: [UserObj] = []
    
//    @State var pageAdmins : [UserObj] = []
//    @State var pageAdminIDs : [String] = []
    @State var searchPadding: CGFloat = 0
    @State var pageTerm: String = ""
    @State var pageDescription : String = ""
    
    @State var pageName : String = ""
    @State var categories : [String] = ["DJ Group", "Organiser", "Band"]
    @State var pageCategories : [String] = []
    

    @State var showAlert : Bool = false
    @State var loading : Bool = false
    
    @State var showRemoveAdmin = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack (alignment: .leading) {
                        HStack {
                            Text("Name")
                            Spacer()
                        }
    
                        TextField("Page Name", text: $pageName)
                            .padding(10)
                            .focused($isFocused)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5,
                                                     style: .continuous)
                                        .stroke(isFocused ? Color.purple : Color.gray.opacity(0.5))
                                }
                            )
                    }
                    
                    VStack (alignment: .leading) {
                        HStack {
                            Text("Description")
                            Spacer()
                        }
    
                        ZStack {
                            TextEditor(text: $pageDescription)
                                .font(.body)
                                .opacity(self.pageDescription.isEmpty ? 0.25 : 1)
                                .padding(10)
                                .focused($isFocused)
                                .frame(maxHeight: 150)
                                .background(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5,
                                                         style: .continuous)
                                            .stroke(isFocused ? Color.purple : Color.gray.opacity(0.5))
                                    }
                                )
                        }
    
    //                    Spacer()
                }
                    
                    VStack (alignment: .leading) {
                        Text("Category (Select 1)")
//                        Text("Select 1")
                        ScrollView {
                            VStack(alignment: .leading) {
                                let tagsView = TagsView(items: pageManager.pageCategories)
                                ForEach(tagsView.groupedItems, id: \.self) { subItems in
                                    HStack {
                                        ForEach(subItems, id: \.self) { word in
                                            Text(word)
                                                .fixedSize()
                                                .padding()
                                                .background(pageCategories.contains(word) ? .purple : .purple.opacity(0.4))
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                                .onTapGesture {
                                                    withAnimation {
                                                        if !pageCategories.contains(word) && pageCategories.count < 3 {
                                                            pageCategories.append(word)
                                                        }
                                                        else {
                                                            withAnimation {
                                                                if let index = pageCategories.firstIndex(of: word) {
                                                                    pageCategories.remove(at: index)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
    //                                                if tags.count >= 1 {
    //                                                    continueBool = true
    //                                                }
    //                                                else {
    //                                                    continueBool = false
    //                                                }
                                                }
                                        }
                                    }
                                }
                            }
                        }
//                        ScrollView(.horizontal, showsIndicators: false) {
//                             HStack {
//                                ForEach(categories, id: \.self) { category in
//                                    Text(category)
//                                        .padding(5)
//                                        .background(pageCategories.contains(category) ? .purple : .purple.opacity(0.4))
//                                        .foregroundColor(.primary)
//                                        .cornerRadius(5)
//                                        .onTapGesture {
//                                            withAnimation {
//                                                if !pageCategories.contains(category) && pageCategories.count < 1 {
//                                                    pageCategories.append(category)
//                                                }
//                                                else {
//                                                    withAnimation {
//                                                        if let index = pageCategories.firstIndex(of: category) {
//                                                            pageCategories.remove(at: index)
//                                                        }
//                                                    }
//                                                }
//                                            }
//
//                                        }
//                                }
//                            }
//                        }
                    }
                    .padding(.bottom, 5)
                    VStack (alignment: .leading) {
                        Text("Page Admins")
                            
                        TextField("Search Luna", text: $pageTerm)
                            .padding(10)
                            .padding(.leading, searchPadding)
                            .background(
                                ZStack (alignment: .leading) {
                                    HStack (spacing: 5){
                                        ForEach(self.adminsObjectsAdded, id: \.self) { profile in
                                            WebImage(url: URL(string: profile.imageURL))
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 20, height: 20).cornerRadius(20)
                                                .clipped()
                                                .onTapGesture {
                                                    withAnimation {
                                                        if let index = adminsAdded.firstIndex(of: profile.uid) {
                                                            adminsAdded.remove(at: index)
                                                            self.searchPadding = CGFloat((self.adminsAdded.count) * 25)
                                                        }
                                                        
                                                        if let index = adminsObjectsAdded.firstIndex(of: profile) {
                                                            adminsObjectsAdded.remove(at: index)
                                                    
                                                        }
    
                                                    }
                                                }
                                        }
                                    }
                                    .padding(.leading, 10)
    
                                    RoundedRectangle(cornerRadius: 5,
                                                     style: .continuous)
                                        .stroke(Color.gray.opacity(0.5))
                                }
                            )
                            .onChange(of: pageTerm) { newTerm in
                                sessionService.searchVenues(term: pageTerm, option: 2)
                            }
                        
    
                        if sessionService.searchPeopleResults.count != 0 {
                            withAnimation {
                                VStack (alignment: .leading, spacing: 0) {
                                    ScrollView {
                                        ForEach(sessionService.searchPeopleResults, id: \.self) { profile in
                                            if !pageManager.pageAdmins.contains(profile) {
                                                HStack {
                                                    WebImage(url: URL(string: profile.imageURL))
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 20, height: 20).cornerRadius(20)
                                                        .clipped()
        
                                                    Spacer()
        
                                                    Text("\(profile.firstName) \(profile.lastName)")
                                                }
                                                .frame(height: 20)
                                                .padding(.top, 5)
                                                .onTapGesture {
                                                    withAnimation {
                                                        
                                                        adminsObjectsAdded.append(profile)
                                                        adminsAdded.append(profile.uid)
    //                                                    self.pageAdminIDs.append(profile.uid)
    //                                                    self.pageAdmins.append(profile)
                                                        
                                                        self.pageTerm = ""
                                                        sessionService.searchPeopleResults = []
                                                        self.searchPadding = CGFloat((self.adminsAdded.count) * 25)
                                                    }
                                                }
                                                Divider()
                                            }
                                        }
                                    }
                                }
                                .frame(height: 75)
                            }
                        }
                        
                        VStack (alignment: .leading, spacing: 0) {
                            ScrollView {
                                ForEach(pageManager.pageAdmins, id: \.self) { profile in
                                    HStack {
                                        WebImage(url: URL(string: profile.imageURL))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 20, height: 20).cornerRadius(20)
                                            .clipped()

                                        Text("\(profile.firstName) \(profile.lastName)")
                                            .foregroundColor(adminsRemoved.contains(profile.uid) ? .red : .primary)
                                            .lineLimit(1)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "xmark")
                                            .foregroundColor(adminsRemoved.contains(profile.uid) ? .red : .primary)
                                    }
                                    .frame(height: 20)
                                    .padding(.top, 5)
                                    .onTapGesture {
                                        withAnimation {
                                            
//
                                                if adminsRemoved.contains(profile.uid) {
                                                    if let index = adminsRemoved.firstIndex(of: profile.uid) {
                                                        adminsRemoved.remove(at: index)
                                                    }
                                                    if let index = adminsObjectsRemoved.firstIndex(of: profile) {
                                                        adminsObjectsRemoved.remove(at: index)
                                                    }
                                                } else {
                                                    if adminsRemoved.count < pageManager.pageAdmins.count - 1 {
                                                        adminsRemoved.append(profile.uid)
                                                        adminsObjectsRemoved.append(profile)
                                                    }
                                                }
                                            
                            
                                        }
                                    }
                                    Divider()
                                }
                            }
                        }
                        .frame(height: 75)
                        
                        
                    }
                    
                    HStack {
                        Text("Change page profile image")
                        Spacer()
                    }
                    
                    VStack (alignment: .leading) {
                        if let image = self.logoImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                        } else {
                            WebImage(url: URL(string: page.logo_url))
                                .resizable()
                        }
                    }
                    .frame(width: 80, height: 80, alignment: .center)
                    .cornerRadius(40)
                    .offset(x: 10, y: 10)
                    .onTapGesture {
                        showLogo.toggle()
                    }
                    
                    Spacer()
                    Spacer()
                    
                    VStack (alignment: .center) {
                        HStack {
                            Text("Change banner image")
                            Spacer()
                        }
                        
                        
    
//                        ZStack {
                        GeometryReader { proxy in
                            let size = proxy.size

                            VStack {
                                if let image = self.bannerImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    WebImage(url: URL(string: page.banner_url))
                                        .resizable()
                                        .scaledToFill()
                                }
                            }
                            .frame(width: size.width, height: 200, alignment: .bottom)
                            .cornerRadius(10)
                            .onTapGesture {
                                showBanner.toggle()
                            }
                            


                        }
//                        }
    
                        Spacer()
                        
                        
    
    
                    }
                    .fullScreenCover(isPresented: $showBanner, onDismiss: nil) {
                           ImagePicker(image: $bannerImage)
                    }
                    .fullScreenCover(isPresented: $showLogo, onDismiss: nil) {
                           ImagePicker(image: $logoImage)
                    }

                }
                .navigationBarTitle("Update Page", displayMode: .inline)
                .padding(.horizontal)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            if( page.name != pageName || page.description != pageDescription || page.categories != pageCategories || adminsAdded != [] || adminsRemoved != []) {
                                showAlert.toggle()
                            }
                            else {
                                showEditPage.toggle()
                            }
                        } label: {
                            Text("Cancel")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            if page.name != pageName {
                                db.collection("pages").document(page.id).updateData([
                                    "name" : pageName
                                ])
                            }
                            
                            if page.description != pageDescription {
                                db.collection("pages").document(page.id).updateData([
                                    "description" : pageDescription
                                ])
                            }
                            
                            if adminsAdded != [] || adminsRemoved != [] {
                                let newAdmins = (page.admins + adminsAdded).filter { !adminsRemoved.contains($0) }

                                db.collection("pages").document(page.id).updateData([
                                    "admins" : newAdmins
                                ])
                                for admin in (newAdmins) {
                                    db.collection("profiles").document(admin).updateData([
                                        "pages" : FieldValue.arrayUnion([page.id])
                                    ])
                                }
                                for removedAdmin in adminsRemoved {
                                    db.collection("profiles").document(removedAdmin).updateData([
                                        "pages" : FieldValue.arrayRemove([page.id])
                                    ])
                                }
                            }
                            
                            if page.categories != pageCategories {
                                db.collection("pages").document(page.id).updateData([
                                    "categories" : pageCategories
                                ])
                            }
                            
                            if  self.bannerImage != nil && self.logoImage != nil {
                                pageManager.storePageBannerImage(image: bannerImage!, eventRef: page.id, completion: {
                                    pageManager.storePageLogoImage(image: logoImage!, eventRef: page.id, completion: {})
                                })
                            }
                            
                            if self.bannerImage != nil {
                                pageManager.storePageBannerImage(image: bannerImage!, eventRef: page.id, completion: {})
                            }
                            
                            if self.logoImage != nil{
                                pageManager.storePageLogoImage(image: logoImage!, eventRef: page.id, completion: {})
                            }
                            
                            pageManager.refreshPage(page: page, completion: {
                                page = pageManager.updatedPage!
                                showEditPage.toggle()
                            })
                            
                            
                            
                        } label: {
                            Text("Submit")
                        }
                    }
                }
                .alert("Cancel Edit?", isPresented: $showAlert, actions: {
                    // 1
                      Button("Cancel", role: .cancel, action: {})

                      Button("I'm sure", role: .destructive, action: {
                          showEditPage.toggle()})
                    }, message: {
                      Text("You will lose all changes")
                    })
            }
            .onAppear {
                self.pageDescription = page.description
                self.pageName = page.name
                self.pageCategories = page.categories
            }
            .task {
                await pageManager.getPageAdmins(id: page.id, completion: {
//                    self.pageAdmins = pageManager.pageAdmins
                })
                await pageManager.getPageCategories()
            }
//            .alert("Confirm Remove Admin", isPresented: $showAlert, actions: {
//                // 1
//                  Button("Cancel", role: .cancel, action: {})
//
//                  Button("I'm sure", role: .destructive, action: {
//                      withAnimation {
//                          if let index = pageAdmins.firstIndex(of: profile) {
//                              pageAdmins.remove(at: index)
//                              self.searchPadding = CGFloat((self.pageAdmins.count) * 25)
//                          }
//
//                          if let index = pageAdminIDs.firstIndex(of: profile.uid) {
//                              pageAdminIDs.remove(at: index)
//                          }
//                      }
//                }, message: {
//
//                })
            
        }
    }
}
//struct EditPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        let page = PageObj(id: "", name: "", email: "", description: "", promotedEvent: "", events: [], banner_url: "", logo_url: "", categories: [], followers: [], admins: [], website: "")
//        VStack {
//            Text("lol")
//        }
//        .sheet(isPresented: .constant(true), onDismiss: nil) {
//            EditPageView(page: page)
//        }
//        
//    }
//}
