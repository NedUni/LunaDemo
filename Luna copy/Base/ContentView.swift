//
//  Home.swift
//  Luna
//
//  Created by Will Polich on 17/1/2022.
//

import Foundation
import SwiftUI
import FirebaseStorage
import MapKit
import SDWebImageSwiftUI
import SDWebImage
import Mixpanel

struct ContentView : View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var viewModel = ViewModel()
    @StateObject var firesaleManager = FiresaleManager()
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
//    @StateObject var service = VenueService()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var appState = AppState.shared
    @State var navigate : Bool = false
    @State var shouldNavigateToChat : Bool = false
    @State var shouldNavigateToEventChat : Bool = false
    @Binding var didReceiveDynamicLink : Bool
    @Binding var dynamicLinkedEvent : EventObj?
    
    
    var pushNavigationBinding : Binding<Bool> {
            .init { () -> Bool in
                appState.pageToNavigationTo != nil
            } set: { (newValue) in
                if !newValue { appState.pageToNavigationTo = nil }
            }
        }

    let tabBarImageName = ["house", "tray", "newspaper", "bubble.left", "map"]
    
    @State var selectedIndex : Int = 0
   @State var showCheckin = false

    @State var showFriendsToAdd : Bool = true
    @State var showFiresale : Bool = false


    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -33.865143, longitude: 151.209900), span: MKCoordinateSpan(latitudeDelta: 0.9, longitudeDelta: 0.9)) //span: MKCoordinateSpan(latitudeDelta: 0.9, longitudeDelta: 0.9
    
    private var viewDisplayed : some View {
        if self.selectedIndex == 0 {
            return AnyView(HomeView(showFriendsToAdd: $showFriendsToAdd)
                    .environmentObject(sessionService)
                    .environmentObject(manager)
                    .environmentObject(viewModel))
        } else if self.selectedIndex == 1 {
            return AnyView(MyEventsView(showFriendsToAdd: $showFriendsToAdd)
                   .environmentObject(sessionService)
                   .environmentObject(viewModel)
                   .environmentObject(manager))
        } else if self.selectedIndex == 2 {
            return AnyView(DiscoverEventsView(showFriendsToAdd: $showFriendsToAdd)
                   .environmentObject(sessionService)
                   .environmentObject(viewModel)
                   .environmentObject(manager))
        } else if self.selectedIndex == 3 {
            return AnyView(MessagesInboxView(showFriendsToAdd: $showFriendsToAdd, shouldNavigateToChat: $shouldNavigateToChat, shouldNavigateToEventChat: $shouldNavigateToEventChat)
                   .environmentObject(sessionService)
                   .environmentObject(viewModel)
                   .environmentObject(manager))
        } else {
            return AnyView(MapView()
                .environmentObject(sessionService)
                .environmentObject(viewModel)
                .environmentObject(manager))
        }
        
//        }
        
    }
    
    private var overlay : some View {
        if didReceiveDynamicLink == true && dynamicLinkedEvent != nil {
            return AnyView(EventViewNew(event: dynamicLinkedEvent!)
                            .environmentObject(sessionService)
                            .environmentObject(manager)
                            .environmentObject(viewModel))
        }
        
        return AnyView(EmptyView())
        
        
    }

    var body: some View {
        
        
       VStack (spacing: 0) {
//           if self.loadingHome == true
//                && ((viewModel.venues.count == 0 || viewModel.hotVenues.count == 0) && ((sessionService.userDetails.favourites.count != 0 && viewModel.myFavourites.count == 0) ))
//           {
//               ProgressView()
//                   .progressViewStyle(CircularProgressViewStyle(tint: Color.purple))
//
//
//           } else {
//           HStack {
//               Text("hey")
//           }
//           .background(Color("darkForeground"))
//           .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.black), alignment: .top)
           
               ZStack {
                   if dynamicLinkedEvent != nil {
                       NavigationLink("", isActive: $didReceiveDynamicLink) {
                           EventViewNew(event: dynamicLinkedEvent!)
                               .environmentObject(sessionService)
                               .environmentObject(manager)
                               .environmentObject(viewModel)
                       }
                    }
                   
//                   NavigationLink("", destination: self.overlay, isActive: self.didReceiveDynamicLink)
//                   if self.didReceiveDynamicLink == true {
//                       self.overlay
//                   } else {
                    self.viewDisplayed
//                   }

               }
               .background(Color("darkForeground"))
              
               
               
           
//           Spacer()
            
           
           
               HStack {
                   ForEach(0..<5) { num in
                       Button(action: {
                           presentationMode.wrappedValue.dismiss()
                           selectedIndex = num
                           if num == 1 {
                               print("My Events")
                               Mixpanel.mainInstance().track(event: "My Events")
                           } else if num == 2 {
                               print("Discover Events")
                               Mixpanel.mainInstance().track(event: "Discover Events")
                           } else if num == 3 {
                               print("Messages")
                               Mixpanel.mainInstance().track(event: "Messages")
                           } else if num == 4 {
                               print("Map")
                               Mixpanel.mainInstance().track(event: "Map")
                           }
                          

                       }, label: {
                           Spacer()
                           if num == 3 && sessionService.unread > 0{
                               ZStack (alignment: .topTrailing) {


                                   Image(systemName: selectedIndex == num ? tabBarImageName[num] + ".fill" : tabBarImageName[num])
                                       .font(.system(size: 24, weight: .bold))
                                       .foregroundColor(selectedIndex == num ? .purple : .primary)

                                   Image(systemName: "circle")
                                       .resizable()
                                       .frame(width: 13, height: 13)
                                       .scaledToFit()
                                       .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.primary, lineWidth: 2))
                                       .colorInvert()
                                       .background(Color.purple).cornerRadius(20)
                                       .offset(x: 3, y: 0)
                                       .padding(.bottom, 1)
                               }

                           } else {
                               Image(systemName: selectedIndex == num ? tabBarImageName[num] + ".fill" : tabBarImageName[num])
                                   .font(.system(size: 24, weight: .bold))
                                   .foregroundColor(selectedIndex == num ? .purple : .primary)
                           }

                           Spacer()
                       })

                   }
               }
               .padding(.top)
               .background(Color("darkBackground"))
               .overlay(Rectangle().frame(width: nil, height: 0.5, alignment: .top).foregroundColor(Color("darkSecondaryText")), alignment: .top)
