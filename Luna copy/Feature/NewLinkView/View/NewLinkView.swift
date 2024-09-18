//
//  NewLinkView.swift
//  Luna
//
//  Created by Will Polich on 7/2/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewLinkView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    @State var currEvent : EventObj?
    @Binding var linkedEvent : EventObj?
    @Binding var linkedVenue : VenueObj?
    @Binding var shouldShowNewLink : Bool
    
    @State var term: String = ""
    @State var searchOption : Int = 0
    @State var selectedTab = 0
    
    @State var showSearch : Bool = false
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .center) {
                
                VStack {
                    HStack {
                        newLinkTopBar(currentTab: $selectedTab)
                        Spacer()
                        Button {
                            withAnimation {
                                showSearch.toggle()
                            }
                        } label: {
                            if showSearch {
                                Image(systemName: "magnifyingglass")
                                    .padding(4)
                                    .background(.purple.opacity(0.3))
                                    .foregroundColor(.purple)
                                    .cornerRadius(40)
                            }
                            else {
                                Image(systemName: "magnifyingglass")
                                    .padding(4)
                                    .cornerRadius(10)
                            }
                            
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Divider()
                    
                    if showSearch {
                        
                        TextField("Search Luna", text: $term)
                            .disableAutocorrection(true)
                            .padding(5)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                            .onChange(of: term) { newTerm in
                                if selectedTab == 1  {
                                    searchOption = 1
                                }
                                else {
                                    searchOption = 4
                                }
                                
                                sessionService.searchVenues(term: term, option: searchOption)
                            }
                    }
                }
                
                ScrollView {
                    VStack (alignment: .leading) {
                        if selectedTab == 0 {
                    
                            if showSearch {
                                ForEach(sessionService.searchEventResults, id: \.self) { event in
                                    MyEventsEventView(event: event, clickable: false)
                                        .environmentObject(sessionService)
                                        .onTapGesture {
                                            self.linkedVenue = nil
                                            self.linkedEvent = event
                                            shouldShowNewLink.toggle()
                                        }
                                    
                                    Divider()
                                }
                            }
                            
                            else {
                                if homeVM.myEvents.count == 0 && !homeVM.gettingMyEvents {
                                    Text("Looks like you have no events. Search to find some!")
                                        .foregroundColor(Color("darkSecondaryText"))
                                }
                                else {
                                    ForEach(homeVM.myEvents, id: \.self) { event in
                                        
                                        if event.endTime != "" {
                                            if self.currEvent != nil {
                                                if self.currEvent?.id != event.id {
                                                    if event.userCreated == false {
                                                
                                                        MyEventsEventView(event: event, clickable: false)
                                                            .environmentObject(sessionService)
                                                            .onTapGesture {
                                                                self.linkedVenue = nil
                                                                self.linkedEvent = event
                                                                shouldShowNewLink.toggle()
                                                            }
                                                        
                                                        Divider()
                                                        
                                                    } else {
                                                        
                                                        UserEventTileView(event: event, clickable: false)
                                                            .environmentObject(sessionService)
                                                            .onTapGesture {
                                                                self.linkedVenue = nil
                                                                self.linkedEvent = event
                                                                shouldShowNewLink.toggle()
                                                            }
                                                        
                                                        Divider()
                                                    }
                                                }
                                            } else {
                                                if event.userCreated == false {
                                                    
                                                    MyEventsEventView(event: event, clickable: false)
                                                        .environmentObject(sessionService)
                                                        .onTapGesture {
                                                            self.linkedVenue = nil
                                                            self.linkedEvent = event
                                                            shouldShowNewLink.toggle()
                                                        }
                                                    
                                                    Divider()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                            
                        else if selectedTab == 1 {
                            
                            
                            if showSearch {
                                ForEach(sessionService.searchVenueResults, id: \.self) { venue in
                                    VenueSearchTileView(ven: venue)
                                        .environmentObject(sessionService)
                                        .environmentObject(manager)
                                        .environmentObject(homeVM)
                                        .highPriorityGesture(TapGesture()
                                                                .onEnded { _ in
                                                                    self.linkedEvent = nil
                                                                    self.linkedVenue = venue
                                                                    shouldShowNewLink.toggle()
                                                                })
                                }
                            }
                            
                            else {
                                ForEach(homeVM.venues, id: \.self) { venue in
                                    VenueSearchTileView(ven: venue)
                                        .environmentObject(sessionService)
                                        .environmentObject(manager)
                                        .environmentObject(homeVM)
                                        .highPriorityGesture(TapGesture()
                                                                .onEnded { _ in
                                                                    self.linkedEvent = nil
                                                                    self.linkedVenue = venue
                                                                    shouldShowNewLink.toggle()
                                                                })
                                }
                            }
                        }
                        
                    }
                            
                            
                            
                            
//                            TextField("Search Venues", text: $term)
//                                .disableAutocorrection(true)
//                                .padding(12)
//                                .background(Color.gray.opacity(0.5))
//                                .cornerRadius(5)
//                                .onChange(of: term) { newTerm in
//                                    sessionService.searchVenues(term: term, option: 1)
//                                }
                            
//                            ForEach(sessionService.searchVenueResults, id: \.self) { venue in
//                                Divider()
//                                HStack {
//
//                                    WebImage(url: URL(string: venue.imageurl))
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(maxWidth: 110, maxHeight: 75)
//                                        .cornerRadius(10)
//
//                                    VStack (alignment: .leading) {
//                                        Text(venue.displayname)
//                                            .font(.system(size: 20))
//                                            .foregroundColor(Color.primary)
//
//                                        Text("\(venue.address)")
//                                            .fontWeight(.thin)
//                                            .font(.system(size: 15))
//
//
//
//                                    }
//                                    .foregroundColor(.primary)
//                                    .frame(width: 200, height: 100)
//                                    .multilineTextAlignment(.leading)
//
//
//
//                                }.onTapGesture {
//                                    self.linkedEvent = nil
//                                    self.linkedVenue = venue
//                                    shouldShowNewLink.toggle()
//
//                                }
//
//                                Divider()
//                            }
                      
                    
         
                    
                    

                }
                
            }
            .navigationBarTitle("Pres Link", displayMode: .inline)
            .applyClose()
            


        }
        .padding(.horizontal)
        .navigationBarHidden(true)
        .onAppear {
            sessionService.searchVenues(term: "", option: 1)
            
//            sessionService.searchUsers(term: "")
        }
        .task {
            await homeVM.getMyEvents(uid: sessionService.userDetails.uid, token: sessionService.token)
        }
        
        
        
    }
    
}

struct venueTile: View {
    
    @State var venue : VenueObj
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: venue.imageurl))
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 110, maxHeight: 75)
                .cornerRadius(10)

            VStack (alignment: .leading) {
                Text(venue.displayname)
                    .font(.system(size: 20))
                    .foregroundColor(Color.primary)
        
                Text("\(venue.address)")
                    .fontWeight(.thin)
                    .font(.system(size: 15))

                
                    
            }
            .foregroundColor(.primary)
            .frame(width: 200, height: 100)
            .multilineTextAlignment(.leading)
        }
    }
}

struct newLinkTopBar: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    var tabBarOptions: [String] = ["Events", "Venues"]
    
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
