//
//  InviteTileView.swift
//  Luna
//
//  Created by Will Polich on 30/1/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import CachedAsyncImage

struct InviteTileView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var eventHandler: EventHandler
    
    var user : UserObj
    @State var invited : Bool
    

    var body: some View {
        
        VStack (alignment: .leading) {
            Button {
                if self.invited == false {
                    self.invited = true
                    eventHandler.invite(user: user)
                }
                else if self.invited == true {
                    self.invited = false
                    eventHandler.removeInvite(user: user)
                }
                
                
            } label: {
                HStack {
                    WebImage(url: URL(string: user.imageURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64).cornerRadius(64)
                        .clipped()

                    Text("\(user.firstName) \(user.lastName)")
                        .font(.system(size: 20))
                        .foregroundColor(Color.primary)
                    
                    Spacer()
                    
                    if self.invited == false {
                        RoundedRectangle(cornerRadius: 32).strokeBorder(Color.secondary, lineWidth: 1)
                                .frame(width: 32, height: 32)
                            
                        
                    } else if self.invited == true {
                        ZStack {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .foregroundColor(Color.green)
                                .scaledToFill()
                                .frame(width: 32, height: 32)
                            RoundedRectangle(cornerRadius: 32).strokeBorder(Color.secondary, lineWidth: 1)
                                    .frame(width: 32, height: 32)
                        }
                    }
                }
                .opacity(self.invited ? 0.5 : 1)
            }
        }
    }
}

//struct InviteTileView_Previews: PreviewProvider {
//    
//    @StateObject static var sessionService = SessionServiceImpl()
//    
//    
//    static var previews: some View {
//        let user = UserObj(firstName: "John", lastName: "Smith", uid: "zaqedvUSCIYMxTpiY9GHjjpLUGz1", imageURL: "https://firebasestorage.googleapis.com:443/v0/b/appluna.appspot.com/o/users%2FprofilePictures%2FzaqedvUSCIYMxTpiY9GHjjpLUGz1?alt=media&token=83d7ce99-a3be-409f-883f-0d6e396f4d30", friends: [], favourites: [], streak: 0)
//        
//        InviteTileView(user: user, invited: false)
//            .environmentObject(sessionService)
//    }
//}
