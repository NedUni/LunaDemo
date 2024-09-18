//
//  PresView.swift
//  Luna
//
//  Created by Will Polich on 5/2/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct PresView: View {
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var vm : UserEventViewHandler
    @StateObject var handler = EventHandler()
//    @State var shouldShowResponses : Bool = false
    @State var showEditPres : Bool = false
//    @State var showInvites = false
//
    @State var event : EventObj
//    var linkedEvent : EventObj?
//    var linkedVenue : VenueObj?
//
    let df = DateFormatter()
    let calendar = Calendar.current
//
//    @State var going : Int = 0
//    @State var invited : Int = 0
//    @State var maybe : Int = 0
//    @State var buttonText : String = "Invited"
    @State var date = ""
    @State var startTime = ""
    @State var responseTab = 1
    @State var loaded = false
    
    @State var showResponses = false
    
//    @State var loading = false
    @State var options : [VenueObj] = []
    @State var showCastVote = false
    
    @State var imageURL = ""
//    @State var loaded = false
//
//    @State var shouldNavigateToEventChat = false
    
    
    var body: some View {
        
//        VStack {
//            Text("hey")
//        }
        
        VStack  {
            ScrollView {
                VStack (alignment: .leading) {
//                    if self.loaded {
                    if event.linkedEvent != "" || event.linkedVenue != "" {
                        WebImage(url: URL(string: event.linkedEvent == "" ? vm.linkedVenue!.imageurl : vm.linkedEvent!.imageurl))
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    else {
                        Image("usereventplaceholder")
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
//                    }
                    
                    VStack (alignment: .leading, spacing: 5) {
                        
                        Text(event.label)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                        
                        HStack {
                            if vm.eventResponse == "going" {
                                Button {
                                    vm.changeEventResponse(uid: sessionService.userDetails.uid, eventID: event.id, response: "invited") {
                                        vm.getEventResponse(uid: sessionService.userDetails.uid, eventID: event.id)
                                        vm.getPresInvited(eventID: event.id, completion: {})
                                        vm.getPresGoing(eventID: event.id, completion: {})
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "person.fill.checkmark")
                                            .foregroundColor(.primary)
                                        Text("I'll be there")
                                            .font(.system(size: 20))
                                            .foregroundColor(.primary)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
                                    .background(.purple)
                                    .cornerRadius(5)
                                }

                                
                            } else if vm.eventResponse == "invited" {
                                Button {
                                    vm.changeEventResponse(uid: sessionService.userDetails.uid, eventID: event.id, response: "going") {
                                        vm.getEventResponse(uid: sessionService.userDetails.uid, eventID: event.id)
                                        vm.getPresGoing(eventID: event.id, completion: {})
                                        vm.getPresInvited(eventID: event.id, completion: {})
                                    }
                                } label: {
                                        HStack {
                                            Image(systemName: "person.fill.checkmark")
                                                .foregroundColor(.primary)
                                            Text("I'll be there")
                                                .font(.system(size: 20))
                                                .foregroundColor(.primary)
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
                                        .background(.purple.opacity(0.5))
                                        .cornerRadius(5)
                                }
    
                                Button {
                                    vm.changeEventResponse(uid: sessionService.userDetails.uid, eventID: event.id, response: "interested") {
                                        vm.getEventResponse(uid: sessionService.userDetails.uid, eventID: event.id)
                                        vm.getPresInvited(eventID: event.id, completion: {})
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "person.fill.questionmark")
                                            .foregroundColor(.primary)
                                        Text("Not sure yet")

                                            .font(.system(size: 20))
                                            .foregroundColor(.primary)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
                                    .background(.purple.opacity(0.3))
                                    .cornerRadius(5)
    
                                }
                            } else if vm.eventResponse == "interested" {
                                Button {
                                    vm.changeEventResponse(uid: sessionService.userDetails.uid, eventID: event.id, response: "invited") {
                                        vm.getEventResponse(uid: sessionService.userDetails.uid, eventID: event.id)
                                        vm.getPresInvited(eventID: event.id, completion: {})
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "person.fill.questionmark")
                                            .foregroundColor(.primary)
                                        Text("Not sure yet")
                                            .font(.system(size: 20))
                                            .foregroundColor(.primary)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
                                    .background(.purple.opacity(0.3))
                                    .cornerRadius(5)
                                }
                            } else {
                                HStack {
                                    Text("Loading...")
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
                                .background(.purple.opacity(0.3))
                                .cornerRadius(5)
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            Image(systemName: "clock")
                            Text("on \(self.date) at \(self.startTime)")
                        }
                        
                        HStack {
                            Image(systemName: "mappin")
                            Text(event.address)
                                .lineLimit(1)
                        }
                        
                        if event.linkedVenue != "" || event.linkedEvent != "" {
                            HStack {
                                Image(systemName: "megaphone")
                                HStack (spacing: 0){
                                    Text("For ")
                                    NavigationLink(destination: event.linkedVenue == "" ? AnyView(EventViewNew(event: vm.linkedEvent!)) : AnyView(VenueView(ven: vm.linkedVenue!))) {
                                        Text("\(event.linkedVenue == "" ? vm.linkedEvent!.label : vm.linkedVenue!.displayname)")
                                            .fontWeight(.bold)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        
                        Divider()

                        Group {
                            Text("The Plan")
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                            
                            LongText(event.description, dark: true)
                            
                            Divider()
                            
                            Text("The Squad")
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                            
                            HStack (spacing: 5) {
                                NavigationLink(destination: UserResponsesView(selectedTab: 0, event: event)
                                    .environmentObject(vm)
                                    .environmentObject(manager)
                                    .environmentObject(sessionService)
                                    .environmentObject(homeVM)
                                    .environmentObject(handler)) {
                                        VStack {
                                            Text("Going")
                                            Text("\(vm.goingUsers.count)")
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, idealHeight: 55, maxHeight: 55, alignment: .center)
                                        .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("darkSecondaryText"), lineWidth: 0.5))
                                    }
                                    .simultaneousGesture(TapGesture().onEnded({
                                        vm.getPresInvited(eventID: event.id, completion: {})
                                        vm.getPresGoing(eventID: event.id, completion: {})
                                    }))
                                
                                NavigationLink(destination: UserResponsesView(selectedTab: 1, event: event)
                                    .environmentObject(vm)
                                    .environmentObject(manager)
                                    .environmentObject(sessionService)
                                    .environmentObject(homeVM)
                                    .environmentObject(handler)) {
                                        VStack {
                                            Text("Invited")
                                            Text("\(vm.invitedUsers.count)")
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, idealHeight: 55, maxHeight: 55, alignment: .center)
                                        .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("darkSecondaryText"), lineWidth: 0.5))
                                    }
                                    .simultaneousGesture(TapGesture().onEnded({
                                        vm.getPresInvited(eventID: event.id, completion: {})
                                        vm.getPresGoing(eventID: event.id, completion: {})
                                    }))
                                
                                
                                NavigationLink(destination: UserResponsesView(selectedTab: 2, event: event)
                                    .environmentObject(vm)
                                    .environmentObject(manager)
                                    .environmentObject(sessionService)
                                    .environmentObject(homeVM)
                                    .environmentObject(handler)) {
                                        VStack {
                                            Text("+1")
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, idealHeight: 55, maxHeight: 55, alignment: .center)
                                        .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("darkSecondaryText"), lineWidth: 0.5))
                                    }
                                    .simultaneousGesture(TapGesture().onEnded({
                                        vm.getPresInvited(eventID: event.id, completion: {})
                                        vm.getPresGoing(eventID: event.id, completion: {})
                                    }))
                                
                            }
                            .buttonStyle(.plain)
                            
                            Divider()
                            
//                            Group {
//                                Text("Poll")
//                                    .fontWeight(.bold)
//                                    .font(.system(size: 20))
//                                
//                                VStack {
//                                    
//                                    if vm.pollActive {
//                                        VStack {
//                                            ForEach(vm.pollData.sorted(by: >), id: \.key) { key, value in
//                                                VStack (alignment: .leading) {
//                                                    Text(key)
//                                                    ZStack {
//                                                        GeometryReader { proxy in
//                                                            Rectangle()
//                                                                .frame(height: 5, alignment: .leading)
//                                                                .frame(width: proxy.size.width)
//                                                                .cornerRadius(5)
//                                                            
//                                                            Rectangle()
//                                                                .frame(height: 5, alignment: .leading)
//                                                                .frame(width: proxy.size.width * value)
//                                                                .background(.red)
//                                                                .foregroundColor(.red)
//                                                                .cornerRadius(5)
//                                                        }
//                                                        .frame(height: 5)
//                                                    }
//                                                }
//                                                .onAppear {
////                                                    sessionService.getVenueByID(id: key) { venue in
////                                                        options.append(venue!)
//////                                                        print()
////                                                    }
//                                                }
//                                            }
//                                            
//                                            Spacer()
//                                            
//                                            Button {
//                                                self.showCastVote.toggle()
//                                            } label: {
//                                                Text("i wanna vote")
//                                            }
//
//                                        }
//                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
//                                        .padding(.horizontal)
//                                        .padding(.top)
//                                        
//                                    }
//                                    else {
//                                        Button {
//                                            print("request")
////                                            vm.getPollData(eventID: event.id, completion: {print("d")})
//                                        } label: {
//                                            Text("Request Poll for Location")
//                                        }
//                                    }
//                                    
//
//                                    
//                                }
//                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200, idealHeight: 200, maxHeight: 300, alignment: .topLeading)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 5)
//                                        .strokeBorder(Color("darkSecondaryText"), lineWidth: 0.5)
//                                )
//                                .padding(.bottom)
//                            }
                        }
                        
                        
                    }
                    .padding(.horizontal)
                    
                }
            }
            .background(Color("darkBackground"))
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .navigationBarItems(leading: BackButtonView())
//        .sheet(isPresented: $showCastVote, content: {
//            CastVoteView(dummyData: dummyData)
//
//        })
        .onAppear {
            if event.hostIDs.contains(sessionService.userDetails.uid) {
                vm.getPlusOnes(eventID: event.id, completion: {})
            }
            
            vm.getPresInvited(eventID: event.id, completion: {})
            vm.getPresGoing(eventID: event.id, completion: {})
            vm.getMaybeUsers(users: event.interested, token: sessionService.userDetails.token)
            vm.getGoingUsers(users: event.going, token: sessionService.userDetails.token)
            vm.getDeclinedUsers(users: event.declined, token: sessionService.userDetails.token)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"

            let date = dateFormatter.date(from: event.startTime)
            dateFormatter.dateFormat = "h:mm a"

            let Date12 = dateFormatter.string(from: date!)
            self.startTime = Date12

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
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                PresEllipsis(showEditPres: $showEditPres, event: $event)
                    .environmentObject(vm)
                    .environmentObject(homeVM)
                    .environmentObject(sessionService)
            }
        }
        
//           } else if event.linkedEvent != "" {
//                vm.getLinkedEvent(id: event.linkedEvent, token: sessionService.userDetails.token)
//               self.imageURL = vm.linkedEvent!.imageurl
//           }
                
//            if vm.linkedEvent != nil {
//
//            } else if vm.linkedVenue != nil {
//
//            }
//        }
        
//        ZStack (alignment: .bottom) {
//            Color("darkBackground")
//                .ignoresSafeArea()
//
////            VStack (alignment: .leading) {
////                    VStack (alignment: .leading) {
//            ScrollView {
//
//                if vm.linkedVenue != nil {
//
//                        NavigationLink(destination: VenueView(ven: vm.linkedVenue!)
//                            .environmentObject(sessionService)
//                            .environmentObject(manager)
//                            .environmentObject(homeVM)) {
//                                ZStack (alignment: .bottom) {
//                                    WebImage(url: URL(string: vm.linkedVenue!.imageurl))
//                                        .resizable()
//
//
////                                    HStack {
////                                        Text(vm.linkedVenue!.displayname)
////                                            .font(.system(size: 20))
////                                        Spacer()
////
////                                    }
////                                    .padding(.leading)
////                                    .padding(.trailing)
////                                    .frame(maxWidth: .infinity, maxHeight: 30, alignment: .bottomLeading)
////                                    .background(Color("darkBackground").opacity(0.8))
//                                }
//                                .frame(maxWidth: .infinity, maxHeight: 240, alignment: .bottomLeading)
//                                .multilineTextAlignment(.leading)
//                            }
//
//                }
//
//                else if vm.linkedEvent != nil {
//
//
//                    NavigationLink(destination: EventViewNew(event: vm.linkedEvent!)
//                        .environmentObject(sessionService)
//                        .environmentObject(manager)
//                        .environmentObject(homeVM)) {
//
//                            ZStack (alignment: .bottom) {
//                                WebImage(url: URL(string: vm.linkedEvent!.imageurl))
//                                    .resizable()
//
////                                HStack {
////                                    Text(vm.linkedEvent!.label)
////                                        .font(.system(size: 20)).bold()
////                                    Spacer()
////
////                                }
////                                .padding(.horizontal)
////                                .padding(.bottom, 2)
////                                .frame(maxWidth: .infinity, maxHeight: 30, alignment: .bottomLeading)
////                                .background(Color("darkBackground").opacity(0.8))
//                            }
//                            .frame(maxWidth: .infinity, maxHeight: 240, alignment: .bottomLeading)
//                            .multilineTextAlignment(.leading)
//                        }
//
//                } else {
//                    ZStack {
//                        Image("usereventplaceholder")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 240, height: 240)
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: 240)
//                    .multilineTextAlignment(.leading)
//                }
//
//                VStack (alignment: .leading) {
//
//                    VStack (alignment: .leading, spacing: 10) {
//                        Text(event.label)
//                            .fontWeight(.bold)
//
//                        HStack {
//                            Image(systemName: "clock")
//                            Text("\(self.date) at \(event.startTime)")
//                                .padding(.leading, 4)
//                        }
//
//
//                        if event.address != "" {
//                            Button(action: {
//                                let urlString = "maps://?address=\(event.address)"
//                                let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//                                let url = URL(string: encodedURL)
//
//                                if UIApplication.shared.canOpenURL(url!) {
//                                      UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//                                }
//
//                            }) {
//                                VStack (alignment: .leading) {
//                                    HStack {
//                                        Image(systemName: "mappin")
//                                        Text(event.address)
//                                            .padding(.leading, 5)
//                                            .lineLimit(1)
//                                        Image(systemName: "rectangle.portrait.and.arrow.right")
//                                            .font(.system(size: 13))
//
//                                    }
//                                    .foregroundColor(Color.primary)
//                                    .padding(.leading, 2.5)
//                                }
//                                .multilineTextAlignment(.leading)
//                            }
//                        }
//                    }
//
//                    HStack {
//                        if vm.eventResponse == "invited" {
//                            Button {
//                                vm.changeEventResponse(uid: sessionService.userDetails.uid, eventID: event.id, response: "going") {
//                                    vm.getEventResponse(uid: sessionService.userDetails.uid, eventID: event.id)
//                                }
//                            } label: {
//                                    VStack {
//                                        HStack {
//                                            Image(systemName: "person.fill.checkmark")
//                                                .foregroundColor(.primary)
//                                            Text("I'll be there")
//                                                .font(.system(size: 20))
//                                                .foregroundColor(.primary)
//                                        }
//                                    }
//                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
//                                    .background(.purple.opacity(0.5))
//                                    .cornerRadius(5)
//                            }
//
//                            Button {
//                                vm.changeEventResponse(uid: sessionService.userDetails.uid, eventID: event.id, response: "interested") {
//                                    vm.getEventResponse(uid: sessionService.userDetails.uid, eventID: event.id)
//                                }
//                            } label: {
//                                VStack {
//                                    HStack {
//                                        Image(systemName: "person.fill.questionmark")
//                                            .foregroundColor(.primary)
//                                        Text("Not sure yet")
//
//                                            .font(.system(size: 20))
//                                            .foregroundColor(.primary)
//                                    }
//
//                                }
//                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
//                                .background(.purple.opacity(0.3))
//                                .cornerRadius(5)
//
//                            }
//                        }
//
//                        else if vm.eventResponse == "going" {
//                            Button {
//                                vm.changeEventResponse(uid: sessionService.userDetails.uid, eventID: event.id, response: "invited") {
//                                    vm.getEventResponse(uid: sessionService.userDetails.uid, eventID: event.id)
//                                }
//                            } label: {
//                                VStack {
//                                    HStack {
//                                        Image(systemName: "person.fill.checkmark")
//                                            .foregroundColor(.primary)
//                                        Text("I'll be there")
//                                            .font(.system(size: 20))
//                                            .foregroundColor(.primary)
//                                    }
//
//                                }
//                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
//                                .background(.purple)
//                                .cornerRadius(5)
//                            }
//                        }
//
//                        else if vm.eventResponse == "interested" {
//                            Button {
//                                vm.changeEventResponse(uid: sessionService.userDetails.uid, eventID: event.id, response: "invited") {
//                                    vm.getEventResponse(uid: sessionService.userDetails.uid, eventID: event.id)
//                                }
//                            } label: {
//                                VStack {
//                                    HStack {
//                                        Image(systemName: "person.fill.questionmark")
//                                            .foregroundColor(.primary)
//                                        Text("Not sure yet")
//                                            .font(.system(size: 20))
//                                            .foregroundColor(.primary)
//                                    }
//
//                                }
//                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
//                                .background(.purple.opacity(0.3))
//                                .cornerRadius(5)
//                            }
//                        }
//
//                        else {
//                            VStack {
//                                Text("loading")
//                            }
//                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
//                        }
//                    }
//
//
//
//
//
//                    Divider()
//
//
//
//
//
//
//                    Group {
//
//
//
//                    }
//
//
//                    GeometryReader { proxy in
//                        HStack {
//                            Spacer()
//                            Button(action: {
//                                responseTab = 1
//                                shouldShowResponses.toggle()
//                            }, label: {
//                                VStack {
//                                    VStack {
//                                        Text(String(event.going.count))
//                                            .font(.system(size: 30))
//                                            .fontWeight(.bold)
//
//                                        Text("Going")
//                                            .font(.system(size: 15))
//                                            .fontWeight(.bold)
//
//                                    }
//                                    .frame(width: 80, height: 80, alignment: .center)
//                                    .background(.purple.opacity(0.3))
//                                    .cornerRadius(40)
//                                    .foregroundColor(.purple.opacity(0.8))
//
//
//                                }
//                                .padding(.trailing, 3)
//    //                            .overlay(
//    //                                RoundedRectangle(cornerRadius: 10)
//    //                                    .stroke(Color("darkSecondaryText"), lineWidth: 1)
//    //                            )
//    //                            .background(.purple.opacity(0.8))
//                            })
//
//                            Button(action: {
//                                responseTab = 3
//                                shouldShowResponses.toggle()
//                            }, label: {
//                                VStack {
//                                    VStack {
//                                        Text(String(event.invited.count))
//                                            .font(.system(size: 30))
//                                            .fontWeight(.bold)
//
//                                        Text("Invited")
//                                            .font(.system(size: 15))
//                                            .fontWeight(.bold)
//
//                                    }
//                                    .frame(width: 80, height: 80, alignment: .center)
//                                    .background(.purple.opacity(0.3))
//                                    .cornerRadius(40)
//                                    .foregroundColor(.purple.opacity(0.8))
//
//
//                                }
//                                .padding(3)
//                            })
//
//                            if event.hostIDs[0] == sessionService.userDetails.uid {
//                                Button(action: {
//                                    showInvites.toggle()
//                                }, label: {
//                                    VStack {
//                                        VStack {
//                                            Image(systemName: "plus")
//
//
//    //                                        Text("Invited")
//    //                                            .font(.system(size: 20))
//    //                                            .fontWeight(.bold)
//
//                                        }
//                                        .frame(width: 80, height: 80, alignment: .center)
//                                        .background(.purple.opacity(0.3))
//                                        .cornerRadius(40)
//                                        .foregroundColor(.purple.opacity(0.8))
//
//    //                                    Text("Invite")
//    //                                        .foregroundColor(.primary)
//                                    }
//                                    .padding(3)
//                                })
//                            }
//
//                            Button {
//                                shouldNavigateToEventChat.toggle()
//                            } label: {
//                                VStack {
//                                    VStack {
//                                        Image(systemName: "bubble.left")
//
//
//                                    }
//                                    .frame(width: 80, height: 80, alignment: .center)
//                                    .background(.purple.opacity(0.3))
//                                    .cornerRadius(40)
//                                    .foregroundColor(.purple.opacity(0.8))
//
//                                }
//                                .padding(.leading, 3)
//                            }
//
//
//                            NavigationLink("", isActive: $shouldNavigateToEventChat) {
//                                MessageView(shouldNavigateToEventChat: $shouldNavigateToEventChat, event: event)
//                                    .environmentObject(sessionService)
//                                    .environmentObject(manager)
//                                    .environmentObject(homeVM)
//                            }
//
//                            Spacer()
//                        }
//                        .frame(width: proxy.size.width, height: 80)
//
//                    }
//                    .frame(height: 80)
//
//
//
//
//                    if (vm.interestedFriends.count != 0 || vm.goingFriends.count != 0 || vm.invitedFriends.count != 0) {
//                        Divider()
//
//                        HStack {
//                            Text("Friends Responses")
//                                .foregroundColor(Color.secondary)
////                            if (vm.interestedFriends.count + vm.goingFriends.count >= 2) {
////                                Spacer()
////
////                                Button {
////                                    showAllResponses.toggle()
////                                } label: {
////                                    Text("See All")
////                                }
////
////                            }
//                        }
//
//                        Group {
//                            ScrollView (.horizontal, showsIndicators: false) {
//                                HStack {
//
//                                    ForEach(vm.goingFriends, id: \.self) { friend in
//                                        ZStack (alignment: .bottomTrailing) {
//                                            NavigationLink(destination: friend.performer ? AnyView(PerformerProfileView(user: friend)
//                                                .environmentObject(sessionService)
//                                                .environmentObject(manager)
//                                                .environmentObject(homeVM))
//                                               : AnyView(UserProfileView(user: friend)
//                                                .environmentObject(sessionService)
//                                                .environmentObject(manager)
//                                                .environmentObject(homeVM))) {
//                                                WebImage(url: URL(string: friend.imageURL))
//                                                   .resizable()
//                                                   .scaledToFill()
//                                                   .frame(width: 64, height: 64).cornerRadius(64)
//                                                   .clipped()
//
//
//
//                                           }
//                                           Image(systemName: "checkmark.circle.fill")
//                                               .resizable()
//                                               .frame(width: 20, height: 20)
//                                               .scaledToFit()
//                                               .background(Color.white).cornerRadius(64)
//                                               .foregroundColor(.green)
//
//                                       }
//
//                                    }
//                                    .frame(maxWidth: 100, maxHeight: 120)
//
//                                    ForEach(vm.interestedFriends, id: \.self) { friend in
//                                        ZStack (alignment: .bottomTrailing) {
//                                            NavigationLink(destination: friend.performer ? AnyView(PerformerProfileView(user: friend)
//                                                .environmentObject(sessionService)
//                                                .environmentObject(manager)
//                                                .environmentObject(homeVM))
//                                               : AnyView(UserProfileView(user: friend)
//                                                .environmentObject(sessionService)
//                                                .environmentObject(manager)
//                                                .environmentObject(homeVM))) {
//                                                WebImage(url: URL(string: friend.imageURL))
//                                                        .resizable()
//                                                       .scaledToFill()
//                                                       .frame(width: 64, height: 64).cornerRadius(64)
//                                                       .clipped()
//
//
//
//                                           }
//                                           Image(systemName: "questionmark.circle.fill")
//                                               .resizable()
//                                               .frame(width: 20, height: 20)
//                                               .scaledToFit()
//                                               .background(Color.white).cornerRadius(64)
//                                               .foregroundColor(.gray)
//
//                                       }
//
//                                    }
//                                    .frame(maxWidth: 100, maxHeight: 120)
//
//                                    ForEach(vm.invitedFriends, id: \.self) { friend in
//                                        ZStack (alignment: .bottomTrailing) {
//                                            NavigationLink(destination: friend.performer ? AnyView(PerformerProfileView(user: friend)
//                                                .environmentObject(sessionService)
//                                                .environmentObject(manager)
//                                                .environmentObject(homeVM))
//                                               : AnyView(UserProfileView(user: friend)
//                                                .environmentObject(sessionService)
//                                                .environmentObject(manager)
//                                                .environmentObject(homeVM))) {
//                                                WebImage(url: URL(string: friend.imageURL))
//                                                        .resizable()
//                                                       .scaledToFill()
//                                                       .frame(width: 64, height: 64).cornerRadius(64)
//                                                       .clipped()
//
//
//                                           }
//                                           Image(systemName: "paperplane.circle.fill")
//                                               .resizable()
//                                               .frame(width: 20, height: 20)
//                                               .scaledToFit()
//                                               .background(Color.white).cornerRadius(64)
//                                               .foregroundColor(Color("facade"))
//
//                                       }
//
//                                    }
//                                    .frame(maxWidth: 100, maxHeight: 120)
//
//                                }
//
//                            }
//                            .padding(.bottom, 5)
//
//                        }
//                    }
//
//                    if event.description != "" {
//                        Divider()
//
//
//                        VStack (alignment: .leading) {
//                            Text("Description")
//                            LongText(event.description, dark: true)
//
//                        }
//                    }
//
//                    Divider()
//
//
//
//                }
//                .padding(.horizontal)
//
//            }
//        }
//        .sheet(isPresented: $showInvites, onDismiss: {
//            vm.getEventResponse(uid: sessionService.userDetails.uid, eventID: event.id)
//            vm.getInterestedFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)
//            vm.getGoingFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)
//            vm.getInvitedFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)
//            handler.getAllUsers(event: event.id)
//        }, content: {
//            InviteView(event: $event, showInvites: $showInvites)
//                .environmentObject(handler)
//                .environmentObject(manager)
//                .environmentObject(sessionService)
//                .environmentObject(homeVM)
//        })
//        .sheet(isPresented: $shouldShowResponses, content: {
//            UserResponsesView(selectedTab: responseTab, event: event)
//                .environmentObject(vm)
//                .environmentObject(manager)
//                .environmentObject(sessionService)
//                .environmentObject(homeVM)
//        })
//        .sheet(isPresented: $showEditPres, content: { UpdatePresView(showEditPres: $showEditPres, event: event)
//            .environmentObject(sessionService)
//            .environmentObject(vm)
//            .environmentObject(homeVM)
//        })
//
//        .navigationBarBackButtonHidden(true)
//        .ignoresSafeArea()
//        .navigationBarItems(leading: BackButtonView())
//        .onAppear {
//
//            let queue = DispatchQueue(label: "pres", attributes: .concurrent)
//            queue.async { handler.getAllUsers(event: event.id)}
//            queue.async { vm.getEventResponse(uid: sessionService.userDetails.uid, eventID: event.id)}
//            queue.async { vm.getInterestedFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)}
//            queue.async { vm.getGoingFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)}
//            queue.async { vm.getInvitedFriends(uid: sessionService.userDetails.uid, eventID: event.id, token: sessionService.token)}
//            self.date = event.date
//
//            if event.linkedVenue != "" && self.linkedVenue == nil {
//                queue.async { vm.getLinkedVenue(id: event.linkedVenue, token: sessionService.userDetails.token)}
//            } else if event.linkedEvent != "" && self.linkedEvent == nil {
//                queue.async { vm.getLinkedEvent(id: event.linkedEvent, token: sessionService.userDetails.token)}
//            }
//
////            dateFormatter.dateFormat = "dd-MM-yyyy"
////            guard let dateObj = dateFormatter.date(from: event.date) else {return}
////
////            if calendar.isDateInToday(dateObj) {
////                self.date = "Today"
////            } else if calendar.isDateInTomorrow(dateObj) {
////                self.date = "Tomorrow"
////
////            } else if calendar.isDateInThisWeek(dateObj) {
////
////                dateFormatter.dateFormat = "EEEE"
////                let dayOfTheWeekString = dateFormatter.string(from: dateObj)
////                self.date = dayOfTheWeekString
////
////            }
//            dateFormatter.dateFormat = "dd-MM-yyyy"
//            guard let dateObj = dateFormatter.date(from: event.date) else {return}
//
//
//            if calendar.isDateInToday(dateObj) {
//                self.date = "Today"
//            } else if calendar.isDateInTomorrow(dateObj) {
//                self.date = "Tomorrow"
//
//            } else if calendar.isDateInThisWeek(dateObj) {
//
//                dateFormatter.dateFormat = "EEEE"
//                let dayOfTheWeekString = dateFormatter.string(from: dateObj)
//                self.date = dayOfTheWeekString
//            }
//
//            else {
//                let weekdays = [
//                            "Sun",
//                            "Mon",
//                            "Tues",
//                            "Wed",
//                            "Thurs",
//                            "Fri",
//                            "Sat"
//                        ]
//                let weekDay = calendar.component(.weekday, from: dateObj)
//                let day = calendar.component(.day, from: dateObj)
//                let month = calendar.component(.month, from: dateObj)
//                self.date = weekdays[weekDay - 1] + " \(day)/\(month)"
//            }
//
//        }
//        .if(event.hostIDs[0] == sessionService.userDetails.uid ) {
//            $0.navigationBarItems(trailing: PresEllipsis(showEditPres: $showEditPres, event: $event)
//                                    .environmentObject(vm)
//                                    .environmentObject(homeVM)
//                                    .environmentObject(sessionService)
//            )}
//
    }
    
}
    
    
    


extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}

