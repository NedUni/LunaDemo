//
//  FriendsView.swift
//  Luna
//
//  Created by Will Polich on 25/1/2022.
//

import Foundation
import SwiftUI

struct FriendsView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    
    var body: some View {
        
//        ZStack {
//
//            Color("darkBackground")
//                .ignoresSafeArea()
        
            
//            LazyVStack {
            ScrollView (showsIndicators: false) {
                LazyVStack {
                    if sessionService.currentFriends.count != 0 {
                        ForEach(sessionService.currentFriends, id: \.self) { user in
                            FriendTileView(user: user)
                                .environmentObject(sessionService)
                                .environmentObject(manager)
                                .environmentObject(homeVM)
                            Divider()
                        }
                    } else {
                        Text("No current friends. To add friends, search for other users and send a friend request.")
                            .foregroundColor(Color.secondary)
                    }
                }
                
            }
//            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButtonView())
            .navigationBarTitle("My Friends", displayMode: .inline)
            .background(Color("darkBackground"))
            .padding(.horizontal)
            .onDisappear {
                sessionService.getFriendRequests(uid: sessionService.userDetails.uid, completion: {})
                
                sessionService.getFriends(uid: sessionService.userDetails.uid, completion: {})
            }
            .background(Color("darkBackground"))
            
            //Stops flashing if get rid of this
//            .task {
//                await sessionService.getFriends(uid: sessionService.userDetails.uid)
//            }
            
//    }
    }
}
