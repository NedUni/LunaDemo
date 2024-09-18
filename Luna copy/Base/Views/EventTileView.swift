//
//  EventTileView.swift
//  Luna
//
//  Created by Ned O'Rourke on 22/1/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct EventTileView: View {
    
    let event : EventObj
    @StateObject var viewModel = ViewModel()
    @EnvironmentObject var sessionService : SessionServiceImpl
    @State var going = 0
    @State var interested = 0
    @State var friendsGoing = 0
    var body: some View {
        
        NavigationLink(destination: EventView(event: event)) {
            VStack (alignment: .leading) {
                HStack {
        
                    WebImage(url: URL(string: event.imageurl))
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 100, maxHeight: 100)
                        .cornerRadius(10)

                    VStack (alignment: .leading) {
                        Text(event.label)
                            .font(.system(size: 25))
                            .foregroundColor(Color.primary)

                        
                        // Eventually add a day instead of date if it's this week etc
                        Text("\(event.date) \(event.startTime) - \(event.endTime)")
                            .fontWeight(.thin)
                        
                        // Placeholder
                        // Only show once a certain amount of people has been reached maybe?
                        
                        HStack {
                            if self.going > 0 {
                                Text("\(self.going) going ")
                                    .fontWeight(.thin)
                                    .foregroundColor(Color.secondary)
                            }
                            if self.interested > 0 {
                                Text("\(self.interested) interested")
                                    .fontWeight(.thin)
                                    .foregroundColor(Color.secondary)
                            }
                        }
                      
                            
                        
                        if self.friendsGoing > 0 {
                            Text("\(self.friendsGoing) friends going")
                                .fontWeight(.thin)
                                .foregroundColor(Color.secondary)
                        }
                        
                        
                            
                    }
                    .foregroundColor(.primary)
                    .frame(width: 200, height: 100)


                }
            }
        }.onAppear {
            self.going = event.going.count
            self.interested = event.interested.count
            for user in event.going {
                if sessionService.userDetails.friends.contains(user) {
                    self.friendsGoing += 1
                }
                   
            }
        }
        
    }
}

struct EventTileView_Previews: PreviewProvider {
    static var previews: some View {
        let event = EventObj(date: "23/01/2022", description: "", endTime: "23:00", filename: "the ivy precinct", id: "", imageurl: "https://storage.googleapis.com/appluna.appspot.com/eventImages/4S4lYoQRZwWEw2cba46s/lost.png", label: "Lost Sundays", startTime: "20:00", creatorID: "", invited: [], going: [], interested: [], declined: [], userCreated: false)
        NavigationView {
            EventTileView(event: event)
        }
    }
}
