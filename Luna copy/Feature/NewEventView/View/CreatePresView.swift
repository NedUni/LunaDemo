//
//  CreatePresView.swift
//  Luna
//
//  Created by Ned O'Rourke on 5/6/2022.
//

import SwiftUI

struct CreatePresView: View {
    
    //Environment Objects
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var manager : LocationManager
    @StateObject var vm = EventHandler()
    
    //Error Handling
    @State var showError = false
    @State var error = ""
    
    //General
    @Binding var showCreatePres : Bool
    @State var currentIndex = 0
    @State var presName = ""
    @Binding var createdEvent : EventObj
    
    //Booleans
    @State var showInvite = false
    @State var isCreated = false
    @State var showLink = false
    
    //Case 0
    @State var linkedEvent : EventObj?
    @State var linkedVenue : VenueObj?
    @State var presAddress = ""
    @State var presDate = Date()
    
    //Case 1
    @State var presDescription = "Description"
    
    //Case 2
    
    @State var wantToAbandon: Bool = false
    @State var term : String = ""

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                switch currentIndex {
                    
                case 0:
                    VStack (alignment: .leading, spacing: 5) {
                        if linkedEvent != nil {
                            MyEventsEventView(event : linkedEvent!, clickable: true)
                                .environmentObject(sessionService)
                                .environmentObject(manager)
                                .highPriorityGesture(TapGesture().onEnded({self.showLink.toggle()}))
                        }
                        
                        else if linkedVenue != nil {
                            HStack {
                                Spacer()
                                VenueTileView(ven: linkedVenue!)
                                    .environmentObject(sessionService)
                                    .environmentObject(manager)
                                    .highPriorityGesture(TapGesture().onEnded({self.showLink.toggle()}))
                                Spacer()
                            }
                        }
                        
                        else {
                            VStack {
                                Image(systemName: "photo")
                                    .foregroundColor(.white)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200, maxHeight: 200, alignment: .center)
                            .background(.purple.opacity(0.3))
                            .cornerRadius(10)
                            .onTapGesture {
                                self.showLink.toggle()
                            }
                        }
                        
                        Divider()
                        
                        TextField("", text: $presAddress)
                            .font(.system(size: 20, weight: .heavy))
                            .multilineTextAlignment(TextAlignment.leading)
                            .foregroundColor(.white)
                            .disableAutocorrection(true)
                            .placeholder(when: presAddress.isEmpty, alignment: .leading) {
                                Text("Pres Address")
                                    .font(.system(size: 20, weight: .heavy))
                                    .foregroundColor(Color("darkSecondaryText")).opacity(0.3)
                            }
                        
                        Divider()
                        
                        DatePicker (
                                 selection: $presDate,
                                 displayedComponents: [.date, .hourAndMinute]
                        ) {
                            Text("Pres Time")
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(Color("darkSecondaryText")).opacity(0.3)
                        }
                        
                        Divider()
                        
                        Spacer()
                        
                        VStack {
                            
                            if self.showError {
                                Text(self.error)
                                    .foregroundColor(Color("Error"))
                                    .onAppear {
                                        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {
                                            timer in
                                            withAnimation {
                                                self.error = ""
                                                self.showError = false
                                            }
                                        }
                                    }
                            }
                            
                            
                            HStack (spacing: 5) {
                                ForEach(0..<3, id: \.self) { tab in
                                    Rectangle()
                                        .fill(tab <= self.currentIndex ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, idealHeight: 5, maxHeight: 5, alignment: .center)
                                        .cornerRadius(10)
                                }
                            }
                            
                            Button {
                                if self.presAddress == "" {
                                    self.error = "Looks like you forgot an address"
                                    self.showError = true
                                }
                                else if self.presDate <= Date() {
                                    self.error = "Looks like you forgot a date"
                                    self.showError = true
                                }
                                else {
                                    self.currentIndex += 1
                                }
                            } label: {
                                VStack {
                                    Text("Continue")
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
                                .background(self.presAddress != "" && self.presDate >= Date() ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }

                            
                        }
                    }
                    .padding(.horizontal)
                    
                case 1:
                    VStack (alignment: .leading, spacing: 5) {
                        Text("The plan (description)")
                            .foregroundColor(.white)
                        TextEditor(text: $presDescription)
                            .simultaneousGesture(TapGesture().onEnded({
                                if self.presDescription == "Description" {
                                    self.presDescription = ""
                                }
                            }))
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, idealHeight: 80, maxHeight: 150, alignment: .center)
                            .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("darkForeground"), lineWidth: 1))
                        
                        Spacer()
                        
                        VStack {
                            HStack (spacing: 5) {
                                ForEach(0..<3, id: \.self) { tab in
                                    Rectangle()
                                        .fill(tab <= self.currentIndex ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, idealHeight: 5, maxHeight: 5, alignment: .center)
                                        .cornerRadius(10)
                                }
                            }
                            
                            Button {
                                self.currentIndex += 1
                            } label: {
                                VStack {
                                    Text("Continue")
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
                                .background(.purple.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                case 2:
                    VStack (alignment: .leading, spacing: 5) {
                        
                        VStack {
                            TextField("Search Luna", text: $term)
                                .disableAutocorrection(true)
                                .padding(5)
                                .padding(.vertical, 5)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(5)
                                .onChange(of: term) { newTerm in
                                    sessionService.searchVenues(term: term, option: 2)
                                }
                                .padding(.horizontal)


                            ScrollView {
                                LazyVStack {
                                    if term != "" {
                                        ForEach(sessionService.searchPeopleResults, id: \.self) { user in
                                            InviteTileView(user: user, invited: true)
                                            
                                            if vm.invited.contains(user) {
                                                InviteTileView(user: user, invited: true)
                                                    .environmentObject(vm)
                                            } else {
                                                InviteTileView(user: user, invited: false)
                                                    .environmentObject(vm)
                                            }
                                        }

                                    }

                                    else {
                                            ForEach(sessionService.currentFriends, id: \.self) { user in
                                                if vm.invited.contains(user) {
                                                    InviteTileView(user: user, invited: true)
                                                        .environmentObject(vm)
                                                } else {
                                                    InviteTileView(user: user, invited: false)
                                                        .environmentObject(vm)
                                                }

                                                Divider()
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            Button {
                                if self.linkedEvent != nil {
                                    self.presName = "\(sessionService.userDetails.firstName)'s pres for \(self.linkedEvent!.label)"
                                }
                                else if self.linkedVenue != nil {
                                    self.presName = "\(sessionService.userDetails.firstName)'s pres for \(self.linkedVenue!.displayname)"
                                }
                                else {
                                    self.presName = "\(sessionService.userDetails.firstName)'s pres"
                                }
                                
                                vm.sendAllInvites()
                                
                                vm.createPres(uid: sessionService.userDetails.uid, name: self.presName, description: self.presDescription, date: self.presDate, address: self.presAddress, linkedEvent: self.linkedEvent?.id ?? "", linkedVenue: self.linkedVenue?.id ?? "", token: sessionService.userDetails.token) { id in
                                    Task {
                                        await homeVM.getMyEvents(uid: sessionService.userDetails.uid, token: sessionService.userDetails.uid)
                                    }
                                    self.showCreatePres = false
                                }
                            } label: {
                                VStack {
                                    Text("Create and Invite")
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
                                .background(vm.addedInvites.count > 0 ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                    }

                default:
                    Text("LOL")
                    
                }
                
                
            }
            .sheet(isPresented: $showLink) {
                NewLinkView(linkedEvent: $linkedEvent, linkedVenue: $linkedVenue, shouldShowNewLink: $showLink)
                    .environmentObject(vm)
                    .environmentObject(homeVM)
            }
            .navigationTitle("Create Pres")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showInvite) {
                SendInvitesView(shouldShowFriendsList: $showInvite)
                    .environmentObject(vm)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.showCreatePres.toggle()
                    } label: {
                        Image(systemName: "xmark")
                    }

                    
                }
            }
        }
        
        
    }
}

//struct CreatePresView_Previews: PreviewProvider {
//    static var previews: some View {
//
////        NavigationView {
//        CreatePresView(showCreatePres: .constant(true), freshEvent: .constant(true))
//            .environmentObject(ViewModel())
////        }
//    }
//}
