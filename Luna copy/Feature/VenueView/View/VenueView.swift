//
//  VenueView.swift
//  Luna
//
//  Created by Ned O'Rourke on 18/1/22.
//

import SwiftUI
import SDWebImageSwiftUI
import MapKit
import PopupView
import FirebaseFirestore
import Mixpanel

struct EventsView : View {
    
    var ven : VenueObj
    
    var body: some View {
        VStack {
            Text("Events")
            ForEach (ven.events , id: \.self) { event in
                EventTileView(event: event, clickable: true)
            }
        }
    }
}

struct DealsView : View {
    
    var ven : VenueObj
    
    var body: some View {
        VStack {
            ForEach (ven.events , id: \.self) { event in
                Text("Deal")
            }
        }
    }
}

struct VenueView: View {
    
    var ven : VenueObj
    
    
    @State var selectedTab = 0
    @State var followed = false
    @State var buttonState : Int = 1
    @State var buttonText : String = "Check In"
    @State var following = false
    @State var distance : CLLocationDistance = 101.0
    @State var showNewPres : Bool = false
    @State var canCheckin : Bool = false
    @State var text = "heart"
    @State var orderedEvents: [EventObj] = []
    @State var showTime = false
    @State var boss: Int = 1
    @State var alertBool: Bool = false
    
    @State var selectedDeal : DealObj?
    @State var dealIsPresented : Bool = false
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    @StateObject var service = VenueService()
    @StateObject var storyHandler = storiesHandler()
    @StateObject var firesaleManager = FiresaleManager()
    
    
    @State var storyView : Bool = false
    @State var showCamera : Bool = false
    
    @State var trig : Bool = false
    
    @State var alertTitle : String = ""
    @State var alertText : String = ""
    
    @State var showFiresale = false
    @State var showOldStories = false
    
