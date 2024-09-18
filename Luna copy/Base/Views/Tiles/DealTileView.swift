//
//  DealTileView.swift
//  Luna
//
//  Created by Will Polich on 27/1/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct DealTileView: View {
    
    @Environment(\.colorScheme) var colorScheme
        
    let deal : DealObj
    
    var body: some View {
        
        ZStack (alignment: .bottomLeading) {
            WebImage(url: URL(string: deal.imageURL))
                .resizable()
                .scaledToFill()
                .frame(width: 230, height: 150)
                .clipped()


            VStack (alignment: .leading) {
                HStack {
                    Text("\(deal.name)")
                        .font(.system(size: 15))
                        .padding(.leading, 3)
                        .lineLimit(1)
                }
                
                Text("@ \(deal.venueName)")
                    .font(.system(size: 10))
                    .foregroundColor(.purple)
                    .fontWeight(.medium)
                    .padding(.leading, 3)

            }
            .frame(width: 230, alignment: .leading)
            .padding(.vertical, 4)
            .background(Color("darkForeground"))



        }
        .cornerRadius(10)
        .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.primary, lineWidth: 0.5)
        )        
    }
}

