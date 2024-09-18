//
//  View1.swift
//  Luna
//
//  Created by Ned O'Rourke on 29/3/22.
//

import SwiftUI

struct View1: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var pageManager : PageHandler
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var manager : LocationManager
    
    @State var page : PageObj
        
    var body: some View {
        VStack (alignment: .center) {
            if pageManager.upcomingEvents.count == 0 {
                Text("Page has no upcoming events")
                    .padding(.vertical, 5)
                
                Divider()
                
            }
            ScrollView (showsIndicators: false) {
                ForEach(pageManager.upcomingEvents, id: \.self) { event in
                    EventTileView(event: event, clickable: true)
                            .environmentObject(sessionService)
                            .environmentObject(manager)
                            .environmentObject(homeVM)
                            .padding(.vertical, 5)
                    
                    Divider()

                }
            }
        }
        .onAppear {
            let queue = DispatchQueue(label: "upcoming", attributes: .concurrent)
            
            queue.async {pageManager.getUpcomingEvents(pageID: page.id) }
        }
    }
}

//struct View1_Previews: PreviewProvider {
//    static var previews: some View {
//        View1(page: page)
//            .environmentObject(SessionServiceImpl())
//    }
//}
