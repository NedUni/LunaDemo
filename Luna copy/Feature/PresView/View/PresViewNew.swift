//
//  PresViewNew.swift
//  Luna
//
//  Created by Ned O'Rourke on 6/6/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct PresViewNew: View {
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    @StateObject var vm = UserEventViewHandler()
    @StateObject var handler = EventHandler()
    
    @State var presEvent : EventObj
    
    
    var linkedEvent : EventObj?
    var linkedVenue : VenueObj?
    
    @State var imageURL = ""
    
    let calendar = Calendar.current
    
    @State var going : Int = 0
    @State var invited : Int = 0
    @State var maybe : Int = 0
    @State var buttonText : String = "Invited"
    @State var date = ""
    @State var responseTab = 1
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack (alignment: .leading) {
                        WebImage(url: URL(string: self.imageURL))
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: 240)
                    
                        VStack (alignment: .leading) {
                            
                            HStack {
                                Image(systemName: "clock")
                                Text("\(self.date) at \(presEvent.startTime)")
                                    .padding(.leading, 4)
                            }
                            
                            Text(presEvent.label)
                            
                            //HANDLER
                            HStack {
                                if vm.eventResponse == "invited" {
                                    Button {
                                        vm.changeEventResponse(uid: sessionService.userDetails.uid, eventID: presEvent.id, response: "going") {
                                            vm.getEventResponse(uid: sessionService.userDetails.uid, eventID: presEvent.id)
                                        }
                                    } label: {
                                            VStack {
                                                HStack {
                                                    Image(systemName: "person.fill.checkmark")
                                                        .foregroundColor(.primary)
                                                    Text("I'll be there")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(.primary)
                                                }
                                            }
                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
                                            .background(.purple.opacity(0.5))
                                            .cornerRadius(5)
                                    }
                                    
                                    Button {
                                        vm.changeEventResponse(uid: sessionService.userDetails.uid, eventID: presEvent.id, response: "interested") {
                                            vm.getEventResponse(uid: sessionService.userDetails.uid, eventID: presEvent.id)
                                        }
                                    } label: {
                                        VStack {
                                            HStack {
                                                Image(systemName: "person.fill.questionmark")
                                                    .foregroundColor(.primary)
                                                Text("Not sure yet")
                                                
                                                    .font(.system(size: 20))
                                                    .foregroundColor(.primary)
                                            }
                                            
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
                                        .background(.purple.opacity(0.3))
                                        .cornerRadius(5)

                                    }
                                }
                                
                                else if vm.eventResponse == "going" {
                                    Button {
                                        vm.changeEventResponse(uid: sessionService.userDetails.uid, eventID: presEvent.id, response: "invited") {
                                            vm.getEventResponse(uid: sessionService.userDetails.uid, eventID: presEvent.id)
                                        }
                                    } label: {
                                        VStack {
                                            HStack {
                                                Image(systemName: "person.fill.checkmark")
                                                    .foregroundColor(.primary)
                                                Text("I'll be there")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(.primary)
                                            }
                                            
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
                                        .background(.purple)
                                        .cornerRadius(5)
                                    }
                                }
                                
                                else if vm.eventResponse == "interested" {
                                    Button {
                                        vm.changeEventResponse(uid: sessionService.userDetails.uid, eventID: presEvent.id, response: "invited") {
                                            vm.getEventResponse(uid: sessionService.userDetails.uid, eventID: presEvent.id)
                                        }
                                    } label: {
                                        VStack {
                                            HStack {
                                                Image(systemName: "person.fill.questionmark")
                                                    .foregroundColor(.primary)
                                                Text("Not sure yet")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(.primary)
                                            }
                                            
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
                                        .background(.purple.opacity(0.3))
                                        .cornerRadius(5)
                                    }
                                }
                                
                                else {
                                    VStack {
                                        Text("loading")
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
                                }
                            }
                            
                            Divider()
                            
                            Text("The Plan")
                            
                            LongText(presEvent.description, dark: true)
                            
                            Divider()
                            
                            Text("Responses")
                            
                            HStack (alignment: .center) {
                                
                                VStack {
                                    ZStack {
                                        Circle().stroke(Color.purple, lineWidth: 1).scaledToFill()
                                        Text("going")
                                    }
                                    
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
//                                .overlay(Circle().stroke(Color.red, lineWidth: 1).scaledToFill())
                                
                                VStack {
                                    ZStack {
                                        Circle().stroke(Color.purple, lineWidth: 1).scaledToFill()
                                        Text("Invited")
                                    }
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                               
                                VStack {
                                    ZStack {
                                        Circle().stroke(Color.purple, lineWidth: 1).scaledToFill()
                                        Text("+1")
                                    }
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    
                }
            }
            .onAppear {
                
                let queue = DispatchQueue(label: "pres", attributes: .concurrent)
                queue.async { handler.getAllUsers(event: presEvent.id)}
                queue.async { vm.getEventResponse(uid: sessionService.userDetails.uid, eventID: presEvent.id)}
                queue.async { vm.getInterestedFriends(uid: sessionService.userDetails.uid, eventID: presEvent.id, token: sessionService.token)}
                queue.async { vm.getGoingFriends(uid: sessionService.userDetails.uid, eventID: presEvent.id, token: sessionService.token)}
                queue.async { vm.getInvitedFriends(uid: sessionService.userDetails.uid, eventID: presEvent.id, token: sessionService.token)}
                self.date = presEvent.date
                
                if presEvent.linkedVenue != "" && self.linkedVenue == nil {
//                    queue.async { vm.getLinkedVenue(id: presEvent.linkedVenue, token: sessionService.userDetails.token)}
                } else if presEvent.linkedEvent != "" && self.linkedEvent == nil {
                    queue.async { vm.getLinkedEvent(id: presEvent.linkedEvent, token: sessionService.userDetails.token)}
                }
                
                if vm.linkedVenue != nil {
                    self.imageURL = vm.linkedVenue!.imageurl
                } else if vm.linkedEvent != nil {
                    self.imageURL = vm.linkedEvent!.imageurl
                }
                
                dateFormatter.dateFormat = "dd-MM-yyyy"
                guard let dateObj = dateFormatter.date(from: presEvent.date) else {return}

                
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
            }
            .ignoresSafeArea()
//            .navigationTitle(presEvent.label)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PresViewNew_Previews: PreviewProvider {
    static var previews: some View {
        PresViewNew(presEvent: EventObj(id: "", label: "Ned's pres for Ivanhoe Hotel", description: "", imageurl: "", tags: [], date: "", startTime: "", endTime: "", invited: [], going: [], interested: [], declined: [], hostIDs: [], hostNames: [], performers: [], address: "", linkedVenueName: "", linkedVenue: "", linkedEvent: "", userCreated: false, pageCreated: false, ticketLink: ""))
    }
}
