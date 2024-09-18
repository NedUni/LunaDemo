//
//  UpdateEventView.swift
//  Luna
//
//  Created by Will Polich on 8/2/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct UpdateEventView: View {
    
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var handler : UserEventViewHandler
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM: ViewModel
    @StateObject var vm = EventHandler()
    @Environment(\.presentationMode) var presentationMode
    @State var showAlert : Bool = false
    let dateFormatter = DateFormatter()
    
    @Binding var showEditEvent: Bool
    @Binding var event : EventObj

    
    @State var selectedTab = 1
    @State var name : String = ""
    @State var description: String = ""
    @State var address: String = ""
    @State var date : Date = Date.now
    @State var startTime: Date = Date.now
    @State var endTime: Date = Date.now
    @State var shouldShowImagePicker = false
    @State var shouldShowFriendsList = false
    @State var image: UIImage?
    @State var linkedEvent : EventObj?
    @State var linkedVenue : VenueObj?
    
    @State var wantToAbandon: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (spacing: 16) {
                    
                    Button(action: {
                        shouldShowImagePicker.toggle()
                    }, label: {
                        if let image = self.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 360, height: 144)
                        } else if self.event.imageurl != "" {
                            WebImage(url: URL(string: self.event.imageurl))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 360, height: 144)
                        }
                        else {
                            Image("usereventplaceholder")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 360, height: 144)
                        }
                        
                    })
                    
                    
                    TextInputView(text: $name,
                                  placeholder: "Event Name (Required)",
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
                    
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
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
                    
                    DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
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
                }
                .padding()
                
                if vm.invited.count != 0 {
                    
                    Text("Invited")
                    
                    ScrollView (.horizontal) {
                        HStack {
                            ForEach(vm.invited, id: \.self) { user in
                                if user.uid != sessionService.userDetails.uid {
                                    AsyncImage(url: URL(string: user.imageURL)) { image in
                                        image
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(100)
                                            .scaledToFill()
                                            .clipped()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                
                                
                            }
                        }.padding()
                    }
                    
                   
                    
                }

                
                VStack (spacing:24) {
                    HStack {
                        Spacer()
                        Button(action: {
                            shouldShowFriendsList.toggle()
                        }, label: {
                            Text("Add Friends")
                                .foregroundColor(Color.primary)
                        })
                        
                        Image(systemName: "plus")
                        Spacer()
                    }
                    .frame(width: 288, height: 40)
                    .overlay (
                        RoundedRectangle(cornerRadius: 44,
                                         style: .continuous)
                            .stroke(Color.primary)
                    )
                   
                    
                   
                    Button(action: {
                        if self.name == "" {
                            self.showAlert.toggle()
                        } else {
                            if self.image == nil && event.imageurl != ""  {
                                vm.updateUserEvent(id: event.id, name: name, description: description, date: date, startTime: startTime, endTime: endTime, address: address, image: nil, token: sessionService.token, oldEvent: event)
                            } else if self.image == nil {
                                vm.updateUserEvent(id: event.id, name: name, description: description, date: date, startTime: startTime, endTime: endTime, address: address, image: UIImage(named: "usereventplaceholder")!, token: sessionService.token, oldEvent: event)
                            } else {
                                vm.updateUserEvent(id: event.id, name: name, description: description, date: date, startTime: startTime, endTime: endTime, address: address, image: (image ?? UIImage(named: "usereventplaceholder"))!, token: sessionService.token, oldEvent: event)
                            }
                            
                            
                            
                            Task {
                                await homeVM.getMyEvents(uid: sessionService.userDetails.uid, token: sessionService.token)
                            }
                            
                            showEditEvent.toggle()
                        }
                        
                    }, label: {
                        HStack {
                            Text("Update")
                            .foregroundColor(Color.white)
                            Image(systemName: "paperplane")
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 288, height: 40)
                        .background(Color.purple).cornerRadius(44)
                    })
                    
                   
                }
            
            }
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                   ImagePicker(image: $image)
            }
            .sheet(isPresented: $shouldShowFriendsList, content: {
                SendInvitesView(shouldShowFriendsList: $shouldShowFriendsList).environmentObject(vm)
            })
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                
                Button (action: {
                    // remove friend + confirmation popup
                    wantToAbandon.toggle()

                },
                
                    label: {
                    Image(systemName: "xmark")
                })
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Missing Event Name"),
                      message: Text("Please provide a name for your event"),
                      dismissButton: .default(Text("Ok")) {
                    showAlert.toggle()
                })
            }
            .alert("Are you sure you want to abandon progress?", isPresented: $wantToAbandon, actions: {
                // 1
                  Button("Cancel", role: .cancel, action: {})

                  Button("I'm sure", role: .destructive, action: {
                      showEditEvent.toggle()})
                }, message: {
                  Text("This can't be undone")
                })
            .onAppear {
                let allUsers = event.invited + event.going
                vm.getInvited(invited: allUsers, token: sessionService.token, completion: {})
                self.name = event.label
                self.description = event.description
                dateFormatter.dateFormat = "dd-MM-yyyy"
                self.date = dateFormatter.date(from: event.date) ?? Date.now
                dateFormatter.dateFormat = "HH:mm"
                self.startTime = dateFormatter.date(from: event.startTime) ?? Date.now
                self.endTime = dateFormatter.date(from: event.startTime) ?? Date.now
                self.address = event.address
                self.linkedVenue = handler.linkedVenue
                self.linkedEvent = handler.linkedEvent

            }
            
        }.navigationBarHidden(true)
    }
}

