////
////  EventChatTile.swift
////  Luna
////
////  Created by Will Polich on 1/4/2022.
////
//
//import SwiftUI
//import SDWebImageSwiftUI
//
//struct EventChatTile: View {
//    
//    @State var event : EventObj
//    @StateObject var messagesManager = MessagesManager()
//    @EnvironmentObject var viewModel : ViewModel
//    @EnvironmentObject var sessionService: SessionServiceImpl
//    @EnvironmentObject var manager : LocationManager
//    @State var lastMessageTime : Date?
//    
//    var body: some View {
//        NavigationLink(destination: MessageView(event: event)
//            .environmentObject(sessionService)
//            .environmentObject(manager)
//            .environmentObject(viewModel), label: {
//            HStack {
//                WebImage(url : URL(string: event.imageurl))
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 64, height: 64).cornerRadius(64)
//                    .clipped()
//                    .padding()
//                
//                VStack (alignment: .leading, spacing: 0) {
//                    HStack (alignment: .bottom){
//                        Text(event.label)
//                            .font(.body.bold())
//                            .foregroundColor(Color.primary)
//                        
//                        Spacer()
//                        
//                        if messagesManager.messages.last != nil {
//                            if Calendar.current.isDateInToday((messagesManager.messages.last?.timestamp)!)  {
//                                Text(messagesManager.messages.last?.timestamp.formatted(.dateTime.hour().minute()) ?? "")
//                                    .font(.caption)
//                                    .foregroundColor(Color.secondary)
//                            } else if Calendar.current.isDateInYesterday((messagesManager.messages.last?.timestamp)!)  {
//                                Text("Yesterday")
//                                    .font(.caption)
//                                    .foregroundColor(Color.secondary)
//                            } else {
//                                Text(messagesManager.messages.last?.timestamp.formatted(.dateTime) ?? "")
//                                    .font(.caption)
//                                    .foregroundColor(Color.secondary)
//                            }
//                        }
//                        
//                    }
//                    
//                    HStack (alignment: .top){
//                        if messagesManager.messages.last != nil {
//                            Text("\(messagesManager.messages.last!.senderName): \(messagesManager.messages.last!.text)")
//                                .foregroundColor(messagesManager.messages.last?.received.contains(sessionService.userDetails.uid) ?? false ? .secondary : .primary)
////                                .font(.system(size: 10))
//                                .lineLimit(2)
//                                .multilineTextAlignment(.leading)
//                        } else {
//                            Text("\(event.hostNames.joined(separator: ", ")) created the event: \(event.label)")
//                                .font(.body)
//                                .foregroundColor(Color.primary)
////                                .font(.system(size: 10))
//                                .lineLimit(2)
//                                .multilineTextAlignment(.leading)
//                                
//                        }
//                        
//                        
//                        
//                        if !(messagesManager.messages.last?.received.contains(sessionService.userDetails.uid) ?? true) {
//                            Spacer()
//                            Image(systemName: "circle.fill")
//                                .resizable()
//                                .foregroundColor(Color.purple)
//                                .frame(width: 10, height: 10)
//                                .ignoresSafeArea()
//                                .offset(x: 0, y: 5)
//                        }
//                        
//                        
//                    }
//                    
//                }
//                
//                
//                
//            }
//            .frame(maxWidth: .infinity, maxHeight: 100)
//        })
//            .onAppear {
//                messagesManager.getMessages(id: event.id, pres: event.endTime == "" ? true : false)
//                
//            }
//    }
//}
//
//
