//
//  EventView.swift
//  Luna
//
//  Created by Will Polich on 13/2/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import MapKit

struct EventView: View {
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    @StateObject var handler = EventViewHandler()
    @Environment(\.openURL) var openURL
    var event : EventObj
    let df = DateFormatter()
    let calendar = Calendar.current
    
    @State var distance : CLLocationDistance = 101.0
    @State var date = ""
    @State var buttonText = "Interested"
    @State var interested = false
    @State var showNewPres = false
    
    @State var followed = false
    @State var buttonState : Int = 1
    @State var buttonText2 : String = "Check In"
    @State var showTime : Bool = false
    
    var body: some View {
        
        VStack {
            
            ZStack (alignment: .bottom) {
                
                
                ScrollView {
                    WebImage(url: URL(string: event.imageurl))
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(maxWidth: .infinity, maxHeight: 250)
                        .clipped()
                       

                    
                    VStack (alignment: .leading) {
                        Text(event.label).font(.system(size: 22).bold())
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        Group {
                            HStack {
                                Image(systemName: "clock")
                                Text("\(self.date) from \(event.startTime) to \(event.endTime)")
                                    .padding(.leading, 4)
                            }
                            
                            Spacer()
                            Spacer()
                            
//                            HStack {
//                                Image(systemName: "person.fill")
//                                Text("Created by")
//                                    .padding(.leading, 4)
//                                Text(event.creator)
//                            }
//
//                            Spacer()
//                            Spacer()
                        }
                        
                        Button(action: {
                

                            let urlString = "maps://?address=\(event.address)"
                            let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            let url = URL(string: encodedURL)

                            if UIApplication.shared.canOpenURL(url!) {
                                  UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                            }

                        }) {
                            VStack (alignment: .leading) {
                                HStack {
                                    Image(systemName: "mappin")
                                    Text(event.address)
                                        .padding(.leading, 5)
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.system(size: 13))
                                    
                                }
                                .foregroundColor(Color.primary)
                                .padding(.leading, 2.5)
                            }
                            .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                        
                        Group {
                            if handler.venue != nil {
                                Spacer()
                                NavigationLink(destination: VenueView(ven : handler.venue!)
                                                .environmentObject(sessionService)
                                                .environmentObject(manager)
                                                .environmentObject(homeVM), label: {
                                    HStack {
                                        Image(systemName: "person")
                                        Text("Created by **\(handler.venue!.displayname)**")
                                            .padding(.leading, 4)
                                        
                                    }
                                    .foregroundColor(Color.primary)
                                    .padding(.leading, 2)
                                    .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    Spacer()
                        
    //
                                })
                            }
                        }
                       
                            
                        
                        
                        Group {
                            if event.ticketLink != "" {
                                Spacer()
                                Spacer()
                                Button (action: {
                                    
                                    guard let url = URL(string: event.ticketLink) else {
                                        print("Cannot build url from ticket link.")
                                        return
                                    }
                                    
                                    
                                    if UIApplication.shared.canOpenURL(url) {
                                          UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    }
                                    
                                }, label: {
                                    
                                    HStack {
                                        Image(systemName: "ticket")
                                            .foregroundColor(Color.primary)
                                        VStack (alignment: .leading){
                                            Text("Tickets")
                                                .foregroundColor(Color.primary)
                                            Text(event.ticketLink)
                                                .foregroundColor(Color.secondary)
                                            
                                        }
                                        

                                        
                                    }
                                    .multilineTextAlignment(.leading)
                                    
                                    
                                })
                                
                            }
                            Spacer()
                            Divider()
                            Spacer()
                        }
                        
                        NavigationLink(destination: EmptyView()) {
                            EmptyView()
                        }
                        
                        
                        Group {
                            if handler.interestedFriends.count != 0 {
                                Text("Interested Friends")
                                    .foregroundColor(Color.secondary)
                                Spacer()
                                ScrollView (.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(handler.interestedFriends, id: \.self) { friend in
                                            NavigationLink(destination: friend.performer ? AnyView(PerformerProfileView(user: friend)
                                                .environmentObject(sessionService)
                                                .environmentObject(manager)
                                                .environmentObject(homeVM))
                                               : AnyView(UserProfileView(user: friend)
                                                .environmentObject(sessionService)
                                                .environmentObject(manager)
                                                .environmentObject(homeVM)), label: {
                                                VStack {
                                                    WebImage(url: URL(string: friend.imageURL))
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 64, height: 64).cornerRadius(64)
//                                                            .overlay(RoundedRectangle(cornerRadius: 128).strokeBorder(Color.primary, lineWidth: 2))
                                                        .clipped()
                                                    
//                                                    Text("\(friend.firstName)")
//                                                        .foregroundColor(Color.primary)
//                                                    Text("\(friend.lastName)")
//                                                        .foregroundColor(Color.primary)
                                                }
                                            })
                                        }
                                        .frame(maxWidth: 100, maxHeight: 120)
                                        
                                        
                                        
                                    }
                                }
                                
                                
                                Divider()
                                Spacer()
                            }
                            
                        }
                        
                    }
                    .padding(.horizontal)
                    .multilineTextAlignment(.leading)
                        
                    VStack (alignment: .leading) {
                        
                        Group {
                            Text("Description")
                                .foregroundColor(Color.secondary)
                            
                            Text(event.description)
                                .foregroundColor(Color.primary)
                                .padding(.bottom, 50)
                            
                    
                        }
                        
                        Group {
                            Text("Tonights grove dealers")
                                .foregroundColor(Color.secondary)
                            
                            VStack (alignment: .center) {
                                
                                ForEach(handler.performers, id: \.self) { performer in
                                    Performer(performer: performer)
                                        .environmentObject(sessionService)
                                        .environmentObject(manager)
//                                        .environmentObject(viewModel)
                            }
                                
                                
                                
                                
                            }
                        }
                            
                        

                       
                        
                    }
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    
                }
                
                
                
                if self.distance <= 200 {
                    Button(action: {
                        self.showTime = false
                        
                        if self.buttonState == 1 {
                            
                            self.buttonText2 = "Check Out"
                            self.buttonState = 2
                            
                            self.showTime.toggle()
                            
                             
                        } else if self.buttonState == 2 {
                            
                            sessionService.checkOut(venueID: event.linkedVenue, UID: sessionService.userDetails.uid, completion: {
                                self.buttonText2 = "Check In"
                                self.buttonState = 1
                                sessionService.getActiveCheckin(uid: sessionService.userDetails.uid, completion: {})
                            })
                           
                            
                            
                        }
                        
                    } , label: {
                        HStack {

                            Spacer()

                            Text(self.buttonText2)

                            Spacer()
                        }
                        .foregroundColor(Color.white)
                        .frame(width: 288, height: 40).cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.purple, lineWidth: 2))
                        .background(Color.purple).cornerRadius(20)
                        .sheet(isPresented: $showTime, content: {
                            LineLengthView(ven: handler.venue!, showTime : $showTime, buttonText: $buttonText2, buttonState: $buttonState)
                                .environmentObject(sessionService)
                        })
                        
                    })
                        .buttonStyle(.plain)
                } else {
                    if self.interested == false {
                        Button(action: {
                            sessionService.eventInterest(venueID: event.linkedVenue, uid: sessionService.userDetails.uid, eventID: event.id)
                            self.interested.toggle()
                            sessionService.refreshUserDetails()
                        }, label: {
                            HStack {
                                Text("Interested")
                                    .foregroundColor(Color.white)
                            }
                            .frame(width: 300, height: 40)
                            .background(Color.purple)
                                .cornerRadius(20)
                        })
                        .padding()
                        .padding(.bottom, 20)
                        
                    } else {
                        HStack {
                            Button(action: {
                                sessionService.eventInterestRemove(venueID: event.linkedVenue, uid: sessionService.userDetails.uid, eventID: event.id)
                                self.interested.toggle()
                                sessionService.refreshUserDetails()
                            }, label: {
                                HStack {
                                    Text("Cancel Interested")
                                        .foregroundColor(Color.primary)
                                }
                                .frame(width: 170, height: 40)
                                .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.primary, lineWidth: 2))
                                .background((Color.primary).colorInvert())
                                .cornerRadius(20)
                            })
                                
                            Button(action: {
                                self.showNewPres.toggle()
                            }, label: {
                                HStack {
                                    Text("Create Pres")
                                        .foregroundColor(Color.white)
                                }
                                .frame(width: 170, height: 40)
                                .background(Color.purple )
                                .cornerRadius(20)
                            })
                            
                        }
                        .padding()
                        .padding(.bottom, 20)
                        
                    }
                }
                
                
                
                
                
                
            }
