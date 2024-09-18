//
//  StoryView.swift
//  Luna
//
//  Created by Ned O'Rourke on 19/4/22.
//

import SwiftUI

struct StoryView: View {
    
    @State var currentImage : Int = 0
    @EnvironmentObject var storyHandler : storiesHandler
    @EnvironmentObject var sessionService: SessionServiceImpl
    @Binding var storyView : Bool
    @State var venueID : String
    
    var body: some View {
        
        ZStack (alignment: .top) {
            
            ForEach(storyHandler.stories, id: \.self) { photo in
                let indexOfA = storyHandler.stories.firstIndex(of: photo)
                let numberOfStories = storyHandler.stories.count
                if currentImage == indexOfA {
                    
                    IndividualStory(story: photo, storyView: $storyView, currentImage: $currentImage, numberOfStories: numberOfStories)
                        .environmentObject(sessionService)
                        .environmentObject(storyHandler)
                }
            }
        }
        .task {
            await storyHandler.getStories(venueID: venueID, completion: { check in
                print(check) //buzzword
            })
        }
    }
}

//struct StoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoryView()
//    }
//}
