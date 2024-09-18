//
//  View2.swift
//  Luna
//
//  Created by Ned O'Rourke on 29/3/22.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct View2: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var pageManager : PageHandler
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var manager : LocationManager
    
    @State var page : PageObj
    
    var body: some View {
        ScrollView {
            VStack (alignment: .center) {
                if pageManager.pastEvents.count == 0 {
                    Text("Page has no past events")
                        .padding(.vertical, 5)
                    
                    Divider()
                }
                ScrollView (showsIndicators: false) {
                    ForEach(pageManager.pastEvents, id: \.self) { event in
                        EventTileView(event: event, clickable: true)
                                .environmentObject(sessionService)
                                .environmentObject(manager)
                                .environmentObject(homeVM)
                                .padding(.vertical, 5)
                        
                        Divider()
                    
                    }
                }
            }
        }
        .onAppear {
            let queue = DispatchQueue(label: "past", attributes: .concurrent)
            
            queue.async {pageManager.getPastEvents(pageID: page.id) }
        }
    }
}

//struct View2_Previews: PreviewProvider {
//    static var previews: some View {
//        View2(page)
//    }
//}
