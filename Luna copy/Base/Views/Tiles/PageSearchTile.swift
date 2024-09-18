//
//  PageSearchTitle.swift
//  Luna
//
//  Created by Ned O'Rourke on 16/5/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct PageSearchTile: View {
    
    @StateObject var pageManager = PageHandler()
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    @State var page : PageObj
    
    
    var body: some View {
        NavigationLink(destination: PageView(page: page)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(pageManager)
            .environmentObject(homeVM)) {
                HStack {
                    VStack (alignment: .leading) {
                        Text(page.name)
                            .font(.system(size: 20))
                        Text(page.categories.joined(separator: ","))
                            .foregroundColor(Color("darkSecondaryText"))
                    }
                    
                    
                    Spacer()
                    
                    WebImage(url: URL(string: page.logo_url))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .cornerRadius(50)
                        .clipped()
                }
            }
            .buttonStyle(.plain)
        
    }
}

//struct PageSearchTile_Previews: PreviewProvider {
//    static var previews: some View {
//        PageSearchTile()
//    }
//}
