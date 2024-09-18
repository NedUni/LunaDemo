//
//  CreatePageView.swift
//  Luna
//
//  Created by Ned O'Rourke on 29/4/2022.
//

import SwiftUI

struct CreatePageView: View {
    
    @Binding var show : Bool
    
    @EnvironmentObject var pageManager : PageHandler
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State var tab : Int = 0
    @State var continueBool : Bool = false
    @State var error : Bool = false
    
    //Case 0
    @State var pageName: String = ""
    @State var pageChosenCategories : [String] = []
    
    //Case 1
    @State var showBanner : Bool = false
    @State var showLogo : Bool = false
    @State var bannerImage : UIImage?
    @State var logoImage : UIImage?
    
    //Case 2
    @State var pageDescription : String = ""
    @State var placeholderText : String = "Description"
    
    //Case 3
    @State var created : Bool = false

    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                switch tab {
                
                case 0:
                    VStack (alignment: .leading, spacing: 0) {
                        VStack (alignment: .leading) {
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
                                .onChange(of: pageName) { newValue in
                                    if newValue.count >= 2 && pageChosenCategories.count >= 1 {
                                        continueBool = true
                                    }
                                    else {
                                        continueBool = false
                                    }
                                }
                        }
                        .ignoresSafeArea(.keyboard)
                        
                        VStack (alignment: .leading) {
                            Text("What categories fits you best?")
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
                                                        
                                                        if pageName.count >= 2 && pageChosenCategories.count >= 1 {
                                                            continueBool = true
                                                        }
                                                        else {
                                                            continueBool = false
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                }
                            }
                            
                        }
                        .padding(.top, 30)
                        Spacer()
                        
                        VStack {
                            
                            NextButton(text: "Continue", isTriggered: $continueBool, signUpTab: $tab)
                        }
                        .padding(.bottom)
                    }
                    .onAppear {
                        if pageName.count >= 2 && pageChosenCategories.count >= 1 {
                            continueBool = true
                        }
                    }
                    .padding(.horizontal)
                    .task {
                        await pageManager.getPageCategories()
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                show = false
                            } label: {
                                Text("cancel")
                            }
                        }
                    }
                    
                case 1:
                    VStack (alignment: .leading, spacing: 0) {
                        VStack (alignment: .leading) {
                            
                            
                            Text("Pick your banner image")
                                .foregroundColor(.white)
                             
                            HStack {
                                Spacer()
                                VStack {
                                        if let image = self.bannerImage {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                        } else {
                                            Color.purple.opacity(0.4)
                                        }
                                    }
                                .frame(width: UIScreen.main.bounds.size.width*0.85, height: 200, alignment: .center)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        showBanner.toggle()
                                    }
                                Spacer()
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
                            .frame(width: 80, height: 80, alignment: .center)
                            .cornerRadius(40)
                            .onTapGesture {
                                showLogo.toggle()
                            }
                            
                            Spacer()
                        }
                        
                        VStack {
                            NextButton(text: "Continue", isTriggered: $continueBool, signUpTab: $tab)
                        }
                        .padding(.bottom)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                tab -= 1
                            } label: {
                                Text("previous")
                            }
                        }
                    }
                    .onAppear {
                        if bannerImage != nil {
                            continueBool = true
                        }
                    }
                    .padding(.horizontal)
                    .fullScreenCover(isPresented: $showLogo, onDismiss: nil) {
                           ImagePicker(image: $logoImage)
                    }
                    .fullScreenCover(isPresented: $showBanner, onDismiss: {
                        if bannerImage != nil {
                            continueBool = true
                        }
                    }) {
                           ImagePicker(image: $bannerImage)
                    }
                    
                case 2:
                    VStack (alignment: .leading, spacing: 0) {
                        VStack (alignment: .leading) {
                            
                            Text("Describe your page")
                                .foregroundColor(.white)
                            
                            ZStack {
                                if self.pageDescription.isEmpty {
                                        TextEditor(text: $placeholderText)
                                            .font(.body)
                                            .foregroundColor(.gray)
                                            .disabled(true)
                                            .padding(-3)
                                            .frame(maxHeight: 150)
                                }
                                TextEditor(text: $pageDescription)
                                    .font(.body)
                                    .opacity(self.pageDescription.isEmpty ? 0.25 : 1)
                                    .padding(-3)
                                    .frame(maxHeight: 150)
                            }
                            
                            Spacer()

                        }
                        
                        VStack {
                            NextButton(text: "Continue", isTriggered: .constant(true), signUpTab: $tab)
                        }
                        .padding(.bottom)

                    }
                    .padding(.horizontal)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                tab -= 1
                            } label: {
                                Text("previous")
                            }
                        }
                    }
                    
                case 3:
                    VStack (alignment: .center, spacing: 0) {
                        VStack (alignment: .leading) {
                            Text("Confirm your page")
                                .foregroundColor(.white)
                                
                            VStack {
                                ScrollView (.vertical, showsIndicators: false) {
                                    VStack (spacing: 0) {
                                        HeaderView()
                                        
                                        VStack {
                                            Content()
                                        }
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.size.width*0.9, height: UIScreen.main.bounds.size.height*0.6, alignment: .center)
                            .cornerRadius(10)
                            .padding(.horizontal)

                            Spacer()
                        }
                        
                        VStack {
                            Button {
                                pageManager.createPage(pageName: pageName, pageDescription: pageDescription, pageCategories: pageChosenCategories.joined(separator: ","), pageAdmins: sessionService.userDetails.uid, bannerImage: bannerImage!, logoImage: (logoImage ??  UIImage(named: "stockPageLogo"))!, completion: {
                                    show = false
                                })
                                
                            } label: {
                                VStack {
                                    Text(pageManager.creatingPage ? "Creating..." : "Create")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .frame(width: UIScreen.main.bounds.width*0.9, height: 55)
                                .background(.purple.opacity(0.8))
                                .cornerRadius(20)
                            }
                        }
                        .padding(.bottom)
                    }
                    .padding(.horizontal)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                tab -= 1
                            } label: {
                                Text("previous")
                            }
                        }
                    }
                    
                
                default:
                    Text("nah")
                }
            }
            .navigationTitle("Create your page")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                Task {
//                    await pageManager.getMyPages(uid: sessionService.userDetails.uid)
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        
        GeometryReader {proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = (size.height + minY)
                        
                
            Image(uiImage: bannerImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: height >= 250 ? height : 250, alignment: .top)
                    .overlay(content: {
                        ZStack (alignment: .bottom) {
                            LinearGradient(colors: [
                                .clear,
                                .black.opacity(0.5)
                            ], startPoint: .top, endPoint: .bottom)
                        }
                    })
                    .cornerRadius(1)
                    .offset(y: -minY)
            
        }
        .frame(height: 200)
    }
    
    @ViewBuilder
    func Content()-> some View {
        VStack (alignment: .leading) {
            HStack (alignment: .center) {
                Image(uiImage: logoImage ?? UIImage(named: "stockPageLogo")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .cornerRadius(32)

                VStack (alignment: .leading) {
                    Text(pageName)
                        .font(.system(size: 20))
                        .fontWeight(.medium)

                    Text(pageChosenCategories.joined(separator: ","))
                        .fontWeight(.light)
                }
                .font(.system(size: 8))
                .padding(.vertical)

                Spacer()
                
                Group {
                    HStack (alignment: .center) {
                        Text("1.2K people like this")
                            .foregroundColor(.secondary)
                            .font(.system(size: 10))

                        Button {
                          print("lol")
                            
                            
                        } label: {
                            Image(systemName: pageManager.isFollowed ? "heart.fill" : "heart")
                        }

                        
                    }
                }

            }
            .padding(.top)
            
            Divider()
            
            VStack (alignment: .leading) {
                Text("100 friends like this page")
            }
            
            Divider()
            
            VStack (alignment: .leading) {
                Text("About these organisers")
                
                LongText(pageDescription, dark: false)
            }
            Divider()
            
            VStack {
                
                ZStack (alignment: .topTrailing) {
                    
                    HStack {
                        Spacer()
                        
//                        let previewPromotedEvent = EventObj(date: "23-10-2022", description: "Trot", endTime: "", id: "id", imageurl: "https://www.contiki.com/six-two/wp-content/uploads/2015/09/sarthak-navjivan-iTZOPe7BpTM-unsplash.jpg", label: "House", startTime: "18:00", invited: [], going: [], interested: [], declined: [], performers: [], userCreated: false, linkedVenueName: "", linkedEvent: "", linkedVenue: "", address: "", ticketLink: "", hostIds: [], hostNames: [], pageCreated: true, tags: [])
                        
                        let previewPromotedEvent = EventObj(id: "id", label: "", description: "", imageurl: "", tags: [], date: "", startTime: "", endTime: "", invited: [], going: [], interested: [], declined: [], hostIDs: [], hostNames: [], performers: [], address: "", linkedVenueName: "", linkedVenue: "", linkedEvent: "", userCreated: true, pageCreated: false, ticketLink: "")
                        
                        MyEventsEventView(event: previewPromotedEvent, clickable: false)
                        Spacer()
                    }
                }
            }
            
            
            Divider()
        }
        .padding(.horizontal)
        .background(.white)
        .cornerRadius(20)
        .offset(y: -18)
    }
        
}

struct CreatePageView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePageView(show: .constant(true))
    }
}
