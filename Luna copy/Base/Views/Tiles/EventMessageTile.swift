//
//  EventMessageTile.swift
//  Luna
//
//  Created by Will Polich on 29/5/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct EventMessageTile: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    @Binding var currentEventChat : EventObj?
    @Binding var shouldNavigateToEventChat: Bool
    
    @State var event : EventObj?
    
    var message : RecentMessage
    
    var body: some View {
//        NavigationLink(destination: FriendMessageView(shouldNavigateToChat: $shouldNavigateToChat, chatUser: chatUser)
//                        .environmentObject(sessionService)
//                        .environmentObject(manager)
//                        .environmentObject(homeVM), label: {
        Button {
            if self.event != nil {
                self.currentEventChat = self.event
                self.shouldNavigateToEventChat = true
            } else {
                sessionService.getEventByID(id: message.linkedEvent) { event in
                    self.event = event
                    self.currentEventChat = event
                    self.shouldNavigateToEventChat = true
                }
            }
        } label: {
            HStack {
                ZStack (alignment: .bottomTrailing) {
                    WebImage(url : URL(string: message.fromImageurl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64).cornerRadius(64)
                        .clipped()  

                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .scaledToFit()
                        .foregroundColor(.purple)
                        .background(.white).cornerRadius(64)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color("darkBackground"), lineWidth: 3))
                }
                .padding(.trailing, 5)
//                .padding(.horizontal)
//                .padding(5)
                
                
                VStack (alignment: .leading, spacing: 0) {
                    HStack (alignment: .bottom){
                        Text(message.fromName)
                            .font(.body.bold())
                            .foregroundColor(Color.primary)
                            .lineLimit(1)
                        
                        Spacer()
                        
//                        if messagesManager.messages.last != nil {
                        if Calendar.current.isDateInToday((message.timestamp))  {
                            Text(message.timestamp.formatted(.dateTime.hour().minute()) )
                                .font(.caption)
                                .foregroundColor(Color.secondary)
                        } else if Calendar.current.isDateInYesterday((message.timestamp))  {
                            Text("Yesterday")
                                .font(.caption)
                                .foregroundColor(Color.secondary)
                        } else if Calendar.current.isDateInThisWeek((message.timestamp)) {
                            Text(message.timestamp.formatted(.dateTime.weekday()))
                                .font(.caption)
                                .foregroundColor(Color.secondary)
                        } else {
                            Text(message.timestamp.formatted(Date.FormatStyle()
                                .year(.defaultDigits)
                                .month(.abbreviated)
                                .day(.twoDigits)))
                                .font(.caption)
                                .foregroundColor(Color.secondary)
                        }
//                        }
                        
                    }
                    
                    HStack (alignment: .top){
                        
                        Text("\(message.text)")
                            .foregroundColor(message.received.contains(sessionService.userDetails.uid) ? Color.secondary : Color.primary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        
                        
                        if !(message.received.contains(sessionService.userDetails.uid) ) {
                            Spacer()
                            Image(systemName: "circle.fill")
                                .resizable()
                                .foregroundColor(Color.purple)
                                .frame(width: 10, height: 10)
                                .ignoresSafeArea()
                                .offset(x: 0, y: 5)
                        }
                        
                        
                    }
                    
                }
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
        }
        .onAppear {
//            print("msgID: \(message.fromID)")
//            if let target = homeVM.myEvents.first(where: {$0.id == message.linkedEvent})  {
//                print(target)
//                self.event = target
//            } else {
//                print("Could not find event in my events")
                sessionService.getEventByID(id: message.linkedEvent) { event in
                    self.event = event
                    self.currentEventChat = event
                }
//            }
        }

    }
}