    var body: some View  {
        
        
        ZStack (alignment: .bottom) {
            ScrollView (showsIndicators: false) {
                
                ZStack (alignment: .bottom) {
//                    CachedAsyncImage(url: URL(string: ven.imageurl)) {image in
//                        image.resizable()
//                    } placeholder: {
//                        VStack (alignment: .center){
//                            ProgressView()
//                        }
//                        .frame(width: 240, height: 240)
//                    }
                    WebImage(url: URL(string: ven.imageurl))
                        .resizable()
                    
                    HStack {
                        Text(ven.displayname)
                            .font(.system(size: 20))
                        Spacer()
                        Text(ven.averageTime == -1 ? "No Line Data" : "\(ven.averageTime) mins")
                            .font(.system(size: 12))
                        Image(systemName: "person.3.sequence.fill")
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    .frame(maxWidth: .infinity, maxHeight: 30)
                    .background(Color("darkBackground").opacity(0.8))
                }
                .frame(maxWidth: .infinity, maxHeight: 240)
                .multilineTextAlignment(.leading)
                
                VStack (alignment: .leading) {
                    
                                    
                    //Main content
                    Button(action: {
                        
                        let urlString = "maps://?address=\(ven.address)"
                        let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        let url = URL(string: encodedURL)

                        if UIApplication.shared.canOpenURL(url!) {
                              UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        }
                        
                    }) {
                        HStack (alignment: .center) {
                            Image(systemName: "mappin")
                                .font(.system(size: 13))
                            Text(ven.address)
                           
                        }
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 2.5)
                        
                    }
                    .buttonStyle(.plain)
                    
                    if ven.favourites.count > 0 {
                        HStack {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 13))
                            
                            Text("\(ven.favourites.count) Like this venue")
                                .offset(x: -1, y: 0)
                        }
                        .offset(x: -1, y: 0)
                        .padding(.bottom, 2.5)
                        
                    }
                   
                    
                    if ven.checkins.count > 0 {
                        HStack {
                            Image(systemName: "person.fill")
                                .font(.system(size: 13))
                            
                            Text("\(ven.checkins.count) Checked In")
                                .padding(.bottom, 2.5)
                        }
                    }
                    
                    
                    if ven.activeFiresale != "" && sessionService.activeCheckin?.id ?? ""  == ven.id {
                        Button {
                            self.showFiresale.toggle()
                        } label: {
                            HStack (alignment: .center) {
                                Image(systemName: "flame")
                                    .font(.system(size: 13))
                                Text("Firesale now active")
                               
                            }
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color("Error"))
                        }
                    }
                    
                    Divider()
                    
                    
                    
                    
                    Group {
                    
                        Text("About this venue")
                        LongText(ven.description, dark: true)
                            .foregroundColor(.purple)
                        
                        Divider()
                        
                        VStack (alignment: .leading) {
                            Text("Friends Checked In")
                                .foregroundColor(.primary)
                            
                            if service.friendsCheckedIn.count == 0 {
                                Text("Looks like none of your friends are here yet!")
                                    .foregroundColor(Color("darkSecondaryText"))
                                    .font(.system(size: 16))
                            }
                            else {
                                ScrollView (.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(service.friendsCheckedIn, id: \.self) { friend in
                                            NavigationLink(destination: friend.performer ? AnyView(PerformerProfileView(user: friend)
                                                .environmentObject(sessionService)
                                                .environmentObject(manager)
                                                .environmentObject(homeVM))
                                               : AnyView(UserProfileView(user: friend)
                                                .environmentObject(sessionService)
                                                .environmentObject(manager)
                                                .environmentObject(homeVM)), label: {
                                                VStack {
                                                    WebImage(url: URL(string: friend.imageURL))
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 64, height: 64).cornerRadius(64)
                                                        .clipped()
                                                    
                                                    
                                                }
                                            })
                                        }
                                        .frame(maxWidth: 100, maxHeight: 120)
                                    }
                                }
                            }
                            
                            Divider()
                        }
                    }
                    
                    
                    
                    Group {
                        if trig {
                            Text("Stories")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(storyHandler.stories, id: \.self) { story in
                                        VStack {
                                            if story.url != "" {
                                                StoryImage(
                                                    url: URL(string: story.url)!,
                                                    placeholder: { Text("Loading ...") },
                                                    image: { Image(uiImage: $0).resizable() }
                                                )
                                                .blur(radius: CGFloat(storyHandler.stories.firstIndex(of: story)!) * 2)
                                                .onTapGesture {
                                                    storyView.toggle()
                                                }
                                            }
                                               
                                        }
                                        .frame(width: UIScreen.main.bounds.size.width*0.25, height: UIScreen.main.bounds.size.height*0.2, alignment: .center)
                                        .cornerRadius(10)
                                    }
                                    
                                }
                            }
                            
                            Divider()
                        }
                    }
                    
                    
                    

                    Group {
                        
                        if ven.events.count > 0 {
                            Text("Upcoming Events")
                                .fontWeight(.medium)
    //                            .font(.system(size: 10))
    //                            .padding(.top, 0.01)
    //                        Spacer()
                            
                            ForEach (orderedEvents, id: \.self) { event in
                                MyEventsEventView(event: event, clickable: true)
                                    .environmentObject(sessionService)
                                    .environmentObject(manager)
                                Divider()
                            }
                        }
                        
                        
                       
                        
                        
                        
                        
                        
                        if ven.deals.count > 0 {
                            Text("Current Deals")
                                .fontWeight(.medium)
//                                .font(.title)
                            
                            Spacer()
                            ScrollView (.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach (ven.deals, id: \.self) { deal in
                                        DealTileView(deal: deal)
                                            .onTapGesture {
                                                self.selectedDeal = deal
                                                self.dealIsPresented.toggle()
                                                Mixpanel.mainInstance().track(event: "Deal View", properties: [
                                                    "venueID" : deal.venue,
                                                    "dealID" : deal.id])
                                            }
                                    }
                                }
                            }
                            .padding(.bottom)
                        }
                    }
                    
                    
                    
                    
                }
                .padding(.horizontal)
            }
            
            
            
            
