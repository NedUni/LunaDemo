//
//  AddFriendTile.swift
//  Luna
//
//  Created by Ned O'Rourke on 28/4/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct AddFriendTile: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    @State var user : UserObj
    @State var queue : DispatchQueue
    @State var count : Int = 0
    
    @State var actionTaken : Bool = false
    
    var body: some View {
        NavigationLink(destination: user.performer ? AnyView(PerformerProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM))
           : AnyView(UserProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM))) {
                
                if !actionTaken {
                    VStack (alignment: .leading) {
                        HStack (alignment: .center) {
                            WebImage(url: URL(string: user.imageURL))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 56, height: 56)
                                .cornerRadius(64)
//                                .padding(10)
                            
                            VStack (alignment: .leading) {
                                Text("\(user.firstName) \(user.lastName)")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.primary)
                                    .lineLimit(1)
                                
                                Text(self.count == 0 ? "" : String("\(self.count) mutual friends"))
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.secondary)
                            }
                            
                            
                            Spacer()
                            
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "xmark")
                                    .opacity(0.2)
                                    .padding(.top, 4)
                            }
                            .buttonStyle(.plain)
                            .highPriorityGesture(
                                TapGesture()
                                    .onEnded { _ in
                                        sessionService.removeSuggested(uid: sessionService.userDetails.uid, user: user.uid)
                                        withAnimation {
                                            self.actionTaken = true
                                        }


                                    }
                            )
                            .buttonStyle(.plain)

                            
                            Button {} label: {
                                Text("+ add")
                                    .fontWeight(.medium)
                                    .foregroundColor(self.actionTaken ? .white : .purple)
                                    .background(self.actionTaken ? .purple : .clear)
                                    .padding(7)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.purple, lineWidth: 1)
                                    )
                                    .padding(.trailing, 1)
                            }
//                            .padding(.trailing)
                            .highPriorityGesture(
                                TapGesture()
                                    .onEnded { _ in
                                        sessionService.sendFriendRequest(sender: sessionService.userDetails.uid, recipient: user.uid) {
                                            sessionService.refreshUserDetails()
                                            
                                        }
                                        withAnimation {
                                            self.actionTaken = true
                                        }
                                    }
                            )
                            
//                            Button {} label: {
//                                Text("x")
//                                    .fontWeight(.bold)
//                                    .foregroundColor(.white)
//                                    .background(self.actionTaken ? .white : .clear)
////                                    .padding(6)
//                                    .padding(.vertical, 7)
//                                    .padding(.horizontal, 10)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 10)
//                                            .stroke(Color.white, lineWidth: 1)
//                                    )
////                                    .padding(.trailing, 1)
//                            }
//                            .padding(.trailing)
//                            .highPriorityGesture(
//                                TapGesture()
//                                    .onEnded { _ in
//                                        print("Remove me")
//                                        sessionService.removeSuggested(uid: sessionService.userDetails.uid, user: user.uid)
//                                        withAnimation {
//                                            self.actionTaken = true
//                                        }
//
//
//                                    }
//                            )
                        }
                        
                        
                    }
                    .transition(AnyTransition.opacity.combined(with: .slide))
                    .onAppear {
                        queue.async { sessionService.getMutualFriendsCount(userID: sessionService.userDetails.uid, friendID: user.uid, completion: { count in
                            self.count = count
                        })}
                        
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 2)

                }
            }
        
        
//        VStack (alignment: .leading) {
//            HStack {
//                WebImage(url: URL(string: user.imageURL))
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 64, height: 64)
//                    .cornerRadius(64)
//                    .padding()
//
//                VStack (alignment: .leading) {
//                    Text("\(user.firstName) \(user.lastName)")
//                        .font(.system(size: 20))
//                        .foregroundColor(Color.primary)
//
//                    Text(self.count == 0 ? "" : String("\(self.count) mutual friends"))
//                        .font(.system(size: 10))
//                        .foregroundColor(Color.secondary)
//                }
//
//
//                Spacer()
//
//                Button {
//                    print("send friend request")
////                    isShowingMessages.toggle()
//
//                } label: {
//                    Text("+ add")
//                        .fontWeight(.medium)
//                        .foregroundColor(.purple)
//                        .padding(7)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.purple, lineWidth: 1)
//                        )
//                }
//                .padding(.trailing)
//            }
//        }
//        .onAppear {
//            Task {
//                await sessionService.getMutualFriendsCount(userID: sessionService.userDetails.uid, friendID: user.uid, completion: { count in
//                    self.count = count
//                })
//            }
//        }
//        .task {
//
//        }
    }
}

//struct AddFriendTile_Previews: PreviewProvider {
//    static var previews: some View {
//        AddFriendTile()
//    }
//}
