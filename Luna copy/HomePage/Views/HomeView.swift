//
//  HomeView.swift
//  Luna
//
//  Created by Will Polich on 6/4/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import PopupView
import MapKit
import Mixpanel

struct HomeView: View {
   
    @EnvironmentObject var viewModel : ViewModel
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @StateObject var handler = EventViewHandler()
    @StateObject var service = DealTileService()
    @StateObject var storiesManager = storiesHandler()
//    @StateObject var firesaleManager = FiresaleManager()
    
    @ObservedObject var appState = AppState.shared
    
    @Binding var showFriendsToAdd : Bool
    @State var selectedDeal : DealObj?
    @State var selectedVenue : VenueObj?
    @State var dealIsPresented : Bool = false
    
    @State var friendsToAdd : Bool = false
    
    @State var storyView : Bool = false
    
    @State var venueNumber : Int = 0
    
    @State var selectedVenueString : String = ""
    
    @State var closeVenue : VenueObj?
    
    @State var showFiresale = false
    
//    var pushNavigationBinding : Binding<Bool> {
//            .init { () -> Bool in
//                appState.pageToNavigationTo != nil
//            } set: { (newValue) in
//                if !newValue { appState.pageToNavigationTo = nil }
//            }
//        }
    
    
    var body: some View {
        NavigationView {
            
            VStack (alignment: .leading) {
                HeaderView(pageName: "Home", showFriendsToAdd: $showFriendsToAdd)
                    .environmentObject(sessionService)
                    .environmentObject(manager)
                    .environmentObject(viewModel)
                
                
                if viewModel.drinkControl {
                    if sessionService.userDetails.friends.count < 15 && sessionService.userDetails.firstName != "" {

                        VStack (alignment: .leading) {
                            Text("Luna is way better with friends")
                            Text("Make 15 friends")
                                .font(.system(size: 10))
                                .foregroundColor(Color("darkSecondaryText"))

                            HStack (spacing: 2){

                                ForEach(1..<16, id: \.self) { number in
                                    Capsule()
                                        .frame(height: 2)
                                        .foregroundColor(number <= sessionService.userDetails.friends.count ? .purple : .purple.opacity(0.3))
                                }
                            }

                            Divider()
                        }
                        .onTapGesture {
                            friendsToAdd = true
                        }
                    }
                    
                    if sessionService.userDetails.friends.count >= 15 && sessionService.drinkEligibility {
                        NavigationLink(destination: ProfileView()
                            .environmentObject(sessionService)
                            .environmentObject(manager)
                            .environmentObject(viewModel)) {

                                    HStack {
                                    VStack (alignment: .leading) {
                                        Text("Congrats!")
                                        Text("Claim your free drink in your profile")
                                            .font(.system(size: 10))
                                            .foregroundColor(Color("darkSecondaryText"))
        //                                Text("You kno")
        //
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                }
                        }
                    }
                }
                
//                ZStack {
//                    ForEach (viewModel.popularStoryVenues, id: \.self) { venue in
//                        storiesManager.getStories(venueID: venue) { xd in
//                            ForEach(storiesManager.stories, id: \.self) { story in
//                                StoryImage(
//                                    url: URL(string: story.url)!,
//                                    placeholder: { Text("Loading ...") },
//                                    image: { Image(uiImage: $0).resizable() }
//                                )
//                            }
//                        }
//                    }
//                }
                



                //FROM HERE
                ScrollView (.vertical, showsIndicators: false) {
                    LazyVStack (alignment: .leading) {

//                        ScrollView(.horizontal, showsIndicators: false) {
//                            LazyHStack {
//                                ForEach(viewModel.hotVenues, id: \.self) { venue in
//                                    HStack {
//
//                                    }
//                                    .frame(width: UIScreen.main.bounds.size.width*0.15, height: UIScreen.main.bounds.size.width*0.15)
//                                    .background(.red)
//                                    .cornerRadius(100)
//                                }
//                            }
//                        }

//                        ZStack {

//                        }
//                        .frame(width: 1, height: 1, alignment: .center)
//                        .opacity(0.0001)
                        
//                        Button {
//                            print("hello")
//                        } label: {
//                            Text("refresh")
//                        }


                        if sessionService.activeCheckin != nil {
                           NavigationLink(destination: VenueView(ven: sessionService.activeCheckin!)
                                            .environmentObject(sessionService)
                                            .environmentObject(manager)
                                            .environmentObject(viewModel), label: {
                               HStack {
                                   VStack (alignment: .leading){
                                       Text("Checked into:")
                                       Text(sessionService.activeCheckin!.displayname)
                                   }

                                   Spacer()

                                   WebImage(url: URL(string: sessionService.activeCheckin!.imageurl))
                                       .resizable()
                                       .frame(width: 80, height: 50)
                                       .scaledToFill()

                               }
                               .foregroundColor(Color.primary)
                               .padding()
                               .background(.gray.opacity(0.2))
                               .cornerRadius(20)
                           })
                       }

                        else if closeVenue != nil {
                            NavigationLink(destination: VenueView(ven: closeVenue!)
                                             .environmentObject(sessionService)
                                             .environmentObject(manager)
                                             .environmentObject(viewModel), label: {
                                HStack {
                                    VStack (alignment: .leading){
                                        Text("Inside \(closeVenue!.displayname)?")
                                        Text("Check in?")
//                                        Text(sessionService.activeCheckin!.displayname)
                                    }

                                    Spacer()

                                    WebImage(url: URL(string: closeVenue!.imageurl))
                                        .resizable()
                                        .frame(width: 80, height: 50)
                                        .scaledToFill()

                                }
                                .foregroundColor(Color.primary)
                                .padding()
                                .background(.gray.opacity(0.2))
                                .cornerRadius(20)
                            })
                        }




                        Group {
                            //HOT RIGHT NOW
                            if viewModel.hotVenues.count > 1 {
                                Group {

                                    HStack {
                                        Text("Hot Right Now")
                                            .fontWeight(.heavy)

                                        Image(systemName: "flame")
                                           .foregroundColor(.red)
                                    }

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack {
                                            ForEach(viewModel.hotVenues, id: \.self) { venue in
                                               VenueTileView(ven: venue)
                                                    .environmentObject(sessionService)
                                                    .environmentObject(manager)
                                                    .environmentObject(viewModel)
                                            }
                                        }
                                    }
                                }
                            }

                            //Going to be big
                            Group {
                                if viewModel.topToday.count > 1 {
                                    Text("Shaping up to be a big one")
                                        .fontWeight(.heavy)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack {
                                            ForEach(viewModel.topToday, id: \.self) { venue in
                                               VenueTileView(ven: venue)
                                                    .environmentObject(sessionService)
                                                    .environmentObject(manager)
                                                    .environmentObject(viewModel)
                                            }
                                        }
                                    }
                                } else if viewModel.nearYou.count > 1 {
                                    Text("Near You")
                                        .fontWeight(.heavy)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack {
                                            ForEach(viewModel.nearYou, id: \.self) { venue in
                                               VenueTileView(ven: venue)
                                                    .environmentObject(sessionService)
                                                    .environmentObject(manager)
                                                    .environmentObject(viewModel)
                                            }
                                        }
                                    }
                                }
                            }
                        }



//                        Text("Out on the town?")
//                            .fontWeight(.heavy)
//                            .font(.system(size: 25))
//                            .padding(.top, 3)


                        Group {
                            //TODAYS TOP DEALS
                            if viewModel.todaysDeals.count > 1 {
                                Group {
                                    Text("Todays Top Deals")
                                        .fontWeight(.heavy)

                                    ScrollView (.horizontal, showsIndicators: false) {
                                        LazyHStack {
                                            ForEach(viewModel.todaysDeals, id: \.self) { thisDeal in
                                                DealTileView(deal: thisDeal)
                                                    .environmentObject(viewModel)
                                                    .onTapGesture {
                                                        self.selectedDeal = thisDeal
                                                        Mixpanel.mainInstance().track(event: "Deal View", properties: [
                                                            "venueID" : thisDeal.venue,
                                                            "dealID" : thisDeal.id])
                                                        withAnimation {
                                                            self.dealIsPresented.toggle()
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                }
                            }

                            //POPULAR STORIES
                            if viewModel.popularStoryVenues.count > 1 {
                                Group {
                                    Text("Popular Stories")
                                        .fontWeight(.heavy)
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack {
                                            ForEach(viewModel.popularStoryVenues, id: \.self) { venue in
                                                HomePageStoryTile(venue: venue, storyView: $storyView, VenueNumber: venueNumber, selectedVenueString: $selectedVenueString)
                                                    .environmentObject(storiesManager)
                                            }

                                        }

                                    }

                                }
                            }


                            //EVENTS POPULAR WITH YOUR FRIENDS
                            if viewModel.friendsEvents.count > 1 {
                                Group {
                                    Text("Events popular with your friends")
                                        .fontWeight(.heavy)

                                    ScrollView (.horizontal, showsIndicators: false) {
                                        LazyHStack {
                                            ForEach(viewModel.friendsEvents, id: \.self) { event in
                                                HomeEventTile(event: event, clickable: true)
                                                    .environmentObject(sessionService)
                                                    .environmentObject(manager)
                                                    .environmentObject(viewModel)
                                            }
                                        }
                                    }
                                }
                            }


                            Group {
                            //FOR YOU

                                Group {
                                    if viewModel.myFavourites.count > 1 {
                                        Text("Favourites")
                                            .fontWeight(.heavy)

                                        ScrollView (.horizontal, showsIndicators: false) {
                                            LazyHStack {
                                                ForEach(viewModel.myFavourites, id: \.self) { venue in
                                                    VenueTileView(ven: venue)
                                                        .environmentObject(sessionService)
                                                        .environmentObject(manager)
                                                        .environmentObject(viewModel)
                                                }
                                            }
                                        }
                                    }
                                }



                                if viewModel.friendsPages.count > 0 {
                                    Group {
                                        Text("Pages Your Friends Like")
                                            .fontWeight(.heavy)

                                        ScrollView (.horizontal, showsIndicators: false) {
                                            LazyHStack {
                                                ForEach(viewModel.friendsPages, id: \.self) { page in
                                                    PageTileView(page: page)
                                                        .environmentObject(sessionService)
                                                        .environmentObject(manager)
                                                        .environmentObject(viewModel)
                                                }
                                            }
                                        }
                                    }
                                }

                                //FOR YOU

                                if viewModel.recentlyPopularVenues.count > 1 {
                                    Group {
                                        Text("Popular recently")
                                            .fontWeight(.heavy)

                                        ScrollView (.horizontal, showsIndicators: false) {
                                            LazyHStack {
                                                ForEach(viewModel.recentlyPopularVenues, id: \.self) { venue in
                                                    VenueTileView(ven: venue)
                                                        .environmentObject(sessionService)
                                                        .environmentObject(manager)
                                                        .environmentObject(viewModel)
                                                }
                                            }
                                        }
                                    }
                                }


                                //FOR YOU
                                if viewModel.topUpcomingEvents.count > 1 {
                                    Group {
                                        Text("Biggest upcoming events")
                                            .fontWeight(.heavy)

                                        ScrollView (.horizontal, showsIndicators: false) {
                                            LazyHStack {
                                                ForEach(viewModel.topUpcomingEvents, id: \.self) { event in
                                                    HomeEventTile(event: event, clickable: true)
                                                        .environmentObject(sessionService)
                                                        .environmentObject(manager)
                                                        .environmentObject(viewModel)
                                                }
                                            }
                                        }
                                    }
                                }

                                Group {
                                    if viewModel.forYou.count > 1 {
                                        Text("For You")
                                            .fontWeight(.heavy)

                                        ScrollView (.horizontal, showsIndicators: false) {
                                            LazyHStack {
                                                ForEach(viewModel.forYou, id: \.self) { venue in
                                                    VenueTileView(ven: venue)
                                                        .environmentObject(sessionService)
                                                        .environmentObject(manager)
                                                        .environmentObject(viewModel)
                                                }
                                            }
                                        }
                                    }
                                }

                                //FOR YOU


                                if viewModel.popularLastWeek.count > 1 {
                                    Group {
                                        Text("Popular This Time Last Week")
                                            .fontWeight(.heavy)

                                        ScrollView (.horizontal, showsIndicators: false) {
                                            LazyHStack {
                                                ForEach(viewModel.popularLastWeek, id: \.self) { venue in
                                                    VenueTileView(ven: venue)
                                                        .environmentObject(sessionService)
                                                        .environmentObject(manager)
                                                        .environmentObject(viewModel)
                                                }
                                            }
                                        }
                                    }
                                }

                                //SOMETHING DIFFERENT


                                //PEED
                                if viewModel.pubFeed.count > 1 {
                                    Group {
                                        Text("Get Your Feed on")
                                            .fontWeight(.heavy)

                                        ScrollView (.horizontal, showsIndicators: false) {
                                            LazyHStack {
                                                ForEach(viewModel.pubFeed, id: \.self) { venue in
                                                    VenueTileView(ven: venue)
                                                        .environmentObject(sessionService)
                                                        .environmentObject(manager)
                                                        .environmentObject(viewModel)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            //Sunday Sesh
                            Group {
                                if viewModel.sundaySesh.count > 0 {
                                    Text("Did Someone Say Sunday Sesh?")
                                        .fontWeight(.heavy)
    
                                    ScrollView (.horizontal, showsIndicators: false) {
                                        LazyHStack {
                                            ForEach(viewModel.sundaySesh, id: \.self) { venue in
                                                VenueTileView(ven: venue)
                                                    .environmentObject(sessionService)
                                                    .environmentObject(manager)
                                                    .environmentObject(viewModel)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            Group {
                                if viewModel.nearYou.count > 1 && viewModel.topToday.count > 1{
                                    Text("Near You")
                                        .fontWeight(.heavy)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack {
                                            ForEach(viewModel.nearYou, id: \.self) { venue in
                                               VenueTileView(ven: venue)
                                                    .environmentObject(sessionService)
                                                    .environmentObject(manager)
                                                    .environmentObject(viewModel)
                                            }
                                        }
                                    }
                                }
                            }

                            Group {
                                if viewModel.somethingDifferent.count > 1 {
                                    Text("Try something different?")
                                        .fontWeight(.heavy)

                                    ScrollView (.horizontal, showsIndicators: false) {
                                        LazyHStack {
                                            ForEach(viewModel.somethingDifferent, id: \.self) { venue in
                                                VenueTileView(ven: venue)
                                                    .environmentObject(sessionService)
                                                    .environmentObject(manager)
                                                    .environmentObject(viewModel)
                                            }
                                        }
                                    }
                                }
                            }


                            //FOR YOU
                            if viewModel.popularLastNight.count > 1 {
                                Group {
                                    Text("Popular Last Night")
                                        .fontWeight(.heavy)

                                    ScrollView (.horizontal, showsIndicators: false) {
                                        LazyHStack {
                                            ForEach(viewModel.popularLastNight, id: \.self) { venue in
                                                VenueTileView(ven: venue)
                                                    .environmentObject(sessionService)
                                                    .environmentObject(manager)
                                                    .environmentObject(viewModel)
                                            }
                                        }
                                    }
                                }
                            }

                        }

                        if viewModel.friendsFavourites.count > 1 {
                            Group {
                                Text("Your Friends Favourites")
                                    .fontWeight(.heavy)

                                ScrollView (.horizontal, showsIndicators: false) {
                                    LazyHStack {
                                        ForEach(viewModel.friendsFavourites, id: \.self) { venue in
                                            VenueTileView(ven: venue)
                                                .environmentObject(sessionService)
                                                .environmentObject(manager)
                                                .environmentObject(viewModel)
                                        }
                                    }
                                }
                            }
                        }

                        //GIRLS NIGHT OUT
                        Group {
                            if viewModel.girlsNight.count > 1 {
                                Text("Girls night out?")
                                    .fontWeight(.heavy)

                                ScrollView (.horizontal, showsIndicators: false) {
                                    LazyHStack {
                                        ForEach(viewModel.girlsNight, id: \.self) { venue in
                                            VenueTileView(ven: venue)
                                                .environmentObject(sessionService)
                                                .environmentObject(manager)
                                                .environmentObject(viewModel)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .padding(.horizontal)
            .background(Color("darkBackground"))
            .foregroundColor(.primary)
            .onAppear {
                Mixpanel.mainInstance().time(event: "Home Page")
                
                viewModel.checkDrinkControl()
                
                print("page is \(appState.pageToNavigationTo)")
//                manager.requestPermissions()
                
                sessionService.hasClaimedDrink(uid: sessionService.userDetails.uid)
                sessionService.refreshUserDetails()
                sessionService.getToken()
                
                let queue = DispatchQueue(label: "homePage", attributes: .concurrent)
                    
                queue.async {viewModel.getNearYou(uid: sessionService.userDetails.uid)}
                queue.async {viewModel.fetchTopToday()}
                queue.async {viewModel.fetchHotVenues(token: sessionService.token) }
                queue.async {viewModel.fetchFriendsEvents(uid: sessionService.userDetails.uid, token: sessionService.token)}
                queue.async {viewModel.getFavourites(UID: sessionService.userDetails.uid, token: sessionService.token)}
                queue.async {viewModel.getForYou(uid: sessionService.userDetails.uid, token: sessionService.token)}
                queue.async {viewModel.getSundaySesh()}
                queue.async {viewModel.getTodaysDeals(uid: sessionService.userDetails.uid, token: sessionService.token)}
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
                queue.async {sessionService.getActiveCheckin(uid: sessionService.userDetails.uid, completion: {})}
                queue.async {
                    for venue in viewModel.popularStoryVenues {
                        Task {
                            await storiesManager.getStories(venueID: venue, completion: {_ in })
                        }
                    }
                }
                queue.async { viewModel.fetch(token: sessionService.token, completion: {
                    var distance = CLLocation(latitude: manager.region.center.latitude, longitude: manager.region.center.longitude).distance(from: CLLocation(latitude: viewModel.venues[0].latitude, longitude: viewModel.venues[0].longitude))
                    for ven in viewModel.venues {
                        if CLLocation(latitude: manager.region.center.latitude, longitude: manager.region.center.longitude).distance(from: CLLocation(latitude: ven.latitude, longitude: ven.longitude)) <= 100 {
                            if CLLocation(latitude: manager.region.center.latitude, longitude: manager.region.center.longitude).distance(from: CLLocation(latitude: ven.latitude, longitude: ven.longitude)) < distance {
                                distance = CLLocation(latitude: manager.region.center.latitude, longitude: manager.region.center.longitude).distance(from: CLLocation(latitude: ven.latitude, longitude: ven.longitude))
                                closeVenue = ven
                            }
                        }
                    }
                })}
                
                print("sunday sesh result is\(viewModel.sundaySesh)")
               

                
                sessionService.getUnreadCount(uid: sessionService.userDetails.uid, token: sessionService.token)
                
               sessionService.updateStreak(id: sessionService.userDetails.uid)
                sessionService.refreshUserDetails()
            }
            
//            .onChange(of: sessionService.token) { token in
//                sessionService.refreshUserDetails()
//                sessionService.getActiveCheckin(token: sessionService.token, uid: sessionService.userDetails.uid, completion: {})
//                sessionService.updateStreak(id: sessionService.userDetails.uid)
//
//
//                let queue = DispatchQueue(label: "homePage", attributes: .concurrent)
//
//                queue.async {viewModel.fetchTopToday()}
//                queue.async {viewModel.fetchHotVenues(token: sessionService.token) }
//                queue.async {viewModel.fetchFriendsEvents(uid: sessionService.userDetails.uid, token: sessionService.token)}
//                queue.async {viewModel.getFavourites(UID: sessionService.userDetails.uid, token: sessionService.token)}
//                queue.async { viewModel.fetch(token: sessionService.token)}
//                queue.async {viewModel.getForYou(uid: sessionService.userDetails.uid, token: sessionService.token)}
//                queue.async {viewModel.getSundaySesh()}
//                queue.async {viewModel.getTodaysDeals(uid: sessionService.userDetails.uid, token: sessionService.token)}
//                queue.async {viewModel.getRecentlyPopularVenues()}
//                queue.async {viewModel.getPopularLastNight()}
//                queue.async {viewModel.getPopularLastWeek()}
//                queue.async {viewModel.getPopularStoryVenues()}
//                queue.async {viewModel.getGirlsNight(uid: sessionService.userDetails.uid)}
//                queue.async {viewModel.getSomethingDifferent(uid: sessionService.userDetails.uid)}
//                queue.async {viewModel.getPubFeed(uid: sessionService.userDetails.uid)}
//                queue.async {viewModel.fetchTopUpcomingEvents()}
//                queue.async {viewModel.getFriendsFavourites(uid: sessionService.userDetails.uid)}
//                queue.async {viewModel.getFriendsPages(uid: sessionService.userDetails.uid)}
//
//
//            }

            .blur(radius: dealIsPresented && self.selectedDeal != nil ? 10 : 0)
            .popup(isPresented: $dealIsPresented) {
                if self.selectedDeal != nil {
                    DealTileExpanded(deal: self.selectedDeal!, venue: nil, dealIsPresented: $dealIsPresented)
                        .environmentObject(sessionService)
                        .environmentObject(manager)
                        .environmentObject(viewModel)
                }
            }
            .fullScreenCover(isPresented: $storyView, content: {
                ZStack (alignment: .topTrailing) {
                    hotStoriesManager(storyView: $storyView, venueID: $selectedVenueString)
                        .environmentObject(sessionService)
                        .environmentObject(storiesManager)
                        .environmentObject(viewModel)
                }
            })
            .fullScreenCover(isPresented: $friendsToAdd) {
                ContentView2(viewed: $showFriendsToAdd, showAddFriends: $friendsToAdd)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
        
        
        
        

//        NavigationView {
//
//            VStack (alignment: .leading) {
//                HeaderView(pageName: "Home", showFriendsToAdd: $showFriendsToAdd)
//                    .environmentObject(sessionService)
//                    .environmentObject(manager)
//                    .environmentObject(viewModel)
//
//                ScrollView (showsIndicators: false) {
//
//                    VStack (alignment: .leading) {
//
//                        //Currently Checked In Venue
//                        if sessionService.activeCheckin != nil {
//                            NavigationLink(destination: VenueView(ven: sessionService.activeCheckin!)
//                                             .environmentObject(sessionService)
//                                             .environmentObject(manager)
//                                             .environmentObject(viewModel), label: {
//                                HStack {
//                                    VStack (alignment: .leading){
//                                        Text("Checked into:")
//                                        Text(sessionService.activeCheckin!.displayname)
//                                    }
//
//                                    Spacer()
//
//                                    WebImage(url: URL(string: sessionService.activeCheckin!.imageurl))
//                                        .resizable()
//                                        .frame(width: 80, height: 50)
//                                        .scaledToFill()
//
//                                }
//                                .foregroundColor(Color.primary)
//                                .padding()
//                                .background(.gray.opacity(0.2))
//                                .cornerRadius(20)
//                            })
//                        }
//
//
//
//                        //Hot right Now
//                        Group {
//                            VStack (alignment: .leading) {
//                                HStack {
//                                    Text("Hot right now")
//                                        .font(.title)
//                                        .fontWeight(.bold)
//                                    Image(systemName: "flame")
//                                        .font(.system(size: 30))
//                                        .foregroundColor(.red)
//                                }
//
//                                ScrollView (.horizontal, showsIndicators: false) {
//                                    HStack {
//                                        ForEach(viewModel.hotVenues, id: \.self) { venue in
//                                            VenueTileView(ven: venue)
//                                                .environmentObject(sessionService)
//                                                .environmentObject(manager)
//                                                .environmentObject(viewModel)
//                                        }
//                                    }
//                                }
//                            }
//                        }
//
//
////
//                        Text("Out on the town?")
//                            .font(.title)
//                            .fontWeight(.bold)
//
//                        //For you
//
//                        if viewModel.friendsEvents.count > 0 {
//                            VStack (alignment: .leading) {
//                                Text("Events your Friends are into")
//                                   .font(.title2)
//                                   .fontWeight(.semibold)
//
//                                ScrollView (.horizontal, showsIndicators: false) {
//                                    HStack {
//                                        ForEach(viewModel.friendsEvents, id: \.self) { event in
//                                            HomeEventTile(event: event, clickable: true)
//                                                .environmentObject(sessionService)
//                                                .environmentObject(manager)
//                                                .environmentObject(viewModel)
//
//                                        }
//                                    }
//                                }
//                            }
//                        }
//
//                        if viewModel.todaysDeals.count > 0 {
//                            VStack (alignment: .leading) {
//                                Text("Todays Top Deals")
//                                   .font(.title2)
//                                   .fontWeight(.semibold)
//
//                                ScrollView (.horizontal, showsIndicators: false) {
//                                    HStack {
//                                        ForEach(viewModel.todaysDeals, id: \.self) { thisDeal in
//                                            DealTileView(deal: thisDeal)
//                                                .environmentObject(viewModel)
//                                                .onTapGesture {
//                                                    self.selectedDeal = thisDeal
//                                                    withAnimation {
//                                                        self.dealIsPresented.toggle()
//                                                    }
//
//                                                }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//
//                        Group {
//                            if viewModel.forYou.count > 0 {
//                                VStack (alignment: .leading) {
//                                    Text("For You")
//                                       .font(.title2)
//                                       .fontWeight(.semibold)
//
//                                    ScrollView (.horizontal, showsIndicators: false) {
//                                        HStack {
//                                            ForEach(viewModel.forYou, id: \.self) { venue in
//                                                VenueTileView(ven: venue)
//                                                    .environmentObject(sessionService)
//                                                    .environmentObject(manager)
//                                                    .environmentObject(viewModel)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//
//
//                        //Events popular with your friends
////                                       VStack (alignment: .leading) {
////                                           Text("Friends Are Interested In")
////                                              .font(.title2)
////                                              .fontWeight(.semibold)
////
////                                           ScrollView (.horizontal, showsIndicators: false) {
////                                               HStack {
////                                                   ForEach(viewModel.myFavourites, id: \.self) { venue in
////                                                       VenueTileView(ven: venue)
////                                                           .environmentObject(sessionService)
////                                                           .environmentObject(manager)
////                                                           .environmentObject(viewModel)
////                                                   }
////                                               }
////                                           }
////                                       }
//
//                        //Deals
//
//
//
//
//
//                        //Favourites
//
//                        if viewModel.myFavourites.count > 0 {
//                            VStack (alignment: .leading) {
//                                Text("Favourites")
//                                   .font(.title2)
//                                   .fontWeight(.semibold)
//
//                                ScrollView (.horizontal, showsIndicators: false) {
//                                    HStack {
//                                        ForEach(viewModel.myFavourites, id: \.self) { venue in
//                                            VenueTileView(ven: venue)
//                                                .environmentObject(sessionService)
//                                                .environmentObject(manager)
//                                                .environmentObject(viewModel)
//                                        }
//                                    }
//                                }
//                            }
//                        }
//
//
//                        //Sunday Sesh
//                        if viewModel.sundaySesh.count > 0 {
//                            VStack (alignment: .leading) {
//                                Text("Did Someone Say Sunday Sesh?")
//                                   .font(.title2)
//                                   .fontWeight(.semibold)
//
//                                ScrollView (.horizontal, showsIndicators: false) {
//                                    HStack {
//                                        ForEach(viewModel.sundaySesh, id: \.self) { venue in
//                                            VenueTileView(ven: venue)
//                                                .environmentObject(sessionService)
//                                                .environmentObject(manager)
//                                                .environmentObject(viewModel)
//                                        }
//                                    }
//                                }
//                            }
//                        }
//
//
//                            VStack (alignment: .leading) {
////
//
//
//                                Text("Events Coming Up")
//                                    .font(.title2)
//                                    .fontWeight(.semibold)
//                                ScrollView (.horizontal, showsIndicators: false) {
//                                    HStack {
//                                        ForEach(viewModel.venues, id: \.self) { venue in
//                                            if venue.events.count > 0 {
//                                                VenueTileView(ven: venue)
//                                                    .environmentObject(sessionService)
//                                                    .environmentObject(manager)
//                                                    .environmentObject(viewModel)
//                                            }
//                                        }
//                                    }
//                                }
//
//
//
////                                       }
//
//                        }
//
//                    }
//                }
////                               .padding(.horizontal)
//                .navigationBarHidden(true)
//                .onAppear {
//                    sessionService.refreshUserDetails()
//                    sessionService.getToken()
//
//                    let queue = DispatchQueue(label: "homePage", attributes: .concurrent)
//
//                    queue.async {viewModel.fetchHotVenues(token: sessionService.token) }
//                    queue.async {viewModel.fetchFriendsEvents(uid: sessionService.userDetails.uid, token: sessionService.token)}
//                    queue.async {viewModel.getFavourites(UID: sessionService.userDetails.uid, token: sessionService.token)}
//                    queue.async { viewModel.fetch(token: sessionService.token)}
//                    queue.async {viewModel.getForYou(uid: sessionService.userDetails.uid, token: sessionService.token)}
//                    queue.async {viewModel.getSundaySesh()}
//                    queue.async {viewModel.getTodaysDeals(uid: sessionService.userDetails.uid, token: sessionService.token)}
//
//                    sessionService.getUnreadCount(uid: sessionService.userDetails.uid, token: sessionService.token)
//                   sessionService.getActiveCheckin(token: sessionService.token, uid: sessionService.userDetails.uid)
//                   sessionService.updateStreak(id: sessionService.userDetails.uid)
//                }
//            }
//            .padding(.horizontal)
//            .blur(radius: dealIsPresented && self.selectedDeal != nil ? 10 : 0)
//
//            .popup(isPresented: $dealIsPresented) {
//                if self.selectedDeal != nil {
////                    Text("\(self.selectedDeal!.name)")
//
//
//                    DealTileExpanded(deal: self.selectedDeal!, venue: nil, dealIsPresented: $dealIsPresented)
//                        .environmentObject(sessionService)
//                        .environmentObject(manager)
//                        .environmentObject(viewModel)
//                }
//
//            }
//
//
//
//
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//        .onChange(of: sessionService.token) { token in
//            sessionService.refreshUserDetails()
//            sessionService.getActiveCheckin(token: sessionService.token, uid: sessionService.userDetails.uid)
//            sessionService.updateStreak(id: sessionService.userDetails.uid)
//
//
//            let queue = DispatchQueue(label: "homePage", attributes: .concurrent)
//
//            queue.async {viewModel.fetchHotVenues(token: sessionService.token) }
//            queue.async {viewModel.fetchFriendsEvents(uid: sessionService.userDetails.uid, token: sessionService.token)}
//            queue.async {viewModel.getFavourites(UID: sessionService.userDetails.uid, token: sessionService.token)}
//            queue.async { viewModel.fetch(token: sessionService.token)}
//            queue.async {viewModel.getForYou(uid: sessionService.userDetails.uid, token: sessionService.token)}
//            queue.async {viewModel.getSundaySesh()}
//            queue.async {viewModel.getTodaysDeals(uid: sessionService.userDetails.uid, token: sessionService.token)}
//
//
//
//        }
    }
    
    
}

//
//  RefreshScrollView.swift
//  Luna
//
//  Created by Ned O'Rourke on 28/5/2022.


//


