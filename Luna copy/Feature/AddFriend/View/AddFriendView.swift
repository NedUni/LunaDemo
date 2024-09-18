////
////  AddFriendView.swift
////  Luna
////
////  Created by Ned O'Rourke on 2/3/22.
////
//
//import SwiftUI
//
//struct AddFriendView: View {
//    
//    @EnvironmentObject var sessionService: SessionServiceImpl
//    @EnvironmentObject var manager : LocationManager
//    @EnvironmentObject var homeVM : ViewModel
//    
//    @StateObject var lol = ContactsHandler()
//    @StateObject var xd = FetchContacts()
//    @State var toggle : Bool = false
//    @Binding var viewed: Bool
//    @State var contacts : [ContactInfo] = []
//    
//    @State var term = ""
//    
//    @State var search = false
//    
//    var body: some View {
//        ScrollView {
//            LazyVStack(alignment: .center, spacing: 5, pinnedViews: [.sectionHeaders]) {
//                Section(header:
//                            VStack {
//                                HStack{
//                                    Text("Contacts on LUNA")
//                                    Spacer()
//                                }
//                                .frame(height: 32)
//                    
//                                Divider()
//                            }
//                            .background(Color("darkBackground"))
//                            .padding(.horizontal)) {
//                    ForEach(lol.contactsOnLuna, id:\.self) { user in
//                        AddFriendTile(user: user)
//                            .environmentObject(sessionService)
//                            .environmentObject(manager)
//                            .environmentObject(homeVM)
//                    }
//                }
//                
//                Section(header:
//                            VStack {
//                    HStack (alignment: .center) {
//                                    Text("Suggested friends on Luna")
//                                    Spacer()
//                                }
//                                .frame(height: 32)
//                                
//                    
//                                Divider()
//                            }
//                            .background(Color("darkBackground"))
//                            .padding(.horizontal)) {
//
//                    ForEach(sessionService.mutualFriends, id: \.self) { user in
//                        AddFriendTile(user: user)
//                            .environmentObject(sessionService)
//                            .environmentObject(manager)
//                            .environmentObject(homeVM)
//                        
//                        
//                    }
//                }
//                
//                Section(header:
//                            VStack {
//                                HStack{
//                                    Text("Invite to Luna")
//                                    Spacer()
//                                }
//                                .frame(height: 32)
//                    
//                                Divider()
//                            }
//                                .background(Color("darkBackground"))
//                                .padding(.horizontal)) {
//                    ForEach(lol.contactsNotOnLuna, id:\.self) { user in
//                        HStack {
//                            InviteContactTileView(contact: user)
//                        }
//                    }
//                }
//            }
//        }
//        
//        .background(Color("darkBackground"))
////        .toolbar {
////            Image(systemName: "xmark")
////                .onTapGesture {
////                    self.showAddFriends = false
////                }
////        }
//        .onAppear {
//            self.viewed = false
//            
////            if !toggle {
//            xd.requestAccess(userID : sessionService.userDetails.uid, completion: {
//                    let queue = DispatchQueue(label: "homePage", attributes: .concurrent)
//
//                    if xd.contactsBool {
//                        DispatchQueue.main.async {
//                            self.contacts = xd.fetchingContacts()
//                            for contact in self.contacts {
//                                queue.async {lol.getContactsOnLuna(contact: contact, completion: {
//                                    toggle.toggle()
//                                })}
//                            }
//                       }
//                    }
//                })
//                
//                let queue = DispatchQueue(label: "homePage", attributes: .concurrent)
//
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
//
//                
////            }
//        }
//        .task{
//            await sessionService.getMutualFriends(uid: sessionService.userDetails.uid)
//        }
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: BackButtonView())
////        VStack {
////
////            if search == true {
////                TextField("Search Luna", text: $term)
////                    .padding(8)
////                    .background(Color.gray.opacity(0.5))
////                    .cornerRadius(5)
////                    .disableAutocorrection(true)
////                    .onChange(of: term) { newTerm in
////                        sessionService.searchVenues(term: term, option: 2)
////                    }
////                    .ignoresSafeArea(.keyboard)
////            }
////
////
////            ScrollView {
////                if sessionService.gettingMutualFriends == true {
////                    ProgressView()
////                        .progressViewStyle(CircularProgressViewStyle())
////                } else {
////
////                    if term == "" {
////                        ForEach(sessionService.mutualFriends, id: \.self) { friend in
////
////                            if !sessionService.userDetails.outgoingRequests.contains(friend.uid) {
////                                MutualFriendTileView(user: friend)
////                                    .environmentObject(sessionService)
////                                    .environmentObject(manager)
////                                    .environmentObject(homeVM)
////                                Divider()
////                            }
////
////
////                        }
////                    }
////
////                    else {
////                        ForEach(sessionService.searchPeopleResults, id: \.self) { user in
////                            if user.uid != sessionService.userDetails.uid {
////                                if sessionService.userDetails.friends.contains(user.uid) {
////                                    UserSearchTileView(user: user)
////                                        .environmentObject(sessionService)
////                                        .environmentObject(manager)
////                                        .environmentObject(homeVM)
////                                    Divider()
////
////                                }
////
////                                else {
////                                    MutualFriendTileView(user: user)
////                                        .environmentObject(sessionService)
////                                        .environmentObject(manager)
////                                        .environmentObject(homeVM)
////                                    Divider()
////                                }
////                            }
////
////                        }
////                    }
////
////                }
////            }
////
////            NavigationLink(destination: EmptyView()) {
////                EmptyView()
////            }
////
////        }
////        .onAppear {
////            sessionService.refreshUserDetails()
////            self.viewed = false
////        }
////        .padding(.horizontal)
////        .task{
////            await sessionService.getMutualFriends(uid: sessionService.userDetails.uid)
////        }
////        .navigationBarTitle("Add Friends", displayMode: .inline)
////        .navigationBarBackButtonHidden(true)
////        .toolbar {
////            ToolbarItemGroup(placement: .navigationBarTrailing) {
////
////                Button {
////                    Task {
////                        await sessionService.getMutualFriends(uid: sessionService.userDetails.uid)
////                    }
////                } label: {
////                    Image(systemName: "arrow.counterclockwise.circle.fill")
////                        .resizable()
////                        .scaledToFit()
////                        .frame(width: 30, height: 30)
////                        .foregroundColor(Color.primary)
////                        .colorInvert()
////                        .background(Color.primary).cornerRadius(20)
////                }
////
////                Button {
////                    withAnimation {
////                        search.toggle()
////                    }
////                } label: {
////                    Image(systemName: "magnifyingglass")
////                        .resizable()
////                        .scaledToFit()
////                        .foregroundColor(Color.primary)
////                        .frame(width: 24, height: 24)
////                }
////
////            }
////        }
////        .navigationBarItems(leading: BackButtonView())
//    }
//}
//