//            HStack {
//                Button(action: {
//                    self.showTime = false
//
//                    if self.buttonState == 1 {
//                        if canCheckin {
//
//
//                            self.showTime.toggle()
//                        } else {
//                            showBadCheckin.toggle()
//                        }
//
//                    } else if self.buttonState == 2 {
//
//                        sessionService.checkOut(venueID: ven.id, UID: sessionService.userDetails.uid, completion: {
//
//                            self.buttonText = "Check In"
//                            self.buttonState = 1
//                            sessionService.getActiveCheckin(token: sessionService.token, uid: sessionService.userDetails.uid, completion: {})
//                        })
//
//
//
//                    }
//
//                } , label: {
//
//                    VStack {
//                        Text(self.buttonText)
//                            .font(.system(size: 20))
//                            .foregroundColor(.white)
//                    }
//                    .frame(width: UIScreen.main.bounds.width*0.4, height: 40)
//                    .background(self.canCheckin ? .purple.opacity(0.8) : .purple.opacity(1))
//                    .cornerRadius(10)
//                    .sheet(isPresented: $showTime, content: {
//                        LineLengthView(ven: ven, showTime : $showTime, buttonText: $buttonText, buttonState: $buttonState)
//                            .environmentObject(sessionService)
//                    })
//
//                })
//                    .buttonStyle(.plain)
//
//
//                Button {
//                    if buttonText == "Check Out" {
//                        showCamera.toggle()
//                    }
//                    else {
//                        self.showBadCamera.toggle()
//                    }
//
//
//                } label: {
//                    VStack {
//                        Text("Add Story")
//                            .font(.system(size: 20))
//                            .foregroundColor(.white)
//                    }
//                    .frame(width: UIScreen.main.bounds.width*0.4, height: 40)
//                    .background(.purple.opacity(0.8))
//                    .cornerRadius(10)
//
//                }
////                NavigationLink(destination: CameraView()
////                    .environmentObject(storiesManager)) {
////                    Text("Create Pres")
////                        .foregroundColor(Color.white)
////                        .padding(.vertical, 10)
////                        .frame(width: 170, height: 40).cornerRadius(20)
////                        .background(Color.purple).cornerRadius(20)
////                }
//            }
//            .padding()
//            .padding(.bottom, 10)
            HStack (alignment: .center) {
                
                Button(action: {
                    self.showTime = false

                    if self.buttonState == 1 {
                        if canCheckin {
                            self.showTime = true
                            Mixpanel.mainInstance().track(event: "Check In", properties: [
                                "venueID" : ven.id,
                                "user" : sessionService.userDetails.uid])
                        } else {
                            alertTitle = "Can't Check in"
                            alertText = "You must be within 200m of a venue to check in."
                            self.alertBool = true
                        }

                    } else if self.buttonState == 2 {

                        sessionService.checkOut(venueID: ven.id, UID: sessionService.userDetails.uid, completion: {

                            self.buttonText = "Check In"
                            self.buttonState = 1
                            sessionService.getActiveCheckin(uid: sessionService.userDetails.uid, completion: {})
                        })

                    }
                }, label: {
                    HStack {
                        
                        Spacer()
                        
                        HStack {
                            Text(self.buttonText)
                        }
                        .frame(width: UIScreen.main.bounds.size.width*0.4, height: 40, alignment: .center)
                        .background(.purple.opacity(0.9))
                        .cornerRadius(30)
                        .padding(.bottom)
                        .foregroundColor(.primary)
                    }
                    
                   
                })
                
                
                Button {
                    
                    if buttonText == "Check Out" {
                        self.showCamera = true
                    }
                    else {
                        alertTitle = "Can't Post Story"
                        alertText = "You must be checked in to post a story."
                        self.alertBool = true
                    }
                } label: {
                    Image(systemName: "camera")
                        .frame(width: 40, height: 40, alignment: .center)
                        .background(.purple.opacity(0.9))
                        .cornerRadius(30)
                        .padding(.bottom)
                        .foregroundColor(.primary)
                }

            }
            .padding(.horizontal)
            
            
        }
        .background(Color("darkBackground"))
        .fullScreenCover(isPresented: $storyView, content: {
            ZStack (alignment: .topTrailing) {
                StoryView(storyView: $storyView, venueID: ven.id)
                    .environmentObject(sessionService)
                    .environmentObject(storyHandler)
            }
            
        })
        .fullScreenCover(isPresented: $showCamera, content: {
            ZStack (alignment: .topTrailing) {
                CameraView(venueID: ven.id, showCamera: $showCamera)
                    .environmentObject(storyHandler)
                    .environmentObject(sessionService)
            }
            
        })
        .fullScreenCover(isPresented: $showFiresale, content: {
            FiresaleView(firesaleID: ven.activeFiresale, showFiresale: $showFiresale)
                .environmentObject(sessionService)
        })
        .task {
            await storyHandler.getStories(venueID: ven.id, completion: { status in
                if status {
                    trig = true
                }
            })
        }
