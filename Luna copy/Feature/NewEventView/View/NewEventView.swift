//
//  NewEventView.swift
//  Luna
//
//  Created by Will Polich on 30/1/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Mixpanel

struct NewEventView: View {
    
    @StateObject var vm = EventHandler()
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var manager: LocationManager
    @Binding var showNewEvent: Bool
    @State var showMissingNameAlert : Bool = false
    @State var showBadTimeAlert : Bool = false
    @State var creating = false
    @Environment(\.presentationMode) var presentationMode
    
    @State var selectedTab = 1
    @State var shouldShowFriendsList = false
    @State var shouldShowNewLink = false
    @State var linkedEvent : EventObj?
    @State var linkedVenue : VenueObj?
    
    @State var wantToAbandon: Bool = false
    
    
    @State var presName : String = ""
    @State var presAddress : String = ""
    @State var presDate = Date.now
    @State var presDescription : String = ""
    
    @State var createBool = false
    
    var body: some View {
        NavigationView {
            
//            ZStack (alignment: .bottom) {
            ScrollView (showsIndicators: false) {
                    VStack (alignment: .leading, spacing: 15) {
                        
                        if linkedEvent != nil {
                            MyEventsEventView(event : linkedEvent!, clickable: true)
                                .environmentObject(sessionService)
                                .environmentObject(manager)
                                .padding(.horizontal)
                        }
                        
                        else if linkedVenue != nil {
                            
                            HStack {
                                
                                Spacer()
                                VenueTileView(ven: linkedVenue!)
                                    .environmentObject(sessionService)
                                    .environmentObject(manager)
                                Spacer()
                            }
                            
                            Divider()
                            
                        }
                        
                        
                        TextField("", text: $presName)
                            .font(.system(size: 20, weight: .heavy))
                            .multilineTextAlignment(TextAlignment.leading)
                            .foregroundColor(.white)
                            .disableAutocorrection(true)
                            .placeholder(when: presName.isEmpty, alignment: .leading) {
                                Text("Pres Name (Required)")
                                    .font(.system(size: 20, weight: .heavy))
                                    .foregroundColor(Color("darkSecondaryText")).opacity(0.3)
                            }
                            .onChange(of: presName, perform: { name in
                                if vm.invited.count != 0 && name != "" {
                                    withAnimation {
                                        createBool = true
                                    }
                                }
                                else {
                                    withAnimation {
                                        createBool = false
                                    }
                                }
                            })
                            .padding(.top)
                        
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
                            Text("Pres Date")
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(Color("darkSecondaryText")).opacity(0.3)
                        }
                        
                        Divider()
                        
                        ZStack {
                            TextEditor(text: $presDescription)
                                .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 300, alignment: .leading)
                                .padding(.trailing)
//                                .padding(.top, 6)
                                .padding(.leading, -2)
                                .foregroundColor(Color.primary)
                            
                            if presDescription == "" {
                                HStack {
                                    Text("Description")
                                        .font(.system(size: 20, weight: .heavy))
                                        .foregroundColor(Color("darkSecondaryText")).opacity(0.3)
                                        .padding(.trailing)
                                    Spacer()
                                }

                                    
                            }
                        }
                    }
                
//                .ignoresSafeArea(.keyboard)
                
//                Spacer()
                
                VStack (spacing: 5) {
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(vm.invited, id: \.self) { user in
                                if user.uid != sessionService.userDetails.uid {
                                    AsyncImage(url: URL(string: user.imageURL)) { image in
                                        image
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .cornerRadius(15)
                                            .scaledToFill()
                                            .clipped()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                            }
                        }
                    }
                        
                    HStack {
                        
                        Button {
                               shouldShowNewLink.toggle()
                        } label: {
                            VStack {
                                Text(linkedEvent == nil && linkedVenue == nil ? "Link Event" : "Change Link")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 40)
                            .background(.purple.opacity(0.3))
                            .cornerRadius(10)

                        }
                        
                        Button {
                                shouldShowFriendsList.toggle()
                        } label: {
                            VStack {
                                Text("Invite Friends")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 40)
                            .background(.purple.opacity(0.3))
                            .cornerRadius(10)

                        }
                    }
                    
//                    if createBool {
                    Button {
                        if creating {
                            return
                        }
                        if self.presName == "" {
                           self.showMissingNameAlert = true
                        }
                        
                        else if (presDate <= Date.now) {
                            showBadTimeAlert = true
                        }
                        
                        else {
                            creating = true
                            createBool = false
//                            vm.createPres(uid: sessionService.userDetails.uid, name: presName, description: presDescription, date: presDate, address: presAddress, linkedEvent: linkedEvent?.id ?? "", linkedVenue: linkedVenue?.id ?? "" , token: sessionService.userDetails.token, completion: {
//                                Task {
//                                    await homeVM.getMyEvents(uid: sessionService.userDetails.uid, token: sessionService.token)
//                                }
//                                creating = false
//                                showNewEvent = false
//                                Mixpanel.mainInstance().track(event: "Create Pres", properties: [
//                                    "numberOfInvites" : vm.invited.count,
//                                    "venueID" : linkedVenue?.id ?? "",
//                                    "eventID" : linkedEvent?.id ?? ""])
//
//                            })
                        }
                    } label: {
                        HStack {
                            if creating {
                                ProgressView()
                            } else {
                                Text("Create Pres")
                            }
                        }
                        .foregroundColor(.primary)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 40)
                        .background(createBool ? .purple.opacity(0.8) : .purple.opacity(0.3))
                        .cornerRadius(10)
                    }

                       
//                    }
                }
                }
                        
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.horizontal)
                .navigationTitle("Create Pres")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    Button (action: {
                        if presName != "" || presAddress != "" || presDescription != "" || vm.invited.count != 0 || linkedEvent != nil || linkedVenue != nil {
                            wantToAbandon.toggle()
                        }
                        else {
                            showNewEvent.toggle()
                        }
                    },
                        label: {
                        Image(systemName: "xmark")
                    })
                    .buttonStyle(.plain)
                }
                }
                .navigationBarHidden(true)
                .alert(isPresented: $showMissingNameAlert) {
                    Alert(title: Text("Missing Event Name"),
                          message: Text("Please provide a name for your event."),
                          dismissButton: .default(Text("Ok")) {
                        showMissingNameAlert.toggle()
                    })
                }
                .alert(isPresented: $showBadTimeAlert) {
                    Alert(title: Text("Invalid Time/Date"),
                          message: Text("The given date/time cannot be in the past."),
                          dismissButton: .default(Text("Ok")) {
                        showBadTimeAlert.toggle()
                    })
                }
            
                .alert("Are you sure you want to abandon progress?", isPresented: $wantToAbandon, actions: {
                      Button("Cancel", role: .cancel, action: {})

                      Button("I'm sure", role: .destructive, action: {
                          showNewEvent.toggle()})
                    }, message: {
                      Text("This can't be undone.")
                    })
            
                .sheet(isPresented: $shouldShowFriendsList, onDismiss: {
                    if vm.invited.count != 0 && presName != "" {
                        withAnimation {
                            createBool = true
                        }
                    }
                    else {
                        withAnimation {
                            createBool = false
                        }
                    }
                }) {
                    SendInvitesView(shouldShowFriendsList: $shouldShowFriendsList).environmentObject(vm)
                }
            
                .sheet(isPresented: $shouldShowNewLink, onDismiss: {
                    if vm.invited.count != 0 && presName != "" {
                        withAnimation {
                            createBool = true
                        }
                    }
                    else {
                        withAnimation {
                            createBool = false
                        }
                    }
                }) {
                    NewLinkView(linkedEvent: $linkedEvent, linkedVenue: $linkedVenue, shouldShowNewLink: $shouldShowNewLink)
                        .environmentObject(vm)
                        .environmentObject(homeVM)
                }
        
        
       
    }
}

struct NewEventView_Previews: PreviewProvider {
    @State static var showNewEvent = true
    
    static var previews: some View {
        NewEventView(showNewEvent: $showNewEvent)
    }
}
