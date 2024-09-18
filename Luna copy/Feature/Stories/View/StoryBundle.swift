//
//  StoryBundle.swift
//  Luna
//
//  Created by Ned O'Rourke on 9/5/2022.
//

import SwiftUI

struct StoryBundle: View {
    
    @EnvironmentObject var storyHandler : storiesHandler
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var homeVM : ViewModel
    
    @State var images : [String] = ["https://firebasestorage.googleapis.com:443/v0/b/appluna.appspot.com/o/storyImages%2F6NNoWaIRryVO0m7IdIMf?alt=media&token=07db6fc0-0868-4ab7-a4f3-e190043ce06b", "https://firebasestorage.googleapis.com:443/v0/b/appluna.appspot.com/o/storyImages%2F8fuLj4hcFr3lncKeR0A7?alt=media&token=ed65fb05-d80d-4e2d-abfb-236d8a525c3c"] //"https://firebasestorage.googleapis.com:443/v0/b/appluna.appspot.com/o/storyImages%2FDzotFzA2wzVCbpPzVVLH?alt=media&token=4d52808f-9100-428c-8302-d550446a14f8"
    var body: some View {
        
        ZStack {
            ForEach(self.images, id:\.self) { story in
                StoryImage(
                    url: URL(string: story)!,
                    placeholder: { Text("Loading ...") },
                    image: { Image(uiImage: $0).resizable() }
                )
            }
        }
        
    }
}

struct StoryBundle_Previews: PreviewProvider {
    static var previews: some View {
        StoryBundle()
    }
}
