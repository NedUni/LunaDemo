//
//  MeetHostsTile.swift
//  Luna
//
//  Created by Ned O'Rourke on 3/5/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import MapKit

struct MeetHostsTile: View {
    
    @State var page : PageObj
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var pageManager : PageHandler
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var manager : LocationManager
    
    var body: some View {
        NavigationLink(destination: PageView(page: page)) {
            ZStack(alignment: .leading) {
                
                VStack (spacing: 0) {
                    WebImage(url: URL(string: page.banner_url))
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width*0.5, height: UIScreen.main.bounds.height*0.125, alignment: .center)
                        .clipped()
                    
                    VStack (alignment: .leading, spacing: 0) {
                        VStack {
                            Text("\(page.followers.count) likes • \(page.events.count) events")
                                .font(.system(size: 10))
                        }
                        .padding(.top, 5)
                        .padding(.leading, 55)
                        .padding(.horizontal)
                        .foregroundColor(Color("darkSecondaryText"))

                        VStack (alignment: .leading) {
                            Text(page.name)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)

                        }
                        .padding(.horizontal)
                        .padding(.top, 7)
                        .foregroundColor(.primary)
                        .layoutPriority(1)

                        Divider()
                            .padding(.horizontal)

                        VStack {
                            Text(page.description)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.leading)
                        }
                        .frame(minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                        .padding(.top, 3)
                        .padding(.horizontal)
                        .padding(.bottom, 3)
                        .foregroundColor(Color("darkSecondaryText"))
                        

                    }
                    .frame(width: UIScreen.main.bounds.width*0.5, height: UIScreen.main.bounds.height*0.125, alignment: .center)
                }
                .frame(width: UIScreen.main.bounds.size.width*0.5, height: UIScreen.main.bounds.size.height*0.25, alignment: .center)
                .background(Color("darkForeground"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10,
                                     style: .continuous)
                    .strokeBorder(Color("darkSecondaryText"), lineWidth: 0.3)
                )
                
                WebImage(url: URL(string: page.logo_url))
                   .resizable()
                   .scaledToFill()
                   .frame(width: 50, height: 50, alignment: .bottom)
                   .cornerRadius(75)
                   .padding()
                
            }
        }
        }
    
}

struct MeetHostsTile_Previews: PreviewProvider {
    static var previews: some View {
        let page = PageObj(id: "", name: "Scenes", email: "", description: "Providing and establishing a scene for the intricacies of music and arts.", promotedEvent: "", events: [], banner_url: "https://scontent.fsyd7-1.fna.fbcdn.net/v/t39.30808-6/273044221_284772693749062_274659856556264380_n.jpg?_nc_cat=110&ccb=1-5&_nc_sid=e3f864&_nc_ohc=jy2XIQhrKEEAX-KC4hX&tn=2vBl4W4EZzgoRa9r&_nc_ht=scontent.fsyd7-1.fna&oh=00_AT87RoHI7zNMDwOVqsa8Bk2CofMAHBi7wbGoCNUdZwq4xg&oe=627649EF", logo_url: "https://scontent.fsyd8-1.fna.fbcdn.net/v/t1.6435-9/200649635_139540311605635_918823717422474070_n.png?_nc_cat=111&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=MmyyC2Ogo80AX8d_W63&_nc_ht=scontent.fsyd8-1.fna&oh=00_AT-C6ACjvqcbbthYEFgxl2m9FXUJlxKcDrcbvQleiJSigg&oe=62928654", categories: [], followers: ["me"], admins: [], website: "")
        MeetHostsTile(page: page)
    }
}
