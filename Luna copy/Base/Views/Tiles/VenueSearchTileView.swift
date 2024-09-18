//
//  VenueSearchTileView.swift
//  Luna
//
//  Created by Will Polich on 23/1/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct VenueSearchTileView: View {
   
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    @State var ven: VenueObj
    
    var body: some View {
        
        NavigationLink(destination: VenueView(ven: ven)
                        .environmentObject(sessionService)
                        .environmentObject(manager)
                        .environmentObject(homeVM)) {
            VStack (alignment: .leading) {
                HStack (alignment: .top) {
        
                    WebImage(url: URL(string: ven.imageurl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 110, height: 75)
                        .cornerRadius(10)
                        .clipped()

                    VStack (alignment: .leading) {
                        Text(ven.displayname)
                            .font(.system(size: 20))
                            .foregroundColor(Color.primary)
                            .multilineTextAlignment(.leading)
                
                        Text("\(ven.address)")
                            .fontWeight(.thin)
                            .font(.system(size: 15))
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                    .padding(.leading)
                    .foregroundColor(.primary)
                    
                    Spacer()
                }
                
            }
        }
       
       
    }

}



//struct Previews_VenueSearchTileView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let ven = VenueObj(id: "", displayname: "The Ivy Complex", abn: "", email: "", username: "", description: "", address: "330 George St, Sydney NSW 2000", events: [], filename: "", imageurl: "https://storage.googleapis.com/appluna.appspot.com/venueImages/4S4lYoQRZwWEw2cba46s/ea15d52f2a47e5a4b37c8ba11528486c.jpeg", deals: [], longitude: 0.0, latitude: 0.0, hasPokerMachines: false, hasLiveMusic: false, hasDanceFloor: false, checkins: [], tags: [], averageTime: -1, stories: [])
//
//        VenueSearchTileView(ven: ven)
//        
//    }
//}
