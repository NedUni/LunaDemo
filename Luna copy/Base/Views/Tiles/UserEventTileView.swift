//
//  UserEventTileView.swift
//  Luna
//
//  Created by Will Polich on 31/1/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserEventTileView: View {

    let event : EventObj

    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    let df = DateFormatter()
    let calendar = Calendar.current
    
    @State var response = 1
    @State var clickable : Bool
    @State var date = ""
    
    var body: some View {
    
        VStack (alignment: .leading) {
            
            if clickable {
            
                if event.endTime == "" {
                    NavigationLink(destination: PresView(event: event)
                                    .environmentObject(manager)
                                    .environmentObject(sessionService)
                                    .environmentObject(homeVM)) {
                        VStack (alignment: .leading) {
                            HStack {
                    
                                WebImage(url: URL(string: event.imageurl))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)

                                VStack (alignment: .leading) {
                                    
                                    Text(event.label)
                                        .font(.system(size: 25))
                                        .foregroundColor(Color.primary)

                                    
                                    // Eventually add a day instead of date if it's this week etc
                                    if event.endTime != "" {
                                        Text("\(self.date) \(event.startTime) - \(event.endTime)")
                                            .fontWeight(.thin)
                                    } else {
                                        Text("\(self.date) \(event.startTime)")
                                            .fontWeight(.thin)
                                    }
                                   
                                    
                                    // Placeholder
                                    // Only show once a certain amount of people has been reached maybe?
                                    Text("Created by \(event.hostNames.joined(separator: ", "))")
                                        .fontWeight(.thin)
                                        .foregroundColor(Color.secondary)
                                    
                                    Text("\(event.going.count) going \(event.invited.count) invited")
                                        .fontWeight(.thin)
                                        .foregroundColor(Color.secondary)
                                    
                                    
                                    
                                        
                                }
                                .padding(.leading, 10)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.primary)
//                                .frame(maxWidth: 200, maxHeight: 100)

                                Spacer()
                                Spacer()
                            }
                        }
                        .frame(maxWidth: 400, maxHeight: 100)
                    }
                } else {
                   
                    NavigationLink(destination: PresView(event: event, responseTab: response)
                                    .environmentObject(manager)
                                    .environmentObject(sessionService)
                                    .environmentObject(homeVM)) {
                        VStack (alignment: .leading) {
                            HStack {
                    
                                WebImage(url: URL(string: event.imageurl))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)

                                VStack (alignment: .leading) {
                                    Text(event.label)
//                                        .frame(maxWidth: 200)
                                        .font(.system(size: 25))
                                        .foregroundColor(Color.primary)

                                    
                                    // Eventually add a day instead of date if it's this week etc
                                    if event.endTime != "" {
                                        Text("\(self.date) \(event.startTime) - \(event.endTime)")
                                            .fontWeight(.thin)
//                                            .frame(width: 200)
                                    } else {
                                        Text("\(self.date) \(event.startTime)")
                                            .fontWeight(.thin)
                                    }
                                    
                                    Text("Created by \(event.hostNames.joined(separator: ", "))")
                                        .fontWeight(.thin)
                                        .foregroundColor(Color.secondary)
                                   
                                    
                                    // Placeholder
                                    // Only show once a certain amount of people has been reached maybe?
                                    
                                    Text("\(event.going.count) going \(event.invited.count) invited")
                                        .fontWeight(.thin)
                                        .foregroundColor(Color.secondary)
                                    
                                        
                                }
                                .padding(.leading, 10)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.primary)
//                                .frame(maxWidth: 200, maxHeight: 100)

                                Spacer()
                            }
                        }
                    }
