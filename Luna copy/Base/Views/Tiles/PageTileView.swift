//
//  PageTileView.swift
//  Luna
//
//  Created by Will Polich on 23/5/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct PageTileView: View {
    let page : PageObj

    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    var body: some View {
        NavigationLink(destination: PageView(page: page)
                        .environmentObject(sessionService)
                        .environmentObject(manager)
                        .environmentObject(homeVM)) {
            
            ZStack (alignment: .bottomLeading) {
                WebImage(url: URL(string: page.banner_url))
                   .resizable()

                VStack (alignment: .leading){
                    
                    HStack {
                        WebImage(url: URL(string: page.logo_url))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45).cornerRadius(64)

                    }
                    .padding(5)
                   
                    
                    Spacer()
                    
                    
                    HStack {
                        Text(page.name)
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

