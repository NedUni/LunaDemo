//
//  MessageBubbleView.swift
//  Luna
//
//  Created by Will Polich on 19/3/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageBubbleView: View {
    var message : Message
    var received : Bool
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    @State var linkedEvent : EventObj?
    @State var linkedVenue : VenueObj?
    @State var linkedDeal : DealObj?
    @Binding var showDeal : Bool
    @Binding var selectedDeal : DealObj?

    @State private var showTime = false
    
    var body: some View {
        VStack(alignment: received ? .leading : .trailing) {
            
            
            HStack (alignment: .bottom) {
                if received == true {
                    WebImage(url : URL(string: message.imageurl))
                       .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .cornerRadius(20)
//                    } placeholder: {
//                        ProgressView()
//                                .scaledToFill()
//                                .frame(width: 30, height: 30)
//                                .cornerRadius(20)
//                    }
                }
                
                VStack(alignment: received ? .leading : .trailing) {
                    HStack {
                            
                        if message.linkedVenue != "" {
                            if linkedVenue != nil {
                                withAnimation {
                                    VenueTileView(ven: self.linkedVenue!)
                                        .environmentObject(sessionService)
                                        .environmentObject(manager)
                                        .environmentObject(homeVM)
                                }
                            } else {
                                HStack {
                                    Text("Venue")
                                        
                                    ProgressView()
                                    
                                }
                                .padding()
                                .background(received ? Color.secondary.opacity(0.3) : Color.purple)
                                .cornerRadius(30)
                            }
                        } else if message.linkedEvent != "" {
                            if linkedEvent != nil {
                                withAnimation {
                                    HomeEventTile(event: self.linkedEvent!, clickable: true)
                                        .environmentObject(sessionService)
                                        .environmentObject(manager)
                                        .environmentObject(homeVM)
                                }
                            } else {
                                HStack {
                                    Text("Event")
                                        
                                    ProgressView()
                                }
                                .padding()
                                .background(received ? Color.secondary.opacity(0.3) : Color.purple)
                                .cornerRadius(30)
                            }
                            
                        } else if message.linkedDeal != "" {
                            if linkedDeal != nil {
                                withAnimation {
                                    DealTileView(deal: linkedDeal!)
                                        .highPriorityGesture(
                                            TapGesture()
                                                .onEnded { _ in
                                                    self.selectedDeal = self.linkedDeal!
                                                    showDeal.toggle()
                                                }
                                        )
                                }
                            } else {
                                HStack {
                                    Text("Deal")
                                        
                                    ProgressView()
                                }
                                .padding()
                                .background(received ? Color.secondary.opacity(0.3) : Color.purple)
                                .cornerRadius(30)
                            }
                        } else {
                            
                            Text(message.text)
                            .padding()
                            .background(received ? Color.secondary.opacity(0.3) : Color.purple)
                            .cornerRadius(30)
                        }
                        
                    }
                    .frame(maxWidth: 300, alignment: received ? .leading : .trailing)
                    .onTapGesture {
                        withAnimation {
                            showTime.toggle()
                        }
                       
                    }
                    
                    
                    
                }
            
            }
            
            if showTime == true {
                Text(message.timestamp.formatted(.dateTime.hour().minute()))
                    .font(.caption)
                    .foregroundColor(Color.secondary)
                    .padding(received ? .leading : .trailing, received ? 50 : 20)
                
            }
            
            
        }
        .onAppear {
            if message.linkedVenue != "" {
                sessionService.getVenueByID(id: message.linkedVenue) { venue in
                    if linkedVenue == nil {
                        self.linkedVenue = venue
                    }
                }
            } else if message.linkedEvent != "" {
                sessionService.getEventByID(id: message.linkedEvent) { event in
                    if linkedEvent == nil {
                        self.linkedEvent = event
                    }
                }
            } else if message.linkedDeal != "" {
                sessionService.getDealByID(id: message.linkedDeal){ deal in
                    if linkedDeal == nil {
                        self.linkedDeal = deal
                    }
                }
                    
            }
        }
        .animation(.easeInOut, value: showTime)
        .frame(maxWidth: .infinity, alignment:  received ? .leading : .trailing)
        .padding(received ? .leading : .trailing, 10)
        
        
        
    }
}

