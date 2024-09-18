//
//  HeaderView.swift
//  Luna
//
//  Created by Will Polich on 7/4/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct HeaderView : View {
    
    @EnvironmentObject var viewModel : ViewModel
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    
    @State var showAddFriends : Bool = false

    var pageName : String
    @Binding var showFriendsToAdd : Bool
    
    var body: some View {
        
        HStack (spacing: 16) {
            Text(pageName)
                .font(.system(size: 24))
            Spacer()
            
            Button(action: {
                showAddFriends = true
            }, label: {
                ZStack (alignment: .topTrailing) {
                       Image(systemName: "person.crop.circle.badge.plus")
                           .resizable()
                           .scaledToFill()
                           .frame(width: 30, height: 30)
                           .foregroundColor(Color.primary)
                           

                    if showFriendsToAdd == true {
                        Image(systemName: "circle")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .scaledToFit()
                            .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.purple, lineWidth: 2))
                            .background(Color.purple).cornerRadius(20)
                            .padding(.leading, 2)
                            .padding(.bottom, 1)
                            .offset(x: 5, y: 0)
                    }
                   
                }
            })
            
            NavigationLink(destination: SearchView() //
                             .environmentObject(sessionService)
                             .environmentObject(manager)
                             .environmentObject(viewModel)) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.primary)
                    .frame(width: 24, height: 24)

            }
             .offset(x: 5, y: 0)
            
                        
            ZStack (alignment: .bottomTrailing) {
               NavigationLink(destination: ProfileView()
                                .environmentObject(sessionService)
                                .environmentObject(manager)
                                .environmentObject(viewModel)) {
                   WebImage(url: URL(string: sessionService.userDetails.imageURL))
                            .resizable()
                           .scaledToFill()
                           .frame(width: 45, height: 45).cornerRadius(64)
                           .clipped()
                       
                       

               }
               Image(systemName: "circle")
                   .resizable()
                   .frame(width: 13, height: 13).cornerRadius(64)
                   .scaledToFit()
                   .background(Color.green).cornerRadius(64)
                   .overlay(RoundedRectangle(cornerRadius: 64).strokeBorder(Color("darkBackground"), lineWidth: 2))
                   .padding(.trailing, 2)
                   .padding(.bottom, 1)
           }
        }
        .fullScreenCover(isPresented: $showAddFriends) {
            ContentView2(viewed: $showFriendsToAdd, showAddFriends: $showAddFriends)
        }
    }
    
}

