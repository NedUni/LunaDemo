//
//  FriendMessageTile.swift
//  Luna
//
//  Created by Will Polich on 13/4/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct FriendMessageTile: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    @Binding var chatUser : UserObj?
    @Binding var shouldNavigateToChat: Bool
    
    @State var user : UserObj?
    
    var message : RecentMessage
    
    var body: some View {
//        NavigationLink(destination: FriendMessageView(shouldNavigateToChat: $shouldNavigateToChat, chatUser: chatUser)
//                        .environmentObject(sessionService)
//                        .environmentObject(manager)
//                        .environmentObject(homeVM), label: {
        Button {
            if self.user != nil {
                self.chatUser = self.user
                self.shouldNavigateToChat = true
            } else {
                sessionService.getUserByID(uid: message.fromID, token: sessionService.token) { user in
                    self.user = user
                    self.chatUser = user
                    self.shouldNavigateToChat = true
                }
            }
        } label: {
            HStack {
                WebImage(url : URL(string: message.fromImageurl)) 
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64).cornerRadius(64)
                    .clipped()
//                    .padding(.horizontal)
//                    .padding(5)
                    .padding(.trailing, 5)
                
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
//                            .font(.system(size: 10))
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
            print("msgID: \(message.fromID)")
            if let target = sessionService.currentFriends.first(where: {$0.uid == message.fromID})  {
                print(target)
                self.user = target
            } else {
                print("Could not find chat user in friends")
                sessionService.getUserByID(uid: message.fromID, token: sessionService.token) { user in
                    self.user = user
                }
            }
        }

            
//        })
//        })
//            .onAppear {
//                messagesManager.getMessages(id: event.id, pres: event.endTime == "" ? true : false)
//
//            }
    }
}