//               .background(Color("darkForeground"))

//           }
            

       }
        .onChange(of: appState.pageToNavigationTo) { page in
            if page == "checkin" {
                if sessionService.activeCheckin == nil {
                    sessionService.getActiveCheckin(uid: sessionService.userDetails.uid, completion: {
                        showCheckin.toggle()
                    })
                } else {
                    showCheckin.toggle()
                }
                
            } else if page == "addfriendsview" {
                showFriendsToAdd.toggle()
            }
            else if page == "firesale" {
                if page == "firesale" {
                    if sessionService.activeCheckin != nil {
                        sessionService.getActiveCheckin(uid: sessionService.userDetails.uid, completion: {
                            firesaleManager.getID(venueID: sessionService.activeCheckin!.id, completion: {
                                if firesaleManager.firesaleID != "" {
                                    appState.pageToNavigationTo = ""
                                    showFiresale.toggle()
                                }
                            })
                        })
                    }
                }
            }
            
            
        }
        .onAppear {
            sessionService.getFriends(uid: sessionService.userDetails.uid, completion: {})
        }
       .sheet(isPresented: $showCheckin, content: {
           if sessionService.activeCheckin != nil {
               AutoLineLengthView(venue: sessionService.activeCheckin!, showTime: $showCheckin)
           }
       })
       .sheet(isPresented: $showFiresale, content: {
           if sessionService.activeCheckin != nil {
               FiresaleView(firesaleID: firesaleManager.firesaleID, showFiresale: $showFiresale)
                   .environmentObject(sessionService)
                   .environmentObject(firesaleManager)
//               Firesale(venue: sessionService.activeCheckin!, showTime: $showCheckin)
           }
       })
//       .overlay(NavigationLink(destination: EventViewNew(event: dynamicLinkedEvent)
//             .environmentObject(sessionService)
//             .environmentObject(manager)
//             .environmentObject(viewModel),
//                            isActive: didReceiveDynamicLink) {
//            EmptyView()
//       })
       .if(appState.pageToNavigationTo == "friendrequestsview") {
           $0.overlay(NavigationLink(destination: FriendRequestsView()
                .environmentObject(sessionService)
                .environmentObject(manager)
                .environmentObject(viewModel),
                               isActive: pushNavigationBinding) {
           EmptyView()
       })}
       .if(appState.pageToNavigationTo == "friendsview") {
           $0.overlay(NavigationLink(destination: FriendsView()
                .environmentObject(sessionService)
                .environmentObject(manager)
                .environmentObject(viewModel),
                               isActive: pushNavigationBinding) {
           EmptyView()
       })}
//       .if(appState.pageToNavigationTo == "firesale") {
//           $0.overlay(NavigationLink(destination: VenueView(ven: sessionService.activeCheckin!)
//                .environmentObject(sessionService)
//                .environmentObject(manager)
//                .environmentObject(viewModel),
//                               isActive: pushNavigationBinding) {
//           EmptyView()
//       })}
       

       
//       .if(appState.pageToNavigationTo == "friendmessageview") {
//           self.selectedIndex = 3
//           self.viewDisplayed = AnyView(MessagesInboxView(showFriendsToAdd: $showFriendsToAdd, shouldNavigateToChat: $shouldNavigateToChat)
//                  .environmentObject(sessionService)
//                  .environmentObject(viewModel)
//                  .environmentObject(manager))
//       }
       

