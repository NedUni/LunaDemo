//
//  ContentView.swift
//  Luna
//
//  Created by Ned O'Rourke on 27/4/2022.
//

import SwiftUI
import Mixpanel

struct ContactRow: View {
    var contact: ContactInfo
    var body: some View {
        Text("\(contact.firstName) \(contact.phoneNumber!.stringValue)").foregroundColor(.primary)
    }
}

struct ContentView2: View {
    
//    @State private var contacts = [ContactInfo.init(firstName: "", lastName: "", phoneNumber: nil)]
    @State var contacts : [ContactInfo] = []
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    @State private var numbers : [String] = []
    
    @StateObject var xd = FetchContacts()
    @StateObject var lol = ContactsHandler()
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    @State var toggle : Bool = false
    let queue = DispatchQueue(label: "homePage", attributes: .concurrent)
    
    @Binding var viewed: Bool
    @Binding var showAddFriends : Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .center, spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Section(header:
                                VStack {
                                    HStack{
                                        Text("Contacts on LUNA")
                                        Spacer()
                                    }
                                    .frame(height: 32)
                        
                                    Divider()
                                }
                                .background(Color("darkBackground"))
                                .padding(.horizontal)) {
                        ForEach(lol.contactsOnLuna, id:\.self) { user in
                            if !sessionService.userDetails.friends.contains(user.uid) && !sessionService.userDetails.outgoingRequests.contains(user.uid) && !sessionService.userDetails.incomingRequests.contains(user.uid) {
                                if user.uid != sessionService.userDetails.uid {
                                    AddFriendTile(user: user, queue: queue)
                                        .environmentObject(sessionService)
                                        .environmentObject(manager)
                                        .environmentObject(homeVM)
                                }
                                
                            }
                            
                        }
                    }
                    
                    Section(header:
                                VStack {
                        HStack (alignment: .center) {
                                        Text("Suggested friends on LUNA")
                                        Spacer()
                                    }
                                    .frame(height: 32)
                                    
                        
                                    Divider()
                                }
                                .background(Color("darkBackground"))
                                .padding(.horizontal)) {
 
                        ForEach(sessionService.mutualFriends, id: \.self) { user in
                            AddFriendTile(user: user, queue: queue)
                                .environmentObject(sessionService)
                                .environmentObject(manager)
                                .environmentObject(homeVM)
                                                            
                            
                        }
                    }
                    
                    Section(header:
                                VStack {
                                    HStack{
                                        Text("Invite to LUNA")
                                        Spacer()
                                    }
                                    .frame(height: 32)
                        
                                    Divider()
                                }
                                    .background(Color("darkBackground"))
                                    .padding(.horizontal)) {
                        ForEach(lol.contactsNotOnLuna, id:\.self) { user in
                            HStack {
                                InviteContactTileView(contact: user)
                            }
                        }
                    }
                }
            }
            .background(Color("darkBackground"))
            .toolbar {
                Image(systemName: "xmark")
                    .foregroundColor(Color.purple)
                    .onTapGesture {
                        self.showAddFriends = false
                    }
            }
            .onAppear {
                Mixpanel.mainInstance().track(event: "Add Friends View")
                
                self.viewed = false
                
//                if !toggle {
                xd.requestAccess(userID: sessionService.userDetails.uid, completion: {
                    print("success")
                        let queue = DispatchQueue(label: "getContacts", attributes: .concurrent)

//                        if xd.contactsBool {
                            DispatchQueue.main.async {
                                self.contacts = xd.fetchingContacts()
                                for contact in self.contacts {
                                    queue.async {lol.getContactsOnLuna(contact: contact, completion: {
                                        print("it is \(lol.contactsOnLuna)")
                                    })}
                                }
                           }
//                        }
                    })

                    
//                }
                
//                let queue = DispatchQueue(label: "homePage", attributes: .concurrent)

//                if xd.contactsBool {
//                    DispatchQueue.main.async {
//                        self.contacts = xd.fetchingContacts()
//                        for contact in self.contacts {
//                            queue.async {lol.getContactsOnLuna(contact: contact, completion: {
//                                toggle.toggle()
//                            })}
//                        }
//                   }
//                }
                
            }
            .task{
                await sessionService.getMutualFriends(uid: sessionService.userDetails.uid)
            }
            .navigationBarTitle("The more the merrier")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}
//            List {
//                Section(header: HStack {
//                    Text("friends on luna")
//                }) {
//                    ForEach(lol.contactsOnLuna, id:\.self) { user in
//                        FriendRequestTileView(user: user)
//                            .environmentObject(sessionService)
//                            .environmentObject(manager)
//                            .environmentObject(homeVM)
//                    }
//                }
//
//                Section(header: HStack {
//                    Text("friends on luna")
//                }) {
//                    ForEach(lol.contactsNotOnLuna, id:\.self) { user in
//                        HStack {
//                            InviteContactTileView(contact: user)
//                        }
//                    }
//                }
//            }
//            List {
//                ForEach (self.contacts.filter({ (cont) -> Bool in
//                    self.searchText.isEmpty ? true :
//                        "\(cont)".lowercased().contains(self.searchText.lowercased())
//                })) { contact in
////                    Text(\(contact.phoneNumber))
//                    ContactRow(contact: contact)
//                }
//            }
//            List(lol.contactsOnLuna) { penis in
//                Text(penis.firstName)
//            }
//            VStack {
//
//                ScrollView {
//                    ForEach(lol.contactsOnLuna, id:\.self) { user in
//                        FriendRequestTileView(user: user)
//                            .environmentObject(sessionService)
//                            .environmentObject(manager)
//                            .environmentObject(homeVM)
//                    }
//                }
//
//                ScrollView {
//                    ForEach(lol.contactsNotOnLuna, id:\.self) { user in
//                        HStack {
//                            InviteContactTileView(contact: user)
//                        }
//                    }
//                }
//            }
//        }


struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2(viewed: .constant(true), showAddFriends: .constant(true))
    }
}
