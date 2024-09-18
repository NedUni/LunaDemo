//
//  StoryView.swift
//  Luna
//
//  Created by Ned O'Rourke on 19/4/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct HotStoriesStoryView: View {
    
    @EnvironmentObject var storyHandler : storiesHandler
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var homeVM : ViewModel
    
    @State var currentImage : Int = 0
    @Binding var storyView : Bool
    @State var venueID : String
    
    @Binding var nextChange : String
    
    @State private var theseStories : [StoryObj] = []
        
    var body: some View {
        
        ZStack (alignment: .top) {
            
                ForEach(theseStories, id: \.self) { photo in
                        
//                    if trig {
                        let indexOfA = theseStories.firstIndex(of: photo)
                        let numberOfStories = theseStories.count
                        if currentImage == indexOfA {

                            HotStoriesIndividualStory(story: photo, storyView: $storyView, currentImage: $currentImage, numberOfStories: numberOfStories, nextChange: $nextChange)
                               .environmentObject(sessionService)
                               .environmentObject(storyHandler)
                               .environmentObject(homeVM)
                       }
                }
        }
        .task {
            await storyHandler.getStories(venueID: venueID, completion: { check in
                print(check) //buzzword
            })
            theseStories = storyHandler.stories
            
        }
    }
    
}

//struct StoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoryView(storyView: .constant(true), venueID: "fpdGaaewafHPfJt7MqD2")
//            .environmentObject(storiesHandler())
//            .environmentObject(SessionServiceImpl())
//    }
//}

