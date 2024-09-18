//
//  FriendTileView.swift
//  Luna
//
//  Created by Will Polich on 25/1/2022.
//


import SwiftUI
import SDWebImageSwiftUI
import SDWebImage
import CachedAsyncImage


struct FriendTileView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var homeVM : ViewModel
    @State var removed: Bool = false
    
    @State var wantToRemove: Bool = false
    
    var user : UserObj
    var body: some View {
        
        
        NavigationLink(destination: user.performer ? AnyView(PerformerProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM))
           : AnyView(UserProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM)), label: {
            if (removed == false) {
                VStack () {
                    HStack {
                        WebImage(url: URL(string: user.imageURL))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64).cornerRadius(64)
                            .clipped()
//                            .padding()
                        

                        Text("\(user.firstName) \(user.lastName)")
                            .font(.system(size: 20))
                            .foregroundColor(Color.primary)
                        
                        Spacer()
                        
                       
                        
                        if self.removed == false {
                            Button (action: {
                                // remove friend + confirmation popup
                                withAnimation {
                                    wantToRemove.toggle()
                                }
                                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                impactMed.impactOccurred()
                                

                            },
                            
                                label: {
                                VStack {
                                    Text("Remove")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .frame(minWidth: 0, maxWidth: 75, minHeight: 30, maxHeight: 30)
                                .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color("darkSecondaryText"), lineWidth: 1)
                                )
                                .padding(.trailing, 1)
                            })
                        }

                    }
                }
                .transition(AnyTransition.opacity.combined(with: .slide))
            }
        })
        .alert("Are you sure you want to remove this friend?", isPresented: $wantToRemove, actions: {
            // 1
              Button("Cancel", role: .cancel, action: {})

              Button("Confirm", role: .destructive, action: {
                  
                  
                  sessionService.removeFriend(user1: sessionService.userDetails.uid, user2: user.uid, completion: {
                      withAnimation {
                          self.removed = true
                      }
                      
                      sessionService.refreshUserDetails()
                      
                  })
            })
                  
                
                  
            }, message: {
              Text("You can find them again later through search or the Add Friends section of your profile.")
            })
        
    }
}
