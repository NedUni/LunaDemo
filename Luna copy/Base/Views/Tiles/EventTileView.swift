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
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    let df = DateFormatter()
    let calendar = Calendar.current
    
    @State var going = 0
    @State var interested = 0
    @State var friendsGoing = 0
    @State var clickable : Bool
    @State var date = ""
    @State var startTime = ""
    @State var endTime = "late"
    

    var body: some View {
        
        VStack (alignment: .leading) {
        
            if clickable {
                NavigationLink(destination: EmptyView()) {
                    EmptyView()
                }
                NavigationLink(destination: EventViewNew(event: event)
                                .environmentObject(sessionService)
                                .environmentObject(manager)
                                .environmentObject(homeVM)) {
                                    HStack (alignment: .top) {
                                        WebImage(url: URL(string: event.imageurl))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: UIScreen.main.bounds.size.width*0.3, height: UIScreen.main.bounds.size.width*0.2, alignment: .center)
                                            .clipped()
                                            .cornerRadius(10)
                                        
                                        VStack (alignment: .leading) {
                                            Text("By \(event.hostNames.joined(separator: ", "))")
                                                .font(.system(size: 14))
                                                .fontWeight(.medium)
                                                .foregroundColor(.primary)
                                                .lineLimit(1)
                                            
                                            Text(event.label)
                                                .font(.system(size: 17))
                                                .foregroundColor(Color.primary)
                                                .fontWeight(.bold)
                                                .lineLimit(2)
                                            
                                            Text("on \(self.date) • \(self.startTime) till \(self.endTime)")
                                                .font(.system(size: 12))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("darkSecondaryText"))
                                            
                                            if self.friendsGoing > 0  {
                                                Text("\(self.friendsGoing) friends • \(self.going + self.interested) others")
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.purple.opacity(0.7))
                                            }
                                            
                                            else if (self.going + self.interested) > 0 {
                                                Text("\(self.going + self.interested) others interested or going")
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.purple.opacity(0.7))
                                            }
                                        }
                                        .multilineTextAlignment(.leading)
                                        
                                        
                                        Spacer()
                                        
                                        
                                    }
                                    