//                    .frame(maxWidth: 400, maxHeight: 100)
                }
            } else {
                if event.endTime == "" {
                    
                    VStack (alignment: .leading) {
                        HStack {
                
                            WebImage(url: URL(string: event.imageurl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)

                            VStack (alignment: .leading) {
                                Text(event.label)
                                    .font(.system(size: 25))
                                    .foregroundColor(Color.primary)

                                
                                // Eventually add a day instead of date if it's this week etc
                                if event.endTime != "" {
                                    Text("\(self.date) \(event.startTime) - \(event.endTime)")
                                        .fontWeight(.thin)
                                } else {
                                    Text("\(self.date) \(event.startTime)")
                                        .fontWeight(.thin)
                                }
                               
                                
                                // Placeholder
                                // Only show once a certain amount of people has been reached maybe?
                                Text("Created by \(event.hostNames.joined(separator: ", "))")
                                    .fontWeight(.thin)
                                    .foregroundColor(Color.secondary)
                                
                                Text("\(event.going.count) going \(event.invited.count) invited")
                                    .fontWeight(.thin)
                                    .foregroundColor(Color.secondary)
                                
                                    
                            }
                            .padding(.leading, 10)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.primary)
//                            .frame(maxWidth: 200, maxHeight: 100)
                            
                            Spacer()

                        }
                    }
//                    .frame(maxWidth: 400, maxHeight: 100)
                    
                } else {
                   
                   
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
                                if event.endTime != "" {
                                    Text("\(self.date) \(event.startTime) - \(event.endTime)")
                                        .fontWeight(.thin)
                                } else {
                                    Text("\(self.date) \(event.startTime)")
                                        .fontWeight(.thin)
                                }
                               
                                
                                // Placeholder
                                // Only show once a certain amount of people has been reached maybe?
                                Text("Created by \(event.hostNames.joined(separator: ", "))")
                                    .fontWeight(.thin)
                                    .foregroundColor(Color.secondary)
                                
                                Text("\(event.going.count) going \(event.invited.count) invited")
                                    .fontWeight(.thin)
                                    .foregroundColor(Color.secondary)
                                
                                    
                            }
                            .padding(.leading, 10)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.primary)
//                            .frame(maxWidth: 200, maxHeight: 100)
                            
                            Spacer()
                        }
                    }
//                    .frame(maxWidth: 400, maxHeight: 100)
                }
            }
                
        }
        .onAppear {
            self.date = event.date
            if event.invited.contains(sessionService.userDetails.uid) {
                self.response = 1
            } else if event.going.contains(sessionService.userDetails.uid) {
                self.response = 2
            } else if event.interested.contains(sessionService.userDetails.uid) {
                self.response = 3
            } else if event.declined.contains(sessionService.userDetails.uid) {
                self.response = 4
            }
            
            dateFormatter.dateFormat = "dd-MM-yyyy"
            guard let dateObj = dateFormatter.date(from: event.date) else {return}

            if calendar.isDateInToday(dateObj) {
                self.date = "Today"
            } else if calendar.isDateInTomorrow(dateObj) {
                self.date = "Tomorrow"
                
            } else if calendar.isDateInThisWeek(dateObj) {
                
                dateFormatter.dateFormat = "EEEE"
                let dayOfTheWeekString = dateFormatter.string(from: dateObj)
                self.date = dayOfTheWeekString
                
            }
        }
        
    }
}



//struct Previews_UserEventTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        let event = EventObj(creator: "Ned O'Rourke", date: "23/01/2022", description: "", endTime: "", filename: "the ivy precinct", id: "", imageurl: "https://storage.googleapis.com/appluna.appspot.com/eventImages/4S4lYoQRZwWEw2cba46s/lost.png", label: "Lost Sundays", startTime: "20:00", creatorID: "", invited: [], going: [], interested: [], declined: [], performers: [], userCreated: false, linkedEvent: "", linkedVenue: "", address: "", ticketLink: "", hosts: [], hostNames: [])
//        
//        UserEventTileView(event: event, clickable : true)
//            .environmentObject(SessionServiceImpl())
//            .environmentObject(LocationManager())
//            .environmentObject(ViewModel())
//    }
//}
