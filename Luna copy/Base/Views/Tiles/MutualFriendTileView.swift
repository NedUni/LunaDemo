//
//  MutualFriendTileView.swift
//  Luna
//
//  Created by Ned O'Rourke on 2/3/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct MutualFriendTileView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var homeVM : ViewModel
    @StateObject var service = UserProfileService()
    
    var user : UserObj
    @State var actionTaken : Bool = false
    
    
    var body: some View {
        
        NavigationLink(destination: user.performer ? AnyView(PerformerProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM))
           : AnyView(UserProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM)), label: {
            if (actionTaken == false) {
                VStack (alignment: .leading) {
                    HStack (alignment: .center) {
                        WebImage(url: URL(string: user.imageURL))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64).cornerRadius(64)
                            .clipped()
                            .padding()
                        
                        VStack (alignment: .leading) {
                            
                            Text(user.firstName + " " + user.lastName)
                            
                            if service.mutualFriends.count > 1 {
                                Text("\(service.mutualFriends.count) mutual friends")
                                    .foregroundColor(Color.secondary)
                            } else if service.mutualFriends.count == 1 {
                                Text("1 mutual friend")
                                    .foregroundColor(Color.secondary)
                            }
                        }
                       
                        
                        Spacer()
                        
                            Button (action: {


                                sessionService.sendFriendRequest(sender: sessionService.userDetails.uid, recipient: user.uid, completion: {

                                    withAnimation {
                                        self.actionTaken = true
                                    }

                                    sessionService.refreshUserDetails()

                                    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                    impactMed.impactOccurred()
                                })





                            }, label: {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                            })
                        }
                    }
                .transition(AnyTransition.opacity.combined(with: .slide))
                .onAppear {
                    service.getProfileMutualFriends(uid: sessionService.userDetails.uid, target: user.uid)
                }
                .buttonStyle(.plain)
            }
        })
        .buttonStyle(.plain)
        
    }
}

//struct MutualFriendTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        MutualFriendTileView()
//    }
//}
//
//struct MutualFriendTIme_Previews: PreviewProvider {
//    static var previews: some View {
//        let user = UserObj(firstName: "John", lastName: "Smith", uid: "zaqedvUSCIYMxTpiY9GHjjpLUGz1", imageURL: "https://firebasestorage.googleapis.com:443/v0/b/appluna.appspot.com/o/users%2FprofilePictures%2FzaqedvUSCIYMxTpiY9GHjjpLUGz1?alt=media&token=83d7ce99-a3be-409f-883f-0d6e396f4d30", friends: [], favourites: [], streak: 0)
//        
//        MutualFriendTileView(user: user)
//            .environmentObject(SessionServiceImpl())
//            .environmentObject(LocationManager())
//            .environmentObject(ViewModel())
//    }
//}
