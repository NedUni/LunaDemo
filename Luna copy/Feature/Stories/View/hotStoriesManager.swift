//
//  manager.swift
//  Luna
//
//  Created by Ned O'Rourke on 5/5/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct hotStoriesManager: View {
    
    @State var currentImage : Int = 0
    @EnvironmentObject var storyHandler : storiesHandler
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var homeVM : ViewModel
    
    @Binding var storyView : Bool
    
    @Binding var venueID : String
    
//    @State var reachedEnd : Bool = false
    
    var body: some View {
        
        TabView (selection: $venueID) {
            ForEach(homeVM.popularStoryVenues, id: \.self) { venue in
                ZStack {
                    HotStoriesStoryView(storyView: $storyView, venueID: venue, nextChange: $venueID)
                       .environmentObject(sessionService)
                       .environmentObject(storyHandler)
                       .environmentObject(homeVM)
                       .tag(venue)
//                       .onAppear {
//                           if reachedEnd {
//                               print("lol")
//                           }
//                       }
                    
//                        Button {
//                            var index = homeVM.popularStoryVenues.firstIndex(where: {$0 == venue})
//                            index! += 1
//                            print(index!)
//                            venueID = homeVM.popularStoryVenues[index!]
//                        } label: {
//                            Text("press me you cat")
//                        }
                    }
                
                    

                }
                
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}
