//
//  MessageView.swift
//  Luna
//
//  Created by Will Polich on 19/3/2022.
//

import SwiftUI
import Foundation

struct Message: Identifiable, Codable, Hashable {
    var id: String
    var text: String
    var timestamp: Date
    var sender: String
    var received: [String]
    var imageurl: String
    var senderName: String
    var linkedEvent: String
    var linkedVenue: String
    var linkedDeal: String
}

extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
}

struct MessageView: View {
    
    @Binding var shouldNavigateToEventChat : Bool
    
    let event : EventObj
    @StateObject var service = MessagesManager()
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    @State var showDeal : Bool = false
    @State var selectedDeal : DealObj?
    
   
    
    
    var body: some View {
        
        VStack {
            VStack {
                TitleRowView(shouldNavigateToEventChat: $shouldNavigateToEventChat, event: event)
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
            
            MessageFieldView(event: event)
                .environmentObject(sessionService)
                .environmentObject(manager)
                .environmentObject(homeVM)
                .environmentObject(service)
//            .background(Color("facade"))
//            .background((Color.primary).colorInvert())
                
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
        .background(Color("darkBackground"))
        .navigationBarHidden(true)
        .onAppear {
            service.getMessages(id: event.id, pres: event.endTime == "" ? true : false)
            service.readAllMessages(uid: sessionService.userDetails.uid, id: event.id, pres: event.endTime == "" ? true : false, completion: {
                sessionService.getUnreadCount(uid: sessionService.userDetails.uid, token: sessionService.token)
            })
        }
    }
    
}


//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        
//        let event = EventObj(creator: "", date: "23-01-2022", description: "Let's trot", endTime: "", filename: "", id: "", imageurl: "https://s3-ap-southeast-2.amazonaws.com/production.assets.merivale.com.au/wp-content/uploads/2019/07/15171723/lost_sundays_gallery_2.jpg", label: "Pres", startTime: "20:00", creatorID: "", invited: ["QV8WKYu09tUxjj5Iai827aBbbXD2"], going: [], interested: [], declined: [], performers: [], userCreated : true, linkedEvent: "", linkedVenue: "", address: "", ticketLink: "", hosts: [], hostNames: [])
//        
//        MessageView(event: event)
//    }
//}