//            .fullScreenCover(isPresented: $showNewPres, onDismiss: nil, content: {
//                NewPresView(showNewPres: $showNewPres, linkedEvent: event)
//            })
        }
        .multilineTextAlignment(.leading)
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView())
    
        .onAppear {
            
            handler.getPerformers(eventID: event.id)
            
            handler.getVenue(venue: event.linkedVenue, token: sessionService.token, completion: {
                self.distance = CLLocation(latitude: manager.region.center.latitude, longitude: manager.region.center.longitude).distance(from: CLLocation(latitude: handler.venue?.latitude ?? 0.0, longitude: handler.venue?.longitude ?? 0.0))
                
                if sessionService.activeCheckin != nil {
                    if sessionService.activeCheckin!.id == handler.venue?.id ?? ""  {
                        self.buttonText2 = "Check Out"
                        self.buttonState = 2
                    } else {
                        self.buttonText2 = "Check In"
                        self.buttonState = 1
                    }
                    
                }
        
            })
            handler.getInterestedFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)
            
            
            
            if sessionService.userDetails.interested.contains(event.id) {
                self.interested = true
            } else {
                self.interested = false
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
            
            self.distance = CLLocation(latitude: manager.region.center.latitude, longitude: manager.region.center.longitude).distance(from: CLLocation(latitude: handler.venue?.latitude ?? 0.0, longitude: handler.venue?.longitude ?? 0.0))
            
           
            
            
            
        }

                
    }
}

extension Calendar {
  private var currentDate: Date { return Date() }

  func isDateInThisWeek(_ date: Date) -> Bool {
    return isDate(date, equalTo: currentDate, toGranularity: .weekOfYear)
  }
}

//struct EventView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        let event = EventObj(creator: "", date: "23/01/2022", description: "From the people behind the Lost Paradise Festival and Paradise Club nights comes Lost Sundays – an expression of rhythm and dance, each and every Sunday afternoon at the recently transformed ivy.", endTime: "23:00", filename: "the ivy precinct", id: "", imageurl: "https://storage.googleapis.com/appluna.appspot.com/eventImages/4S4lYoQRZwWEw2cba46s/lost.png", label: "Lost Sundays", startTime: "20:00", creatorID: "", invited: [], going: [], interested: [], declined: [], performers: [], userCreated : false, linkedEvent: "", linkedVenue: "", address: "330 George St, Sydney NSW 2000", ticketLink: "www.google.com", hosts: [], hostNames: [])
//    
//        EventView(event : event)
//            .environmentObject(SessionServiceImpl())
//            .environmentObject(LocationManager())
//    }
//}
