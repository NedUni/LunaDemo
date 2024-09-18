//
//  SearchView.swift
//  Luna
//
//  Created by Will Polich on 28/1/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    @State var term: String = ""
    @State var selectedTab = 0
    @State var option: Int = 1
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack (alignment: .leading) {
            HStack (alignment: .center) {
                TextField("Search Luna", text: $term)
                    .padding(8)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                    .onChange(of: term) { newTerm in
                        if selectedTab == 0 {
                            option = 2
                        }
                        else if selectedTab == 1 {
                            option = 4
                        }
                        else if selectedTab == 2 {
                            option = 1
                        }
                        else {
                            option = 3
                        }
                        
                        sessionService.searchVenues(term: term, option: option)
                    }
                    .ignoresSafeArea(.keyboard)
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("cancel")
                })
                    .buttonStyle(.plain)
            }
            
            searchTopTab(currentTab: $selectedTab)
            
            ScrollView (showsIndicators: false) {
                if selectedTab == 0 {
                    ForEach(sessionService.searchPeopleResults, id: \.self) { person in
                        if person.uid != sessionService.userDetails.uid {
                            UserSearchTileView(user: person)
                                .environmentObject(sessionService)
                                .environmentObject(manager)
                                .environmentObject(homeVM)
                            Divider()
                        }
                    }
                }
                
                
                if selectedTab == 1 {
                    ForEach(sessionService.searchEventResults, id: \.self) { event in
                        MyEventsEventView(event: event, clickable: true)
                                .environmentObject(sessionService)
                                .environmentObject(manager)
                                .environmentObject(homeVM)
                            Divider()
                    }
                }
                
                if selectedTab == 2 {
                    ForEach(sessionService.searchVenueResults, id: \.self) { venue in
                        VenueSearchTileView(ven: venue)
                            .environmentObject(sessionService)
                            .environmentObject(manager)
                            .environmentObject(homeVM)
                        Divider()
                    }
                }
                
                if selectedTab == 3 {
                    ForEach(sessionService.searchPageResults, id: \.self) { page in
                        PageSearchTile(page: page)
                    }
                }
            }
//            .padding()
        }
        .padding(.horizontal)
        .background(Color("darkBackground"))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.term = ""
            sessionService.searchVenues(term: "", option: 1)
            sessionService.searchVenues(term: "", option: 2)

        }
        .onChange(of: selectedTab) { tab in
            if selectedTab == 0 {
                option = 2
            }
            else if selectedTab == 1 {
                option = 4
            }
            else if selectedTab == 2 {
                option = 1
            }
            else {
                option = 3
            }
            
            sessionService.searchVenues(term: term, option: option)
        }
    }
}

//struct SearchView_Previews: PreviewProvider {
//    @StateObject static var sessionService = SessionServiceImpl()
//    static var previews: some View {
//        SearchView()
//            .environmentObject(sessionService)
//    }
//}

struct searchTopTab: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    var tabBarOptions: [String] = ["People", "Events", "Venues", "Pages"]
    
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
