//
//  NewPresTile.swift
//  Luna
//
//  Created by Will Polich on 20/5/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewPresTile: View {
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
        
    @StateObject var vm = UserEventViewHandler()
    
    let event : EventObj
    
    var linkedVenue : VenueObj?
    
    let df = DateFormatter()
    let calendar = Calendar.current

    @State var going = 0
    @State var interested = 0
    @State var friendsGoing = 0
    @State var date = ""
    @State var startTime = ""
    @State var creator : UserObj?
    @State var iterator = 0
    
    
    var body: some View {
        NavigationLink(destination: PresView(event: event)
            .environmentObject(manager)
            .environmentObject(sessionService)
            .environmentObject(homeVM)
            .environmentObject(vm)) {
                
    
                ZStack (alignment: .topLeading) {
                    VStack (alignment: .leading, spacing: 0) {
                        
                        VStack {
                                HStack {
                                    ScrollView (.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(vm.goingFriends, id: \.self) { friend in
                                                ZStack (alignment: .bottomTrailing) {
                                                    WebImage(url: URL(string: friend.imageURL))
                                                           .resizable()
                                                           .scaledToFill()
                                                           .frame(width: 36, height: 36).cornerRadius(64)
                                                           .clipped()
                                                       
            
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .resizable()
                                                        .frame(width: 10, height: 10)
                                                        .scaledToFit()
                                                        .background(Color.white).cornerRadius(64)
                                                        .foregroundColor(.green)
                                                   }
                                            }
            
                                            ForEach(vm.interestedFriends, id: \.self) { friend in
                                                ZStack (alignment: .bottomTrailing) {
            
                                                    WebImage(url: URL(string: friend.imageURL))
                                                           .resizable()
                                                           .scaledToFill()
                                                           .frame(width: 36, height: 36).cornerRadius(64)
                                                           .clipped()
            
            
                                                   Image(systemName: "questionmark.circle.fill")
                                                       .resizable()
                                                       .frame(width: 20, height: 20)
                                                       .scaledToFit()
                                                       .background(Color.white).cornerRadius(64)
                                                       .foregroundColor(.gray)
            
                                               }
            
                                            }
            
                                            ForEach(vm.invitedFriends, id: \.self) { friend in
                                                ZStack (alignment: .bottomTrailing) {
            
                                                    WebImage(url: URL(string: friend.imageURL))
                                                           .resizable()
                                                           .scaledToFill()
                                                           .frame(width: 36, height: 36).cornerRadius(64)
                                                           .clipped()
            
                                                   Image(systemName: "paperplane.circle.fill")
                                                       .resizable()
                                                       .frame(width: 10, height: 10)
                                                       .scaledToFit()
                                                       .background(Color.white).cornerRadius(64)
                                                       .foregroundColor(Color("facade"))
            
                                               }
            
                                            }
                                        }
                                        .padding(.leading, 74)
                                        .padding(.vertical, 3)
                                    }
                                    .background(Color("darkForeground"))
                                }
                            
                        }
                        
                        VStack {
                            if event.linkedEvent != "" {
                                  if vm.linkedEvent != nil {
                                      WebImage(url: URL(string: vm.linkedEvent!.imageurl))
                                          .resizable()
                                          .aspectRatio(2.1, contentMode: .fit)
                                      
                                  }
                                     
                          } else if event.linkedVenue != "" {
                              if vm.linkedVenue != nil {
                                  WebImage(url: URL(string: vm.linkedVenue!.imageurl))
                                      .resizable()
                                      .aspectRatio(2.1, contentMode: .fit)
                              }
                          } else {
                              Image("nolinkpres")
                                  .resizable()
                                  .aspectRatio(2.1, contentMode: .fill)
                                  .clipped()
                          }
                        }
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
                           Text("by \(event.hostNames.joined(separator: ",")) on \(self.date) at \(self.startTime)")
                                   .font(.system(size: 10))
                                   .fontWeight(.medium)
                                   .foregroundColor(.purple)
                                   .lineLimit(1)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 3)
                        .background(Color("darkForeground"))
                        
                        
                    }
                    
                    VStack {
                        if self.creator != nil {
                            WebImage(url: URL(string: creator!.imageURL))
                                    .resizable()
                                   .scaledToFill()
                                   .frame(width: 64, height: 64, alignment: .center)
                                   .cornerRadius(32)
//                                           .frame(width: 36, height: 36).cornerRadius(64)
//                                           .clipped()
                           
                        }
                    }
                    .padding(5)
                    .background(Color("darkForeground"))
                    .cornerRadius(48)
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .cornerRadius(20)
                .onAppear {
                    if event.linkedEvent != "" {
                        vm.getLinkedEvent(id: event.linkedEvent, token: sessionService.userDetails.token)
                    } else if event.linkedVenue != "" {
                        vm.getLinkedVenue(id: event.linkedVenue, token: sessionService.userDetails.token, completion: {})
                    }

                    sessionService.getUserByID(uid: event.hostIDs[0], token: sessionService.token) { user in
                        self.creator = user
                    }
                    
//                    if event.linkedVenue != "" {
//                        vm.getLinkedVenue(id: event.linkedVenue, token: sessionService.userDetails.token, completion: {})
//                    } else if event.linkedEvent != "" {
//                        vm.getLinkedEvent(id: event.linkedEvent, token: sessionService.userDetails.token)
//                    }
                    vm.getEventResponse(uid: sessionService.userDetails.uid, eventID: event.id)
                    vm.getInterestedFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)
                    vm.getGoingFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)
                    vm.getInvitedFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)
                    