//        }
        .onAppear {
            db.collection("businessUsers").document(ven.id).updateData(["engagementToday" : FieldValue.increment(0.5)])
//            Task {
//
//            }
//
//            ForEach(storyHandler.stories, id:\.self) { story in
//                var xd = ImageLoader(url: URL(string: story.url)!)
//                xd.load()
//            }
            
            service.getFriendsCheckedIn(uid: sessionService.userDetails.uid, venue: ven.id, token: sessionService.token)
//            service.getFriendsLiked(uid: sessionService.userDetails.uid, venue: ven.id, token: sessionService.token)
            if sessionService.userDetails.favourites.contains(ven.id) {
                following = true
                text = "heart.fill"
            }
            else {
                following = false
                text = "heart"
            }

            self.distance = CLLocation(latitude: manager.region.center.latitude, longitude: manager.region.center.longitude).distance(from: CLLocation(latitude: ven.latitude, longitude: ven.longitude))

            sessionService.getActiveCheckin(uid: sessionService.userDetails.uid, completion: {})
            if sessionService.activeCheckin != nil {
                if sessionService.activeCheckin!.id == ven.id {
                    self.buttonText = "Check Out"
                    self.buttonState = 2
                } else {
                    self.buttonText = "Check In"
                    self.buttonState = 1
                }
                
            }
            print(self.distance)
            if self.distance <= 200.0 {
                self.canCheckin = true
            } else {
                self.canCheckin = false
            }
            
            print("check in statu s \(self.canCheckin)")
            
            self.orderedEvents = ven.events.sorted {
                $0.date < $1.date
            }
            
        }
        .alert(isPresented: $alertBool) {
            Alert(title: Text(alertTitle),
                  message: Text(alertText),
                  dismissButton: .default(Text("Ok")) {
                alertBool = false
            })
        }
        .sheet(isPresented: $showTime, content: {
            LineLengthView(ven: ven, showTime : $showTime, buttonText: $buttonText, buttonState: $buttonState)
                .environmentObject(sessionService)
        })
//        .fullScreenCover(isPresented: $showOldStories, content: {
//            NavigationView {
//                ScrollView {
//                    VStack (spacing: 5) {
//                        let columns = [
//                                GridItem(.flexible()),
//                                GridItem(.flexible())
//                        ]
//
//                        let x = "https://firebasestorage.googleapis.com:443/v0/b/appluna.appspot.com/o/storyImages%2F0UARQdh482g05gSPIlp5?alt=media&token=de4c7641-e169-4473-8301-f112407ab98e"
//
//                        LazyVGrid (columns: columns, spacing: 5) {
//                            ForEach(0..<40, id: \.self) { f in
//                                VStack (alignment: .leading, spacing: 0) {
//                                    WebImage(url: URL(string: x))
//                                        .resizable()
//                                        .scaledToFill()
//                                        .cornerRadius(10)
//
//                                    VStack (alignment: .leading) {
//                                        Text("15/34/56")
//                                        Text("Lost Sundays")
//                                        Text("1.3K Checked in")
//
//                                    }
////                                    .padding(.horizontal)
//
//                                }
//                                .frame(minWidth: 0, maxWidth: .infinity)
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//                .background(Color("darkBackground"))
////                .navigationBarItems(trailing: {
////                    Text("close")
////                        .onTapGesture {
////                            self.showOldStories.toggle()
////                        }
////                })
//            }
////            .navigationBarItems(trailing: {
////                Text("close")
////                    .onTapGesture {
////                        self.showOldStories.toggle()
////                    }
////            })
//
//        })
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView())
        .toolbar {
            HStack {
                Button(action: {
                    if following == false {
                        sessionService.followVenue(venueID: ven.id, UID: sessionService.getUID())
                        following = true
                        text = "heart.fill"
                    }
                    else {
                        sessionService.unfollowVenue(venueID: ven.id, UID: sessionService.getUID())
                        following = false
                        text = "heart"

                    }
                    
                }, label: {
                    Image(systemName: text)
                        .frame(width: 30, height: 30)
                        .background(Color("darkBackground"))
                        .foregroundColor(Color.primary).cornerRadius(20)

                })
            }
            .buttonStyle(.plain)
            
        }
        .blur(radius: dealIsPresented && self.selectedDeal != nil ? 10 : 0)
        .popup(isPresented: $dealIsPresented) {
            if self.selectedDeal != nil {
                DealTileExpanded(deal: self.selectedDeal!, venue: ven, dealIsPresented: $dealIsPresented)
                    .environmentObject(sessionService)
                    .environmentObject(manager)
                    .environmentObject(homeVM)
            }
        }
    }
}