//                    VStack (alignment: .leading) {
//                        HStack {
//
//                            WebImage(url: URL(string: event.imageurl))
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 100, height: 100)
//                                .cornerRadius(10)
//
//                            VStack (alignment: .leading) {
//                                Text(event.label)
//                                    .font(.system(size: 25))
//                                    .foregroundColor(Color.primary)
//
//
//                                // Eventually add a day instead of date if it's this week etc
//                                Text("\(self.date) \(event.startTime) - \(event.endTime)")
//                                    .fontWeight(.thin)
//
//                                // Placeholder
//                                // Only show once a certain amount of people has been reached maybe?
//                                Text("Created by \(event.hostNames.joined(separator: ", "))")
//                                    .fontWeight(.thin)
//                                    .foregroundColor(Color.secondary)
//
//                                HStack {
//                                    if self.going > 0 {
//                                        Text("\(self.going) going ")
//                                            .fontWeight(.thin)
//                                            .foregroundColor(Color.secondary)
//                                    }
//                                    if self.interested > 0 {
//                                        Text("\(self.interested) interested")
//                                            .fontWeight(.thin)
//                                            .foregroundColor(Color.secondary)
//                                    }
//                                }
//
//
//
//                                if self.friendsGoing > 0 {
//                                    Text("\(self.friendsGoing) friends going")
//                                        .fontWeight(.thin)
//                                        .foregroundColor(Color.secondary)
//                                }
//
//
//
//                            }
//                            .multilineTextAlignment(.leading)
//                            .foregroundColor(.primary)
//                            .padding(.leading, 10)
////                            .frame(maxWidth: 200, maxHeight: 100)
//
//                            Spacer()
//
//
//                        }
////                        .font(.system(size: 10))
//                    }
                }
                                
                
            } else {
                HStack (alignment: .top) {
                    WebImage(url: URL(string: event.imageurl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.size.width*0.3, height: UIScreen.main.bounds.size.width*0.2, alignment: .center)
                            .clipped()
                            .cornerRadius(10)
                            
                    VStack (alignment: .leading) {
                        Text("By \(event.hostNames.joined(separator: ", "))")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        Text(event.label)
                            .font(.system(size: 17))
                            .foregroundColor(Color.primary)
                            .fontWeight(.bold)
                            .lineLimit(2)
                        
                        Text("on \(self.date) • \(self.startTime) till \(self.endTime)")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(Color("darkSecondaryText"))
                        
                        if self.friendsGoing > 0  {
                            Text("\(self.friendsGoing) friends • \(self.going + self.interested) others")
                                .fontWeight(.medium)
                                .foregroundColor(.purple.opacity(0.7))
                        }
                        
                        else if (self.going + self.interested) > 0 {
                            Text("\(self.going + self.interested) others interested or going")
                                .fontWeight(.medium)
                                .foregroundColor(.purple.opacity(0.7))
                        }
                    }
                    .multilineTextAlignment(.leading)
                    
                    
                    Spacer()
                    
                    
                }
            }
        }
        .onAppear {
            
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
            
            else {
                let weekdays = [
                            "Sun",
                            "Mon",
                            "Tues",
                            "Wed",
                            "Thurs",
                            "Fri",
                            "Sat"
                        ]
                let weekDay = calendar.component(.weekday, from: dateObj)
                let day = calendar.component(.day, from: dateObj)
                let month = calendar.component(.month, from: dateObj)
                self.date = weekdays[weekDay - 1] + " \(day)/\(month)"
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"

            let date = dateFormatter.date(from: event.startTime)
            dateFormatter.dateFormat = "h:mm a"

            let Date12 = dateFormatter.string(from: date!)
            self.startTime = Date12
            
            if event.endTime != "" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                
                let date = dateFormatter.date(from: event.endTime)
                dateFormatter.dateFormat = "h:mm a"
            
                let end12 = dateFormatter.string(from: date!)
                self.endTime = end12
            }
            
            
//            self.date = event.date
            self.going = event.going.count
            self.interested = event.interested.count
            
            self.friendsGoing = 0
            
            for user in event.going {
                if sessionService.userDetails.friends.contains(user) {
                    self.friendsGoing += 1
                }
                   
            }
            
//            dateFormatter.dateFormat = "dd-MM-yyyy"
//            guard let dateObj = dateFormatter.date(from: event.date) else {return}
//
//            if calendar.isDateInToday(dateObj) {
//                self.date = "Today"
//            } else if calendar.isDateInTomorrow(dateObj) {
//                self.date = "Tomorrow"
//
//            } else if calendar.isDateInThisWeek(dateObj) {
//
//                dateFormatter.dateFormat = "EEEE"
//                let dayOfTheWeekString = dateFormatter.string(from: dateObj)
//                self.date = dayOfTheWeekString
//
//            }
        }
            
        
    }
}

//struct EventTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        let event = EventObj(creator: "", date: "09-03-2022", description: "", endTime: "23:00", filename: "the ivy precinct", id: "", imageurl: "https://storage.googleapis.com/appluna.appspot.com/eventImages/auOuYRfLteN9r8D4HTHJ/273296019_287235740169424_1934424515841933738_n.jpg", label: "Lost Sundays", startTime: "20:00", creatorID: "", invited: [], going: [], interested: [], declined: [], performers: [], userCreated: false, linkedEvent: "", linkedVenue: "", address: "", ticketLink: "", hosts: [], hostNames: [])
//            NavigationView {
//                EventTileView(event: event, clickable: true)
//                    .environmentObject(ViewModel())
//                    .environmentObject(SessionServiceImpl())
//                    .environmentObject(LocationManager())
//        }
//    }
//}
