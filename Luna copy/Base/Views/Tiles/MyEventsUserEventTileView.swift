//
//  MyEventsUserEventTileView.swift
//  Luna
//
//  Created by Ned O'Rourke on 14/3/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyEventsUserEventTileView: View {
    let event : EventObj
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    
    let df = DateFormatter()
    let calendar = Calendar.current
    
    @State var response = 1
    @State var going = 0
    @State var interested = 0
    @State var friendsGoing = 0
    @State var clickable : Bool
    @State var date = ""
    @State var time = ""
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {

            if clickable {

                NavigationLink(destination: PresView(event: event, responseTab: response)
                    .environmentObject(sessionService)
                    .environmentObject(manager)
                    .environmentObject(homeVM)) {
                        VStack (alignment: .leading) {
                            ZStack (alignment: .bottomTrailing) {
                                AsyncImage(url: URL(string: event.imageurl)) { image in
                                    image.resizable()
                                        .aspectRatio(2.1, contentMode: .fit)
                                        .clipped()
                                } placeholder: {
                                    ZStack {
                                        Image(uiImage: UIImage(named: "usereventplaceholder")!)
                                            .resizable()
                                            .opacity(0.7)
                                            .aspectRatio(2.1, contentMode: .fit)
                                            .clipped()
                                            
                                        ProgressView()
                                    }
                                }
                                                
                                
                                HStack {
                                    Text("\(self.date) at \(self.time)")
                                        .foregroundColor(.white)
                                }
                                .background(.black.opacity(0.4))
                                .cornerRadius(5)
                                .padding(3)
                                
                                
                                
                            }
                           
                            
                            VStack (alignment: .leading) {
                                HStack {
                                    Text("Created by \(event.hostNames.joined(separator: ", "))")
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.secondary.opacity(0.7))
                                        .font(.system(size: 15))
                                    Spacer()
                                    
                                    Text("\(self.interested) interested")
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.secondary.opacity(0.7))
                                        .font(.system(size: 15))
                                }
                                .padding(.trailing, 3)

                                Text(event.label)
//                                    .font(.system(size: 25))
                                    .foregroundColor(Color.primary)
                                    .fontWeight(.bold)
                            }
                            .padding(.bottom, 3)
                            .padding(.horizontal)
                           
                        }
                        .frame(maxWidth: 350)
//                        .frame(width: 350, height: 250)
                        .background(colorScheme == .dark ? Color.black : Color.white)
                    }
                    
            } else {
                VStack (alignment: .leading) {
                    ZStack (alignment: .bottomTrailing) {
                        AsyncImage(url: URL(string: event.imageurl)) { image in
                            image.resizable()
                                .aspectRatio(2.1, contentMode: .fit)
                                .clipped()
                        } placeholder: {
                            ZStack {
                                Image(uiImage: UIImage(named: "usereventplaceholder")!)
                                    .resizable()
                                    .opacity(0.7)
                                    .aspectRatio(2.1, contentMode: .fit)
                                    .clipped()
                                    
                                ProgressView()
                            }
                        }
                                        
                        
                        HStack {
                            Text("\(self.date) at \(self.time)")
                                .foregroundColor(.white)
                        }
                        .background(.black.opacity(0.4))
                        .cornerRadius(5)
                        .padding(3)
                        
                        
                        
                    }
                   
                    
                    VStack (alignment: .leading) {
                        HStack {
                            Text("Created by \(event.hostNames.joined(separator: ", "))")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.secondary.opacity(0.7))
                                .font(.system(size: 15))
                            Spacer()
                            
                            Text("\(self.interested) interested")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.secondary.opacity(0.7))
                                .font(.system(size: 15))
                        }
                        .padding(.trailing, 3)

                        Text(event.label)
//                                    .font(.system(size: 25))
                            .foregroundColor(Color.primary)
                            .fontWeight(.bold)
                    }
                    .padding(.bottom, 3)
                    .padding(.horizontal)
                   
                }
                .frame(maxWidth: 350)
//                        .frame(width: 350, height: 250)
                .background(colorScheme == .dark ? Color.black : Color.white)
            }
                
            }
            .onAppear {
                self.date = event.date
                self.going = event.going.count
                
                self.interested = event.interested.count
                
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
                self.time = Date12
    
                if event.invited.contains(sessionService.userDetails.uid) {
                    self.response = 1
                } else if event.going.contains(sessionService.userDetails.uid) {
                    self.response = 2
                } else if event.interested.contains(sessionService.userDetails.uid) {
                    self.response = 3
                } else if event.declined.contains(sessionService.userDetails.uid) {
                    self.response = 4
                }
                
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
            .cornerRadius(20)
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.black, lineWidth: 0.5)
            )
        
    }
}
