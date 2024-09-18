//
//  FriendRequestTileView.swift
//  Luna
//
//  Created by Will Polich on 24/1/2022.
//


import SwiftUI
import SDWebImageSwiftUI


struct FriendRequestTileView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var homeVM : ViewModel
    @State var actionTaken : Bool = false

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
            
            if (actionTaken == false) {
                VStack (alignment: .leading) {
                    HStack {
                        WebImage(url: URL(string: user.imageURL))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64).cornerRadius(64)
                            .clipped()
                            .padding()

        //                VStack (alignment: .leading) {
                        Text("\(user.firstName) \(user.lastName)")
                            .font(.system(size: 20))
                            .foregroundColor(Color.primary)
                        
                        Spacer()
                        
                        if actionTaken == false {
                            Button (action: {
                                sessionService.declineFriendRequest(sender: user.uid, recipient: sessionService.getUID(), completion: {
                                    sessionService.refreshUserDetails()
                                    withAnimation {
                                        self.actionTaken = true
                                    }
                                })
                                let impactMed = UIImpactFeedbackGenerator(style: .rigid)
                                impactMed.impactOccurred()
                                
                                

                            },
                            
                                label: {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .foregroundColor(Color.primary)
                                    .scaledToFill()
                                    .frame(width: 28, height: 28)
                                    .padding(.trailing)
                            })
                            
                            Button (action: {
                                sessionService.acceptFriendRequest(sender: user.uid, recipient: sessionService.getUID(), completion: {
                                    sessionService.refreshUserDetails()
                                    withAnimation {
                                        self.actionTaken = true
                                    }
                                })
                                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                impactMed.impactOccurred()
                                
                            },
                            
                                label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .foregroundColor(Color.primary)
                                    .scaledToFill()
                                    .frame(width: 28, height: 28)
                                    .padding(.trailing)
                            })
                        }
                        

                    }
                }
                .transition(AnyTransition.opacity.combined(with: .slide))

            }
        })
       
        
    }
}





//struct Previews_FriendRequestTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        let user = UserObj(firstName: "John", lastName: "Smith", uid: "zaqedvUSCIYMxTpiY9GHjjpLUGz1", imageURL: "https://firebasestorage.googleapis.com:443/v0/b/appluna.appspot.com/o/users%2FprofilePictures%2FzaqedvUSCIYMxTpiY9GHjjpLUGz1?alt=media&token=83d7ce99-a3be-409f-883f-0d6e396f4d30", friends: [], favourites: [], streak: 0)
//        
//        FriendRequestTileView(user: user)
//            .environmentObject(LocationManager())
//            .environmentObject(SessionServiceImpl())
//    }
//}

