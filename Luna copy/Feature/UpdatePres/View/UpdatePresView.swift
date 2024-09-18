//
//  UpdatePresView.swift
//  Luna
//
//  Created by Will Polich on 8/2/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct UpdatePresView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var handler : UserEventViewHandler
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    @StateObject var vm = EventHandler()
    @Environment(\.presentationMode) var presentationMode
    @State var showAlert : Bool = false
    let dateFormatter = DateFormatter()
    
    @Binding var showEditPres: Bool
    @State var event : EventObj

    
    @State var selectedTab = 1
    @State var name : String = ""
    @State var description: String = ""
    @State var address: String = ""
    @State var date : Date = Date.now
    @State var startTime: Date = Date.now
    @State var shouldShowImagePicker = false
    @State var shouldShowFriendsList = false
    @State var shouldShowNewLink = false
    @State var image: UIImage?
    @State var linkedEvent : EventObj?
    @State var linkedVenue : VenueObj?
    
    @State var wantToAbandon: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                    
                VStack (spacing: 16) {
                    
                    
                    TextInputView(text: $name,
                                  placeholder: "Pres Name (Required)",
                                  keyboardType: .default,
                                  sfSymbol: nil)
                    
                    
                    TextInputView(text: $address,
                                  placeholder: "Address",
                                  keyboardType: .default,
                                  sfSymbol: nil)
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .frame(maxWidth: .infinity,
                                minHeight: 44)
                        .padding(.trailing)
                        .padding(.leading)

                        .foregroundColor(Color.gray.opacity(0.5))
                        .background (
                            ZStack(alignment: .leading) {

                                RoundedRectangle(cornerRadius: 44,
                                                 style: .continuous)
                                    .stroke(Color.gray.opacity(0.5))
                            }
                        )
                    
                    DatePicker("Time", selection: $startTime, displayedComponents: .hourAndMinute)
                        .frame(maxWidth: .infinity,
                                minHeight: 44)
                        .padding(.trailing)
                        .padding(.leading)

                        .foregroundColor(Color.gray.opacity(0.5))
                        .background (
                            ZStack(alignment: .leading) {

                                RoundedRectangle(cornerRadius: 44,
                                                 style: .continuous)
                                    .stroke(Color.gray.opacity(0.5))
                            }
                        )
                    ZStack {
                        
                        TextEditor(text: $description)
                            .frame(maxWidth: .infinity,
                                    minHeight: 44)
                            .padding(.trailing)
                            .padding(.leading, 12)
                            .padding(.top, 6)
                            .foregroundColor(Color.primary)
                        
                        if description == "" {
                            HStack {
                                Text("Description")
                                    .foregroundColor(Color.gray.opacity(0.5))
                                    .padding(.leading)
                                    .padding(.trailing)
                                Spacer()
                            }

                                
                        }
                    }
                    .overlay (
                        RoundedRectangle(cornerRadius: 44,
                                         style: .continuous)
                            .stroke(Color.gray.opacity(0.5))
                    )
                    
                    
                    Divider()
                }.padding()
                
                if vm.invited.count != 0 {
                   
                    Text("Invited")
                    
                    ScrollView (.horizontal) {
                        HStack {
                            ForEach(vm.invited, id: \.self) { user in
                                if user.uid != sessionService.userDetails.uid {
                                    AsyncImage(url: URL(string: user.imageURL)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(100)
                                           
                                            .clipped()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                        
                                       
                                }
                                
                            
                            }
                        } .padding()
                    }
                       
                }
                
                VStack (spacing:24) {
                    
                    if linkedEvent == nil && linkedVenue == nil {
                        HStack {
                            Spacer()
                            Button(action: {
                                shouldShowNewLink.toggle()
                            }, label: {
                                Text("Link Event / Venue")
                                    .foregroundColor(Color.primary)
                            })
                            
                            Image(systemName: "link")
                            Spacer()
                        }
                        .frame(width: 288, height: 40)
                        .overlay (
                            RoundedRectangle(cornerRadius: 44,
                                             style: .continuous)
                                .stroke(Color.primary)
                        )
                    } else if linkedEvent != nil {
                        HStack {
                            Text("Linked Event")
                            Image(systemName: "link")
                        }
                        
                        Button(action: {
                            shouldShowNewLink.toggle()
                        }, label: {
                            Text("Change")
                        })
                        if linkedEvent?.userCreated == true {
                            UserEventTileView(event: linkedEvent!, clickable: false)
                                .padding(.horizontal)
                        } else {
                            EventTileView(event : linkedEvent!, clickable: false)
                                .padding(.horizontal)
                        }
                       
                        
                    } else if linkedVenue != nil {
                        HStack {
                            Text("Linked Venue")
                            Image(systemName: "link")
                        }
                        
                        Button(action: {
                            shouldShowNewLink.toggle()
                        }, label: {
                            Text("Change")
                        })
                        VenueTileView(ven: linkedVenue!)
                            .environmentObject(sessionService)
                            .environmentObject(manager)
                            .padding(.horizontal)
                            
                    }
                    
                    
                    
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            shouldShowFriendsList.toggle()
//                        }, label: {
//                            Text("Add Friends")
//                                .foregroundColor(Color.primary)
//                        })
//
//                        Image(systemName: "plus")
//                        Spacer()
//                    }
//                    .frame(width: 288, height: 40)
//                    .overlay (
//                        RoundedRectangle(cornerRadius: 44,
//                                         style: .continuous)
//                            .stroke(Color.primary)
//                    )
//
                    
                    HStack {
                        Button(action: {
                            if self.name == "" {
                                self.showAlert.toggle()
                            } else {
                                if linkedEvent != nil {
                                    vm.updatePres(id: event.id, name: name, description: description, date: date, time: startTime, address: address, linkedEvent: sessionService.getEventID(event: linkedEvent!), linkedVenue: "", token: sessionService.userDetails.token)
                                } else if linkedVenue != nil {
                                    vm.updatePres(id: event.id, name: name, description: description, date: date, time: startTime, address: address, linkedEvent: "", linkedVenue: sessionService.getVenueID(venue: linkedVenue!), token: sessionService.userDetails.token )
                                } else {
                                    vm.updatePres(id: event.id, name: name, description: description, date: date, time: startTime, address: address, linkedEvent: "", linkedVenue: "", token: sessionService.userDetails.token)
                                }
                                
                                Task {
                                    await homeVM.getMyEvents(uid: sessionService.userDetails.uid, token: sessionService.token)
                                }
                               
                                showEditPres.toggle()
                            }
                            
                        }, label: {
                            Text("Update")
                                .foregroundColor(Color.white)
                        })
                        Image(systemName: "paperplane")
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 288, height: 40)
                    .background(Color.purple).cornerRadius(44)
                }
               
                        
                    
               
            }
            .toolbar {
                
                Button (action: {
                    // remove friend + confirmation popup
                    wantToAbandon.toggle()

                }, label: {
                    Image(systemName: "xmark")
                })
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Missing Event Name"),
                      message: Text("Please provide a name for your event"),
                      dismissButton: .default(Text("Ok")) {
                    showEditPres.toggle()
                })
            }
            .alert("Are you sure you want to abandon progress?", isPresented: $wantToAbandon, actions: {
                // 1
                  Button("Cancel", role: .cancel, action: {})

                  Button("I'm sure", role: .destructive, action: {
                      showEditPres.toggle()})
                }, message: {
                  Text("This can't be undone")
                })

            
            .navigationBarTitle("Update Pres", displayMode: .inline)
            .onAppear {

                self.name = event.label
                self.description = event.description
                dateFormatter.dateFormat = "dd-MM-yyyy"
                self.date = dateFormatter.date(from: event.date) ?? Date.now
                dateFormatter.dateFormat = "HH:mm"
                self.startTime = dateFormatter.date(from: event.startTime) ?? Date.now
                self.address = event.address
                self.linkedVenue = handler.linkedVenue
                self.linkedEvent = handler.linkedEvent
                
            }
        }
        .sheet(isPresented: $shouldShowFriendsList, content: {
            SendInvitesView(shouldShowFriendsList: $shouldShowFriendsList).environmentObject(vm)
        })
        .sheet(isPresented: $shouldShowNewLink, content: {
            NewLinkView(currEvent: event, linkedEvent: $linkedEvent, linkedVenue: $linkedVenue, shouldShowNewLink: $shouldShowNewLink)
                .environmentObject(handler)
                .environmentObject(homeVM)
            //add bindings for link
        })
        
        
       
    }
}

