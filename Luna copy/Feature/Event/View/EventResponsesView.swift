//
//  EventResponsesView.swift
//  Luna
//
//  Created by Will Polich on 16/5/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct EventResponsesView: View {
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var handler : EventViewHandler
    
    @Binding var showAllResponses : Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(handler.goingFriends, id: \.self) { friend in
                        userResponseTile(user: friend, isGoing: true)
                    }
                    ForEach(handler.interestedFriends, id: \.self) { friend in
                        userResponseTile(user: friend, isGoing: false)
                    }
                }
                .padding(.horizontal)
            }
            .background(Color("darkBackground"))
            .navigationBarTitle("Friend Responses", displayMode: .inline)
            .navigationBarItems(trailing:
                Button {
                    showAllResponses.toggle()
                } label: {
                    Image(systemName: "xmark")
                }
            )
        }
        .navigationBarHidden(true)
//                    HStack {
//
//                        Text("Going")
//                        Spacer()
//                    }
//                    .padding()
//                    .background(Color.purple.opacity(0.3))
//                    ForEach(handler.goingFriends, id: \.self) { friend in
//                        userResponseTile(user: friend, isGoing: true)
//                        .padding(.horizontal)
//                        NavigationLink(destination: friend.performer ? AnyView(PerformerProfileView(user: friend)
//                            .environmentObject(sessionService)
//                            .environmentObject(manager)
//                            .environmentObject(homeVM))
//                           : AnyView(UserProfileView(user: friend)
//                            .environmentObject(sessionService)
//                            .environmentObject(manager)
//                            .environmentObject(homeVM))) {
//                            HStack {
//                                ZStack (alignment: .bottomTrailing) {
//
//                                        WebImage(url: URL(string: friend.imageURL))
//                                           .resizable()
//                                           .scaledToFill()
//                                           .frame(width: 64, height: 64).cornerRadius(64)
//                                           .clipped()
//
//
//                                   Image(systemName: "checkmark.circle.fill")
//                                       .resizable()
//                                       .frame(width: 20, height: 20)
//                                       .scaledToFit()
//                                       .background(Color.white).cornerRadius(64)
//                                       .foregroundColor(.green)
//
//                               }
//                                Text("\(friend.firstName) \(friend.lastName)")
//                                    .foregroundColor(Color.primary)
//
//                                Spacer()
//                            }
//                            .padding(.horizontal)
//
//                            Divider()
//                        }
                       
                            
                        

                    
//                    HStack {
//                        Text("Interested")
//                        Spacer()
//                    }
//                    .padding()
//                    .background(Color.purple.opacity(0.3))
                    
//                    ForEach(handler.interestedFriends, id: \.self) { friend in
//                        NavigationLink(destination: friend.performer ? AnyView(PerformerProfileView(user: friend)
//                            .environmentObject(sessionService)
//                            .environmentObject(manager)
//                            .environmentObject(homeVM))
//                           : AnyView(UserProfileView(user: friend)
//                            .environmentObject(sessionService)
//                            .environmentObject(manager)
//                            .environmentObject(homeVM))) {
//                            HStack {
//                                ZStack (alignment: .bottomTrailing) {
//
//                                        WebImage(url: URL(string: friend.imageURL))
//                                           .resizable()
//                                           .scaledToFill()
//                                           .frame(width: 64, height: 64).cornerRadius(64)
//                                           .clipped()
//
//
//                                   Image(systemName: "bookmark.circle.fill")
//                                       .resizable()
//                                       .frame(width: 20, height: 20)
//                                       .scaledToFit()
//                                       .background(Color.white).cornerRadius(64)
//                                       .foregroundColor(.gray)
//
//                               }
//                                Text("\(friend.firstName) \(friend.lastName)")
//                                    .foregroundColor(Color.primary)
//
//                                Spacer()
//                            }
//                            .padding(.horizontal)
//
//                            Divider()
//                        }
//                        LazyVStack {
//                            userResponseTile(user: friend, isGoing: false)
//                        }
//                        .padding(.horizontal)

                    
//                    }
//                }
//
//            }
//
//
//
//        }
//
        
        
    }
}

struct userResponseTile: View {
    
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    
    @State var user : UserObj
    @State var isGoing : Bool
    
    var body: some View {
     
        NavigationLink(destination: user.performer ? AnyView(PerformerProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM))
           : AnyView(UserProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM))) {
                HStack {
                    
                    ZStack (alignment: .bottomTrailing) {
                        WebImage(url: URL(string: user.imageURL))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50, alignment: .center)
                            .cornerRadius(25)
                        
                        if self.isGoing {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .scaledToFit()
                                .background(Color.white)
                                .cornerRadius(64)
                                .foregroundColor(.green)
                        }
                        
                        else {
                            Image(systemName: "bookmark.circle.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .scaledToFit()
                                .background(Color.white)
                                .cornerRadius(64)
                                .foregroundColor(.gray)
                        }
                    }
                   
                    
                    Text("\(user.firstName) \(user.lastName)")
                    
                    Spacer()
                }
            }
            .buttonStyle(.plain)
    }
}


