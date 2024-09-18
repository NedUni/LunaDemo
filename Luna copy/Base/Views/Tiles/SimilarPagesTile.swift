//
//  SimilarPagesTile.swift
//  Luna
//
//  Created by Ned O'Rourke on 12/4/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct SimilarPagesTile: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var pageManager : PageHandler
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var manager : LocationManager
    
    @State var page : PageObj
    
    var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            WebImage(url: URL(string: page.banner_url))
                .resizable()
                .scaledToFill()
                .frame(width: 230, height: 150, alignment: .center)
                .cornerRadius(10)
                .padding(.top, 10)
                .padding(.horizontal, 10)
            
            VStack (alignment: .leading, spacing: 1) {
                HStack {
                    Text(page.name)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    Spacer()
//                    Text("\(pageManager.totalThatFollowPage) followers")
                    Text("1.2K followers")
                        .foregroundColor(.white)
                }
                Divider()
                    .background(Color("darkSecondaryText"))
                
//                Text("\(pageManager.totalFriendsThatFollowPage) friends like it")
//                Text("69 friends like it • 8 past events")
//                Text(page.description)
                HStack (alignment: .top) {
                    VStack (alignment: .leading, spacing:1) {
                        Text("25 past events")
                        Text("69 friends like it")
                    }
                    .foregroundColor(Color("darkSecondaryText"))
                    Spacer()
                    VStack (alignment: .center, spacing: -5) {
                        Text("25")
                            .fontWeight(.bold)
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                        Text("april")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                        
                    }
                    .frame(width: 60, height: 60, alignment: .center)
                    .background(Color("purple"))
                    .cornerRadius(40)
                    .padding(.top, 5)
                    .padding(.trailing, 5)
                }
            }
            .padding(.horizontal, 10)
                
        }
        .frame(width: 250, height: 270, alignment: .topLeading)
        .background(Color("darkForeground"))
        .cornerRadius(10)
        
    }
}

struct SimilarPagesTile_Previews: PreviewProvider {
    static var previews: some View {
        let page = PageObj(id: "xd", name: "SASH", email: "", description: "blah blah blah this is some gay ass shit", promotedEvent: "", events: [""], banner_url: "https://scontent.fsyd8-1.fna.fbcdn.net/v/t1.6435-9/35530592_1612046495588377_5590993223964164096_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=0WxBIg5qdEcAX8MiN1t&_nc_ht=scontent.fsyd8-1.fna&oh=00_AT_zm9fud1dzMUPpqHE1Sgaa7jVEeoWuf5q30X0qxfTfvQ&oe=627AFB66", logo_url: "https://scontent.fsyd8-1.fna.fbcdn.net/v/t1.6435-9/35530592_1612046495588377_5590993223964164096_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=0WxBIg5qdEcAX8MiN1t&_nc_ht=scontent.fsyd8-1.fna&oh=00_AT_zm9fud1dzMUPpqHE1Sgaa7jVEeoWuf5q30X0qxfTfvQ&oe=627AFB66", categories: [""], followers: [""], admins: [""], website: "")
        
        ZStack {
            Color("darkBackground")
            
            SimilarPagesTile(page: page)
        }
        
    }
}
