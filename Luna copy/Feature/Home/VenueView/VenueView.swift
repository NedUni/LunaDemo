//
//  VenueView.swift
//  Luna
//
//  Created by Ned O'Rourke on 18/1/22.
//

import SwiftUI
import SDWebImageSwiftUI
import MapKit

struct EventsView : View {
    
    var ven : VenueObj
    
    var body: some View {
        VStack {
            Text("Events")
            ForEach (ven.events , id: \.self) { event in
                EventTileView(event: event, clickable: true)
            }
        }
    }
}

struct DealsView : View {
    
    var ven : VenueObj
    
    var body: some View {
        VStack {
            ForEach (ven.events , id: \.self) { event in
                Text("Deal")
            }
        }
    }
}

struct VenueView: View {
    
    var ven : VenueObj
    
    
    @State var selectedTab = 0
    @State var followed = false
    @State var buttonState : Int = 1
    @State var buttonText : String = "Check in"
    @State var following = false
    @State var distance : CLLocationDistance = 101.0
    @State var showNewPres : Bool = false
    @EnvironmentObject var sessionService: SessionServiceImpl
    @State var text = "heart"
    @EnvironmentObject var manager : LocationManager
   
    @State var orderedEvents: [EventObj] = []
    @State var showTime = false
    @State var boss: Int = 1
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View  {
        
        ScrollView {
            ZStack (alignment: .bottom) {
                WebImage(url: URL(string: ven.imageurl))
                    .resizable()
                
                HStack {
                    Text(ven.displayname)
                    Spacer()
                    Text("15 mins")
                    Image(systemName: "person.3.sequence.fill")
                }
                .padding(.leading)
                .padding(.trailing)
                .frame(maxWidth: .infinity, maxHeight: 30)
                .background(colorScheme == .dark ? Color.black.opacity(0.8) : Color.white.opacity(0.8))
            }
            .font(.system(size: 20))
            .frame(width: .infinity, height: 240)
            
            
            VStack (alignment: .leading) {
                Button(action: {
                    
                    let url = URL(string: "maps://?saddr=&daddr=\(ven.latitude),\(ven.longitude)")

                    if UIApplication.shared.canOpenURL(url!) {
                          UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    }
                    
                }) {
                    HStack {
                        Text(ven.address)
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 13))
                    }
                    .padding(.bottom, 0.01)
                    
                }
                .buttonStyle(.plain)
                
                Text(ven.description)
                
                
                if ven.events.count > 0 {
                    Text("Upcoming Events")
                        .font(.title)
                        .padding(.top, 0.01)

                    ForEach (orderedEvents, id: \.self) { event in
                        EventTileView(event: event, clickable: true)
                        Divider()
                    }
                }
              
                if ven.deals.count > 0 {
                    Text("Current Deals")
                        .font(.title)
                    
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach (ven.deals, id: \.self) { deal in
                                DealTileView(deal: deal)
                                    .padding(.trailing, 80)
                            }
                        }
                    }
                }
                
                
//                Picker(selection: $selectedTab, label: Text("Picker")) {
//                    Text("Events")
//                        .tag(0)
//                    Text("Deals")
//                        .tag(1)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//
//                VStack (alignment: .leading) {
//                    if selectedTab == 0 {
//                        ForEach (ven.events, id: \.self) { event in
//                            EventTileView(event: event, clickable: true)
//                            Divider()
//                        }
//
//                    } else {
//                        ForEach (ven.deals, id: \.self) { deal in
//                            DealTileView(deal: deal)
//                            Divider()
//                        }
//                    }
//                }
            }
            .padding(.horizontal)

            
        }
        .onAppear {
            if sessionService.userDetails.following.contains(ven.id) {
                following = true
                text = "heart.fill"
            }
            else {
                following = false
                text = "heart"

            self.distance = CLLocation(latitude: manager.region.center.latitude, longitude: manager.region.center.longitude).distance(from: CLLocation(latitude: ven.latitude, longitude: ven.longitude))

            print(self.distance)

            sessionService.getCheckins(uid: sessionService.userDetails.uid)
            if sessionService.currentCheckins.contains(ven.id) {
                self.buttonText = "Check Out"
                self.buttonState = 2
            } else {
                self.buttonText = "Check In"
                self.buttonState = 1
            }
            }
            
            self.orderedEvents = ven.events.sorted {
                $0.date < $1.date
            }
            
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView())
//        .navigationTitle(ven.displayname)
//        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            HStack {
                Button(action: {
                    if following == false {
                        sessionService.followVenue(venueID: ven.id, UID: sessionService.getUID())
                        following = true
                        text = "heart.fill"
                    }
                    else {
                        sessionService.unfollowVenue(venueID: ven.id, UID: sessionService.getUID())
                        following = false
                        text = "heart"

                    }
                    
                }, label: {
                    Image(systemName: text)
                        .frame(width: 30, height: 30)
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        .background((Color.primary))
                        .cornerRadius(20)
                        
                })
            }
            .buttonStyle(.plain)
            
        }
        
        if self.distance >= 100.0 {
            Button(action: {
                self.showTime = false
                
                if self.buttonState == 1 {
                    self.buttonText = "Check Out"
                    self.buttonState = 2
                    sessionService.checkIn(venueID: ven.id, UID: sessionService.userDetails.uid)
                    
                    self.showTime.toggle()
                    
                    
                
                } else if self.buttonState == 2 {
                    self.buttonText = "Check In"
                    self.buttonState = 1
                    sessionService.checkOut(venueID: ven.id, UID: sessionService.userDetails.uid)
                }
                
            } , label: {
                HStack {

                    Spacer()

                    Text(self.buttonText)

                    Spacer()
                }
                .foregroundColor(Color.primary)
                .padding(.vertical, 10)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.primary, lineWidth: 2))
                
                .sheet(isPresented: $showTime, content: {
                        LineLengthView(ven: ven)
                })
                
            }).padding(.horizontal)
                .buttonStyle(.plain)
        } else {
            Button {
                showNewPres.toggle()
            } label: {
                HStack {

                    Spacer()

                    Text("Create Pres")

                    Spacer()
                }
                .foregroundColor(Color.white)
                .padding(.vertical, 10)
                .frame(width: 288, height: 40)
                .background(Color.purple).cornerRadius(20)
                .padding()

            }
            .padding(.horizontal)
            .sheet(isPresented: $showNewPres, content: {
                NewPresView(showNewPres : $showNewPres, linkedVenue: ven).environmentObject(sessionService)
            })
        }
        
        Spacer()
    }
    
}