struct PresView_Previews: PreviewProvider {
    
    static var previews: some View {
        
//        let linkedEvent = EventObj(date: "23/01/2022", description: "", endTime: "23:00", filename: "the ivy precinct", id: "", imageurl: "https://storage.googleapis.com/appluna.appspot.com/eventImages/4S4lYoQRZwWEw2cba46s/lost.png", label: "Lost Sundays", startTime: "20:00", creatorID: "", invited: [], going: [], interested: [], declined: [], userCreated: false)
        
        let event = EventObj(id: "", label: "Ned's pres for Ivanhoe Hotel", description: "", imageurl: "https://storage.googleapis.com/appluna.appspot.com/venueImages/0Ag3xBxsGflVCdbiObTw/234873793_6239743032704240_655567617756359616_n.jpeg", tags: [], date: "", startTime: "", endTime: "", invited: [], going: [], interested: [], declined: [], hostIDs: [], hostNames: [], performers: [], address: "", linkedVenueName: "", linkedVenue: "", linkedEvent: "", userCreated: true, pageCreated: false, ticketLink: "")
        
        PresView(event: event, responseTab: 1)
            .environmentObject(SessionServiceImpl())
            .environmentObject(LocationManager())
            .environmentObject(LocationManager())
            .environmentObject(UserEventViewHandler())
            .environmentObject(EventHandler())
        
        
//        @EnvironmentObject var sessionService : SessionServiceImpl
//        @EnvironmentObject var manager : LocationManager
//        @EnvironmentObject var homeVM : ViewModel
//        @StateObject var vm = UserEventViewHandler()
//        @StateObject var handler = EventHandler()
    }
    
    
}
