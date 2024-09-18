//
//  MyEventsEventView.swift
//  Luna
//
//  Created by Ned O'Rourke on 4/3/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyEventsEventView: View {
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
                
                VStack (alignment: .center, spacing: 0) {
                    HStack {
                        AnimatedImage(url: URL(string: event.imageurl))
                            .resizable()
                            .aspectRatio(2.1, contentMode: .fit)
                            .clipped()
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
    //                        .clipped()
//                            .frame(maxWidth: 200, maxHeight: 150)
//                            .clipped()
    //                        .clipped()
                    }
//                    .resizable()
//
//                    .frame(maxWidth: 350)
//                    .frame(height: 150)
//                    .clipped()
                    

                    HStack (alignment: .top) {
                        VStack (alignment: .leading) {
                            HStack {
                                Text("@ \(event.address)")
                                    .font(.system(size: 12))
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(1)
                                    .foregroundColor(Color("darkSecondaryText"))
                                Spacer()
                                
                                Text("\(event.interested.count) interested")
                                    .font(.system(size: 14))
                                    .fontWeight(.medium)
                            }
                           
                            Text(event.label)
                                .font(.system(size: 12))
                                .fontWeight(.heavy)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.primary)
                                .lineLimit(2)
                            Text("by \(event.hostNames.joined(separator: ",")) on \(self.date) • \(self.startTime) till \(self.endTime)")
                                    .font(.system(size: 10))
                                    .fontWeight(.medium)
                                    .foregroundColor(.purple)
                        }
                    }
//                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .padding(.vertical, 3)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color("darkForeground"))
                .cornerRadius(20)
                .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 0.5)
                )
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
        
        else {
            VStack (alignment: .center, spacing: 0) {
                HStack {
                    AnimatedImage(url: URL(string: event.imageurl))
                        .resizable()
                        .aspectRatio(2.1, contentMode: .fit)
                        .clipped()
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                        .clipped()
//                            .frame(maxWidth: 200, maxHeight: 150)
//                            .clipped()
//                        .clipped()
                }
//                    .resizable()
//
//                    .frame(maxWidth: 350)
//                    .frame(height: 150)
//                    .clipped()
                

                HStack (alignment: .top) {
                    VStack (alignment: .leading) {
                        HStack {
                            Text("@ \(event.address)")
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)
                                .foregroundColor(Color("darkSecondaryText"))
                            Spacer()
                            
                            Text("\(event.interested.count) interested")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                        }
                       
                        Text(event.label)
                            .font(.system(size: 12))
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                        Text("by \(event.hostNames.joined(separator: ",")) on \(self.date) • \(self.startTime) till \(self.endTime)")
                                .font(.system(size: 10))
                                .fontWeight(.medium)
                                .foregroundColor(.purple)
                    }
                }
//                    .foregroundColor(.primary)
                .padding(.horizontal)
                .padding(.vertical, 3)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color("darkForeground"))
            .cornerRadius(20)
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 0.5)
            )
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



                   
//struct MyEventsEventView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        let event = EventObj(creator: "SCENES", date: "07-04-2022", description: "", endTime: "23:00", filename: "the ivy precinct", id: "", imageurl: "https://scontent.fsyd8-1.fna.fbcdn.net/v/t39.30808-6/277574825_1071653123388757_8145428168056564990_n.jpg?_nc_cat=104&ccb=1-5&_nc_sid=340051&_nc_ohc=nsuooGkHopAAX-AoQ5Q&_nc_ht=scontent.fsyd8-1.fna&oh=00_AT-rXvdig1YaHATnRrf2e8ScA_Z5IDVH-fEY-DdrEZjl7A&oe=624F2FC9", label: "★ S*A*S*H By Day ★ The Breakfast Club ★ Kerry Wallace ★", startTime: "21:00", creatorID: "", invited: ["f"], going: [], interested: [], declined: [], performers: [], userCreated: false, linkedEvent: "", linkedVenue: "", address: "Ivy Precinct", ticketLink: "", hosts: [], hostNames: [])
//        
//        Group {
//            MyEventsEventView(event: event, clickable: true)
//                .environmentObject(ViewModel())
//                .environmentObject(SessionServiceImpl())
//                .environmentObject(LocationManager())
//                .preview(with: "Test")
//        }
//    }
//}
