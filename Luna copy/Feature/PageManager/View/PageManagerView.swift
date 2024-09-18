//
//  PageManagerView.swift
//  Luna
//
//  Created by Ned O'Rourke on 30/3/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PageManagerView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var pageManager : PageHandler
    @EnvironmentObject var manager : LocationManager
    @State var showCreatePage : Bool = false
    
    var body: some View {
        
        VStack {
            ScrollView (showsIndicators: false) {
                ForEach(pageManager.myPages, id: \.self) { page in
                            VStack (spacing: 0) {
                                
                                WebImage(url: URL(string: page.banner_url))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 175)
                                    .clipped()
                                
                                HStack (spacing: 0) {
                                    
                                    NavigationLink(destination: PageView(page: page)
                                        .environmentObject(sessionService)
                                        .environmentObject(manager)
                                        .environmentObject(pageManager)
                                        .environmentObject(homeVM)) {
                                            VStack {
                                                Text("View Page")
                                            }
                                            .frame(height: 40)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                            .foregroundColor(.white)
                                        }
                                        
                                    
                                    Divider()
                                    
                                    VStack {
                                        Text("Analytics")
                                        Text("coming soon")
                                            .foregroundColor(Color("darkSecondaryText"))
                                            .font(.system(size: 10))
                                    }
                                    .frame(height: 40)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                }
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("darkForeground"), lineWidth: 1)
                            )
                    }
                
                NavigationLink(destination: FeedbackView()) {
                    VStack {
                        Text("Submit a Suggestion")
                    }
                    .foregroundColor(.white)
                    .frame(height: 40)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .background(Color("darkForeground").opacity(0.3))
                    .cornerRadius(10)
                    .padding(.bottom)
                }
            }
        }
        .padding(.horizontal)
        .background(Color("darkBackground"))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView())
        .navigationTitle("Your Pages")
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showCreatePage, content: {
            CreatePageView2(showCreatePage : $showCreatePage)
                .environmentObject(pageManager)
                .environmentObject(sessionService)
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.showCreatePage = true
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 30, height: 30)
                        .background(Color("darkBackground"))
                        .foregroundColor(Color.primary).cornerRadius(20)
                        .overlay(
                            Circle()
                                .stroke(Color("darkBackground"), lineWidth: 1)
                        )
                }
            }
        }
    }
}

struct PageManagerView_Previews: PreviewProvider {
    static var previews: some View {
        PageManagerView()
    }
}