//
       .ignoresSafeArea(.keyboard)
       .navigationBarHidden(true)
//       .onChange(of: self.viewDisplayed) {
//           sessionService.refreshUserDetails()
//           sessionService.getToken()
//       }
       .onChange(of: dynamicLinkedEvent) { x in
           sleep(2)
           print(self.didReceiveDynamicLink)
       }
       .onAppear {
           
          self.showFriendsToAdd = true
          sessionService.getToken()
          sessionService.refreshUserDetails()
          sessionService.getFCMToken()
           manager.requestPermissions()
           sessionService.updateFCM()
          
          
           let queue = DispatchQueue(label: "homePage", attributes: .concurrent)
           sessionService.tokenRturn { token in
               queue.async {viewModel.getNearYou(uid: sessionService.userDetails.uid)}
               queue.async {viewModel.fetchTopToday()}
               queue.async {viewModel.fetchHotVenues(token: token) }
               queue.async {viewModel.fetchFriendsEvents(uid: sessionService.userDetails.uid, token: token)}
               queue.async {viewModel.getFavourites(UID: sessionService.userDetails.uid, token: token)}
               queue.async {viewModel.fetch(token: token, completion: {})}
               queue.async {viewModel.getForYou(uid: sessionService.userDetails.uid, token: token)}
               queue.async {viewModel.getSundaySesh()}
               queue.async {viewModel.getTodaysDeals(uid: sessionService.userDetails.uid, token: token)}
               queue.async {viewModel.getRecentlyPopularVenues()}
               queue.async {viewModel.getPopularLastNight()}
               queue.async {viewModel.getPopularLastWeek()}
               queue.async {viewModel.getPopularStoryVenues()}
               queue.async {viewModel.getGirlsNight(uid: sessionService.userDetails.uid)}
               queue.async {viewModel.getSomethingDifferent(uid: sessionService.userDetails.uid)}
               queue.async {viewModel.getPubFeed(uid: sessionService.userDetails.uid)}
               queue.async {viewModel.fetchTopUpcomingEvents()}
               queue.async {viewModel.getFriendsFavourites(uid: sessionService.userDetails.uid)}
               queue.async {viewModel.getFriendsPages(uid: sessionService.userDetails.uid)}
           }

           



           sessionService.getActiveCheckin(uid: sessionService.userDetails.uid, completion: {})
           sessionService.updateStreak(id: sessionService.userDetails.uid)

           if appState.pageToNavigationTo == "myeventsview" {
               selectedIndex = 1
           }
           
           sessionService.refreshUserDetails()

          
      }
//      .onChange(of: sessionService.token) { token in
//          sessionService.refreshUserDetails()
//          sessionService.getActiveCheckin(token: sessionService.token, uid: sessionService.userDetails.uid, completion: {})
//          sessionService.updateStreak(id: sessionService.userDetails.uid)
//
//
//          let queue = DispatchQueue(label: "homePage", attributes: .concurrent)
//
//          queue.async {viewModel.fetchTopToday()}
//          queue.async {viewModel.fetchHotVenues(token: sessionService.token) }
//          queue.async {viewModel.fetchFriendsEvents(uid: sessionService.userDetails.uid, token: sessionService.token)}
//          queue.async {viewModel.getFavourites(UID: sessionService.userDetails.uid, token: sessionService.token)}
//          queue.async { viewModel.fetch(token: sessionService.token)}
//          queue.async {viewModel.getForYou(uid: sessionService.userDetails.uid, token: sessionService.token)}
//          queue.async {viewModel.getSundaySesh()}
//          queue.async {viewModel.getTodaysDeals(uid: sessionService.userDetails.uid, token: sessionService.token)}
//          queue.async {viewModel.getRecentlyPopularVenues()}
//          queue.async {viewModel.getPopularLastNight()}
//          queue.async {viewModel.getPopularLastWeek()}
//          queue.async {viewModel.getPopularStoryVenues()}
//          queue.async {viewModel.getGirlsNight(uid: sessionService.userDetails.uid)}
//          queue.async {viewModel.getSomethingDifferent(uid: sessionService.userDetails.uid)}
//          queue.async {viewModel.getPubFeed(uid: sessionService.userDetails.uid)}
//          queue.async {viewModel.fetchTopUpcomingEvents()}
//          queue.async {viewModel.getFriendsFavourites(uid: sessionService.userDetails.uid)}
//          queue.async {viewModel.getFriendsPages(uid: sessionService.userDetails.uid)}
//
//
//      }

        
    }

    
}
