//
//  UserResponsesView.swift
//  Luna
//
//  Created by Will Polich on 1/2/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserResponsesView: View {
    
    @State var selectedTab : Int
    @EnvironmentObject var vm : UserEventViewHandler
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var handler : EventHandler
    
    var event : EventObj
    
    var body: some View {
        
        VStack (alignment: .leading) {
            guestListTopBar(currentTab: $selectedTab)
                .padding(.horizontal)
            ScrollView {
                VStack (alignment: .leading) {
                    if selectedTab == 0 {
                        ForEach(vm.goingUsers, id: \.self) { user in
                            if !event.hostIDs.contains(sessionService.userDetails.uid) {
                                userTile(user: user)
                                Divider()
                                
                            }
                            else {
                                if sessionService.userDetails.uid != user.uid {
                                    removeUserTile(user: user, event: event)
                                        .environmentObject(vm)
                                        .environmentObject(sessionService)
                                        .environmentObject(handler)
                                    Divider()
                                }
                                else {
                                    userTile(user: user)
                                    Divider()
                                }
                            }
                        }
                    } else if selectedTab == 1 {
                        ForEach(vm.invitedUsers, id: \.self) { user in
                            if !event.hostIDs.contains(sessionService.userDetails.uid) {
                                userTile(user: user)
                                Divider()
                            }
                            else {
                                if sessionService.userDetails.uid != user.uid {
                                    removeUserTile(user: user, event: event)
                                        .environmentObject(vm)
                                        .environmentObject(sessionService)
                                        .environmentObject(handler)
                                    Divider()
                                }
                            }
                        }
                        
                    } else if selectedTab == 2 {
                        if event.hostIDs.contains(sessionService.userDetails.uid) {
                            ForEach(vm.plusOnes, id : \.self) { user in
                                plusOneAcceptTile(user: user, event: event)
                                    .environmentObject(vm)
                                    .environmentObject(sessionService)
                                    .environmentObject(handler)
                                Divider()
                            }
                            
                            ForEach(sessionService.currentFriends, id : \.self) { user in
                                if !vm.invitedUsers.contains(user) && !vm.goingUsers.contains(user) && !vm.plusOnes.contains(user) {
                                    addUserTile(user: user, event: event)
                                        .environmentObject(vm)
                                        .environmentObject(sessionService)
                                        .environmentObject(handler)
                                    Divider()
                                }
                            }
                        }
                        else {
                            ForEach(sessionService.currentFriends, id: \.self) { user in
                                if !vm.invitedUsers.contains(user) && !vm.goingUsers.contains(user) && !vm.plusOnes.contains(user) {
                                    plusOneTile(user: user, event: event)
                                        .environmentObject(vm)
                                    Divider()
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
        .background(Color("darkBackground"))
        .navigationBarTitle("Responses")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView())
//            vm.getInvitedUsers(users: event.invited, token: sessionService.userDetails.token, completion: {})
//            vm.getMaybeUsers(users: event.interested, token: sessionService.userDetails.token)
//            vm.getGoingUsers(users: event.going, token: sessionService.userDetails.token)
//            vm.getDeclinedUsers(users: event.declined, token: sessionService.userDetails.token)
//        .onAppear {
//                        vm.getInvitedUsers(users: event.invited, token: sessionService.userDetails.token)
//                        vm.getMaybeUsers(users: event.interested, token: sessionService.userDetails.token)
//                        vm.getGoingUsers(users: event.going, token: sessionService.userDetails.token)
//                        vm.getDeclinedUsers(users: event.declined, token: sessionService.userDetails.token)
//                    }
//        NavigationView {
//            VStack {
//
//                if event.endTime != "" {
//                    ScrollView {
//                        Picker(selection: $selectedTab, label: Text("Picker")) {
//                            Text("Going").tag(1)
//                            Text("Maybe").tag(2)
//                            Text("Invited").tag(3)
//                            Text("Can't Go").tag(4)
//
//                        }.pickerStyle(SegmentedPickerStyle())
//
//                        if selectedTab == 1 {
//                            ForEach(vm.goingUsers, id: \.self) { user in
//                                NavigationLink(destination: user.uid == sessionService.userDetails.uid ? AnyView(ProfileView()
//                                                .environmentObject(manager)
//                                                .environmentObject(sessionService)
//                                                .environmentObject(homeVM)) : (user.performer ? AnyView(PerformerProfileView(user: user)
//                                                    .environmentObject(sessionService)
//                                                    .environmentObject(manager)
//                                                    .environmentObject(homeVM))
//                                                   : AnyView(UserProfileView(user: user)
//                                                    .environmentObject(sessionService)
//                                                    .environmentObject(manager)
//                                                    .environmentObject(homeVM))), label: {
//                                    HStack {
//
//                                        WebImage(url: URL(string: user.imageURL))
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(width: 64, height: 64).cornerRadius(64)
//                                            .clipped()
//                                            .padding()
////                                        AsyncImage(url: URL(string: user.imageURL)) {image in
////                                            image.resizable()
////                                                .scaledToFill()
////                                                .frame(width: 64, height: 64).cornerRadius(64)
////                                                .clipped()
////                                                .padding()
////                                        } placeholder: {
////                                            ProgressView()
////                                                .scaledToFill()
////                                                .frame(width: 64, height: 64).cornerRadius(64)
////                                                .clipped()
////                                                .padding()
////                                        }
//
//                                        Text("\(user.firstName) \(user.lastName)")
//                                            .font(.system(size: 20))
//                                            .foregroundColor(Color.primary)
//
//                                        Spacer()
//                                    }
//                                })
//
//                                Divider()
//
//                            }
//                        } else if selectedTab == 2 {
//
//                            ForEach(vm.maybeUsers, id: \.self) { user in
//                                NavigationLink(destination: user.uid == sessionService.userDetails.uid ? AnyView(ProfileView()
//                                                .environmentObject(vm)
//                                                .environmentObject(manager)
//                                                .environmentObject(sessionService)
//                                                .environmentObject(homeVM)) : (user.performer ? AnyView(PerformerProfileView(user: user)
//                                                    .environmentObject(sessionService)
//                                                    .environmentObject(manager)
//                                                    .environmentObject(homeVM))
//                                                   : AnyView(UserProfileView(user: user)
//                                                    .environmentObject(sessionService)
//                                                    .environmentObject(manager)
//                                                    .environmentObject(homeVM))), label: {
//                                    HStack {
//
//                                        WebImage(url: URL(string: user.imageURL))
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(width: 64, height: 64).cornerRadius(64)
//                                            .clipped()
//                                            .padding()
////                                        AsyncImage(url: URL(string: user.imageURL)) {image in
////                                            image.resizable()
////                                                .scaledToFill()
////                                                .frame(width: 64, height: 64).cornerRadius(64)
////                                                .clipped()
////                                                .padding()
////                                        } placeholder: {
////                                            ProgressView()
////                                                .scaledToFill()
////                                                .frame(width: 64, height: 64).cornerRadius(64)
////                                                .clipped()
////                                                .padding()
////                                        }
//
//                                        Text("\(user.firstName) \(user.lastName)")
//                                            .font(.system(size: 20))
//                                            .foregroundColor(Color.primary)
//
//                                        Spacer()
//                                    }
//                                })
//
//                                Divider()
//
//                            }
//                        } else if selectedTab == 3 {
//                            ForEach(vm.invitedUsers, id: \.self) { user in
//                                NavigationLink(destination: user.uid == sessionService.userDetails.uid ? AnyView(ProfileView()
//                                                .environmentObject(vm)
//                                                .environmentObject(manager)
//                                                .environmentObject(sessionService)
//                                                        .environmentObject(homeVM)) : user.performer ? AnyView(PerformerProfileView(user: user)
//                                                            .environmentObject(sessionService)
//                                                            .environmentObject(manager)
//                                                            .environmentObject(homeVM))
//                                                           : AnyView(UserProfileView(user: user)
//                                                            .environmentObject(sessionService)
//                                                            .environmentObject(manager)
//                                                            .environmentObject(homeVM))
//                                        , label: {
//                                    HStack {
//
//                                        WebImage(url: URL(string: user.imageURL))
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(width: 64, height: 64).cornerRadius(64)
//                                            .clipped()
//                                            .padding()
////                                        AsyncImage(url: URL(string: user.imageURL)) {image in
////                                            image.resizable()
////                                                .scaledToFill()
////                                                .frame(width: 64, height: 64).cornerRadius(64)
////                                                .clipped()
////                                                .padding()
////                                        } placeholder: {
////                                            ProgressView()
////                                                .scaledToFill()
////                                                .frame(width: 64, height: 64).cornerRadius(64)
////                                                .clipped()
////                                                .padding()
////                                        }
//
//                                        Text("\(user.firstName) \(user.lastName)")
//                                            .font(.system(size: 20))
//                                            .foregroundColor(Color.primary)
//
//                                        Spacer()
//                                    }
//                                })
//
//                                Divider()
//
//                            }
//                        } else if selectedTab == 4 {
//                            ForEach(vm.declinedUsers, id: \.self) { user in
//                                NavigationLink(destination: user.uid == sessionService.userDetails.uid ? AnyView(ProfileView()
//                                                .environmentObject(vm)
//                                                .environmentObject(manager)
//                                                .environmentObject(sessionService)
//                                                        .environmentObject(homeVM)) : (user.performer ? AnyView(PerformerProfileView(user: user)
//                                                            .environmentObject(sessionService)
//                                                            .environmentObject(manager)
//                                                            .environmentObject(homeVM))
//                                                           : AnyView(UserProfileView(user: user)
//                                                            .environmentObject(sessionService)
//                                                            .environmentObject(manager)
//                                                            .environmentObject(homeVM))), label: {
//                                    HStack {
//
////                                        AsyncImage(url: URL(string: user.imageURL)) {image in
////                                            image.resizable()
////                                                .scaledToFill()
////                                                .frame(width: 64, height: 64).cornerRadius(64)
////                                                .clipped()
////                                                .padding()
////                                        } placeholder: {
////                                            ProgressView()
////                                                .scaledToFill()
////                                                .frame(width: 64, height: 64).cornerRadius(64)
////                                                .clipped()
////                                                .padding()
////                                        }
//                                        WebImage(url: URL(string: user.imageURL))
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(width: 64, height: 64).cornerRadius(64)
//                                            .clipped()
//                                            .padding()
//                                        Text("\(user.firstName) \(user.lastName)")
//                                            .font(.system(size: 20))
//                                            .foregroundColor(Color.primary)
//
//                                        Spacer()
//                                    }
//                                })
//
//                                Divider()
//
//                            }
//                        }
//
//                    }
//                } else {
//                    ScrollView {
//                        Picker(selection: $selectedTab, label: Text("Picker")) {
//                            Text("Going").tag(1)
//                            Text("Invited").tag(3)
//
//                        }.pickerStyle(SegmentedPickerStyle())
//
//                        if selectedTab == 1 {
//                            ForEach(vm.goingUsers, id: \.self) { user in
//                                NavigationLink(destination: user.uid == sessionService.userDetails.uid ? AnyView(ProfileView()
//                                                .environmentObject(vm)
//                                                .environmentObject(manager)
//                                                .environmentObject(sessionService)
//                                                        .environmentObject(homeVM)) : (user.performer ? AnyView(PerformerProfileView(user: user)
//                                                            .environmentObject(sessionService)
//                                                            .environmentObject(manager)
//                                                            .environmentObject(homeVM))
//                                                           : AnyView(UserProfileView(user: user)
//                                                            .environmentObject(sessionService)
//                                                            .environmentObject(manager)
//                                                            .environmentObject(homeVM))), label: {
//                                    HStack {
//
////                                        AsyncImage(url: URL(string: user.imageURL)) {image in
////                                            image.resizable()
////                                                .scaledToFill()
////                                                .frame(width: 64, height: 64).cornerRadius(64)
////                                                .clipped()
////                                                .padding()
////                                        } placeholder: {
////                                            ProgressView()
////                                                .scaledToFill()
////                                                .frame(width: 64, height: 64).cornerRadius(64)
////                                                .clipped()
////                                                .padding()
////                                        }
//                                        WebImage(url: URL(string: user.imageURL))
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(width: 64, height: 64).cornerRadius(64)
//                                            .clipped()
//                                            .padding()
//
//                                        Text("\(user.firstName) \(user.lastName)")
//                                            .font(.system(size: 20))
//                                            .foregroundColor(Color.primary)
//
//                                        Spacer()
//                                    }
//                                })
//
//                                Divider()
//
//                            }
//
//                        } else if selectedTab == 3 {
//                            ForEach(vm.invitedUsers, id: \.self) { user in
//                                NavigationLink(destination: user.uid == sessionService.userDetails.uid ? AnyView(ProfileView()
//                                                .environmentObject(vm)
//                                                .environmentObject(manager)
//                                                .environmentObject(sessionService)
//                                                .environmentObject(homeVM)) : (user.performer ? AnyView(PerformerProfileView(user: user)
//                                                    .environmentObject(sessionService)
//                                                    .environmentObject(manager)
//                                                    .environmentObject(homeVM))
//                                                   : AnyView(UserProfileView(user: user)
//                                                    .environmentObject(sessionService)
//                                                    .environmentObject(manager)
//                                                    .environmentObject(homeVM))), label: {
//                                    HStack {
//
////                                        AsyncImage(url: URL(string: user.imageURL)) {image in
////                                            image.resizable()
////                                                .scaledToFill()
////                                                .frame(width: 64, height: 64).cornerRadius(64)
////                                                .clipped()
////                                                .padding()
////                                        } placeholder: {
////                                            ProgressView()
////                                                .scaledToFill()
////                                                .frame(width: 64, height: 64).cornerRadius(64)
////                                                .clipped()
////                                                .padding()
////                                        }
//                                        WebImage(url: URL(string: user.imageURL))
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(width: 64, height: 64).cornerRadius(64)
//                                            .clipped()
//                                            .padding()
//
//
//                                        Text("\(user.firstName) \(user.lastName)")
//                                            .font(.system(size: 20))
//                                            .foregroundColor(Color.primary)
//
//                                        Spacer()
//                                    }
//                                })
//
//                                Divider()
//
//                            }
//
//                        }
//
//                    }
//                }
//
//
//            }
//            .applyClose()
//            .navigationBarTitle("Responses", displayMode: .inline)
//            .onAppear {
//                vm.getInvitedUsers(users: event.invited, token: sessionService.userDetails.token)
//                vm.getMaybeUsers(users: event.interested, token: sessionService.userDetails.token)
//                vm.getGoingUsers(users: event.going, token: sessionService.userDetails.token)
//                vm.getDeclinedUsers(users: event.declined, token: sessionService.userDetails.token)
//            }
//
//
//        }
        
       
        
        
    }
}

struct userTile: View {
    
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    
    @State var user : UserObj
    
    var body: some View {
     
        NavigationLink(destination: user.performer ? AnyView(PerformerProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM))
           : AnyView(UserProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM))) {
                HStack {
                    
                    WebImage(url: URL(string: user.imageURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(25)
                    
                    Text("\(user.firstName) \(user.lastName)")
                }
            }
            .buttonStyle(.plain)
    }
}



struct plusOneTile: View {
    
    @State var user : UserObj
    @State var event : EventObj
    
    @EnvironmentObject var vm : UserEventViewHandler
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    
    var body: some View {
        
        NavigationLink(destination: user.performer ? AnyView(PerformerProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM))
           : AnyView(UserProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM))) {
                HStack {
                    
                    WebImage(url: URL(string: user.imageURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(25)
                    
                    Text("\(user.firstName) \(user.lastName)")
                    
                    Spacer()
                    
                    Button {
                        vm.requestPlusOne(uid: user.uid, eventID: event.id) {
                            vm.getPlusOnes(eventID: event.id, completion: {
                                vm.getPresInvited(eventID: event.id, completion: {})
                            })
                        }
                    } label: {
                        Text("Request +1")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .padding(5)
                            .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("darkSecondaryText"), lineWidth: 0.5))
                    }
                    .buttonStyle(.plain)

                    
                    
                }
            }
            .buttonStyle(.plain)
    }
}

struct plusOneAcceptTile: View {
    
    @State var user : UserObj
    @State var event : EventObj
    
    @EnvironmentObject var vm : UserEventViewHandler
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var handler: EventHandler
    
    var body: some View {
        
        NavigationLink(destination: user.performer ? AnyView(PerformerProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM))
           : AnyView(UserProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM))) {
                
                HStack {
                    
                    WebImage(url: URL(string: user.imageURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(25)
                    
                    Text("\(user.firstName) \(user.lastName)")
                    
                    Spacer()
                    
                    Button {
                        vm.acceptPlusOne(uid: user.uid, eventID: event.id) {
                            vm.getPlusOnes(eventID: event.id, completion: {
                                vm.getPresInvited(eventID: event.id, completion: {
                                    vm.getPresGoing(eventID: event.id, completion: {})
                                })
                            })
                        }
                    } label: {
                        Text("Accept")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .padding(5)
                            .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("darkSecondaryText"), lineWidth: 0.5))
                    }
                    .buttonStyle(.plain)

                    
                    
                }
            }
            .buttonStyle(.plain)
    }
}

struct addUserTile: View {
    
    @State var user : UserObj
    @State var event : EventObj
    
    @EnvironmentObject var vm : UserEventViewHandler
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var handler : EventHandler
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var manager: LocationManager
    
    var body: some View {
        
        NavigationLink(destination: user.performer ? AnyView(PerformerProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM))
           : AnyView(UserProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM))) {
                HStack {
                    
                    WebImage(url: URL(string: user.imageURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(25)
                    
                    Text("\(user.firstName) \(user.lastName)")
                    
                    Spacer()
                    
                    Button {
                        handler.inviteToPres(eventID: event.id, uid: user.uid, completion: {
                            vm.getPresInvited(eventID: event.id, completion: {})
                            vm.getPresGoing(eventID: event.id, completion: {})
                            vm.getPlusOnes(eventID: event.id, completion: {})
                        })
                        
                    } label: {
                        Text("Add")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .padding(5)
                            .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("darkSecondaryText"), lineWidth: 0.5))
                    }
                    .buttonStyle(.plain)

                    
                    
                }
            }
            .buttonStyle(.plain)
    }
}

