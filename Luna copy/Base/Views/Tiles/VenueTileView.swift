//
//  VenueTileView.swift
//  Luna
//
//  Created by Ned O'Rourke on 20/1/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct VenueTileView: View {
    
    let ven : VenueObj

    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    var body: some View {
        NavigationLink(destination: VenueView(ven: ven)
                        .environmentObject(sessionService)
                        .environmentObject(manager)
                        .environmentObject(homeVM)) {
            
            ZStack (alignment: .bottomLeading) {
//                CachedAsyncImage(url: URL(string: ven.imageurl)) { image in
//                    image.resizable()
//                } placeholder: {
//                    ProgressView()
//                }
                WebImage(url: URL(string: ven.imageurl)).resizable()

            
                VStack (alignment: .trailing){
                    
                    HStack {
                        Text(ven.averageTime == -1 ? "No Line Data" : "\(ven.averageTime) mins")
                        Image(systemName: "person.3.sequence.fill")
                    }
                    .font(.system(size: 15))
                    .padding(.leading, 5)
                    .padding(.trailing, 3)
                    .padding(.vertical, 5)
                    .background(Color("darkForeground").opacity(0.8))
                    .foregroundColor(.primary)
                    .cornerRadius(40)
                    .offset(x: -6, y: 6)
                   
                    
                    Spacer()
                    
                    
                    HStack {
                        Text(ven.displayname)
                            .padding(.leading)
                        Spacer()
                    }
                    .frame(width: 230, height: 30)
                    .background(Color("darkForeground"))
                }
                
            }
            .frame(width: 230, height: 150)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.primary, lineWidth: 0.5))
            .foregroundColor(.primary)
        }
    }
}

//struct VenueTileView_Previews: PreviewProvider {
//    
//    
//    static var previews: some View {
//
//        let ven = VenueObj(id: "", displayname: "The Ivy Complex", abn: "", email: "", username: "", description: "", address: "", events: [], filename: "", imageurl: "https://storage.googleapis.com/appluna.appspot.com/venueImages/5nmYgcYZoS2O9Egdrb3H/Coogee-Pavilion-supplied-1920x1440.jpeg", deals: [], longitude: 0.0, latitude: 0.0, hasPokerMachines: false, hasLiveMusic: false, hasDanceFloor: false, checkins: [], tags: [], averageTime: -1, stories: [])
//
//            
//        NavigationView {
//            VenueTileView(ven: ven)
//                .environmentObject(SessionServiceImpl())
//                .environmentObject(LocationManager())
//                .environmentObject(ViewModel())
//        }
//    }
//}
