//
//  FriendMessageFieldView.swift
//  Luna
//
//  Created by Will Polich on 14/4/2022.
//

import SwiftUI

struct FriendMessageFieldView: View {
    
    @EnvironmentObject var service : FriendMessageService
    @EnvironmentObject var sessionService : SessionServiceImpl
    
    @State var showSearch = false
    
    @State var linkedEvent : EventObj?
    @State var linkedVenue : VenueObj?
    @State var linkedDeal : DealObj?
    
    @State var message = ""
    
    @State var send : Bool = false
    
    @State var selectedTab : Int = 0
    
    var isEmpty : Bool {
        if message == "" && linkedEvent == nil && linkedVenue == nil && linkedDeal == nil {
            return true
        }
        return false
    }
    
    var chatUser : UserObj?
    
    var body: some View {
//        HStack {
//
//        }
        HStack {
            
//            Button {
////                showSearch.toggle()
//                withAnimation {
//                    send.toggle()
//                }
//
//
//            } label: {
//                Image(systemName: "magnifyingglass")
//                    .foregroundColor(Color.white)
//                    .padding(5)
//                    .background(.purple)
//                    .cornerRadius(50)
//            }
            
            HStack (alignment: .center, spacing: 10) {
                if !send {
                    Button {
        //                showSearch.toggle()
                        withAnimation {
                            send.toggle()
                        }
        
        
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .frame(width: 15, height: 15, alignment: .center)
                            .padding(7)
                            .background(.purple)
                            .cornerRadius(15)
                            .foregroundColor(.white)
//                            .cornerRadius(50)
                    }
                }
                
                else {
                    
                    Button {
                        withAnimation {
                            send.toggle()
                        }
                        
                    } label: {
                        Image(systemName: "chevron.left")
                            .frame(width: 15, height: 15, alignment: .center)
                            .padding(7)
                            .background(.purple)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                    }
                    
                    Button {
                        setTab(tab: 0) {
                            showSearch.toggle()
                        }
//                        selectedTab = 1
                        
                        
                    } label: {
                        Image(systemName: "calendar")
                            .frame(width: 15, height: 15, alignment: .center)
                            .padding(7)
                            .background(.purple)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                    }
                    
                    Button {
                        setTab(tab: 1) {
                            showSearch.toggle()
                        }
                        
                    } label: {
                        Image(systemName: "music.note.house")
                            .frame(width: 15, height: 15, alignment: .center)
                            .padding(7)
                            .background(.purple)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                    }
                    
                    Button {
                        setTab(tab: 2) {
                            showSearch.toggle()
                        }
                        
                    } label: {
                        Text("$")
                            .frame(width: 15, height: 15, alignment: .center)
                            .padding(7)
                            .background(.purple)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(5)
            .frame(minWidth: 0, maxWidth: send ? 180 : 40, alignment: .leading)
            
//            CustomTextField(placeholder: "Aa", text: $message)
            CustomTextField(placeholder: Text("Text"), text: $message)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 25)
                .padding(5)
                .background(.gray.opacity(0.7))
                .cornerRadius(15)
            
            Button {
                if isEmpty {
                    return
                } else {
                    service.sendMessage(text: message, sender: sessionService.userDetails, recipient: chatUser, imageurl: sessionService.userDetails.imageURL, name: "\(sessionService.userDetails.firstName) \(sessionService.userDetails.lastName)", linkedEvent: linkedEvent, linkedVenue: linkedVenue, linkedDeal: linkedDeal)
                    linkedEvent = nil
                    linkedVenue = nil
                    linkedDeal = nil
                    self.message = ""
                }

            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(Color.white)
                    .padding(5)
                    .background(.purple)
                    .cornerRadius(50)
                    .opacity(isEmpty ? 0.5 : 1)

            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal)
        .padding(.vertical)
        .background(Color("darkBackground").opacity(0.5))
//        .frame(minWidth: 0, maxWidth: .infinity)
//        .background(.red)
//        .frame(height: 10)
//        .padding(.bottom)
        
        
        .sheet(isPresented: $showSearch) {
            LinkSearchView(linkedEvent: $linkedEvent, linkedVenue: $linkedVenue, linkedDeal: $linkedDeal, shouldShowNewLink: $showSearch, selectedTab: $selectedTab)
        }
        .onChange(of: linkedVenue) { change in
            if change != nil {
                service.sendMessage(text: message, sender: sessionService.userDetails, recipient: chatUser, imageurl: sessionService.userDetails.imageURL, name: "\(sessionService.userDetails.firstName) \(sessionService.userDetails.lastName)", linkedEvent: linkedEvent, linkedVenue: linkedVenue, linkedDeal: linkedDeal)
                message = ""
                linkedEvent = nil
                linkedVenue = nil
                linkedDeal = nil
            }
            
        }
        .onChange(of: linkedEvent) { change in
            if change != nil {
                service.sendMessage(text: message, sender: sessionService.userDetails, recipient: chatUser, imageurl: sessionService.userDetails.imageURL, name: "\(sessionService.userDetails.firstName) \(sessionService.userDetails.lastName)", linkedEvent: linkedEvent, linkedVenue: linkedVenue, linkedDeal: linkedDeal)
                message = ""
                linkedEvent = nil
                linkedVenue = nil
                linkedDeal = nil
            }
            
        }
        .onChange(of: linkedDeal) { change in
            if change != nil {
                service.sendMessage(text: message, sender: sessionService.userDetails, recipient: chatUser, imageurl: sessionService.userDetails.imageURL, name: "\(sessionService.userDetails.firstName) \(sessionService.userDetails.lastName)", linkedEvent: linkedEvent, linkedVenue: linkedVenue, linkedDeal: linkedDeal)
                message = ""
                linkedEvent = nil
                linkedVenue = nil
                linkedDeal = nil
            }
            
        }
//        .padding(.horizontal, 10)
//        .padding(.vertical, 10)
//        .background(.red)
//        .background(Color.secondary.opacity(0.1))
//        .cornerRadius(50)
//        .padding()
    }
    
    func setTab(tab: Int, completion: @escaping () -> ()) {
        self.selectedTab = tab
        completion()
    }
}