//                    vm.getGoingFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)
//                    vm.getInterestedFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)
//                    vm.getInvitedFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"

                    let date = dateFormatter.date(from: event.startTime)
                    dateFormatter.dateFormat = "h:mm a"

                    let Date12 = dateFormatter.string(from: date!)
                    self.startTime = Date12

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
        //
        //            dateFormatter.dateFormat = "HH:mm"
        //
        //            let date = dateFormatter.date(from: event.startTime)
        //            dateFormatter.dateFormat = "h:mm a"
        //
        //            let Date12 = dateFormatter.string(from: date!)
        //            self.time = Date12


                }
//                VStack (spacing: 0)
                
                
            }
            .simultaneousGesture(TapGesture().onEnded({
//                if event.linkedVenue != "" {
//                    vm.getLinkedVenue(id: event.linkedVenue, token: sessionService.userDetails.token, completion: {})
//                } else if event.linkedEvent != "" {
//                    vm.getLinkedEvent(id: event.linkedEvent, token: sessionService.userDetails.token)
//                }
//                vm.getEventResponse(uid: sessionService.userDetails.uid, eventID: event.id)
//                vm.getInterestedFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)
//                vm.getGoingFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)
//                vm.getInvitedFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)
            }))
//                ZStack (alignment: .top) {
//
//                VStack (alignment: .center, spacing: 0) {
//
//
//                    ZStack (alignment: .top) {
//
//                        if event.linkedEvent != "" {
//                            if vm.linkedEvent != nil {
//                                CachedAsyncImage(url: URL(string: vm.linkedEvent!.imageurl)) { image in
//                                    image.resizable()
//                                        .aspectRatio(2.1, contentMode: .fit)
//                                        .clipped()
//                                } placeholder: {
//                                    ProgressView()
//                                        .aspectRatio(2.1, contentMode: .fit)
//                                        .clipped()
//                                }
//                            }
//                        } else if event.linkedVenue != "" {
//                            if vm.linkedVenue != nil {
//                                CachedAsyncImage(url: URL(string: vm.linkedVenue!.imageurl)) { image in
//                                    image.resizable()
//                                        .aspectRatio(2.1, contentMode: .fit)
//                                        .clipped()
//                                } placeholder: {
//                                    ProgressView()
//                                        .aspectRatio(2.1, contentMode: .fit)
//                                        .clipped()
//                                }
//                            }
//                        } else {
//                            Image("nolinkpres")
//                                .resizable()
//                                .aspectRatio(2.1, contentMode: .fill)
//                                .clipped()
//                        }
//

//                    }
//
//
//
//                    HStack (alignment: .top) {
//                        VStack (alignment: .leading) {
//                            HStack {
//                                Text("@ \(event.address)")
//                                    .font(.system(size: 12))
//                                    .fontWeight(.medium)
//                                    .multilineTextAlignment(.leading)
//                                    .lineLimit(1)
//                                    .foregroundColor(Color("darkSecondaryText"))
//                                Spacer()
//
//                                Text("\(event.interested.count) interested")
//                                    .font(.system(size: 14))
//                                    .fontWeight(.medium)
//                            }
//
//                            Text(event.label)
//                                .font(.system(size: 12))
//                                .fontWeight(.heavy)
//                                .multilineTextAlignment(.leading)
//                                .foregroundColor(.primary)
//                            Text("by \(event.hostNames.joined(separator: ",")) on \(self.date) at \(self.startTime)")
//                                    .font(.system(size: 10))
//                                    .fontWeight(.medium)
//                                    .foregroundColor(.purple)
//
//                        }
//                    }
//            //                    .foregroundColor(.primary)
//                    .padding(.horizontal)
//                    .padding(.vertical, 3)
//                }
//                .frame(width: UIScreen.main.bounds.width*0.9)
//                .background(Color("darkForeground"))
//                .cornerRadius(20)
//                .overlay(
//                        RoundedRectangle(cornerRadius: 20)
//                            .stroke(Color.black, lineWidth: 0.5)
//                )
//
//
//
//
//        }
        
//        .background(Color.black)
//        .cornerRadius(20)
//        .overlay(
//                RoundedRectangle(cornerRadius: 20)
//                    .strokeBorder(Color.black, lineWidth: 0.5)
//            )
//        }
            }
    }

