//
//  PerformerProfileView.swift
//  Luna
//
//  Created by Will Polich on 23/5/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import AVFoundation

struct PerformerProfileView: View {
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
   
    
    @State var user: UserObj
    @StateObject var service = UserProfileService()
    
    @State var showConfirmRemove = false
    @State var shouldNavigateToChat = false
    
    @State var showFollowers = false
    
    @State var song1 = false
    
    @State var songURL = ""
    
    @State var time : CGFloat = 0.0
    @State var player : AVPlayer!
    
    @State var loading = false
    
    
    var body : some View {

//        ScrollView (showsIndicators: false) {
//
//
//
//            VStack {
//                NavigationLink("", isActive: $shouldNavigateToChat) {
//                    FriendMessageView(shouldNavigateToChat: $shouldNavigateToChat, chatUser: user)
//                }
//
//                HStack {
//                    CachedAsyncImage(url: URL(string: user.imageURL), content: { image in
//                        image.resizable()
//                            .scaledToFill()
//                            .frame(width: 100, height: 100).cornerRadius(64)
//                            .clipped()
//
//                    }, placeholder: {
//                        ProgressView()
//                            .scaledToFill()
//                            .frame(width: 100, height: 100).cornerRadius(64)
//                            .clipped()
//
//                    })
//
//                    VStack (alignment: .leading) {
//                        Text("\(user.firstName) \(user.lastName)")
//                            .font(.system(size: 26))
//
//                        HStack {
//                            if service.followerCount == 1 {
//                                Text("1 Follower")
//                            } else if service.followerCount > 1 {
//                                Text("\(String(service.followerCount)) Followers")
//                            } else {
//                                Text("0 Followers")
//                            }
//                        }
//
//                    }
//                    .offset(x: 0, y: 5)
//
//                    Spacer()
//
//                }
//
//                HStack {
//                    Button {
//
//                    } label: {
//                        Image(systemName: "play.circle.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(maxWidth: 30)
//                            .padding(.trailing)
//                            .foregroundColor(.white)
//                    }
//
//                    HStack(spacing: 2) {
//
//                        ForEach(0..<9) { num in
//                            Image(systemName: "waveform")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(maxWidth: 30)
//
//                        }
//                    }
//
//                }
//
//                if service.spotifyLink != "" || service.soundcloudLink != "" {
//
//                    VStack (alignment: .leading) {
//
//                        Divider()
//
//
//                        if service.spotifyLink != "" {
//                            Button {
//                                guard let url = URL(string: service.spotifyLink) else {
//                                    return
//                                }
//
//                                if UIApplication.shared.canOpenURL(url) {
//                                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                                }
//                            } label: {
//                                HStack {
//                                    Image("spotify")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(maxWidth: 20)
//
//                                    Text("Spotify")
//
//                                    Image(systemName: "rectangle.portrait.and.arrow.right")
//                                }
//                            }
//                        }
//
//                        if service.soundcloudLink != "" {
//                            Button {
//                                guard let url = URL(string: service.soundcloudLink) else {
//                                    return
//                                }
//
//                                if UIApplication.shared.canOpenURL(url) {
//                                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                                }
//                            } label: {
//                                HStack {
//                                    Image("soundcloud")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(maxWidth: 20)
//
//                                    Text("Soundcloud")
//
//                                    Image(systemName: "rectangle.portrait.and.arrow.right")
//                                }
//                            }
//
//
//                        }
//
//                    }
//                    .foregroundColor(.white)
//                }
//
//
//                Divider()
//
//                Group {
//                    GeometryReader { proxy in
////                    if (service.relationshipStatus != nil) {
//                        if service.relationshipStatus == "friends" {
//                            HStack {
//                                Button {
//                                    showConfirmRemove = true
//                                } label: {
//                                    VStack {
//                                        Text("Friends")
//                                            .font(.system(size: 20))
//                                            .foregroundColor(.primary)
//                                    }
//                                    .frame(width: proxy.size.width*0.47, height: 40)
//                                    .background(.purple.opacity(0.3))
//                                    .cornerRadius(10)
//                                }
//
//                                Button {
//                                    shouldNavigateToChat.toggle()
//                                } label: {
//                                    HStack {
//                                        Text("Message")
//                                            .font(.system(size: 20))
//                                            .foregroundColor(.primary)
//                                        Image(systemName: "bubble.left")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 25, height: 25)
//                                            .foregroundColor(.primary)
//                                            .offset(x: 5, y: 0)
//                                    }
//                                    .frame(width: proxy.size.width*0.47, height: 40)
//                                    .overlay(
//                                            RoundedRectangle(cornerRadius: 10)
//                                                .stroke(Color.primary, lineWidth: 3)
//                                        )
//
//                                    .cornerRadius(10)
//
//                                }
//                            }
//                            .frame(height: 40)
//
//
//                        } else if service.relationshipStatus == "sent" {
//
//                            Button {
//                                sessionService.declineFriendRequest(sender: sessionService.userDetails.uid, recipient: user.uid, completion: {
//                                    sessionService.refreshUserDetails()
//                                    service.getRelationshipStatus(uid: sessionService.userDetails.uid, target: user.uid)
//                                })
//                            } label: {
//                                VStack {
//                                    Text("Friend Request Sent")
//                                        .font(.system(size: 20))
//                                        .foregroundColor(.white)
//                                }
//                                .frame(width: proxy.size.width*0.7, height: 40)
//                                .background(.purple.opacity(0.3))
//                                .cornerRadius(10)
//                            }
//                            .frame(height: 40)
//
//
//                        } else if service.relationshipStatus == "received" {
//
//                            Text("Has sent you a friend request")
//                            HStack {
//                                Button(action: {
//                                    sessionService.declineFriendRequest(sender: user.uid , recipient: sessionService.userDetails.uid, completion: {
//                                        sessionService.refreshUserDetails()
//                                        service.getRelationshipStatus(uid: sessionService.userDetails.uid, target: user.uid)
//                                    })
//
//                                }, label: {
//                                    VStack {
//                                        Text("Decline")
//                                            .font(.system(size: 20))
//                                            .foregroundColor(.black)
//                                    }
//                                    .frame(width: proxy.size.width*0.40, height: 40)
//                                    .background(.white)
//                                    .cornerRadius(10)
//                                })
//
//                                Button(action: {
//                                    sessionService.acceptFriendRequest(sender: user.uid, recipient: sessionService.userDetails.uid, completion: {
//                                        sessionService.refreshUserDetails()
//                                        service.getRelationshipStatus(uid: sessionService.userDetails.uid, target: user.uid)
//                                    })
//
//                                }, label: {
//                                    VStack {
//                                        Text("Accept")
//                                            .font(.system(size: 20))
//                                            .foregroundColor(.white)
//                                    }
//                                    .frame(width: proxy.size.width*0.4, height: 40)
//                                    .background(.purple.opacity(0.8))
//                                    .cornerRadius(10)
//                                })
//
//                            }
//                            .frame(height: 40)
//
//                        } else if service.relationshipStatus == "following" {
//
//                            Button {
//                                service.unfollowPerformer(uid: sessionService.userDetails.uid, performer: user.uid) {
//                                    sessionService.refreshUserDetails()
//                                    service.getRelationshipStatus(uid: sessionService.userDetails.uid, target: user.uid)
//                                    service.getFollowerCount(id: user.uid)
//                                }
//                            } label: {
//                                VStack {
//                                    Text("Following")
//                                        .font(.system(size: 20))
//                                        .foregroundColor(.white)
//                                }
//                                .frame(width: proxy.size.width*0.7, height: 40)
//                                .background(.purple.opacity(0.3))
//                                .cornerRadius(10)
//                            }
//                            .frame(height: 40)
//
//
//                        } else if service.relationshipStatus == "none" {
//                            HStack {
//
//                                Button {
//                                    service.followPerformer(uid: sessionService.userDetails.uid, performer: user.uid) {
//                                        sessionService.refreshUserDetails()
//                                        service.getRelationshipStatus(uid: sessionService.userDetails.uid, target: user.uid)
//                                        service.getFollowerCount(id: user.uid)
//                                    }
//
//                                } label: {
//
//                                    VStack {
//                                        HStack {
//                                            Text("Follow")
//                                                .font(.system(size: 20))
//                                                .foregroundColor(.white)
//
////                                            Image(systemName: "plus")
////                                                .foregroundColor(.white)
//                                        }
//                                    }
//                                    .frame(width: proxy.size.width*0.6, height: 40)
//                                    .background(.purple.opacity(0.8))
//                                    .cornerRadius(10)
//
//                                }
//
//                                Menu {
//                                    Button (action : {
//                                        sessionService.sendFriendRequest(sender: sessionService.userDetails.uid, recipient: user.uid, completion: {
//                                            sessionService.refreshUserDetails()
//                                            service.getRelationshipStatus(uid: sessionService.userDetails.uid, target: user.uid)
//                                        })
//
//                                    }, label: {
//                                        HStack {
//                                            Text("Send Friend Request")
//                                            Image(systemName: "person.crop.circle.badge.plus")
//                                        }
//                                        .foregroundColor(Color.primary)
//
//                                    })
//
//                                } label: {
//
//                                    Image(systemName: "ellipsis")
//                                        .foregroundColor(.white)
//                                        .frame(width: proxy.size.width*0.1, height: 40)
//                                        .background(.purple.opacity(0.8))
//                                        .cornerRadius(10)
//                                }
//
//                            }
//                            .frame(height: 40)
//
//                        } else {
//                            VStack {
//                                Text("Loading")
//                                    .font(.system(size: 20))
//                                    .foregroundColor(.primary)
//                            }
//                            .frame(width: proxy.size.width*0.7, height: 40)
//                            .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.primary, lineWidth: 3)
//                                )
//                            .cornerRadius(10)
//                        }
//                    }
//                    .frame(height: 40, alignment: .center)
//
//                }
//
//
//
//                Group {
//
//                    Spacer()
//                    Spacer()
//                    if service.mutualFriends.count != 0 {
//                        HStack {
//                            Text("Mutual Friends")
//                                .font(Font.body.bold())
//                            Spacer()
//                            Text(String(service.mutualFriends.count))
//                        }
//
//                        ScrollView (.horizontal, showsIndicators: false) {
//                            LazyHStack {
//                                ForEach(service.mutualFriends, id: \.self) { friend in
//                                    NavigationLink(destination: user.performer ? AnyView(PerformerProfileView(user: user)
//                                        .environmentObject(sessionService)
//                                        .environmentObject(manager)
//                                        .environmentObject(homeVM))
//                                       : AnyView(UserProfileView(user: user)
//                                        .environmentObject(sessionService)
//                                        .environmentObject(manager)
//                                        .environmentObject(homeVM)), label: {
//                                        VStack {
//                                            CachedAsyncImage(url: URL(string: friend.imageURL)) { image in
//                                                image.resizable()
//                                                .scaledToFill()
//                                                .frame(width: 64, height: 64).cornerRadius(64)
//                                                .clipped()
//                                            } placeholder: {
//                                                ProgressView()
//                                                    .scaledToFill()
//                                                    .frame(width: 64, height: 64).cornerRadius(64)
//                                                    .clipped()
//                                            }
//
//                                        }
//                                    })
//                                }
//                                .frame(maxWidth: 100, maxHeight: 120)
//
//
//
//                            }
//                        }
//
//                    }
//
//                    if service.friendsFollowing.count != 0 {
//                        HStack {
//                            Text("Friends who follow \(user.firstName) \(user.lastName)")
//                                .font(Font.body.bold())
//                            Spacer()
//                            Text(String(service.mutualFriends.count))
//                        }
//
//                        ScrollView (.horizontal, showsIndicators: false) {
//                            LazyHStack {
//                                ForEach(service.mutualFriends, id: \.self) { friend in
//                                    NavigationLink(destination: user.performer ? AnyView(PerformerProfileView(user: user)
//                                        .environmentObject(sessionService)
//                                        .environmentObject(manager)
//                                        .environmentObject(homeVM))
//                                       : AnyView(UserProfileView(user: user)
//                                        .environmentObject(sessionService)
//                                        .environmentObject(manager)
//                                        .environmentObject(homeVM)), label: {
//                                        VStack {
//                                            CachedAsyncImage(url: URL(string: friend.imageURL)) { image in
//                                                image.resizable()
//                                                .scaledToFill()
//                                                .frame(width: 45, height: 45).cornerRadius(64)
//                                                .clipped()
//                                            } placeholder: {
//                                                ProgressView()
//                                                    .scaledToFill()
//                                                    .frame(width: 45, height: 45).cornerRadius(64)
//                                                    .clipped()
//                                            }
//
//                                        }
//                                    })
//                                }
//                                .frame(maxWidth: 100, maxHeight: 120)
//
//
//
//                            }
//                        }
//
//                    }
//
//                    Group {
//                        if service.upcomingEvents.count > 0 {
//                            VStack (alignment: .leading) {
//                                Divider()
//                                Text("Upcoming Events")
//                                    .font(.title)
//                                ScrollView (showsIndicators: false) {
//                                    ForEach(service.upcomingEvents, id: \.self) { event in
//                                        EventTileView(event: event, clickable: true)
//                                                .environmentObject(sessionService)
//                                                .environmentObject(manager)
//                                                .environmentObject(homeVM)
//                                                .padding(.vertical, 5)
//
//                                        Divider()
//
//                                    }
//                                }
//                            }
//                        }
//
//                        if service.pastEvents.count > 0 {
//                            VStack (alignment: .leading) {
//
//                                Text("Past Events")
//                                    .font(.title)
//                                ScrollView (showsIndicators: false) {
//                                    ForEach(service.pastEvents, id: \.self) { event in
//                                        EventTileView(event: event, clickable: true)
//                                                .environmentObject(sessionService)
//                                                .environmentObject(manager)
//                                                .environmentObject(homeVM)
//                                                .padding(.vertical, 5)
//
//                                        Divider()
//
//                                    }
//                                }
//                            }
//                        }
//
//                    }
//
//
//                }
//
//
//
//            }
//        }
        ScrollView (showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                HStack (alignment: .center) {
                    WebImage(url: URL(string: user.imageURL))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64, alignment: .center)
                            .cornerRadius(32)
                
                    
                    VStack (alignment: .leading) {
                        Text("\(user.firstName) \(user.lastName)")
                            .foregroundColor(.white)
                        if service.followerCount == 1 {
                            Text("1 Follower")
                        } else if service.followerCount > 1 {
                            Text("\(String(service.followerCount)) Followers")
                        }
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
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.primary)
                                        .offset(x: 5, y: 0)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
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
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color("darkSecondaryText"), lineWidth: 1)
                            )
                        }


                    } else if service.relationshipStatus == "received" {

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

                    } else if service.relationshipStatus == "following" {

                        Button {
                            service.unfollowPerformer(uid: sessionService.userDetails.uid, performer: user.uid) {
                                sessionService.refreshUserDetails()
                                service.getRelationshipStatus(uid: sessionService.userDetails.uid, target: user.uid)
                                service.getFollowerCount(id: user.uid)
                            }
                        } label: {
                            VStack {
                                Text("Following")
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color("darkSecondaryText"), lineWidth: 1)
                            )
                        }


                    } else if service.relationshipStatus == "none" {
                        HStack {

                            Button {
                                service.followPerformer(uid: sessionService.userDetails.uid, performer: user.uid) {
                                    sessionService.refreshUserDetails()
                                    service.getRelationshipStatus(uid: sessionService.userDetails.uid, target: user.uid)
                                    service.getFollowerCount(id: user.uid)
                                }

                            } label: {

                                VStack {
                                    HStack {
                                        Text("Follow")
                                            .font(.system(size: 15))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)

    //                                            Image(systemName: "plus")
    //                                                .foregroundColor(.white)
                                    }
                                }
                                .frame(minWidth: UIScreen.main.bounds.width*0.7, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
                                .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color("darkSecondaryText"), lineWidth: 1)
                                )

                            }

                            Menu {
                                Button (action : {
                                    sessionService.sendFriendRequest(sender: sessionService.userDetails.uid, recipient: user.uid, completion: {
                                        sessionService.refreshUserDetails()
                                        service.getRelationshipStatus(uid: sessionService.userDetails.uid, target: user.uid)
                                    })

                                }, label: {
                                    HStack {
                                        Text("Send Friend Request")
                                        Image(systemName: "person.crop.circle.badge.plus")
                                    }
                                    .foregroundColor(Color.primary)

                                })

                            } label: {

                                Image(systemName: "ellipsis")
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
                                    .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color("darkSecondaryText"), lineWidth: 1)
                                    )
                                    .foregroundColor(.white)
                            }

                        }

                    } else {
                        VStack {
                            Text("Loading")
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
                        .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color("darkSecondaryText"), lineWidth: 1)
                        )
                    }
                }
                
                HStack(spacing: 2) {
                    
                    HStack {
                        ZStack {
                            
                            Circle()
                                .stroke(lineWidth: 4)
                                .foregroundColor(.gray)
                                .opacity(0.1)
                            
                            Circle()
                                .trim(from: 0, to: min(time, 1.0))
                                .stroke(AngularGradient(gradient: Gradient(colors: [.purple, .blue, .purple]), center: .center), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                .rotationEffect(Angle(degrees: 270))

                            Button {
                                
                            } label: {
                                
                                
                                if loading {
                                    ProgressView()
                                }
                                
                                else {
                                    Image(systemName: song1 ? "pause.circle.fill": "play.circle.fill")
                                        .font(.system(size: 15))
                                }
                                
                            }
                            .highPriorityGesture(TapGesture()
                                .onEnded {
                                    if self.player != nil {
                                        song1.toggle()
                                        

                                        if song1{
                                           self.player?.play()
                                            loading = true
                                        } else {
                                           self.player?.pause()
                                            loading = false
                                            
                                        }
                                        
                                        DispatchQueue.global(qos: .background).async {
                                            
                                            while song1 {
                                                
                                                if self.player.timeControlStatus.rawValue == 2 && loading {
                                                    loading.toggle()
                                                }
                                                
                                                guard let duration = player?.currentItem?.duration.seconds,
                                                        let currentMoment = player?.currentItem?.currentTime().seconds else { return }

                                                self.time = CGFloat(currentMoment / duration)
                                                                                
                                            }
                                            
                                        }
                                    }
                                })

                           
                        }
                        .frame(width: 25, height: 25)
                        
                        
                       
                    }
                    Spacer()
                    
                    ForEach(0..<9) { num in
                        Image(systemName: "waveform")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 30)

                    }
                }
                
                HStack {
                    if service.spotifyLink != "" || service.soundcloudLink != "" {
                       
                        if service.spotifyLink != "" {
                            Button {
                                guard let url = URL(string: service.spotifyLink) else {
                                    return
                                }

                                if UIApplication.shared.canOpenURL(url) {
                                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            } label: {
                                HStack {
                                    
                                   
                                    
                                    Image("Spotify-1")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 15, height: 15, alignment: .center)
//                                        .frame(width: 100, height: 100, alignment: .center)
//                                        .padding()
                                        .opacity(0.3)
//                                        .frame(maxWidth: 20)

                                    Text("Spotify")
                                        .foregroundColor(.white)
                                    
//                                    Spacer()

//                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 25, maxHeight: 25, alignment: .center)
                                .background(Color("darkForeground").opacity(0.9))
                                .cornerRadius(5)
                            }
                        }
                        
                        if service.soundcloudLink != "" {
                            Button {
                                guard let url = URL(string: service.soundcloudLink) else {
                                    return
                                }

                                if UIApplication.shared.canOpenURL(url) {
                                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            } label: {
                                HStack {
//                                    Spacer()
                                    Image("soundcloud")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 25, height: 25, alignment: .center)
//                                        .padding()
                                        .opacity(0.3)

                                    Text("Soundcloud")
                                        .foregroundColor(.white)
//
//                                    Image(systemName: "rectangle.portrait.and.arrow.right")
//                                    Spacer()
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 25, maxHeight: 25, alignment: .center)
                                .background(Color("darkForeground").opacity(0.9))
                                .cornerRadius(5)
                            }


                        }
                   }
                }
                
                Divider()
                    .background(Color("darkForeground"))
                
                let columns = [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]

                    HStack (alignment: .center) {
            
                        VStack (alignment: .leading) {
                            Text("Followers")
                                .foregroundColor(.white)
                            Text("\(service.followerCount) Followers (\(service.friendsFollowing.count) Friends)")
                                .foregroundColor(Color("darkSecondaryText"))
                        }
                        Spacer()
                        
                        VStack {
                            Button {
                               self.showFollowers = true
                           } label: {
                               Text("See All")
                                   .padding()
                                   .foregroundColor(.purple)
                           }
                        }
                    
                    }
                    .padding(.bottom)
        
                    LazyVGrid (columns: columns) {
                        ForEach(service.friendsFollowing.count > 3 ? (0..<3) : (0..<service.friendsFollowing.count), id: \.self) { item in

                            NavigationLink(destination:  service.friendsFollowing[Int(item)].performer ? AnyView(PerformerProfileView(user:  service.friendsFollowing[Int(item)])
                                .environmentObject(sessionService)
                                .environmentObject(manager)
                                .environmentObject(homeVM))
                               : AnyView(UserProfileView(user:  service.friendsFollowing[Int(item)])
                                .environmentObject(sessionService)
                                .environmentObject(manager)
                                .environmentObject(homeVM))) {
                                    VStack (alignment: .leading, spacing: 0) {
                                        WebImage(url: URL(string: service.friendsFollowing[Int(item)].imageURL))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            .frame(height: 120)

                                        
                                        Text("\(service.friendsFollowing[Int(item)].firstName) \(service.friendsFollowing[Int(item)].lastName)")
                                            
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
                            
                        }
                        
                    }
                
                Group {
                    if service.upcomingEvents.count > 0 {
                        VStack (alignment: .leading) {
                            Divider()
                            Text("Upcoming Events")
//                                .font(.title)
                            ScrollView (showsIndicators: false) {
                                ForEach(service.upcomingEvents, id: \.self) { event in
                                    EventTileView(event: event, clickable: true)
                                            .environmentObject(sessionService)
                                            .environmentObject(manager)
                                            .environmentObject(homeVM)
                                            .padding(.vertical, 5)

                                    Divider()

                                }
                            }
                        }
                    }
                    if service.pastEvents.count > 0 {
                        VStack (alignment: .leading) {

                            Text("Past Events")
                            ScrollView (showsIndicators: false) {
                                ForEach(service.pastEvents, id: \.self) { event in
                                    EventTileView(event: event, clickable: true)
                                            .environmentObject(sessionService)
                                            .environmentObject(manager)
                                            .environmentObject(homeVM)
                                            .padding(.vertical, 5)

                                    Divider()

                                }
                            }
                        }
                    }
                }
                
            }
            .padding(.horizontal, 16)
            
            NavigationLink("", isActive: $shouldNavigateToChat) {
               FriendMessageView(shouldNavigateToChat: $shouldNavigateToChat, chatUser: user)
                    .environmentObject(sessionService)
                    .environmentObject(manager)
                    .environmentObject(homeVM)
           }
        }
        .background(Color("darkBackground"))
//        .padding(.horizontal)
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
            
            let queue = DispatchQueue(label: "performer", attributes: .concurrent)
            queue.async { sessionService.getToken()}
            queue.async { service.getUserFavourites(id: user.uid, token: sessionService.token)}
            queue.async { service.getProfileMutualFriends(uid: sessionService.userDetails.uid, target: user.uid)}
            queue.async { service.getRelationshipStatus(uid: sessionService.userDetails.uid, target: user.uid)}
            queue.async { service.getFriendsFollowing(uid: sessionService.userDetails.uid, target: user.uid)}
            queue.async { service.getFollowerCount(id: user.uid)}
            queue.async { service.getPerformerLinks(id: user.uid)}
            queue.async { service.getUpcomingEvents(id: user.uid)}
            queue.async { service.getPastEvents(id: user.uid)}
            queue.async { service.getFollowers(target: user.uid)}
            queue.async { sessionService.getHeadline(id: user.uid) { songURL in
                self.songURL = songURL
                if let url = URL(string: self.songURL) {
                    self.player = try! AVPlayer(url: url)
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playback)
                    } catch (let error) {
                        print(error.localizedDescription)
                    }
                }
            }}
        }
        .onDisappear {
            self.player?.pause()
        }
        .fullScreenCover(isPresented: $showFollowers, onDismiss: {self.showFollowers = false}) {
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
                            ForEach(service.followers, id: \.self) { item in
                                NavigationLink(destination: item.performer ? AnyView(PerformerProfileView(user: item)
                                    .environmentObject(sessionService)
                                    .environmentObject(manager)
                                    .environmentObject(homeVM))
                                   : AnyView(UserProfileView(user: item)
                                    .environmentObject(sessionService)
                                    .environmentObject(manager)
                                    .environmentObject(homeVM))){
                                    VStack (alignment: .leading, spacing: 0) {
                                        WebImage(url: URL(string: item.imageURL))
                                                .resizable()
                                                .scaledToFill()
                                                .frame(minWidth: 0, maxWidth: .infinity)
                                                .frame(height: 120)

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
                            }

                        }
                    }
                }
                .padding(.horizontal)
                .background(Color("darkBackground"))
                .navigationBarTitle("All Followers", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showFollowers.toggle()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }

                }
            }

        }
    
    }
}

struct PerformerProfileView_Previews: PreviewProvider {
    static var previews: some View {

        let user = UserObj(firstName: "Ned", lastName: "O'Rourke", uid: "", imageURL: "https://static.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest/top-crop/width/360/height/360?cb=20160923150728", friends: ["WRvrsdp1cZYiMpBryzEBmtJfcum2", "g", "h"], favourites: ["5nmYgcYZoS2O9Egdrb3H"], streak: 5, performer: true)

        
        NavigationView {
            PerformerProfileView(user: user)
                .environmentObject(SessionServiceImpl())
                .environmentObject(LocationManager())
                .environmentObject(ViewModel())
        }
       
    }
}

