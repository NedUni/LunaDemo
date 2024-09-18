//
//  MyEventsPresView.swift
//  Luna
//
//  Created by Ned O'Rourke on 4/3/22.
//

import SwiftUI
import SDWebImageSwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

struct MyEventsPresView: View {
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
        
    @StateObject var vm = UserEventViewHandler()
    
    let event : EventObj
    
    var linkedVenue : VenueObj?
    
    @State var time = ""
    @State var creator : UserObj?
    
//    let linkedEvent : EventObj
    
    @State var clickable : Bool
    
    var body: some View {
        VStack {
            
            if clickable {
                
                NavigationLink(destination: PresView(event: event)
                    .environmentObject(manager)
                    .environmentObject(sessionService)
                    .environmentObject(homeVM)) {
                    if (event.endTime == "") {
                        VStack (alignment: .leading) {
                            HStack {
                                if creator != nil {
                                    WebImage(url: URL(string: creator!.imageURL)) 
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 48, height: 48).cornerRadius(64)
                                        .clipped()
                                   
                                } else {
                                    ZStack {
//                                        Image(uiImage: UIImage(named: "stockProfilePicture")!)
                                            
                                        
                                        ProgressView()
                                            .scaledToFill()
                                            .frame(width: 48, height: 48).cornerRadius(64)
                                            .clipped()
                                    }
                                }
                                
    //                            (alignment: .leading)
                                VStack (alignment: .leading){
                                    Text("\(event.label)")
                                        .foregroundColor(Color.primary)
                                        .fontWeight(.bold)
                                        .font(.system(size: 25))
                                        
                                    Text("\(event.address) at \(self.time)")
                                        .foregroundColor(.purple)
                                        .font(.caption)
                                }
                                .multilineTextAlignment(.leading)
                            }


                            if event.linkedEvent != "" {

                                if vm.linkedEvent != nil {
                                    if vm.linkedEvent!.userCreated == true {
                                        MyEventsUserEventTileView(event: vm.linkedEvent!, clickable: false)
                                            .environmentObject(sessionService)
                                            .environmentObject(manager)
                                            .environmentObject(homeVM)
                                            .highPriorityGesture(
                                                TapGesture()
                                                    .onEnded {})
                                    } else {

                                        MyEventsEventView(event: vm.linkedEvent!, clickable: false)
                                            .environmentObject(sessionService)
                                            .environmentObject(manager)
                                            .environmentObject(homeVM)
                                            .highPriorityGesture(
                                                TapGesture()
                                                    .onEnded {})
                                    }
                                }


                            } else if event.linkedVenue != "" {

                                if vm.linkedVenue != nil {

                                    EmbeddedVenueTile(ven: vm.linkedVenue!)
                                        .environmentObject(sessionService)
                                        .environmentObject(manager)
                                        .environmentObject(homeVM)
                                        .highPriorityGesture(
                                            TapGesture()
                                                .onEnded {})
                                    
     
                                }

                            } else {
                          
                                    Image("nolinkpres")
                                        .resizable()
                                        .aspectRatio(2.1, contentMode: .fit)
                                        .frame(maxWidth: 350)
                                        .cornerRadius(20)
                                        .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.black, lineWidth: 0.5)
                                        )
                                    
                                    
                                
                            }
                        }
                        .padding(.bottom)
                    }
                    
                    else {
                        MyEventsUserEventTileView(event: event, clickable: true)
                            .environmentObject(sessionService)
                            .environmentObject(manager)
                            .environmentObject(homeVM)
                        
                    }
                   
                    
                }
                    
                
                    
                    
            }
//            .buttonStyle(.plain)
            
            
            
        }
        .onAppear {
            sessionService.getUserByID(uid: event.hostIDs[0], token: sessionService.token) { user in
                self.creator = user
            }
            vm.getLinkedEvent(id: event.linkedEvent, token: sessionService.userDetails.token)
            vm.getLinkedVenue(id: event.linkedVenue, token: sessionService.userDetails.token, completion: {})
            vm.getGoingUsers(users: event.going, token: sessionService.userDetails.token)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            let date = dateFormatter.date(from: event.startTime)
            dateFormatter.dateFormat = "h:mm a"
            
            let Date12 = dateFormatter.string(from: date!)
            self.time = Date12
            
        }
        .padding(.horizontal)
//        .background(Color(hex: 0xe8e1f4))
        .cornerRadius(10)
//        .padding(.horizontal)
        
    }
}

