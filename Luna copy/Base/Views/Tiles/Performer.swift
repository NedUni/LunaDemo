//
//  Performer.swift
//  Luna
//
//  Created by Ned O'Rourke on 23/3/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct Performer: View {
    
    var performer : UserObj
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    var body: some View {
        NavigationLink(destination: PerformerProfileView(user: performer)
                        .environmentObject(sessionService)
                        .environmentObject(homeVM)
                        .environmentObject(manager)) {
            VStack {
                WebImage(url: URL(string: performer.imageURL))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90).cornerRadius(75)
                    .saturation(0.0)
                    .overlay {
                        Image(systemName: "music.note")
                            .frame(width: 30, height: 30)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .background(.purple.opacity(0.9))
                            .cornerRadius(40)
                            .offset(x: 35, y: 35)
                    }
                
                    
                Text(performer.firstName + " " + performer.lastName)
                    .foregroundColor(Color.primary)
            }
        }
        
    }
}

//struct Performer_Previews: PreviewProvider {
//    static var previews: some View {
//        let user = UserObj(firstName: "Ben", lastName: "Gerrans", uid: "zaqedvUSCIYMxTpiY9GHjjpLUGz1", imageURL: "https://www.famousbirthdays.com/headshots/ben-gerrans-1.jpg", friends: [], favourites: [], streak: 0)
//        
//        Performer(performer: user)
//    }
//}
