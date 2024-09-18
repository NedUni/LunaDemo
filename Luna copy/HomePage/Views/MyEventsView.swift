//
//  MyEventsView.swift
//  Luna
//
//  Created by Will Polich on 7/4/2022.
//

import SwiftUI

struct MyEventsView: View {
    
    @EnvironmentObject var viewModel : ViewModel
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    
    @Binding var showFriendsToAdd : Bool
    @State var myEventsSelection : Int = 1
    @State var showNewEvent : Bool = false
    @State var discoverTab : Int = 0
    
    @State var createdEvent : EventObj = EventObj(id: "", label: "", description: "", imageurl: "", tags: [], date: "", startTime: "", endTime: "", invited: [], going: [], interested: [], declined: [], hostIDs: [], hostNames: [], performers: [], address: "", linkedVenueName: "", linkedVenue: "", linkedEvent: "", userCreated: false, pageCreated: false, ticketLink: "")
    @State var presCreated = false
    
    
    var body: some View {
        
        NavigationView {
            
            ZStack (alignment: .bottom) {
    
                VStack (alignment: .leading) {
                    HeaderView(pageName: "My Events", showFriendsToAdd: $showFriendsToAdd)
                        .environmentObject(sessionService)
                        .environmentObject(manager)
                        .environmentObject(viewModel)
                                      
                    VStack (alignment: .leading) {
                        myEventsTopTab(currentTab: $discoverTab)
                        Divider()
                    }
                    
                    ScrollView (showsIndicators: false) {
//                        LazyVStack {
                            if discoverTab == 0 {
                                if viewModel.gettingMyEvents == true {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                } else {
                                
                                    if viewModel.myEvents.count == 0 {
                                        Text("No upcoming events. Go check out some venues or make an event with friends!")
                                            .foregroundColor(Color.secondary)
                                    } else {
                                        LazyVStack (alignment: .center) {
                                            
                                            
                                            ForEach(viewModel.myEvents, id: \.self) { event in
                                                
                                                
                                                Spacer()
                                                if event.userCreated == false {
                                                    MyEventsEventView(event: event, clickable: true)
                                                        .environmentObject(sessionService)
                                                        .environmentObject(manager)
                                                        .environmentObject(viewModel)
                                                } else {
                                                    NewPresTile(event: event)
                                                        .environmentObject(sessionService)
                                                        .environmentObject(manager)
                                                        .environmentObject(viewModel)
                                                }
                                                Spacer()
                                                
                                                Divider()
                                            }
                                        }
                                    }
                                }
                            }
                            
                            else {
                                if viewModel.gettingMyPastEvents == true {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                } else {
                                    if viewModel.myPastEvents.count == 0 {
                                        Text("No past events. Go get out there!")
                                            .foregroundColor(Color.secondary)
                                    } else {
                                        LazyVStack (alignment: .leading) {
                                            
                                            ForEach(viewModel.myPastEvents, id: \.self) { event in
                                                if event.userCreated == false {
                                                    EventTileView(event: event, clickable: true)
                                                        .environmentObject(sessionService)
                                                        .environmentObject(manager)
                                                        .environmentObject(viewModel)
                                                    
                                                } else {
                                                    EventTileView(event: event, clickable: true)
                                                        .environmentObject(sessionService)
                                                        .environmentObject(manager)
                                                        .environmentObject(viewModel)
                                                }
                                                
                                                Divider()
                                            }
                                        }
    //                                     .padding(.horizontal)
                                    }
                                }
                            }
//                        }
                    }
                }
                
                
                Button(action: {
                    showNewEvent.toggle()
                }, label: {
                    HStack {
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "calendar.badge.plus")
                            Text("New Pres")
                        }
                        .frame(width: UIScreen.main.bounds.size.width*0.4, height: 40, alignment: .center)
                        .background(.purple.opacity(0.7))
                        .cornerRadius(30)
                        .padding(.bottom)
                        .foregroundColor(.white)
                    }
                })
                
                
            }
            .padding(.horizontal)
            .navigationBarHidden(true)
            .background(Color("darkBackground"))
            .sheet(isPresented:  $showNewEvent, onDismiss: {
                Task {
                   await viewModel.getMyEvents(uid: sessionService.userDetails.uid, token: sessionService.token)
                   await viewModel.getMyPastEvents(uid: sessionService.userDetails.uid, token: sessionService.token)
               }
            }) {
                CreatePresView(showCreatePres: $showNewEvent, createdEvent: $createdEvent)
                    .environmentObject(viewModel)
                    .environmentObject(sessionService)
                    .environmentObject(manager)
                    .interactiveDismissDisabled(true)
            }
            
            
            
//            .fullScreenCover(isPresented: $showNewEvent, onDismiss: {
//                Task {
//                    await viewModel.getMyEvents(uid: sessionService.userDetails.uid, token: sessionService.token)
//                    await viewModel.getMyPastEvents(uid: sessionService.userDetails.uid, token: sessionService.token)
//                }
//            }) {
//                NewEventView(showNewEvent: $showNewEvent)
//                .environmentObject(sessionService)
//                .environmentObject(viewModel)
//                .environmentObject(manager)
//            }
            
            .navigationBarHidden(true)

        }

        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            sessionService.getToken()
            sessionService.refreshUserDetails()
            sessionService.getUnreadCount(uid: sessionService.userDetails.uid, token: sessionService.token)
        }
        .onChange(of: myEventsSelection, perform: { change in
            Task {
         
                await viewModel.getMyEvents(uid: sessionService.userDetails.uid, token: sessionService.token)
                await viewModel.getMyPastEvents(uid: sessionService.userDetails.uid, token: sessionService.token)
            }
        })
        .task {
            await viewModel.getMyEvents(uid: sessionService.userDetails.uid, token: sessionService.token)
            await viewModel.getMyPastEvents(uid: sessionService.userDetails.uid, token: sessionService.token)
        }
    }
}

struct myEventsTopTab: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    var tabBarOptions: [String] = ["Upcoming", "Past"]
    
    var body: some View {
        HStack (alignment: .bottom, spacing: 20) {
                ForEach(Array(zip(self.tabBarOptions.indices,
                                  self.tabBarOptions)),
                        id:\.0,
                        content: {
                    index, name in
                    topTabItem(currentTab: self.$currentTab, namespace: namespace.self, tabBarItemName: name, tab: index)
                })
            }
            .background(.clear)
    }
}

