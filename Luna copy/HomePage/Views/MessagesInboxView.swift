//
//  MessagesInboxView.swift
//  Luna
//
//  Created by Will Polich on 7/4/2022.
//

import SwiftUI

struct MessagesInboxView: View {
    
    @EnvironmentObject var viewModel : ViewModel
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @StateObject var inboxService = InboxService()
    
    @Binding var showFriendsToAdd : Bool
    @State var showNewMessage : Bool = false
    @State var messagesTab : Int = 0
    @State var currentChatUser: UserObj?
    @State var currentEventChat: EventObj?
    @Binding var shouldNavigateToChat : Bool
    @Binding var shouldNavigateToEventChat : Bool
    
    var body: some View {
        
        VStack (spacing: 0) {
            VStack (spacing: 0) {
                HeaderView(pageName: "Messages", showFriendsToAdd: $showFriendsToAdd)
                    .environmentObject(sessionService)
                    .environmentObject(manager)
                    .environmentObject(viewModel)
                
                
                Divider()
                    .padding(.vertical)

                ZStack (alignment: .bottom) {
                    
                    ScrollView {
                        if inboxService.allMessages.count == 0 && inboxService.gettingMessages == false {
                            Text("Chats with friends and pres will appear here.")
                                .foregroundColor(Color.secondary)
                        } else {
                           
                            ForEach(inboxService.allMessages, id: \.self) { message in
                                if message.linkedEvent != "" {
                                    EventMessageTile(currentEventChat: $currentEventChat, shouldNavigateToEventChat: $shouldNavigateToEventChat, message: message)
                                        .environmentObject(sessionService)
                                        .environmentObject(manager)
                                        .environmentObject(viewModel)
                                } else {
                                    FriendMessageTile(chatUser: $currentChatUser, shouldNavigateToChat: $shouldNavigateToChat, message: message)
                                        .environmentObject(sessionService)
                                        .environmentObject(manager)
                                        .environmentObject(viewModel)
                                }
                                
                               
                            }
                        }
                    }
                    .navigationBarHidden(true)
                    
                    
                    Button(action: {
                        showNewMessage.toggle()
                    }, label: {
                        HStack {
                            
                            Spacer()
                            
                            HStack {
                                Image(systemName: "plus.app")
                                Text("Message")
                            }
                            .frame(width: UIScreen.main.bounds.size.width*0.4, height: 40, alignment: .center)
                            .background(.purple.opacity(0.7))
                            .cornerRadius(30)
                            .padding(.bottom)
                            .foregroundColor(.white)
                        }
                    })
                    
//                    Button(action: {
//
//
//                    }, label: {
//                        HStack {
//                            Spacer()
//                            Text("New Message")
//                                .foregroundColor(Color.white)
//                            Image(systemName: "plus.app")
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(Color.white)
//                                .frame(width: 24, height: 24)
//                            Spacer()
//                        }.frame(width: 288, height: 40)
//                            .background(Color.purple).cornerRadius(20)
//                            .padding()
//
//                    })
                }
                
                NavigationLink("", isActive: $shouldNavigateToChat) {
                    FriendMessageView(shouldNavigateToChat: $shouldNavigateToChat, chatUser: currentChatUser)
                        .environmentObject(sessionService)
                        .environmentObject(manager)
                        .environmentObject(viewModel)
                }
                .frame(width: 0, height: 0, alignment: .center)
                NavigationLink("", isActive: $shouldNavigateToEventChat) {
                    if currentEventChat != nil {
                        MessageView(shouldNavigateToEventChat: $shouldNavigateToEventChat, event: currentEventChat!)
                            .environmentObject(sessionService)
                            .environmentObject(manager)
                            .environmentObject(viewModel)
                    }
                }
                .frame(width: 0, height: 0, alignment: .center)

                
            }
            .padding(.horizontal)
            .navigationBarHidden(true)
            .background(Color("darkBackground"))
        }
        .fullScreenCover(isPresented: self.$showNewMessage) {
            NewMessageView(showNewMessage: $showNewMessage) { user in
                print("\(user.firstName) \(user.lastName)")
                self.currentChatUser = user
                self.shouldNavigateToChat.toggle()
            }
        }
        .onAppear {
            
            inboxService.getAllMessages(uid: sessionService.userDetails.uid) {
                sessionService.getUnreadCount(uid: sessionService.userDetails.uid, token: sessionService.token)
            }
            
            inboxService.getAllFriendMessages(uid: sessionService.userDetails.uid, completion: {
                sessionService.getUnreadCount(uid: sessionService.userDetails.uid, token: sessionService.token)
            })
            inboxService.getAllEventMessages(uid: sessionService.userDetails.uid) {
                sessionService.getUnreadCount(uid: sessionService.userDetails.uid, token: sessionService.token)
            }
            
            
            sessionService.getToken()
            sessionService.getUnreadCount(uid: sessionService.userDetails.uid, token: sessionService.token)
            
            sessionService.getFriends(uid: sessionService.userDetails.uid, completion: {})
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .task {
            await viewModel.getMyEvents(uid: sessionService.userDetails.uid, token: sessionService.token)
            await viewModel.getMyPastEvents(uid: sessionService.userDetails.uid, token: sessionService.token)
        }
         
    }
}


