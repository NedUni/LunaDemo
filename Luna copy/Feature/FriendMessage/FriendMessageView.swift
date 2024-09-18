//
//  FriendMessageView.swift
//  Luna
//
//  Created by Will Polich on 13/4/2022.
//

import SwiftUI

struct FriendMessageView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var homeVM : ViewModel
    @State var showDeal : Bool = false
    @State var selectedDeal : DealObj?
    @StateObject var service = FriendMessageService()
    @State var loaded = false
    
    @Binding var shouldNavigateToChat : Bool
    
    let chatUser : UserObj?
    
    var body: some View {
        VStack (spacing: 0) {
            VStack {
                FriendTitleRowView(chatUser: chatUser, shouldNavigateToChat : $shouldNavigateToChat)
                    .environmentObject(sessionService)
                    .environmentObject(manager)
                    .environmentObject(homeVM)
                
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack {
                            ForEach(service.messages) { message in
                                VStack(alignment: message.sender != sessionService.userDetails.uid ? .leading : .trailing) {
                                    if service.messages.firstIndex(of: message) == 0 {
                                        Text(message.senderName)
                                            .foregroundColor(Color.secondary)
                                            .padding(message.sender != sessionService.userDetails.uid ? .leading : .trailing, message.sender == sessionService.userDetails.uid ? 20 : 50)
//
                                    }
                                    else if service.messages[(service.messages.firstIndex(of: message) ?? 0) - 1].sender != message.sender {

                                        Text(message.senderName)
                                            .foregroundColor(Color.secondary)
                                            .padding(message.sender != sessionService.userDetails.uid ? .leading : .trailing, message.sender == sessionService.userDetails.uid ? 20 : 50)
                                    }
                                   
//
                                    MessageBubbleView(message: message, received: message.sender != sessionService.userDetails.uid ? true : false, showDeal: $showDeal, selectedDeal: $selectedDeal)
                                        .environmentObject(sessionService)
                                        .environmentObject(manager)
                                        .environmentObject(homeVM)
                                }
                                
                            }
                        }
                        
                        
                    }
                    
                    .padding(.top, 10)
                    .background(Color("darkBackground"))
//                    .background(Color("facade"))
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .ignoresSafeArea()
                    .onChange(of: service.lastMessage) { id in
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                        
                    }
                }
                .cornerRadius(30, corners: [.topLeft, .topRight])
                
                
            }
//            .background(Color("facade"))
//            .background((Color.primary).colorInvert())
            
            
            
            FriendMessageFieldView(chatUser: chatUser)
                .environmentObject(sessionService)
                .environmentObject(service)
           
        }
        .background(Color("darkBackground"))
       
        .navigationBarHidden(true)
        .onAppear {
            if !loaded {
                service.getMessages(id: sessionService.userDetails.uid, recipient: chatUser?.uid ?? "")
            }
            service.readAllMessages(uid: sessionService.userDetails.uid, chatUserID: chatUser?.uid ?? "", completion: {
                sessionService.getUnreadCount(uid: sessionService.userDetails.uid, token: sessionService.token)
            })
//            messagesManager.readAllMessages(uid: sessionService.userDetails.uid, id: event.id, pres: event.endTime == "" ? true : false, completion: {
//                sessionService.getUnreadCount(uid: sessionService.userDetails.uid, token: sessionService.token)
//            })
        }
        .blur(radius: showDeal && self.selectedDeal != nil ? 10 : 0)
        .popup(isPresented: $showDeal) {
            if self.selectedDeal != nil {
                DealTileExpanded(deal: self.selectedDeal!, venue: nil, dealIsPresented: $showDeal)
                    .environmentObject(sessionService)
                    .environmentObject(manager)
                    .environmentObject(homeVM)
                    .onDisappear {
                        self.selectedDeal = nil
                    }
            }
            
        }
        
    
    }
}

