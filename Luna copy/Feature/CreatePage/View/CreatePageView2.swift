//
//  CreatePageView.swift
//  Luna
//
//  Created by Ned O'Rourke on 2/6/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreatePageView2: View {
    
    //Environment Objects
    @EnvironmentObject var pageManager : PageHandler
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    //General
    @State var currentIndex : Int = 0
    @Binding var showCreatePage : Bool
    init(showCreatePage: Binding<Bool>) {
        UITextView.appearance().backgroundColor = .clear
        self._showCreatePage = showCreatePage
    }
    
    //Error Handling
    @State var error = false
    @State var errorText = ""
    
    //Index 0
    @State var pageName = ""
    @State var pageChosenCategories : [String] = []
    
    //Index 1
    @State var pageDescription = "Description"
    
    //Index 2
    @State var showBanner = false
    @State var showLogo = false
    @State var bannerImage : UIImage?
    @State var logoImage : UIImage?
    
    //Index 3
    @State var showSearch = false
    @State var searchTerm = ""
    @State var pageAdmins : [UserObj] = []
    @State var isCreating = false
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .leading) {
                switch currentIndex {
                    
                case 0:
                    VStack (alignment: .leading, spacing: 5) {
                        
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
                        
                        VStack (alignment: .center) {
                            if self.error {
                                Text(self.errorText)
                                    .foregroundColor(Color("Error"))
                                    .onAppear {
                                        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {
                                            timer in
                                            withAnimation {
                                                self.errorText = ""
                                                self.error = false
                                            }
                                        }
                                    }
                            }
                            
                            Button {
                                if pageName.count < 2 {
                                    withAnimation {
                                        self.errorText = "You must name your page"
                                        self.error = true
                                    }
                                }
                                
                                else if pageChosenCategories.count < 1 {
                                    withAnimation {
                                        self.errorText = "You must select at least 1 category"
                                        self.error = true
                                    }
                                }
                                
                                else if pageName.count >= 2 && pageChosenCategories.count >= 1 {
                                    currentIndex += 1
                                }
                                
                            } label: {
                                
                                VStack {
                                    HStack (spacing: 5) {
                                        ForEach(0..<4, id: \.self) { tab in
                                            Rectangle()
                                                .fill(tab <= self.currentIndex ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, idealHeight: 5, maxHeight: 5, alignment: .center)
                                                .cornerRadius(10)
                                        }
                                    }
                                    
                                    VStack {
                                        Text("Continue")
                                            .font(.system(size: 20))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
                                    .background(pageName.count >= 2 && pageChosenCategories.count >= 1 ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                    .cornerRadius(10)
                                }
                                .padding(.bottom)
                            }
                        }



                    }
                    .onAppear {
                        pageManager.getPageCategories()
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                self.showCreatePage = false
                            } label: {
                                Text("Cancel")
                            }

                        }
                    }
                    
                case 1:
                    VStack (alignment: .leading, spacing: 5) {
                        
                        Text("Describe your page")
                            .foregroundColor(.white)
                        
                        TextEditor(text: $pageDescription)
                            .simultaneousGesture(TapGesture().onEnded({
                                if self.pageDescription == "Description" {
                                    self.pageDescription = ""
                                }
                            }))
                        
                        Spacer()
                        
                        Button {
                            if self.pageDescription != "Description" && self.pageDescription != "" {
                                currentIndex += 1
                            }
                        } label: {
                            VStack {
                                HStack (spacing: 5) {
                                    ForEach(0..<4, id: \.self) { tab in
                                        Rectangle()
                                            .fill(tab <= self.currentIndex ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, idealHeight: 5, maxHeight: 5, alignment: .center)
                                            .cornerRadius(10)
                                    }
                                }
                                
                                VStack {
                                    Text("Continue")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
                                .background(self.pageDescription != "Description" && self.pageDescription != "" ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                .cornerRadius(10)
                            }
                            .padding(.bottom)
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                currentIndex -= 1
                            } label: {
                                Text("Back")
                            }

                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                if self.pageDescription == "Description" || self.pageDescription == "" {
                                    currentIndex += 1
                                    self.pageDescription = ""
                                }
                                
                            } label: {
                                if self.pageDescription == "Description" || self.pageDescription == "" {
                                    Text("Skip")
                                }
                            }
                        }
                    }
                    
                case 2:
                    VStack (alignment: .leading, spacing: 5) {
                        
                        //Banner Image
                        Text("Pick your banner image")
                            .foregroundColor(.white)
                        
                        VStack {
                            if let image = self.bannerImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Color.purple.opacity(0.4)
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
                                Image("stockPageLogo")
                                    .resizable()
                            }
                        }
                        .frame(minWidth: 100, maxWidth: 100)
                        .frame(height: 100)
                        .cornerRadius(50)
                        .onTapGesture {
                            showLogo.toggle()
                        }
                        
                        Spacer()
                        
                        VStack (alignment: .center) {
                            if self.error {
                                Text(self.errorText)
                                    .foregroundColor(Color("Error"))
                                    .onAppear {
                                        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {
                                            timer in
                                            withAnimation {
                                                self.errorText = ""
                                                self.error = false
                                            }
                                        }
                                    }
                            }
                            
                            Button {
                                if self.bannerImage == nil {
                                    withAnimation {
                                        self.errorText = "You must select a banner image"
                                        self.error = true
                                    }
                                }
                                
                                else if self.logoImage == nil {
                                    withAnimation {
                                        self.errorText = "You must select a logo image"
                                        self.error = true
                                    }
                                }
                                else if self.bannerImage != nil && self.logoImage != nil {
                                    if self.pageAdmins == [] {
                                        self.pageAdmins.append(UserObj(firstName: sessionService.userDetails.firstName, lastName: sessionService.userDetails.lastName, uid: sessionService.userDetails.uid, imageURL: sessionService.userDetails.imageURL, friends: sessionService.userDetails.friends, favourites: sessionService.userDetails.favourites, streak: sessionService.userDetails.streak, performer: sessionService.userDetails.performer))
                                    }
                                    
                                    sessionService.getFriends(uid: sessionService.userDetails.uid, completion: {
                                        currentIndex += 1
                                    })
                                }
                                
                            } label: {
                                VStack {
                                    HStack (spacing: 5) {
                                        ForEach(0..<4, id: \.self) { tab in
                                            Rectangle()
                                                .fill(tab <= self.currentIndex ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, idealHeight: 5, maxHeight: 5, alignment: .center)
                                                .cornerRadius(10)
                                        }
                                    }
                                    
                                    VStack {
                                        Text("Continue")
                                            .font(.system(size: 20))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
                                    .background(self.bannerImage != nil && self.logoImage != nil ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                    .cornerRadius(10)
                                }
                                .padding(.bottom)
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                currentIndex -= 1
                            } label: {
                                Text("Back")
                            }

                        }
                    }
                    .fullScreenCover(isPresented: $showBanner, onDismiss: nil) {
                           ImagePicker(image: $bannerImage)
                    }
                    .fullScreenCover(isPresented: $showLogo, onDismiss: nil) {
                           ImagePicker(image: $logoImage)
                    }
                    
                case 3:
                    VStack (alignment: .leading, spacing: 5) {
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
                        
                        Spacer()
                        
                        Button {
                            if !self.isCreating {
                                self.isCreating = true
                                var admins : [String] = []
                                for admin in self.pageAdmins {
                                    admins.append(admin.uid)
                                }
                                
                                pageManager.createPage(pageName: self.pageName, pageDescription: self.pageDescription, pageCategories: self.pageChosenCategories.joined(separator: ","), pageAdmins: admins.joined(separator: ","), bannerImage: self.bannerImage!, logoImage: self.logoImage!) {
                                    self.isCreating = false
                                    pageManager.getMyPages(uid: sessionService.userDetails.uid, completion: {
                                        self.showCreatePage = false
                                    })
                                }
                            }
                        } label: {
                            VStack {
                                HStack (spacing: 5) {
                                    ForEach(0..<4, id: \.self) { tab in
                                        Rectangle()
                                            .fill(tab <= self.currentIndex ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, idealHeight: 5, maxHeight: 5, alignment: .center)
                                            .cornerRadius(10)
                                    }
                                }
                                
                                VStack {
                                    Text(self.isCreating ? "Creating..." : "Create Page")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
                                .background(.purple.opacity(0.8))
                                .cornerRadius(10)
                            }
                            .padding(.bottom)
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                currentIndex -= 1
                            } label: {
                                Text("Back")
                            }
                        }
                    }
                default:
                    VStack {
                        Text("fail")
                            
                    }
                }
            }
            .padding(.horizontal)
            .background(Color("darkBackground"))
            .navigationBarTitle("Create Your Page")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

struct CreatePageView2_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            Color("darkBackground")
                .ignoresSafeArea()
            CreatePageView2(showCreatePage: .constant(true))
                .environmentObject(PageHandler())
                .environmentObject(SessionServiceImpl())
        }
        
    }
}
