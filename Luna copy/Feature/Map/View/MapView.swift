//
//  MapView.swift
//  Luna
//
//  Created by Will Polich on 28/1/2022.
//

import SwiftUI
import MapKit
import SDWebImageSwiftUI

struct MapView: View {
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -33.865143, longitude: 151.209900), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var viewModel : ViewModel
    @EnvironmentObject var manager : LocationManager
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var pokies : Bool = false
    @State var liveMusic : Bool = false
    @State var danceFloor : Bool = false
    @State var deals : Bool = false
    @State var hotNow : Bool = false
    @State var friends : Bool = false
    @State var venuesToBeDisplayed: [VenueObj] = []
    @State var showOptions : Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {

               Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: venuesToBeDisplayed) { venue in

                   MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(venue.latitude) , longitude: Double(venue.longitude))) {
//                       NavigationLink(destination: VenueView(ven: venue)
//                                        .environmentObject(sessionService)
//                                        .environmentObject(manager)
//                                        .environmentObject(viewModel)) {
                       VStack {

                           VStack {
                               if (region.span.longitudeDelta < 0.05) {
                                   VStack (spacing: 4){
                                       Text(venue.displayname)
                                           .foregroundColor(.primary)
                                   }
                                   .font(.system(size: 9))

                                   .padding(5)
                                   .background(colorScheme == .dark ? Color.black : Color.white)
                                   .cornerRadius(10)

                               }

                               if (viewModel.hotVenues.contains(venue) == false) {
                                   VStack {
                                       Image(systemName: "mappin")
                                           .resizable()
                                           .scaledToFill()
                                           .font(.title)
                                           .foregroundColor(.purple.opacity(0.8))
                                           .cornerRadius(40)

        //                                                       Image(systemName: "arrowtriangle.down.fill")
        //                                                           .font(.caption)
        //                                                           .foregroundColor(.gray.opacity(0.6))
        //                                                           .offset(x: 0, y: -5)
                                   }
                                   .frame(width: 5, height: 5, alignment: .center)
                                   
//                                   .frame(width: 5/region.span.latitudeDelta, height: 5/region.span.latitudeDelta)
        //                                                   .background(.black)


                               }

                               else {
                                   VStack {
                                       Image(systemName: "flame")
    //                                       .resizable()
    //                                       .scaledToFill()
                                          .font(.title)
                                          .foregroundColor(.red.opacity(0.8))
                                      Image(systemName: "arrowtriangle.down.fill")
    //                                       .resizable()
    //                                       .scaledToFill()
                                          .font(.caption)
                                          .foregroundColor(.red.opacity(0.8))
                                          .offset(x: 0, y: -5)
                                   }
                                   .frame(width: 5, height: 5)

                               }


                           }
                       }
                       .buttonStyle(.plain)
                   }

               }


                HStack (spacing: 0){

                   Spacer()
                   
                   if showOptions {
                       VStack(spacing: 20.0) {
                           Button(action: {
                               pokies.toggle()
                               if venuesToBeDisplayed.count >= 1 {
                                   venuesToBeDisplayed = []
                               }

                               for ve in viewModel.venues {
                                   if (liveMusic && ve.hasLiveMusic == false || pokies && ve.hasPokerMachines == false || danceFloor && ve.hasDanceFloor == false || deals && ve.deals.count < 1 || hotNow && viewModel.hotVenues.contains(ve) == false || friends && viewModel.getFriendsCheckedIn(friends: sessionService.userDetails.friends, checkins: ve.checkins) == false) {
                                       continue
                                   }

                                   else {
                                       if (venuesToBeDisplayed.contains(ve) == false) {
                                           venuesToBeDisplayed.append(ve)
                                       }

                                   }
                               }
                           },
                                  label: {
                               VStack {
                                   Image(systemName: self.pokies == false ? "dice" : "dice.fill")
                                   Text("VIP")
                                       .font(.system(size: 10))
                               }
                               .foregroundColor(self.pokies == false ? .primary : .purple)

                           })

                           Button(action: {
                               liveMusic.toggle()
                               if venuesToBeDisplayed.count >= 1 {
                                   venuesToBeDisplayed = []
                               }

                               for ve in viewModel.venues {
                                   if (liveMusic && ve.hasLiveMusic == false || pokies && ve.hasPokerMachines == false || danceFloor && ve.hasDanceFloor == false || deals && ve.deals.count < 1 || hotNow && viewModel.hotVenues.contains(ve) == false || friends && viewModel.getFriendsCheckedIn(friends: sessionService.userDetails.friends, checkins: ve.checkins) == false) {
                                       continue
                                   }

                                   else {
                                       if (venuesToBeDisplayed.contains(ve) == false) {
                                           venuesToBeDisplayed.append(ve)
                                       }

                                   }
                               }
                           },
                                  label: {
                               VStack {
                                   Image(systemName: self.liveMusic == false ? "music.mic.circle" : "music.mic.circle.fill")
                                   Text("live music")
                                       .font(.system(size: 10))
                               }
                               .foregroundColor(self.liveMusic == false ? .primary : .purple)

                           })

                           Button(action: {
                               danceFloor.toggle()
                               if venuesToBeDisplayed.count >= 1 {
                                   venuesToBeDisplayed = []
                               }

                               for ve in viewModel.venues {
                                   if (liveMusic && ve.hasLiveMusic == false || pokies && ve.hasPokerMachines == false || danceFloor && ve.hasDanceFloor == false || deals && ve.deals.count < 1 || hotNow && viewModel.hotVenues.contains(ve) == false || friends && viewModel.getFriendsCheckedIn(friends: sessionService.userDetails.friends, checkins: ve.checkins) == false) {
                                       continue
                                   }

                                   else {
                                       if (venuesToBeDisplayed.contains(ve) == false) {
                                           venuesToBeDisplayed.append(ve)
                                       }

                                   }
                               }
                           },
                                  label: {
                               VStack {
                                   Image(systemName: self.danceFloor == false ? "music.note.house" : "music.note.house.fill")
                                   Text("dance floor")
                                       .font(.system(size: 10))
                               }
                               .foregroundColor(self.danceFloor == false ? .primary : .purple)

                           })

                           Button(action: {
                               deals.toggle()
                               if venuesToBeDisplayed.count >= 1 {
                                   venuesToBeDisplayed = []
                               }

                               for ve in viewModel.venues {
                                   if (liveMusic && ve.hasLiveMusic == false || pokies && ve.hasPokerMachines == false || danceFloor && ve.hasDanceFloor == false || deals && ve.deals.count < 1 || hotNow && viewModel.hotVenues.contains(ve) == false || friends && viewModel.getFriendsCheckedIn(friends: sessionService.userDetails.friends, checkins: ve.checkins) == false) {
                                       continue
                                   }

                                   else {
                                       if (venuesToBeDisplayed.contains(ve) == false) {
                                           venuesToBeDisplayed.append(ve)
                                       }

                                   }
                               }
                           },
                                  label: {
                               VStack {
                                   Image(systemName: self.deals == false ? "dollarsign.circle" : "dollarsign.circle.fill")
                                   Text("deals")
                                       .font(.system(size: 10))
                               }
                               .foregroundColor(self.deals == false ? .primary : .purple)

                           })

                           Button(action: {
                               hotNow.toggle()
                               if venuesToBeDisplayed.count >= 1 {
                                   venuesToBeDisplayed = []
                               }

                               for ve in viewModel.venues {
                                   if (liveMusic && ve.hasLiveMusic == false || pokies && ve.hasPokerMachines == false || danceFloor && ve.hasDanceFloor == false || deals && ve.deals.count < 1 || hotNow && viewModel.hotVenues.contains(ve) == false || friends && viewModel.getFriendsCheckedIn(friends: sessionService.userDetails.friends, checkins: ve.checkins) == false) {
                                       continue
                                   }

                                   else {
                                       if (venuesToBeDisplayed.contains(ve) == false) {
                                           venuesToBeDisplayed.append(ve)
                                       }

                                   }
                               }
                           },
                                  label: {
                               VStack {
                                   Image(systemName: self.hotNow == false ? "flame" : "flame.fill")
                                   Text("pumping")
                                       .font(.system(size: 10))
                               }
                               .foregroundColor(self.hotNow == false ? .primary : .purple)

                           })

                           Button(action: {
                               friends.toggle()
                               if venuesToBeDisplayed.count >= 1 {
                                   venuesToBeDisplayed = []
                               }

                               for ve in viewModel.venues {
                                   if (liveMusic && ve.hasLiveMusic == false || pokies && ve.hasPokerMachines == false || danceFloor && ve.hasDanceFloor == false || deals && ve.deals.count < 1 || hotNow && viewModel.hotVenues.contains(ve) == false || friends && viewModel.getFriendsCheckedIn(friends: sessionService.userDetails.friends, checkins: ve.checkins) == false) {
                                       continue


                                   }

                                   else {
                                       if (venuesToBeDisplayed.contains(ve) == false) {
                                           venuesToBeDisplayed.append(ve)
                                       }

                                   }
                               }
                           },
                                  label: {
                               VStack {
                                   Image(systemName: self.friends == false ? "person.2" : "person.2.fill")
                                   Text("friends")
                                       .font(.system(size: 10))
                               }
                               .foregroundColor(self.friends == false ? .primary : .purple)

                           })
                           
                           Button {
                               withAnimation {
                                   showOptions = false
                               }
                           } label: {
                               VStack {
                                   Image(systemName: "chevron.right")
                                   Text("hide")
                                       .font(.system(size: 10))
                               }
                           }
                           
                       }
                       .padding(.horizontal, 8)
                       .padding(.vertical, 15)
                       .background(colorScheme == .dark ? Color.black.opacity(0.8) : Color.white.opacity(0.8))
                       .cornerRadius(35)
                       .buttonStyle(.plain)
                       .transition(.move(edge: .trailing))
                   }
                   
                   else {
                       Button {
                           withAnimation {
                               showOptions = true
                               print("lol")
                           }
                       } label: {
                           Image(systemName: "chevron.left")
                               .foregroundColor(.white)
                               .padding()
                       }

                       
                   }

               }.padding()
           }
           .onAppear {
               
               
               if self.region.span.latitudeDelta == 0.1 {
                   self.region.center = manager.region.center
               }
               
               sessionService.getToken()
//               print("latitude is \(manager.region.center.latitude)")
//               print("longitude is \(manager.region.center.longitude)")
               
               let queue = DispatchQueue(label: "homePage", attributes: .concurrent)
               
               queue.async {viewModel.fetch(token: sessionService.token, completion: {})}
               queue.async {viewModel.fetchHotVenues(token: sessionService.token) }
               queue.async {viewModel.getFavourites(UID: sessionService.userDetails.uid, token: sessionService.token)}
               queue.async {viewModel.getForYou(uid: sessionService.userDetails.uid, token: sessionService.token)}
               queue.async {viewModel.getSundaySesh()}

               sessionService.getUnreadCount(uid: sessionService.userDetails.uid, token: sessionService.token)

               MKMapView.appearance().pointOfInterestFilter = .excludingAll
               venuesToBeDisplayed = viewModel.venues
               pokies = false
               danceFloor = false
               liveMusic = false
               deals = false
               hotNow = false
               friends = false
           }
           .ignoresSafeArea()
           .navigationBarHidden(true)
           
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