struct removeUserTile: View {
    
    @State var user : UserObj
    @State var event : EventObj
    
    @EnvironmentObject var vm : UserEventViewHandler
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var handler : EventHandler
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var manager: LocationManager
    
    var body: some View {
     
        NavigationLink(destination: user.performer ? AnyView(PerformerProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM))
           : AnyView(UserProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM))) {
                HStack {
                    
                    WebImage(url: URL(string: user.imageURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(25)
                    
                    Text("\(user.firstName) \(user.lastName)")
                    
                    Spacer()
                    
                    Button {
                        handler.removeFromPres(eventID: event.id, uid: user.uid, completion: {
                            vm.getPresInvited(eventID: event.id, completion: {})
                            vm.getPresGoing(eventID: event.id, completion: {})
                        })
                        
                    } label: {
                        Text("Remove")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .padding(5)
                            .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("darkSecondaryText"), lineWidth: 0.5))
                    }
                    .buttonStyle(.plain)
                    
                    
                    
                }
            }
            .buttonStyle(.plain)
    }
}

struct guestListTopBar: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    var tabBarOptions: [String] = ["Going", "Invited", "Plus One"]
    
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
//struct UserResponsesView_Previews: PreviewProvider {
//    
//    @StateObject static var vm = UserEventViewHandler()
//        
//    static var previews: some View {
//        
//        let event = EventObj(creator: "", date: "23/01/2022", description: "Let's trot", endTime: "23:00", filename: "", id: "", imageurl: "https://s3-ap-southeast-2.amazonaws.com/production.assets.merivale.com.au/wp-content/uploads/2019/07/15171723/lost_sundays_gallery_2.jpg", label: "Summer Solstice Party", startTime: "20:00", creatorID: "", invited: ["QV8WKYu09tUxjj5Iai827aBbbXD2"], going: [], interested: [], declined: [], performers: [], userCreated : true, linkedEvent: "", linkedVenue: "", address: "", ticketLink: "", hosts: [], hostNames: [])
//        
//        UserResponsesView(selectedTab: 1, event: event)
//            .environmentObject(vm)
//    }
//}
