//
//  NewPageView.swift
//  Luna
//
//  Created by Ned O'Rourke on 11/4/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewPageView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var pageManager : PageHandler
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var manager : LocationManager
    
    @Binding var newPage : Bool
    
    @State var tab = 0
    @FocusState private var isFocused: Bool
    
    //Case 0
    @State var pageName : String = ""
    @State var categories : [String] = ["House", "Techno", "Drum and base"]
    @State var pageCategories : [String] = []

    //Case 1
    @State var showBanner : Bool = false
    @State var showLogo : Bool = false
    @State var bannerImage : UIImage?
    @State var logoImage : UIImage?
    
    //Case 2
    @State var pageDescription : String = ""
    @State var placeholderText : String = "Description"
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                switch tab {
                    
                case 0:
                    VStack (alignment: .center) {
                        HStack {
                            Text("What is the name?")
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
                        
                        HStack {
                            VStack (alignment: .leading) {
                                Text("What category fits you best?")
                                Text("Select 2")
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                     HStack {
                                        ForEach(categories, id: \.self) { category in
                                            Text(category)
                                                .padding(5)
                                                .background(pageCategories.contains(category) ? .purple : .purple.opacity(0.4))
                                                .foregroundColor(.white)
                                                .cornerRadius(5)
                                                .onTapGesture {
                                                    withAnimation {
                                                        if !pageCategories.contains(category) && pageCategories.count < 2 {
                                                            pageCategories.append(category)
                                                        }
                                                        else {
                                                            withAnimation {
                                                                if let index = pageCategories.firstIndex(of: category) {
                                                                    pageCategories.remove(at: index)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                        }

                        
                        Spacer()
                        
                        Button {
                            if (pageName != "" && pageCategories.count != 0) {
                                self.tab += 1
                            }
                            
                        } label: {
                            Text("Continue")
                                .frame(width: UIScreen.main.bounds.width*0.8, height: 30, alignment: .center)
                                .padding(.horizontal)
                                .padding(.bottom)
                                .background(pageName != "" && pageCategories.count != 0 ? .purple : .purple.opacity(0.4))
                                .foregroundColor(.white)
                                .cornerRadius(10)

                        }
                    }
                    
                
                case 1:
                    VStack (alignment: .center) {
                        HStack {
                            Text("Pick your images")
                            Spacer()
                        }
                        
                        ZStack {
                            GeometryReader { proxy in
                                let size = proxy.size
                                
                                VStack {
                                    if let image = self.bannerImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        Color.purple.opacity(0.4)
                                    }
                                }
                                .frame(width: size.width, height: 200, alignment: .bottom)
                                .cornerRadius(10)
                                .onTapGesture {
                                    showBanner.toggle()
                                }
                                
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
                                .offset(x: 10, y: 10)
                                .onTapGesture {
                                    showLogo.toggle()
                                }
                                
                                
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            if (bannerImage != nil && logoImage != nil) {
                                self.tab += 1
                            }
                            
                        } label: {
                            Text("Continue")
                                .frame(width: UIScreen.main.bounds.width*0.8, height: 30, alignment: .center)
                                .padding(.horizontal)
                                .padding(.bottom)
                                .background(bannerImage != nil && logoImage != nil ? .purple : .purple.opacity(0.4))
                                .foregroundColor(.white)
                                .cornerRadius(10)

                        }
                    }
                    .fullScreenCover(isPresented: $showBanner, onDismiss: nil) {
                           ImagePicker(image: $bannerImage)
                    }
                    .fullScreenCover(isPresented: $showLogo, onDismiss: nil) {
                           ImagePicker(image: $logoImage)
                    }
                    .toolbar {
                        Button {
                            self.tab += 1
                        } label: {
                            Text("skip")
                                .foregroundColor(.purple)
                        }
                    }
                
                case 2:
                    VStack (alignment: .leading) {
                        HStack {
                            Text("Describe your page")
                            Spacer()
                        }
                        
                        ZStack {
                            if self.pageDescription.isEmpty {
                                    TextEditor(text: $placeholderText)
                                        .font(.body)
                                        .foregroundColor(.gray)
                                        .disabled(true)
                                        .padding(10)
                                        .frame(maxHeight: 150)
                            }
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
                        
                        Spacer()
                        
                        Button {
                            self.tab += 1
                            
                        } label: {
                            Text("Continue")
                                .frame(width: UIScreen.main.bounds.width*0.8, height: 30, alignment: .center)
                                .padding(.horizontal)
                                .padding(.bottom)
                                .background(.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)

                        }
                        
                    }
                    .toolbar {
                        Button {
                            self.tab += 1
                        } label: {
                            Text("skip")
                                .foregroundColor(.purple)
                        }
                    }
                
                case 3:
                    VStack (alignment: .leading) {
                        HStack {
                            Text("Review Your page")
                            Spacer()
                        }
                        
                        GeometryReader { proxy in
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
                            .frame(width: proxy.size.width, height: proxy.size.height*0.8, alignment: .center)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 0.5)
                            )
                        }
                    
                        Spacer()
                        
                        Button {
    //                        print("yeh")
//                            pageManager.createPage(pageName: pageName, pageDescription: pageDescription, pageCategories: pageCategories.joined(separator: ","), pageAdmins: sessionService.userDetails.uid, bannerImage: bannerImage ?? UIImage(named: "stockPageLogo")!, logoImage: logoImage ?? UIImage(named: "stockPageLogo")!, completion: () -> ())
                            
                        } label: {
                            Text("Create")
                                .frame(width: UIScreen.main.bounds.width*0.8, height: 30, alignment: .center)
                                .padding(.horizontal)
                                .padding(.bottom)
                                .background(.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)

                        }
                    }
                    
                default:
                    Text("fail")
                }
            }
            .padding(.horizontal)
            .navigationBarHidden(false)
            .navigationTitle("Create your page")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                Button {
                    newPage = false
                } label: {
                    Image(systemName: "xmark")
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
                Image(uiImage: logoImage!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .cornerRadius(32)

                VStack (alignment: .leading) {
                    Text(pageName)
                        .font(.system(size: 20))
                        .fontWeight(.medium)

                    Text(pageCategories[0])
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
            
            if pageManager.promotedEvent != nil {
                VStack {
                    
                    ZStack (alignment: .topTrailing) {
                        
                        HStack {
                            Spacer()
                            MyEventsEventView(event: pageManager.promotedEvent!, clickable: true)
                            Spacer()
                        }
                    }
                }
                
                
                Divider()
            }
        }
        .padding(.horizontal)
        .background(.white)
        .cornerRadius(20)
        .offset(y: -18)
    
    }
}

struct NewPageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewPageView(newPage: .constant(true))
                .environmentObject(ViewModel())
                .environmentObject(SessionServiceImpl())
                .environmentObject(LocationManager())
        }
        
    }
}
