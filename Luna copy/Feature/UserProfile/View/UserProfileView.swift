//
//  UserProfileView.swift
//  Luna
//
//  Created by Will Polich on 11/2/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserProfileView: View {
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
   
    
    @State var user: UserObj
    @StateObject var service = UserProfileService()
    
    @State var showConfirmRemove = false
    @State var shouldNavigateToChat = false
    
    @State var showFriends = false
    
    
    var body : some View {

        ScrollView {
           
            VStack (alignment: .leading, spacing: 15) {
                HStack (alignment: .center) {
                    WebImage(url: URL(string: user.imageURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64, alignment: .center)
                        .cornerRadius(32)
                    
                    
                    VStack (alignment: .leading) {
                        Text("\(user.firstName) \(user.lastName)")
                            .foregroundColor(.white)
//                        Text("Bender Streak")
//                            .foregroundColor(Color("darkSecondaryText"))
                    }
                    
                    Spacer()
                    
                    
                }
                .padding(.top)
                
                HStack {
                    if service.relationshipStatus == "friends" {
                                                HStack {
                                                    Button {
                                                        showConfirmRemove = true
                                                    } label: {
                                                        VStack {
                                                            Text("Friends")
                                                                .font(.system(size: 15))
                                                                .fontWeight(.bold)
                                                                .foregroundColor(.white)
                                                        }
                                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
                                                        .overlay(
                                                                RoundedRectangle(cornerRadius: 5)
                                                                    .stroke(Color("darkSecondaryText"), lineWidth: 1)
                                                        )
//                                                        .background(.purple.opacity(0.3))
//                                                        .cornerRadius(10)
                                                    }
                    
                                                    Button {
                                                        shouldNavigateToChat.toggle()
                                                    } label: {
                                                        HStack {
                                                            Text("Message")
                                                                .font(.system(size: 15))
                                                                .fontWeight(.bold)
                                                                .foregroundColor(.white)
                                                            Image(systemName: "bubble.left")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 20, height: 20)
                                                                .foregroundColor(.white)
                                                                .offset(x: 5, y: 0)
                                                        }
                                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
//                                                        .frame(width: UIScreen.main.bounds.width*0.2, height: 40)
                                                        .overlay(
                                                                RoundedRectangle(cornerRadius: 5)
                                                                    .stroke(Color("darkSecondaryText"), lineWidth: 1)
                                                        )
                    
                                                    }
                                                }
                    
                    
                                            } else if service.relationshipStatus == "sent" {
                    
                                                Button {
                                                    sessionService.declineFriendRequest(sender: sessionService.userDetails.uid, recipient: user.uid, completion: {
                                                        sessionService.refreshUserDetails()
                                                        service.getRelationshipStatus(uid: sessionService.userDetails.uid, target: user.uid)
                                                    })
                                                } label: {
                                                    VStack {
                                                        Text("Friend Request Sent")
                                                            .font(.system(size: 15))
                                                            .fontWeight(.bold)
                                                            .foregroundColor(.white)
                                                    }
                                                    .frame(width: (UIScreen.main.bounds.width - 32), height: 30)
                                                    .overlay(
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .stroke(Color("darkSecondaryText"), lineWidth: 1)
                                                        )
                                                }
                    
                    
                                            } else if service.relationshipStatus == "received" {
                    
                                                VStack {
                                                    Text("Has sent you a friend request")
                    
                                                    HStack {
                                                        Button(action: {
                                                            sessionService.declineFriendRequest(sender: user.uid , recipient: sessionService.userDetails.uid, completion: {
                                                                sessionService.refreshUserDetails()
                                                                service.getRelationshipStatus(uid: sessionService.userDetails.uid, target: user.uid)
                                                            })
                        
                                                        }, label: {
                                                            VStack {
                                                                Text("Decline")
                                                                    .font(.system(size: 15))
                                                                    .fontWeight(.bold)
                                                                    .foregroundColor(.white)
                                                            }
                                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
                                                            .overlay(
                                                                    RoundedRectangle(cornerRadius: 5)
                                                                        .stroke(Color("darkSecondaryText"), lineWidth: 1)
                                                            )
                                                        })
                        
                                                        Button(action: {
                                                            sessionService.acceptFriendRequest(sender: user.uid, recipient: sessionService.userDetails.uid, completion: {
                                                                sessionService.refreshUserDetails()
                                                                service.getRelationshipStatus(uid: sessionService.userDetails.uid, target: user.uid)
                                                            })
                        
                                                        }, label: {
                                                            VStack {
                                                                Text("Accept")
                                                                    .font(.system(size: 15))
                                                                    .fontWeight(.bold)
                                                                    .foregroundColor(.white)
                                                            }
                                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
                                                            .overlay(
                                                                    RoundedRectangle(cornerRadius: 5)
                                                                        .stroke(Color("darkSecondaryText"), lineWidth: 1)
                                                            )
                                                        })
                        
                                                    }
                                                }
                    
                                            } else if service.relationshipStatus == "none" {
                                                Button {
                                                    sessionService.sendFriendRequest(sender: sessionService.userDetails.uid, recipient: user.uid, completion: {
                                                        sessionService.refreshUserDetails()
                                                        service.getRelationshipStatus(uid: sessionService.userDetails.uid, target: user.uid)
                                                    })
                    
                                                } label: {
                                                    VStack {
                                                        Text("Send Friend Request")
                                                            .font(.system(size: 15))
                                                            .fontWeight(.bold)
                                                            .foregroundColor(.white)
                                                    }
                                                    .frame(width: (UIScreen.main.bounds.width - 32), height: 30)
//                                                    .overlay(
//                                                            RoundedRectangle(cornerRadius: 5)
//                                                                .stroke(Color("darkSecondaryText"), lineWidth: 1)
//                                                        )
                                                    .background(.purple)
                                                    .cornerRadius(5)
                                                }
                                            } else {
                                                VStack {
                                                    Text("Loading")
                                                        .font(.system(size: 15))
                                                        .fontWeight(.bold)
                                                        .foregroundColor(.white)
                                                }
                                                .frame(width: (UIScreen.main.bounds.width - 32), height: 30)
                                                .overlay(
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(Color("darkSecondaryText"), lineWidth: 1)
                                                    )
                                            }
                }
                Divider()
                    .background(Color("darkSecondaryText"))
                
                
                
                
//                Divider()
                
//                HStack (alignment: .center) {
//                    VStack (alignment: .leading) {
//                        Text("Friends")
//                            .foregroundColor(.white)
//                        Text("\(service.mutualFriends.count) Friend")
//                            .foregroundColor(Color("darkSecondaryText"))
//                    }
//
//                    Spacer()
//
//                    Button {
//    //                        self.showFriends = true
//                        print("penis")
//                    } label: {
//                        Text("See All")
//                    }
//
//
//
//                }
                
                VStack {
    //                if sessionService.mutualFriends.count > 0 {
//                    var data = (0...1)
//                    )
//                    if service.mutualFriends.count >= 1 {
//                        var data = (0...3)
//                    } else {
//                        var data = (0...service.mutualFriends.count)
//                    }
                        
                        let columns = [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ]

                                    HStack (alignment: .center) {
                            
                                        VStack (alignment: .leading) {
                                            Text("Friends")
                                                .foregroundColor(.white)
                                            Text("\(user.friends.count) Friends (\(service.mutualFriends.count) mutual)")
                                                .foregroundColor(Color("darkSecondaryText"))
                                        }
                                        Spacer()
                                        
                                        VStack {
                                            Button {
                                               self.showFriends = true
                                           } label: {
                                               Text("See All")
                                                   .padding()
                                                   .foregroundColor(.purple)
                                           }
                                        }
                                    
                                    }
                                    .padding(.bottom)
                        
                                    LazyVGrid (columns: columns) {
                                        ForEach(service.mutualFriends.count > 3 ? (0..<3) : (0..<service.mutualFriends.count), id: \.self) { item in
//                                            if Int(item) < service.mutualFriends.count
//                                            if Int(item) < service.mutualFriends.count {

                                            NavigationLink(destination: service.mutualFriends[Int(item)].performer ? AnyView(PerformerProfileView(user: service.mutualFriends[Int(item)])
                                                .environmentObject(sessionService)
                                                .environmentObject(manager)
                                                .environmentObject(homeVM))
                                               : AnyView(UserProfileView(user: service.mutualFriends[Int(item)])
                                                .environmentObject(sessionService)
                                                .environmentObject(manager)
                                                .environmentObject(homeVM))){
                                                    VStack (alignment: .leading, spacing: 0) {
                                                        WebImage(url: URL(string: service.mutualFriends[Int(item)].imageURL))
                                                                .resizable()
                                                                .scaledToFill()
                                                                .frame(minWidth: 0, maxWidth: .infinity)
                                                                .frame(height: 120)
                                                        
                                                        Text("\(service.mutualFriends[Int(item)].firstName) \(service.mutualFriends[Int(item)].lastName)")
                                                            
                                                            .font(.system(size: 14))
                                                            .foregroundColor(.white)
                                                            .fontWeight(.heavy)
                                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                            .frame(height: 35, alignment: .topLeading)
                                                            .multilineTextAlignment(.leading)
                                                            .padding(5)
                                                            .background(Color("darkForeground"))
                                                    }
                                                    .cornerRadius(5)
                                                    .clipped()
                                                }
//                                            }
                                            
//                                            else {
//                                                VStack {
//                                                    Text("LOL")
//                                                }
//                                                .frame(minWidth: 0, maxWidth: .infinity)
//                                                .frame(height: 1555, alignment: .topLeading)
//                                            }
//                                            }
                                            
                                        }
                                        
                                    }
//                    }
//                                    .frame(maxHeight: 155)
                    
                   
                    
                    if service.favourites.count != 0 {
                        VStack (alignment: .leading) {
                            Divider()
                                .background(Color("darkSecondaryText"))
                            
                            Text("Favourite Venues")
                                .font(Font.body.bold())
                            ScrollView (.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(service.favourites, id: \.self) { venue in
                                        VenueTileView(ven: venue)
                                            .environmentObject(sessionService)
                                            .environmentObject(manager)
                                            .environmentObject(homeVM)
                                    }
                                }
                            }
                        }
                    }
                    
                    if service.interestedEvents.count != 0 {
                        Divider()
                            .background(Color("darkSecondaryText"))
                        
                        VStack (alignment: .leading) {
                            Text("Events \(user.firstName) is interested in")
                                .font(Font.body.bold())
                            ScrollView (.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(service.interestedEvents, id: \.self) { event in
                                        HomeEventTile(event: event, clickable: true)
                                            .environmentObject(sessionService)
                                            .environmentObject(manager)
                                            .environmentObject(homeVM)
                                    }
                                }
                            }
                        }
                    }
                    
                    NavigationLink("", isActive: $shouldNavigateToChat) {
                        FriendMessageView(shouldNavigateToChat: $shouldNavigateToChat, chatUser: user)
                            .environmentObject(sessionService)
                            .environmentObject(manager)
                            .environmentObject(homeVM)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            
            
            
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButtonView())
            .alert("Are you sure you want to remove \(user.firstName) \(user.lastName) as a friend?", isPresented: $showConfirmRemove, actions: {
                  Button("Cancel", role: .cancel, action: {
                      showConfirmRemove = false
                  })
                  Button("I'm sure", role: .destructive, action: {
                      sessionService.removeFriend(user1: sessionService.userDetails.uid, user2: user.uid, completion: {
                          showConfirmRemove = false
                          sessionService.refreshUserDetails()
                          service.getRelationshipStatus(uid: sessionService.userDetails.uid, target: user.uid)
                      })})}, message: {})
            .onAppear {
                sessionService.getToken()
                service.getUserFavourites(id: user.uid, token: sessionService.token)
                service.getProfileMutualFriends(uid: sessionService.userDetails.uid, target: user.uid)
                service.getRelationshipStatus(uid: sessionService.userDetails.uid, target: user.uid)
            }
            .task {
                await service.getInterestedEvents(uid: user.uid, token: sessionService.token)
            }
        }
        .background(Color("darkBackground"))
        .fullScreenCover(isPresented: $showFriends, onDismiss: {self.showFriends = false}) {
//            let data = (0..<service.mutualFriends.count)
                
                let columns = [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]
            
            NavigationView {
                VStack {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(service.mutualFriends, id: \.self) { item in
//                                VStack (alignment: .leading, spacing: 0) {
//                                    WebImage(url: URL(string: item.imageURL))
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(minWidth: 0, maxWidth: .infinity)
//                                            .frame(height: 120)
//
//
//                                    Text("\(item.firstName) \(item.lastName)")
                                NavigationLink(destination: item.performer ? AnyView(PerformerProfileView(user: item)
                                    .environmentObject(sessionService)
                                    .environmentObject(manager)
                                    .environmentObject(homeVM))
                                   : AnyView(UserProfileView(user: item)
                                    .environmentObject(sessionService)
                                    .environmentObject(manager)
                                    .environmentObject(homeVM))) {
                                        VStack (alignment: .leading, spacing: 0) {
                                            WebImage(url: URL(string: item.imageURL))
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(minWidth: 0, maxWidth: .infinity)
                                                    .frame(height: 120)
                                                    .clipped()
                                            
                                            Text("\(item.firstName) \(item.lastName)")
                                                
                                                .font(.system(size: 14))
                                                .foregroundColor(.white)
                                                .fontWeight(.heavy)
                                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                .frame(height: 35, alignment: .topLeading)
                                                .multilineTextAlignment(.leading)
                                                .padding(5)
                                                .background(Color("darkForeground"))
                                        }
                                        .cornerRadius(5)
                                        .clipped()
                                    }
                                
//                            }
                            
                        }
                    }
                }
                .padding(.horizontal)
                .background(Color("darkBackground"))
                .navigationBarTitle("All Mutual Friends", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showFriends.toggle()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }

                }
            }
            
        }
        }
    }
}
        

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {

        let user = UserObj(firstName: "Ned", lastName: "O'Rourke", uid: "", imageURL: "https://static.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest/top-crop/width/360/height/360?cb=20160923150728", friends: ["WRvrsdp1cZYiMpBryzEBmtJfcum2", "g", "h"], favourites: ["5nmYgcYZoS2O9Egdrb3H"], streak: 5, performer: false)

        
        NavigationView {
            UserProfileView(user: user)
                .environmentObject(SessionServiceImpl())
                .environmentObject(LocationManager())
                .environmentObject(ViewModel())
        }
       
    }
}

