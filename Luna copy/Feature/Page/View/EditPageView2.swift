//
//  EditPageView2.swift
//  Luna
//
//  Created by Ned O'Rourke on 3/6/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore

struct EditPageView2: View {
    
    //Environment Objects
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var pageManager : PageHandler
    
    //General
    @State var currentTab = 0
    @Binding var page : PageObj
    @Binding var showEditPage : Bool
    
    //Genral
    @State var pageName = ""
    @State var pageChosenCategories : [String] = []
    
    //Description
    @State var pageDescription =  ""
    init(page: Binding<PageObj>, showEditPage: Binding<Bool>) {
        UITextView.appearance().backgroundColor = .clear
        self._page = page
        self._showEditPage = showEditPage
    }
    
    //Images
    @State var showBanner = false
    @State var showLogo = false
    @State var bannerImage : UIImage?
    @State var logoImage : UIImage?
    
    //Hosts
    @State var showSearch = false
    @State var searchTerm = ""
    @State var pageAdmins: [UserObj] = []
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                
                editPageTab(currentTab: $currentTab)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                
                
                VStack (alignment: .leading) {
                    if currentTab == 0 {
                        //NAME
                        Text("What is the name of your page?")
                            .foregroundColor(.white)
                        TextField("", text: $pageName)
                            .font(.system(size: 40, weight: .heavy))
                            .multilineTextAlignment(TextAlignment.leading)
                            .foregroundColor(.white)
                            .disableAutocorrection(true)
                            .placeholder(when: pageName.isEmpty, alignment: .leading) {
                                Text("Page Name")
                                    .font(.system(size: 40, weight: .heavy))
                                    .foregroundColor(Color("darkSecondaryText")).opacity(0.3)
                            }
                        
                        //Categories
                        Text("What categories fits you best? (up to 2)")
                            .foregroundColor(.white)
                        
                        ScrollView {
                            VStack(alignment: .leading) {
                                let xd = TagsView(items: pageManager.pageCategories)
                                ForEach(xd.groupedItems, id: \.self) { subItems in
                                    HStack {
                                        ForEach(subItems, id: \.self) { word in
                                            Text(word)
                                                .fixedSize()
                                                .padding()
                                                .background(pageChosenCategories.contains(word) ? .purple : .purple.opacity(0.4))
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                                .onTapGesture {
                                                    withAnimation {
                                                        if !pageChosenCategories.contains(word) && pageChosenCategories.count < 2 {
                                                            pageChosenCategories.append(word)
                                                        }
                                                        else {
                                                            withAnimation {
                                                                if let index = pageChosenCategories.firstIndex(of: word) {
                                                                    pageChosenCategories.remove(at: index)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    else if currentTab == 1 {
                        Text("Describe your page")
                            .foregroundColor(.white)
                        
                        TextEditor(text: $pageDescription)
                            .simultaneousGesture(TapGesture().onEnded({
                                if self.pageDescription == "Description" {
                                    self.pageDescription = ""
                                }
                            }))
                    }
                    
                    else if currentTab == 2 {
                        //Banner Image
                        Text("Pick your banner image")
                            .foregroundColor(.white)
                        
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
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 200)
                        .cornerRadius(10)
                        .onTapGesture {
                            showBanner.toggle()
                        }
                        
                        Text("Pick your logo image")
                            .foregroundColor(.white)
                        
                        VStack {
                            if let image = self.logoImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                WebImage(url: URL(string: page.logo_url))
                                    .resizable()
                            }
                        }
                        .frame(minWidth: 100, maxWidth: 100)
                        .frame(height: 100)
                        .cornerRadius(50)
                        .onTapGesture {
                            showLogo.toggle()
                        }
                    }
                    
                    else if currentTab == 3 {
                        HStack (alignment: .center) {
                            Text("Add any other admins")
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    self.showSearch.toggle()
                                }
                            } label: {
                                if self.showSearch {
                                    Image(systemName: "magnifyingglass")
                                        .padding(4)
                                        .background(.purple.opacity(0.3))
                                        .foregroundColor(.purple)
                                        .cornerRadius(40)
                                }
                                else {
                                    Image(systemName: "magnifyingglass")
                                        .padding(4)
                                        .cornerRadius(10)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        
                        if self.showSearch {
                            VStack {
                                TextField("Search Luna", text: $searchTerm)
                            }
                            .padding(.leading)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 45, alignment: .leading)
                            .background(Color("darkForeground").opacity(0.2))
                            .cornerRadius(5)
                            .onChange(of: searchTerm) { newTerm in
                                sessionService.searchVenues(term: searchTerm, option: 2)
                            }
                        }
                       
                        
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack {
                                if showSearch && sessionService.searchPeopleResults.count > 0 {
                                    ForEach(sessionService.searchPeopleResults, id: \.self) { friend in
                                        VStack {
                                            WebImage(url: URL(string: friend.imageURL)!)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: UIScreen.main.bounds.width*0.15, height: UIScreen.main.bounds.width*0.15)
                                                .cornerRadius(100)
                                            
                                            Text("\(friend.firstName) \(friend.lastName)")
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(width: 100, height: 100)
                                        .padding(5)
                                        .padding(.horizontal, 5)
                                        .background(Color("darkForeground").opacity(0.3))
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            if !pageAdmins.contains(friend) {
                                                pageAdmins.append(friend)
                                            }
                                        }
                                    }
                                }
                                
                                else {
                                    ForEach(sessionService.currentFriends, id: \.self) { friend in
                                        VStack {
                                            WebImage(url: URL(string: friend.imageURL)!)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: UIScreen.main.bounds.width*0.15, height: UIScreen.main.bounds.width*0.15)
                                                .cornerRadius(100)
                                            
                                            Text("\(friend.firstName) \(friend.lastName)")
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(width: 100, height: 100)
                                        .padding(5)
                                        .padding(.horizontal, 5)
                                        .background(Color("darkForeground").opacity(0.3))
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            if !pageAdmins.contains(friend) {
                                                pageAdmins.append(friend)
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                        Text("Your Admins (tap to remove)")
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack {
                                if self.pageAdmins != [] {
                                    ForEach(self.pageAdmins, id: \.self) { admin in
                                        ZStack (alignment: .topTrailing) {
                                            VStack {
                                                WebImage(url: URL(string: admin.imageURL)!)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: UIScreen.main.bounds.width*0.15, height: UIScreen.main.bounds.width*0.15)
                                                    .cornerRadius(100)
                                                
                                                Text("\(admin.firstName) \(admin.lastName)")
                                                    .multilineTextAlignment(.center)
                                            }
                                            
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                        .frame(width: 100, height: 100)
                                        .padding(5)
                                        .padding(.horizontal, 5)
                                        .background(Color("darkForeground").opacity(0.3))
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            if admin.uid != sessionService.userDetails.uid {
                                                let index = Int(self.pageAdmins.firstIndex(of: admin)!)
                                                self.pageAdmins.remove(at: index)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
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
                    
                    var adminIDS : [String] = []
                    for admin in pageAdmins {
                        adminIDS.append(admin.uid)
                    }
                    
                    if adminIDS != page.admins {
                        db.collection("pages").document(page.id).updateData([
                            "admins" : adminIDS
                        ])
                        
                        for admin in page.admins {
                            if !adminIDS.contains(admin) {
                                db.collection("profiles").document(admin).updateData([
                                    "pages" : FieldValue.arrayRemove([page.id])
                                ])
                            }
                        }
                        
                        for admin in adminIDS {
                            if !page.admins.contains(admin) {
                                db.collection("profiles").document(admin).updateData([
                                    "pages" : FieldValue.arrayUnion([page.id])
                                ])
                            }
                        }
                    }
                    
                    if page.categories != pageChosenCategories {
                        db.collection("pages").document(page.id).updateData([
                            "categories" : pageChosenCategories
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
                    VStack {
                        Text("Save Changes")
                    }
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, idealHeight: 40, maxHeight: 40, alignment: .center)
                    .background(.purple.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.bottom)
                }

                
                
            }
            .padding(.horizontal)
            .background(Color("darkBackground"))
            .onAppear {
                pageManager.getPageCategories()
                Task {
                    await  pageManager.getPageAdmins(id: page.id, completion: {
                        self.pageAdmins = pageManager.pageAdmins
                    })
                }
                self.pageName = page.name
                self.pageChosenCategories = page.categories
                self.pageDescription = page.description
            }
            .fullScreenCover(isPresented: $showBanner, onDismiss: nil) {
                   ImagePicker(image: $bannerImage)
            }
            .fullScreenCover(isPresented: $showLogo, onDismiss: nil) {
                   ImagePicker(image: $logoImage)
            }
            .navigationBarTitle("Edit Your Page", displayMode: .inline)
            .toolbar {
                Button {
                    showEditPage.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                }

            }
        }
    }
}

//struct EditPageView2_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPageView2(page: PageObj(id: "", name: "Scenes", email: "", description: "lol xd", promotedEvent: "", events: [], banner_url: "https://scontent.fsyd8-1.fna.fbcdn.net/v/t39.30808-6/273044221_284772693749062_274659856556264380_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=e3f864&_nc_ohc=jEoKX88y57wAX9ZOfuK&_nc_ht=scontent.fsyd8-1.fna&oh=00_AT9z8o0id6Pukji9FPGirrr6HD0UFxRsGlSbKUh98SSbdA&oe=629DD6EF", logo_url: "https://scontent.fsyd8-1.fna.fbcdn.net/v/t1.6435-9/200649635_139540311605635_918823717422474070_n.png?_nc_cat=111&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=2CvUpl8YsmgAX-I2oR1&_nc_ht=scontent.fsyd8-1.fna&oh=00_AT8_NogfgnPiNDbBLhjO1GP2EMsCSpVjaCZ4jyfmA5BDyQ&oe=62B61ED4", categories: ["House", "Minimal"], followers: [], admins: [], website: ""), showEditPage: .constant(true))
//            .environmentObject(SessionServiceImpl())
//            .environmentObject(PageHandler())
//    }
//}

struct editPageTab: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    
    var tabBarOptions: [String] = ["General", "Description", "Images", "Hosts"]
    
    var body: some View {
        HStack (alignment: .bottom) {
                ForEach(Array(zip(self.tabBarOptions.indices,
                                  self.tabBarOptions)),
                        id:\.0,
                        content: {
                    index, name in
                    topTabItem(currentTab: self.$currentTab, namespace: namespace.self, tabBarItemName: name, tab: index)
                })
            }
            .background(.clear)
    }
}
