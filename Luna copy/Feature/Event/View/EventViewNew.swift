//
//  EventViewNew.swift
//  Luna
//
//  Created by Ned O'Rourke on 23/3/22.
//

import SwiftUI
import MapKit
import SDWebImageSwiftUI
import Mixpanel
import FirebaseFirestoreSwift
import Firebase

struct ActivityViewController: UIViewControllerRepresentable {
    var itemsToShare: [Any]
    var servicesToShareItem: [UIActivity]? = nil
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: itemsToShare, applicationActivities: servicesToShareItem)
        return controller
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}

struct EventViewNew: View {
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    @StateObject var handler = EventViewHandler()
    @StateObject var pageManager = PageHandler()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openURL) var openURL
    let df = DateFormatter()
    let calendar = Calendar.current
    
    @State var event : EventObj
    
    @State var distance : CLLocationDistance = 101.0
    @State var date = ""
    @State var buttonText = "Interested"
    @State var interested = false
    @State var showNewPres = false
    @State var dynamicLink : URL?
    @State var showUpdate = false
    @State var showDelete = false
    @State var showAllResponses = false
    
    @State var followed = false
    @State var buttonState : Int = 1
    @State var buttonText2 : String = "Check In"
    @State var showTime : Bool = false
    @State var showShareSheet = false
    
    @State var navShow = false
    
    @State var editGrooveDealers = false
    
    var body: some View {
        ZStack {
            ScrollView (.vertical, showsIndicators: false) {
                VStack (spacing: 0) {
                    HeaderView()
                    
                    VStack {
                        Content()
                    }
                }
            }
            

            
//            if navShow {
                GeometryReader {proxy in
                    let size = proxy.size
                    if navShow {
                        HStack (alignment: .center) {
                            BackButtonView()
                            Spacer()
                            Text(event.label)
                            Spacer()
                            
//                            if Set(event.hostIDs).intersection(Set(sessionService.userDetails.pages)).count != 0 {
//                                Button {
//                                    showUpdate.toggle()
//                                } label: {
//                                    Image(systemName: "pencil.circle.fill")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 30, height: 30)
//                                        .foregroundColor(Color.primary)
//                                        .colorInvert()
//                                        .background(Color.primary).cornerRadius(20)
//                                }
//                            }

                            Button {
                                if self.dynamicLink != nil {
                                    let activityView = UIActivityViewController(activityItems: [self.dynamicLink!], applicationActivities: nil)

                                        let allScenes = UIApplication.shared.connectedScenes
                                        let scene = allScenes.first { $0.activationState == .foregroundActive }

                                        if let windowScene = scene as? UIWindowScene {
                                            windowScene.keyWindow?.rootViewController?.present(activityView, animated: true, completion: nil)
                                        }
//                                    let activityController = UIActivityViewController(activityItems: [dynamicLink!], applicationActivities: nil)
//
//                                    UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
                                }
                            } label: {
                                Image(systemName: "square.and.arrow.up.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.primary)
                                    .colorInvert()
                                    .background(Color.primary).cornerRadius(20)
                            }

//                            if event.creatorID.contains(sessionService.userDetails.uid) {
//                                EditPageButton(showEditPage: $showEditPage, page: $page)
//                            }
                           
                        }
                        .padding(.horizontal)
                        .frame(width: size.width, height: 40, alignment: .center)
                        .background(Color("darkBackground"))
                        .foregroundColor(.white)
                    }
                    
                    else {
                        HStack (alignment: .center) {
                            BackButtonView()
                            Spacer()
                            
                            
//                            for x in event.hostIDs {
//                                for y in sessionService.userDetails.pages {
//                                    if x == y {
//
//                                    }
//                                }
//                            }
//                            let set1:Set<String> = Set((event.hostIDs)
//                            let set2:Set<String> = Set(array2)
                            
//                            if Set(event.hostIDs).intersection(Set(sessionService.userDetails.pages)).count != 0 {
//                                Button {
//                                    showDelete.toggle()
//                                } label: {
//                                    Image(systemName: "trash.circle.fill")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 30, height: 30)
//                                        .foregroundColor(Color.primary)
//                                        .colorInvert()
//                                        .background(Color.primary).cornerRadius(20)
//                                }
////                                Button {
////                                    showUpdate.toggle()
////                                } label: {
////                                    Image(systemName: "pencil.circle.fill")
////                                        .resizable()
////                                        .scaledToFit()
////                                        .frame(width: 30, height: 30)
////                                        .foregroundColor(Color.primary)
////                                        .colorInvert()
////                                        .background(Color.primary).cornerRadius(20)
////                                }
//                            }
                            
                            Button {
                                if self.dynamicLink != nil {
                                    let activityView = UIActivityViewController(activityItems: [self.dynamicLink!], applicationActivities: nil)

                                        let allScenes = UIApplication.shared.connectedScenes
                                        let scene = allScenes.first { $0.activationState == .foregroundActive }

                                        if let windowScene = scene as? UIWindowScene {
                                            windowScene.keyWindow?.rootViewController?.present(activityView, animated: true, completion: nil)
                                        }
//                                    let activityController = UIActivityViewController(activityItems: [dynamicLink!], applicationActivities: nil)
//
//                                    UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
                                }
                                
                            } label: {
                                Image(systemName: "square.and.arrow.up.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.primary)
                                    .colorInvert()
                                    .background(Color.primary).cornerRadius(20)
                            }
//                            if page.admins.contains(sessionService.userDetails.uid) {
//                                EditPageButton(showEditPage: $showEditPage, page: $page)
//                            }
                        }
                        .padding(.horizontal)
                        .frame(width: size.width, height: 40, alignment: .center)
                        .background(.clear)
                    }
                }
        }
        .alert("Delete Event Confirmation", isPresented: $showDelete, actions: {
            Button("Cancel", role: .cancel, action: {showDelete.toggle()})

            Button("I'm sure", role: .destructive, action: {
                showDelete.toggle()
                handler.deleteEvent(id: event.id) {
                    DispatchQueue.main.async {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                
            })
            
        }, message: {
            Text("Are you sure you want to delete this event?")
        })
        .fullScreenCover(isPresented: $showAllResponses) {
            EventResponsesView(showAllResponses: $showAllResponses)
                .environmentObject(sessionService)
                .environmentObject(manager)
                .environmentObject(homeVM)
                .environmentObject(handler)
        }
        .background(Color("darkBackground"))
        .fullScreenCover(isPresented: $showNewPres, onDismiss: nil, content: {
            NewEventView(showNewEvent: $showNewPres, linkedEvent: event)
            
//            NewPresView(showNewPres: $showNewPres, linkedEvent: event)
        })
        .fullScreenCover(isPresented: $showUpdate, onDismiss: nil, content: {
            UpdatePageEventView(showUpdate: $showUpdate, event: $event, eventHosts: handler.hosts)
                .environmentObject(sessionService)
                .environmentObject(manager)
                .environmentObject(homeVM)
                .environmentObject(pageManager)
        })
        .navigationBarHidden(true)
        .sheet(isPresented: $showShareSheet, content: { ActivityViewController(itemsToShare: [self.dynamicLink as Any]) })
        .sheet(isPresented: $editGrooveDealers, content: {
            editGrooveDealersView(currentPerformers: handler.performers, editGrooveDealers: $editGrooveDealers, eventID: event.id)
                .environmentObject(sessionService)
                .environmentObject(handler)
        })

//        .ignoresSafeArea()
        .onAppear {
            if !handler.gettingResponse {
                handler.getEventResponse(uid: sessionService.userDetails.uid, eventID: event.id)
            }
            db.collection(event.pageCreated ? "pageEvents" : "venueEvents").document(event.id).updateData(["engagement" : FieldValue.increment(0.5)])
            sessionService.createDynamicLinkEvent(event: self.event, completion: { url in
                if url == nil {
                    print("Failed to generate dynamic link for event.")
                } else {
                    self.dynamicLink = url
                }
            })
            sessionService.getToken()
            handler.getPerformers(eventID: event.id)
            
            if handler.venue == nil {
                handler.getVenue(venue: event.linkedVenue, token: sessionService.token, completion: {
                    self.distance = CLLocation(latitude: manager.region.center.latitude, longitude: manager.region.center.longitude).distance(from: CLLocation(latitude: handler.venue?.latitude ?? 0.0, longitude: handler.venue?.longitude ?? 0.0))
                    
                    if sessionService.activeCheckin != nil {
                        if sessionService.activeCheckin!.id == handler.venue?.id ?? ""  {
                            self.buttonText2 = "Check Out"
                            self.buttonState = 2
                        } else {
                            self.buttonText2 = "Check In"
                            self.buttonState = 1
                        }
                        
                    }
            
                })
            } else {
                self.distance = CLLocation(latitude: manager.region.center.latitude, longitude: manager.region.center.longitude).distance(from: CLLocation(latitude: handler.venue?.latitude ?? 0.0, longitude: handler.venue?.longitude ?? 0.0))
                
                if sessionService.activeCheckin != nil {
                    if sessionService.activeCheckin!.id == handler.venue?.id ?? ""  {
                        self.buttonText2 = "Check Out"
                        self.buttonState = 2
                    } else {
                        self.buttonText2 = "Check In"
                        self.buttonState = 1
                    }
                    
                }
            }
            
            handler.getInterestedFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)
            handler.getGoingFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)
            
//            if sessionService.userDetails.interested.contains(event.id) {
//                self.interested = true
//            } else {
//                self.interested = false
//            }
            
            
            dateFormatter.dateFormat = "dd-MM-yyyy"
            guard let dateObj = dateFormatter.date(from: event.date) else {return}

            
            if calendar.isDateInToday(dateObj) {
                self.date = "Today"
            } else if calendar.isDateInTomorrow(dateObj) {
                self.date = "Tomorrow"

            } else if calendar.isDateInThisWeek(dateObj) {

                dateFormatter.dateFormat = "EEEE"
                let dayOfTheWeekString = dateFormatter.string(from: dateObj)
                self.date = dayOfTheWeekString
            }
            
            else {
                let weekdays = [
                            "Sun",
                            "Mon",
                            "Tues",
                            "Wed",
                            "Thurs",
                            "Fri",
                            "Sat"
                        ]
                let weekDay = calendar.component(.weekday, from: dateObj)
                let day = calendar.component(.day, from: dateObj)
                let month = calendar.component(.month, from: dateObj)
                self.date = weekdays[weekDay - 1] + " \(day)/\(month)"
            }
            
            self.distance = CLLocation(latitude: manager.region.center.latitude, longitude: manager.region.center.longitude).distance(from: CLLocation(latitude: handler.venue?.latitude ?? 0.0, longitude: handler.venue?.longitude ?? 0.0))
            
            handler.getHosts(eventID: event.id)
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        GeometryReader {proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = (size.height + minY)
            
            WebImage(url: URL(string: event.imageurl))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: height >= 250 ? height : 250, alignment: .top)
                    .overlay(content: {
                        ZStack (alignment: .bottom) {
                            LinearGradient(colors: [
                                .clear,
                                .black.opacity(0.5)
                            ], startPoint: .top, endPoint: .bottom)
                            
                            VStack (alignment: .leading, spacing: 12) {
                                HStack (alignment: .bottom, spacing: 10) {
                                    Text(event.label)
                                        .font(.title2.bold())
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 25)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    })
                    .cornerRadius(1)
                    .offset(y: -minY)
                    .onChange(of: minY) { newValue in
                        if newValue < -130 {
                            withAnimation {
                                self.navShow = true
                            }
                            
                        }
                        else {
                            withAnimation {
                                self.navShow = false
                            }
                        }
                    }
                    
            
            
        }
        .frame(height: 200)
        
    }
    
    @ViewBuilder
    func Content()-> some View {
        VStack {
            
            VStack (alignment: .leading) {
                Group {
                    Group {
                        HStack {
                            Image(systemName: "clock")
                            Text("\(self.date) from \(event.startTime) to \(event.endTime)")
                                .padding(.leading, 4)
                        }
                        
                        
                        Button(action: {
                            let urlString = "maps://?address=\(event.address)"
                            let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            let url = URL(string: encodedURL)

                            if UIApplication.shared.canOpenURL(url!) {
                                  UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                            }

                        }) {
                            VStack (alignment: .leading) {
                                HStack {
                                    Image(systemName: "mappin")
                                    Text(event.address)
                                        .padding(.leading, 5)
                                        .lineLimit(1)
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.system(size: 13))
                                    
                                }
                                .foregroundColor(Color.primary)
                                .padding(.leading, 2.5)
                            }
                            .multilineTextAlignment(.leading)
                        }
                        
                        Group {
                            if handler.venue != nil {
                                NavigationLink(destination: VenueView(ven : handler.venue!)
                                                .environmentObject(sessionService)
                                                .environmentObject(manager)
                                                .environmentObject(homeVM), label: {
                                    HStack {
                                        Image(systemName: "megaphone")
                                        Text("Hosted at **\(handler.venue!.displayname)**")
                                            .padding(.leading, 2)
                                        
                                    }
                                    .foregroundColor(Color.primary)
    //                                .padding(.leading, 2)
                                    .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    Spacer()
                        
    //
                                })
                            }
                        }
                        
                        if event.interested.count > 0 && event.going.count > 0{
                            HStack {
                                Image(systemName: "person.3.fill")
                                
                                Text("\(event.going.count) Going, \(event.interested.count) Interested")
    //                                .padding(.leading, 5)
                            }
                            .foregroundColor(Color.primary)
                            .offset(x: -5, y: 0)
    //                        .padding(.leading, 2.5)
                        }
                        else if event.interested.count > 0 {
                            HStack {
                                Image(systemName: "person.3.fill")
                                
                                Text("\(event.interested.count) Interested")
    //                                .padding(.leading, 5)
                            }
                            .foregroundColor(Color.primary)
                            .offset(x: -5, y: 0)
    //                        .padding(.leading, 2.5)
                        }
                        else if event.going.count > 0 {
                            HStack {
                                Image(systemName: "person.3.fill")
                                
                                Text("\(event.going.count) Going")
    //                                .padding(.leading, 5)
                            }
                            .foregroundColor(Color.primary)
                            .offset(x: -5, y: 0)
    //                        .padding(.leading, 2.5)
                        }
                    }
                    .padding(.vertical, 5)
                    
                    Group {
                        if event.ticketLink != "" {
                            Button (action: {
                                
                                guard let url = URL(string: event.ticketLink) else {
                                    print("Cannot build url from ticket link.")
                                    return
                                }
                                
                                if UIApplication.shared.canOpenURL(url) {
                                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                                
                            }, label: {
                                
                                HStack {
                                    Image(systemName: "ticket")
                                        .foregroundColor(Color.primary)
                                    Text("Tickets")
                                        .lineLimit(1)
                                        .foregroundColor(Color.primary)
                                    Text(event.ticketLink)
                                        .lineLimit(1)
                                        .foregroundColor(Color.secondary)

                                }
                                .multilineTextAlignment(.leading)
                            })
                            
                        }
                    }
                    .padding(.vertical, 5)
                }
                
//                Divider()
                Group {
                    Group {
                        
                        if handler.gettingResponse {
                            
                            HStack {
                                Text("Loading")
                                    .font(.system(size: 20))
                                    .foregroundColor(.primary)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
                            .background(.purple.opacity(0.3))
                            .cornerRadius(5)
                                    
                        } else {
                            Group {
                                if handler.eventResponse == "none" {
                                        HStack {
                                            Button {
                                                Mixpanel.mainInstance().track(event: "Going To Event", properties: [
                                                    "user": sessionService.userDetails.uid,
                                                    "eventID" : event.id])
                                                handler.changeEventResponse(uid: sessionService.userDetails.uid, eventID: event.id, response: "going") {
                                                    handler.getEventResponse(uid: sessionService.userDetails.uid, eventID: event.id)
                                                }
                                            } label: {
                                                    HStack {
                                                        Image(systemName: "person.fill.checkmark")
                                                            .foregroundColor(.primary)
                                                        Text("Going")
                                                            .font(.system(size: 20))
                                                            .foregroundColor(.primary)
                                                    }
                                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
                                                    .background(.purple.opacity(0.5))
                                                    .cornerRadius(5)
                                            }
                                                                                        
                                            Button {
                                                Mixpanel.mainInstance().track(event: "Interested In Event", properties: [
                                                    "user": sessionService.userDetails.uid,
                                                    "eventID" : event.id])
                                                handler.changeEventResponse(uid: sessionService.userDetails.uid, eventID: event.id, response: "interested") {
                                                    handler.getEventResponse(uid: sessionService.userDetails.uid, eventID: event.id)
                                                }
                                            } label: {
                                                HStack {
                                                    Image(systemName: "bookmark.fill")
                                                        .foregroundColor(.primary)
                                                    Text("Interested")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(.primary)
                                                }
                                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
                                                .background(.purple.opacity(0.5))
                                                .cornerRadius(5)
                                            }
                                        }
                                    
                                } else if handler.eventResponse == "going" {
                                    Button {
                                        handler.changeEventResponse(uid: sessionService.userDetails.uid, eventID: event.id, response: "none") {
                                            handler.getEventResponse(uid: sessionService.userDetails.uid, eventID: event.id)
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "person.fill.checkmark")
                                                .foregroundColor(.primary)
                                            Text("Going")
                                                .font(.system(size: 20))
                                                .foregroundColor(.primary)
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
                                        .background(.purple.opacity(0.5))
                                        .cornerRadius(5)
                                    }
                                } else if handler.eventResponse == "interested" {
                                    Button {
                                        handler.changeEventResponse(uid: sessionService.userDetails.uid, eventID: event.id, response: "none") {
                                            handler.getEventResponse(uid: sessionService.userDetails.uid, eventID: event.id)
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "bookmark.fill")
                                                .foregroundColor(.primary)
                                            Text("Interested")
                                                .font(.system(size: 20))
                                                .foregroundColor(.primary)
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
                                        .background(.purple.opacity(0.5))
                                        .cornerRadius(5)
                                    }
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                
                if (handler.interestedFriends.count != 0 || handler.goingFriends.count != 0 ) {
//                    Text("LOLR")
                    
                    HStack {
                        Text("Friends Responses")
                            .foregroundColor(Color.secondary)
                        if (handler.interestedFriends.count + handler.goingFriends.count >= 2) {
                            Spacer()
                            
                            Button {
                                showAllResponses.toggle()
                            } label: {
                                Text("See All")
                            }

                        }
                    }
                    
                    Group {
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack {
                                
                                ForEach(handler.goingFriends, id: \.self) { friend in
                                    ZStack (alignment: .bottomTrailing) {
                                        NavigationLink(destination: friend.performer ? AnyView(PerformerProfileView(user: friend)
                                            .environmentObject(sessionService)
                                            .environmentObject(manager)
                                            .environmentObject(homeVM))
                                           : AnyView(UserProfileView(user: friend)
                                            .environmentObject(sessionService)
                                            .environmentObject(manager)
                                            .environmentObject(homeVM))) {
                                            WebImage(url: URL(string: friend.imageURL))
                                                    .resizable()
                                                   .scaledToFill()
                                                   .frame(width: 64, height: 64).cornerRadius(64)
                                                   .clipped()
                                          
      

                                       }
                                       Image(systemName: "checkmark.circle.fill")
                                           .resizable()
                                           .frame(width: 20, height: 20)
                                           .scaledToFit()
                                           .background(Color.white).cornerRadius(64)
                                           .foregroundColor(.green)
                                          
                                   }

                                }
                                .frame(maxWidth: 100, maxHeight: 120)
                                
                                ForEach(handler.interestedFriends, id: \.self) { friend in
                                    ZStack (alignment: .bottomTrailing) {
                                        NavigationLink(destination: friend.performer ? AnyView(PerformerProfileView(user: friend)
                                            .environmentObject(sessionService)
                                            .environmentObject(manager)
                                            .environmentObject(homeVM))
                                           : AnyView(UserProfileView(user: friend)
                                            .environmentObject(sessionService)
                                            .environmentObject(manager)
                                            .environmentObject(homeVM))) {
                                                WebImage(url: URL(string: friend.imageURL))
                                                        .resizable()
                                                       .scaledToFill()
                                                       .frame(width: 64, height: 64).cornerRadius(64)
                                                       .clipped()
      

                                       }
                                       Image(systemName: "bookmark.circle.fill")
                                           .resizable()
                                           .frame(width: 20, height: 20)
                                           .scaledToFit()
                                           .background(Color.white).cornerRadius(64)
                                           .foregroundColor(.gray)
                                          
                                   }
                                    
                                }
                                .frame(maxWidth: 100, maxHeight: 120)
                                
                            }
                            
//                                HStack {
//                                    ForEach(handler.interestedFriends, id: \.self) { friend in
//                                        NavigationLink(destination: UserProfileView(user: friend)
//                                                        .environmentObject(sessionService)
//                                                        .environmentObject(manager)
//                                                        .environmentObject(homeVM), label: {
//                                            VStack {
//                                                WebImage(url: URL(string: friend.imageURL))
//                                                    .resizable()
//                                                    .scaledToFill()
//                                                    .frame(width: 64, height: 64).cornerRadius(64)
//                                                    .clipped()
//                                            }
//                                        })
//                                    }
//                                    .frame(maxWidth: 100, maxHeight: 120)
//                                }
//                            }
                        }

                    }
                }
                
                

                Group {
                    Divider()
                    Text("Description")
                        .foregroundColor(Color.primary)
                    
//                    Text(event.description)
                    LongText(event.description, dark: true)
                        .padding(.bottom, 5)
                    
                    Divider()
                }
//                .padding(.vertical, 5)
                
                if handler.performers.count > 0 {
                    Group {
                        HStack {
                            Text("Groove Dealers")
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if Set(event.hostIDs).intersection(Set(sessionService.userDetails.pages)).count != 0 {
                                Button {
                                    self.editGrooveDealers = true
                                } label: {
                                    Text("Edit")
                                }

                                
                            }
                        }
                       
                        
                        VStack (alignment: .center, spacing: 0) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack (alignment: .center) {
                                    ForEach(handler.performers, id: \.self) { performer in
                                        PerfromerTile(user: performer)
                                            .environmentObject(sessionService)
    //                                        .environmentObject(homeVM)
    //                                        .environmentObject(manager)
                                        
                                    }
                                }
                            }
                        }
                        
                        Divider()
                    }
                }
                
                else if handler.performers.count == 0 && Set(event.hostIDs).intersection(Set(sessionService.userDetails.pages)).count != 0 {
                    Button {
                    } label: {
                        VStack {
                            Text("Add Groove Dealers?")
                            PerfromerTile(user: UserObj(firstName: "Groove", lastName: "Dealer", uid: "", imageURL: "https://firebasestorage.googleapis.com/v0/b/appluna.appspot.com/o/stockprofilepicture.png?alt=media&token=5fcd6739-6e52-4035-8f97-d2f8612840b8", friends: [], favourites: [], streak: 0, performer: true))
                        }
                        .highPriorityGesture(
                        TapGesture()
                            .onEnded {
                                self.editGrooveDealers = true
                            }
                        )
                    }
                    
                    Divider()
                }
                
                if handler.hosts.count > 0 {
                    
                    Group {
                        
                        
                        Text("Meet your hosts")
                        
    //                    HStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(handler.hosts, id: \.self) { host in
                                    MeetHostsTile(page: host)
                                        .environmentObject(sessionService)
                                        .environmentObject(homeVM)
                                        .environmentObject(manager)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, 5)
            .padding(.horizontal)
        }
        .background(Color("darkBackground"))
        .cornerRadius(20)
        .offset(y: -18)
    }
}
    
//struct EventViewNew_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let event = EventObj(creator: "", date: "23/01/2022", description: "From the people behind the Lost Paradise Festival and Paradise Club nights comes Lost Sundays – an expression of rhythm and dance, each and every Sunday afternoon at the recently transformed ivy.", endTime: "23:00", filename: "the ivy precinct", id: "", imageurl: "https://storage.googleapis.com/appluna.appspot.com/eventImages/4S4lYoQRZwWEw2cba46s/lost.png", label: "Lost Sundays", startTime: "20:00", creatorID: "", invited: [], going: [], interested: [], declined: [], performers: [], userCreated : false, linkedEvent: "", linkedVenue: "", address: "330 George St, Sydney NSW 2000", ticketLink: "www.google.com", hosts: [], hostNames: [])
//
//        EventViewNew(event : event)
//            .environmentObject(SessionServiceImpl())
//            .environmentObject(LocationManager())
//            .environmentObject(ViewModel())
//    }
//}
