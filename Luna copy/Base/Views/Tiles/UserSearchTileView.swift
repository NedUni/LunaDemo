//
//  UserSearchTileView.swift
//  Luna
//
//  Created by Will Polich on 23/1/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserSearchTileView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var homeVM : ViewModel
    @StateObject var service = UserProfileService()
    
    var user : UserObj
    
    var body: some View {
        
        NavigationLink(destination: user.performer ? AnyView(PerformerProfileView(user: user)
                        .environmentObject(sessionService)
                        .environmentObject(manager)
                        .environmentObject(homeVM))
                       : AnyView(UserProfileView(user: user)
                        .environmentObject(sessionService)
                        .environmentObject(manager)
                        .environmentObject(homeVM)) , label: {
            VStack (alignment: .leading) {
                HStack (alignment: .center) {
                    WebImage(url: URL(string: user.imageURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .cornerRadius(64)
                    
                    
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
                }
                
                
            }
            .onAppear {
                service.getProfileMutualFriends(uid: sessionService.userDetails.uid, target: user.uid)
            }

            
            
            
//            VStack (alignment: .leading) {
//                HStack {
//                    WebImage(url: URL(string: user.imageURL))
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 64, height: 64).cornerRadius(64)
////                            .overlay(RoundedRectangle(cornerRadius: 128).strokeBorder(Color.primary, lineWidth: 3))
//                        .clipped()
//                        .padding()
//
//                    VStack (alignment: .leading){
//                        Text("\(user.firstName) \(user.lastName)")
//                            .font(.system(size: 20))
//                            .foregroundColor(Color.primary)
//                        if service.mutualFriends.count != 0 {
//                            if service.mutualFriends.count > 1 {
//                                Text("\(service.mutualFriends.count) mutual friends")
//                                    .foregroundColor(Color.secondary)
//                            } else {
//                                Text("1 mutual friend")
//                                    .foregroundColor(Color.secondary)
//                            }
//
//                        }
////                        else {
////                            Text("no mutual friends")
////                                .foregroundColor(Color.primary.opacity(0.8))
////
////                        }
//
//
//                    }
//
//
//                    Spacer()
//
//                }
//            }
            
            
        })
        .buttonStyle(.plain)
        
        
    }
}




//
//struct Previews_UserSearchTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        let user = UserObj(firstName: "John", lastName: "Smith", uid: "zaqedvUSCIYMxTpiY9GHjjpLUGz1", imageURL: "https://firebasestorage.googleapis.com:443/v0/b/appluna.appspot.com/o/users%2FprofilePictures%2FzaqedvUSCIYMxTpiY9GHjjpLUGz1?alt=media&token=83d7ce99-a3be-409f-883f-0d6e396f4d30", friends: [], favourites: [], streak: 0)
//        
//        UserSearchTileView(user: user)
//            .environmentObject(SessionServiceImpl())
//            .environmentObject(LocationManager())
//            .environmentObject(ViewModel())
//    }
//}
