//
//  HomeView.swift
//  Luna
//
//  Created by Ned O'Rourke on 8/1/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    @StateObject var pageManager = PageHandler()
    
    @State var viewed: Bool = true
    @State var shouldShowImagePicker = false
    @State var success = "Confirm Change"
    @State var image: UIImage?
    
    var body: some View {
        
            VStack (alignment: .leading) {
                
                VStack (alignment: .center) {
                    HStack {
                        
                        Spacer()
                        
                        WebImage(url: URL(string: "\(sessionService.userDetails.imageURL)"))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .cornerRadius(200)
                        
                        
                        Spacer()
                    }
                    
                    Text("Ready to party \(sessionService.userDetails.firstName)?")
                    
                }
                
                VStack {
                    
                    Group {
                        NavigationLink (destination: FriendsView()
                           .environmentObject(sessionService)
                           .environmentObject(manager)
                           .environmentObject(homeVM),
                       label: {
                            ProfileLinkTile(destination: "Friends", number: String(sessionService.currentFriends.count))
                        })

                    }

                    Group {
                        NavigationLink (destination: FriendRequestsView()
                           .environmentObject(sessionService)
                           .environmentObject(manager)
                           .environmentObject(homeVM),
                       label: {
                            ProfileLinkTile(destination: "Friend Requests", number: String(sessionService.currentFriendRequests.count))
                        })
                    }
                    
                    
                    
//                    Group {
//                        NavigationLink (destination: ContentView2(viewed: $viewed)
//                           .environmentObject(sessionService)
//                           .environmentObject(manager)
//                           .environmentObject(homeVM),
//                       label: {
//                            ProfileLinkTile(destination: "Add Friends")
//                        })
//                    }
                    
                    Group {
                        NavigationLink (destination: ProfileDetailsView()
                           .environmentObject(sessionService)
                           .environmentObject(manager)
                           .environmentObject(homeVM),
                       label: {
                            ProfileLinkTile(destination: "Profile Details")
                        })
                    }
                    
                    NavigationLink (destination: FeedbackView(), label: {
                        ProfileLinkTile(destination: "Submit Feedback / Bug Report")
            
                    })
                    
                    Group {
                        NavigationLink (destination: SettingsView()
                           .environmentObject(sessionService)
                           .environmentObject(manager)
                           .environmentObject(homeVM),
                       label: {
                            ProfileLinkTile(destination: "Settings")
                        })
                    }
                    
                    if homeVM.drinkControl {
                        Group {
                            NavigationLink (destination: FreeDrinkPrepView()
                               .environmentObject(sessionService)
                               .environmentObject(manager)
                               .environmentObject(homeVM),
                           label: {
                                ProfileLinkTile(destination: "Claim Drink")
                            })

                        }
                    }
                    
                    Group {
                        NavigationLink (destination: PageManagerView()
                           .environmentObject(sessionService)
                           .environmentObject(manager)
                           .environmentObject(homeVM)
                           .environmentObject(pageManager),
                       label: {
                            ProfileLinkTile(destination: "Pages")
                        })
                        .simultaneousGesture(TapGesture().onEnded({
                            pageManager.getMyPages(uid: sessionService.userDetails.uid, completion: {})
                        }))
                    }
                    
                }
                .padding(.top, 30)
                .buttonStyle(.plain)
                
                Spacer()
            }
            .padding(.top, 70)
            .ignoresSafeArea()
            .padding(.horizontal)
            .onAppear {
                homeVM.checkDrinkControl()
                
                sessionService.hasClaimedDrink(uid: sessionService.userDetails.uid)
                
                sessionService.updateStreak(id: sessionService.userDetails.uid)
                sessionService.refreshUserDetails()
                
                homeVM.getVenueFreeDrinks()
                
                sessionService.getFriendRequests(uid: sessionService.userDetails.uid, completion: {})
                
                sessionService.getFriends(uid: sessionService.userDetails.uid, completion: {})
                
//                Task {
////                    await sessionService.getFriendRequests(uid: sessionService.userDetails.uid, completion: {})
//                    await sessionService.getFriends(uid: sessionService.userDetails.uid)
//                }
                

            }
            .background(Color("darkBackground"))
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButtonView())
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ProfileView_Preview: PreviewProvider {
    
    static var previews: some View {
        
        NavigationView {
            ProfileView()
                .environmentObject(SessionServiceImpl())
                .environmentObject(LocationManager())
                .environmentObject(ViewModel())
        }
    }
}
