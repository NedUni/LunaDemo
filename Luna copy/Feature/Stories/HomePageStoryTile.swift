//
//  HomePageStoryTile.swift
//  Luna
//
//  Created by Ned O'Rourke on 5/5/2022.
//

import SwiftUI

struct HomePageStoryTile: View {
    
    @EnvironmentObject var storiesManager : storiesHandler
    @State var story : [StoryObj]?
    @State var trig : Bool = false
    
    @State var hasLoaded : Bool = false
    
    @State var venue : String
    @Binding var storyView : Bool
    @State var VenueNumber : Int
    
    @Binding var selectedVenueString : String
    
    var body: some View {
        ZStack {
            if trig {
                ForEach (self.story!.reversed(), id:\.self) { story in
                    StoryImage(
                        url: URL(string: story.url)!,
                        placeholder: { Text("Loading ...") },
                        image: { Image(uiImage: $0).resizable() }
                    )
                }
                
                    
                
            }
        }
        .frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.25, alignment: .center)
        .cornerRadius(10)
        .onAppear {
            Task {
                if !hasLoaded {
                    await storiesManager.getStories(venueID: self.venue, completion: { story in
                        self.story = storiesManager.stories
                        trig = true
                        hasLoaded = true
                    })
                }
                
            }
        }
        .onTapGesture {
            
            setSelectedVenue(venue: venue) {
                self.storyView.toggle()
            }
            
            
        }
    }
    func setSelectedVenue(venue: String, completion: @escaping () ->()) {
        selectedVenueString = venue
        completion()
    }
}


//struct HomePageStoryTile_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePageStoryTile()
//    }
//}
