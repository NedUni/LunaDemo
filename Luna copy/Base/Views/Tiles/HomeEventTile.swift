//
//  HomeEventTile.swift
//  Luna
//
//  Created by Will Polich on 10/4/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeEventTile: View {
    let event : EventObj
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    @State var clickable : Bool
    
    let df = DateFormatter()
    let calendar = Calendar.current

    @State var going = 0
    @State var interested = 0
    @State var friendsGoing = 0
    @State var date = ""
    @State var startTime = ""
    @State var endTime = "late"
    @State var location = ""

    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if clickable {
            NavigationLink(destination: EventViewNew(event: event)
                            .environmentObject(sessionService)
                            .environmentObject(manager)
                            .environmentObject(homeVM)) {
                
                        ZStack (alignment: .bottomLeading) {
                            WebImage(url: URL(string: event.imageurl)) 
                                .resizable()
                           

                            VStack (alignment: .trailing){
                                
                                Spacer()
                                
                                
                                HStack {
                                    Text(event.label)
                                        .padding(.leading)
                                    Spacer()
                                }
                                .frame(width: 230, height: 30)
                                .background(Color("darkForeground"))
                            }
                            
                        }
                        .frame(width: 230, height: 150)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.primary, lineWidth: 0.5))
                        .foregroundColor(.primary)
                    .onAppear {
                        self.date = event.date

                        for user in event.going {
                            if sessionService.userDetails.friends.contains(user) {
                                self.friendsGoing += 1
                            }
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
                        
    //                    if event.linkedVenue != "" {
    //                        self.location = event.linkedVenue
    //                    }
                    }
            }
        }
    }
}
