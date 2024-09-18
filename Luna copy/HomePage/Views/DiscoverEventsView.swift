//
//  DiscoverEventsView.swift
//  Luna
//
//  Created by Will Polich on 7/4/2022.
//

import SwiftUI

struct DiscoverEventsView: View {
    @EnvironmentObject var viewModel : ViewModel
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    
    @Binding var showFriendsToAdd : Bool
    @State var discoverTab : Int = 0
    @State var showFilters : Bool = false
    @State var clearToggle : Bool = false
    
    @State var chosenCategories : [String] = []
    
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                HeaderView(pageName: "Discover Events", showFriendsToAdd: $showFriendsToAdd)
                    .environmentObject(sessionService)
                    .environmentObject(manager)
                    .environmentObject(viewModel)
            
                VStack (alignment: .leading) {
                    HStack {
                        topTab(currentTab: $discoverTab)
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                showFilters.toggle()
                            }
                        }, label: {
                            if showFilters {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .foregroundColor(.purple)
                                    .padding(7)
                                    .background(.purple.opacity(0.3))
                                    .cornerRadius(20)
                            }
                            else {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .padding(7)
                            }
                            
                        })
                    }
                    
                    if showFilters {
                        Divider()
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack {
                                if clearToggle {
                                    Button {
                                        self.chosenCategories = []
                                        withAnimation {
                                            self.clearToggle = false
                                        }
                                    } label: {
                                        HStack {
                                            Text("Clear")
                                            Image(systemName: "xmark")
                                        }
                                        .foregroundColor(Color("Error"))
                                        .padding(7)
                                        .background(Color("Error").opacity(0.3))
                                        .cornerRadius(20)   
                                    }

                                }
                                ForEach(viewModel.pageCategories, id: \.self) { category in
                                    Button {
                                        if self.chosenCategories.contains(category) {
                                            let theIndex = chosenCategories.firstIndex(of: category)
                                            chosenCategories.remove(at: theIndex!)
                                        }
                                        else {
                                            self.chosenCategories.append(category)
                                        }
                                        
                                        if self.chosenCategories != [] {
                                            withAnimation {
                                                self.clearToggle = true
                                            }
                                        }
                                        else {
                                            withAnimation {
                                                self.clearToggle = false
                                            }
                                        }
                                    } label: {
                                        if self.chosenCategories.contains(category) {
                                            Text(category)
                                                .foregroundColor(.purple)
                                                .padding(7)
                                                .background(.purple.opacity(0.3))
                                                .cornerRadius(20)
                                        }
                                        else {
                                            Text(category)
                                                .padding(7)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    

                    Divider()
                }
                .buttonStyle(.plain)
                
                ScrollView (showsIndicators: false) {
                    if self.discoverTab == 0 {
                        if viewModel.gettingEventsToday == true {
                            ProgressView()
                        } else if viewModel.eventsToday.count == 0 {
                            Text("No venues with events today.")
                                .foregroundColor(Color.secondary)
                        } else {
//                            Text("hey")
                            ForEach(viewModel.eventsToday, id: \.self) { event in
                                if Set(self.chosenCategories).isSubset(of: Set(event.tags)) {
                                    Spacer()
                                    
                                    MyEventsEventView(event: event, clickable: true)
                                        .environmentObject(sessionService)
                                        .environmentObject(manager)
                                        .environmentObject(viewModel)
                                    
                                    Spacer()
                                    Divider()
                                }

                            }
                        }
                    }
                    
                    else if self.discoverTab == 1 {
                        if viewModel.gettingEventsWeek == true {
                            ProgressView()
                        } else if viewModel.eventsWeek.count == 0 {
                            Text("No venues with events this week.")
                                .foregroundColor(Color.secondary)
                        } else {
                            ForEach(viewModel.eventsWeek, id: \.self) { event in
                                if Set(self.chosenCategories).isSubset(of: Set(event.tags)) {
                                    Spacer()
                                    
                                    
                                    MyEventsEventView(event: event, clickable: true)
                                        .environmentObject(sessionService)
                                        .environmentObject(manager)
                                        .environmentObject(viewModel)
                                    
                                    Spacer()
                                    Divider()
                                }

                            }
                        }
                    }
                    
                    else if self.discoverTab == 2 {
                        if viewModel.gettingEventsMonth == true {
                            ProgressView()
                        } else if viewModel.eventsMonth.count == 0 {
                            Text("No venues with events in the next 30 days.")
                                .foregroundColor(Color.secondary)
                        } else {
                            ForEach(viewModel.eventsMonth, id: \.self) { event in
                                if Set(self.chosenCategories).isSubset(of: Set(event.tags)) {
                                    Spacer()
                                    
                                    
                                    MyEventsEventView(event: event, clickable: true)
                                        .environmentObject(sessionService)
                                        .environmentObject(manager)
                                        .environmentObject(viewModel)
                                    
                                    Spacer()
                                    Divider()
                                }

                            }
                        }
                    }
                }
                
               
                
                
                
                
                
//                ScrollView {
//
//
//                    Picker(selection: $discoverTab, label: Text("Discover")) {
//                        Text("Today").tag(1)
//                        Text("This Week").tag(2)
//                        Text("Next 30 Days").tag(3)
//                    }
//                    .padding(.bottom, 10)
//                    .pickerStyle(SegmentedPickerStyle())
//
//                    if discoverTab == 1 {
//                        if viewModel.gettingEventsToday == true {
//                            ProgressView()
//                        } else if viewModel.eventsToday.count == 0 {
//                            Text("No venues with events today.")
//                                .foregroundColor(Color.secondary)
//                        } else {
//                            ForEach(viewModel.eventsToday, id: \.self) { event in
//                                Spacer()
//
//
//                                MyEventsEventView(event: event, clickable: true)
//                                    .environmentObject(sessionService)
//                                    .environmentObject(manager)
//                                    .environmentObject(viewModel)
//
//                                Spacer()
//                                Divider()
//
//                            }
//                        }
//                    } else if discoverTab == 2 {
//                        if viewModel.gettingEventsWeek == true {
//                            ProgressView()
//                        } else if viewModel.eventsWeek.count == 0 {
//                            Text("No venues with events this week.")
//                                .foregroundColor(Color.secondary)
//                        } else {
//                            ForEach(viewModel.eventsWeek, id: \.self) { event in
//                                Spacer()
//
//                                MyEventsEventView(event: event, clickable: true)
//                                    .environmentObject(sessionService)
//                                    .environmentObject(manager)
//                                    .environmentObject(viewModel)
//
//                                Spacer()
//                                Divider()
//
//                            }
//                        }
//                    } else if discoverTab == 3 {
//                        if viewModel.gettingEventsMonth == true {
//                            ProgressView()
//                        } else if viewModel.eventsMonth.count == 0 {
//                            Text("No venues with events in the next 30 days.")
//                                .foregroundColor(Color.secondary)
//                        } else {
//                            ForEach(viewModel.eventsMonth, id: \.self) { event in
//                                Spacer()
//
//                                MyEventsEventView(event: event, clickable: true)
//                                    .environmentObject(sessionService)
//                                    .environmentObject(manager)
//                                    .environmentObject(viewModel)
//
//                                Spacer()
//                                Divider()
//
//                            }
//                        }
//                    }
//                }
//                .padding(.horizontal)
//                .navigationBarHidden(true)
            }
            .padding(.horizontal)
            .navigationBarHidden(true)
            .background(Color("darkBackground"))
            
     
                
            
        }
        
        .onAppear {
            sessionService.getToken()
            sessionService.getUnreadCount(uid: sessionService.userDetails.uid, token: sessionService.token)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onChange(of: discoverTab, perform: { change in
            Task {
                if change == 1 {
                    await viewModel.getEventsToday(token: sessionService.token)
                } else if change == 2 {
                    await viewModel.getEventsWeek(token: sessionService.token)
                } else if change == 3 {
                    await viewModel.getEventsMonth(token: sessionService.token)
                }
               
            }
            
        })
        .task {
            await viewModel.getPageCategories()
            await viewModel.getEventsToday(token: sessionService.token)
            await viewModel.getEventsWeek(token: sessionService.token)
            await viewModel.getEventsMonth(token: sessionService.token)
            
     
        }
        .navigationBarHidden(true)
    }
}

struct topTab: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    var tabBarOptions: [String] = ["Today", "This Week", "30 Days"]
    
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

struct topTabItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                if currentTab == tab {
                    Text(tabBarItemName)
                        .foregroundColor(.purple)
                        .padding(7)
                        .background(.purple.opacity(0.3))
                        .cornerRadius(20)
                }
                else {
                    Text(tabBarItemName)
                        .padding(7)
                }
            }
        }
        .buttonStyle(.plain)

    }
}
