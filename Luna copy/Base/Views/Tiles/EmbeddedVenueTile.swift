//
//  EmbeddedVenueTile.swift
//  Luna
//
//  Created by Will Polich on 11/4/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct EmbeddedVenueTile: View {
    let ven : VenueObj

    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        
        NavigationLink(destination: VenueView(ven: ven)
                        .environmentObject(sessionService)
                        .environmentObject(manager)
                        .environmentObject(homeVM)) {
            
            VStack (alignment: .leading, spacing: 0) {
                HStack {
                    WebImage(url: URL(string: ven.imageurl))
                        .resizable()
                        .aspectRatio(2.1, contentMode: .fit)
                        .clipped()

                }

                

                HStack (alignment: .top) {
                    VStack (alignment: .leading) {
                    
                       
                        Text(ven.displayname)
//                            .font(.system(size: 12))
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.leading)
                        Text(ven.address)
                                .font(.system(size: 10))
                                .fontWeight(.medium)
                                .foregroundColor(.purple)
                    }
                }
                .foregroundColor(.primary)
                .padding(.horizontal)
                .padding(.vertical, 3)
            }
            .frame(maxWidth: 350)
            .cornerRadius(20)
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 0.5)
            )
        }
    }
}


