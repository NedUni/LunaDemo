//
//  FriendRequestsView.swift
//  Luna
//
//  Created by Will Polich on 24/1/2022.
//

import Foundation
import SwiftUI

struct FriendRequestsView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    @State var isLoaded = false
    
    var body: some View {
        
        ZStack {
            Color("darkBackground")
                .ignoresSafeArea()
            
            if isLoaded {
                ScrollView {
                        if sessionService.currentFriendRequests.count != 0 {
                            ForEach(sessionService.currentFriendRequests, id: \.self) { user in
                                FriendRequestTileView(user: user)
                                    .environmentObject(sessionService)
                                    .environmentObject(manager)
                                    .environmentObject(homeVM)
                                Divider()
                            }
                        } else {
                            Text("No current friend requests.")
                                .foregroundColor(Color.secondary)
                        }
                        
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView())
        .navigationBarTitle("Friend Requests", displayMode: .inline)
        .onAppear {
            sessionService.getFriendRequests(uid: sessionService.userDetails.uid, completion: {
                self.isLoaded = true
            })
        }
        .onDisappear {
            sessionService.getFriendRequests(uid: sessionService.userDetails.uid, completion: {})
            
            sessionService.getFriends(uid: sessionService.userDetails.uid, completion: {})
        }
//        .task {
//            await
//        }
    }
}



struct Previews_FriendRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestsView()
    }
}
