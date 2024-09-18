////
////  PresView.swift
////  Luna
////
////  Created by Will Polich on 5/2/2022.
////
//
//import SwiftUI
//import SDWebImageSwiftUI
//
//struct UserEventView: View {
//    
//    @EnvironmentObject var sessionService : SessionServiceImpl
//    @EnvironmentObject var manager : LocationManager
//    @EnvironmentObject var homeVM : ViewModel
//    @StateObject var vm = UserEventViewHandler()
//    @State var shouldShowResponses : Bool = false
//    @State var showEditEvent : Bool = false
//    @State var event: EventObj
//    @State var responsesTab: Int = 1
//    @State var going : Int = 0
//    @State var invited : Int = 0
//    @State var maybe : Int = 0
//    @State var response : Int
//    @State var buttonText : String = "Invited"
//    @State var date = ""
//    
//    @State var shouldNavigateToEventChat = false
//    
//    let df = DateFormatter()
//    let calendar = Calendar.current
//    
//    var body: some View {
//        
//        VStack {
//            
//            ZStack (alignment: .bottom) {
//                
//                
//                ScrollView {
//                    if event.imageurl != "" {
//                     
//                        AsyncImage(url: URL(string: event.imageurl)) { image in
//                            image.resizable()
//                                .scaledToFill()
//                                .edgesIgnoringSafeArea(.all)
//                                .frame(maxWidth: .infinity, maxHeight: 250)
//
//                        } placeholder: {
//                            ProgressView()
//                                .frame(maxWidth: .infinity, maxHeight: 250)
//                                .edgesIgnoringSafeArea(.all)
//                        }
//                            
//                      
//                    }
//                    VStack (alignment: .leading) {
//                        Text(event.label).font(.system(size: 22).bold())
//                        
//                        
//                        if event.endTime == "" {
//                            Text("\(self.date) at \(event.startTime)")
//                            
//                        } else {
//                            Text("\(self.date) from \(event.startTime) to \(event.endTime)")
//                        }
//                        Spacer()
//                        
//                        Text(event.description)
//                            .foregroundColor(Color.secondary)
//
//                        Divider()
//                    }.padding(.horizontal)
//                   
//                    
//                    VStack (alignment: .leading) {
//                        
//                        
//                        Group {
//                            
//                        }
//                       
//                        
//                        Button(action: {
//                            self.responsesTab = 1
//                            shouldShowResponses.toggle()
//                        }, label: {
//                            HStack {
//                                Text("Going")
//                                Spacer()
//                                Text(String(self.going))
//                            }.foregroundColor(Color.primary)
//                        })
//                        
//                        
//                        Spacer()
//                        Spacer()
//                        
//    
//                        Button(action: {
//                            self.responsesTab = 2
//                            shouldShowResponses.toggle()
//                        }, label: {
//                            HStack {
//                                Text("Maybe")
//                                Spacer()
//                                Text(String(self.maybe))
//                            }.foregroundColor(Color.primary)
//                        })
//                        
//                        Spacer()
//                        Spacer()
//
//                        Button(action: {
//                            self.responsesTab = 3
//                            shouldShowResponses.toggle()
//                        }, label: {
//                            HStack {
//                                Text("Invited")
//                                Spacer()
//                                Text(String(self.invited))
//                            }.foregroundColor(Color.primary)
//                        })
//                        
//                        
//                        
//                    }.padding()
//                    
////                    VStack (alignment: .leading) {
////                        Divider()
////
////                        Spacer()
////                        Spacer()
////
////                        if linkedEvent != nil {
////                            Text("Linked Event")
////                            EventTileView(event : linkedEvent!)
////                        }
////                    }.padding()
//                    
//                    
//                    
//                    
//                }
//                
//                HStack {
//                    if event.hostIDs[0] != sessionService.userDetails.uid {
//                        Menu {
//                            Picker("responsePicker", selection: $response) {
//                                Text("Invited").tag(1)
//                                Text("Going").tag(2)
//                                Text("Maybe").tag(3)
//                                Text("Can't Go").tag(4)
//                                
//                            }
//                            .labelsHidden()
//                            .pickerStyle(InlinePickerStyle())
//
//
//                        } label: {
//                            HStack {
//                                Spacer()
//                                Text(self.buttonText)
//                                    .foregroundColor(Color.white)
//                                if self.response == 1 {
//                                    Image(systemName: "envelope")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .foregroundColor(Color.white)
//                                        .frame(width: 14, height: 14)
//                                } else if self.response == 2 {
//                                    Image(systemName: "checkmark")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .foregroundColor(Color.white)
//                                        .frame(width: 14, height: 14)
//                                } else if self.response == 3 {
//                                    Image(systemName: "questionmark")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .foregroundColor(Color.white)
//                                        .frame(width: 14, height: 14)
//                                } else if self.response == 4 {
//                                    Image(systemName: "xmark")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .foregroundColor(Color.white)
//                                        .frame(width: 14, height: 14)
//                                }
//                                Spacer()
//                                
//                            }
//                            
//                        }
//                        .frame(width: 220, height: 40)
//                        .background(Color.purple).cornerRadius(20)
//                        .padding()
//                        .onChange(of: response) { updated in
//                            if updated == 1 {
//                                self.buttonText = "Invited"
//                                
//                                self.invited += 1
//                                if event.going.contains(sessionService.userDetails.uid) {
//                                    if self.going != 0 {
//                                        self.going -= 1
//                                    }
//                                
//                                } else if event.interested.contains(sessionService.userDetails.uid) {
//                                    if self.maybe != 0 {
//                                        self.maybe -= 1
//                                    }
//                                    
//                                }
//                                
//                            } else if updated == 2 {
//                                self.buttonText = "Going"
//                                self.going += 1
//                                
//                                if event.interested.contains(sessionService.userDetails.uid) {
//                                    if self.maybe != 0 {
//                                        self.maybe -= 1
//                                    }
//                                
//                                } else if event.invited.contains(sessionService.userDetails.uid) {
//                                    if self.invited != 0 {
//                                        self.invited -= 1
//                                    }
//                                    
//                                }
//                                
//                            } else if updated == 3 {
//                                self.buttonText = "Maybe"
//                                self.maybe += 1
//                                if event.going.contains(sessionService.userDetails.uid) {
//                                    if self.going != 0 {
//                                        self.going -= 1
//                                    }
//                                
//                                } else if event.invited.contains(sessionService.userDetails.uid) {
//                                    if self.invited != 0 {
//                                        self.invited -= 1
//                                    }
//                                    
//                                }
//        
//                            } else if updated == 4 {
//                                self.buttonText = "Can't Go"
//                                if event.going.contains(sessionService.userDetails.uid) {
//                                    if self.going != 0 {
//                                        self.going -= 1
//                                    }
//                                
//                                } else if event.invited.contains(sessionService.userDetails.uid) {
//                                    if self.invited != 0 {
//                                        self.invited -= 1
//                                    }
//                                    
//                                } else if event.interested.contains(sessionService.userDetails.uid) {
//                                    if self.maybe != 0 {
//                                        self.maybe -= 1
//                                    }
//                                
//                                }
//                            }
//                            
//                            var changedResponse = ""
//                            if response == 1 {
//                                changedResponse = "invited"
//                            } else if response == 2 {
//                                changedResponse = "going"
//                            } else if response == 3 {
//                                changedResponse = "interested"
//                            } else if response == 4 {
//                                changedResponse = "declined"
//                            }
//                            
//                            
//                            vm.changeEventResponse(eventID: event.id, pres: String((event.endTime == "" ? true : false)), uid: sessionService.userDetails.uid, response: changedResponse, token: sessionService.userDetails.token)
//                            
//                            Task {
//                                await homeVM.getMyEvents(uid: sessionService.userDetails.uid, token: sessionService.token)
//                            }
//                            
//                            
//                        }.padding()
//                    }
//                    
//                    Button {,
//                        <#code#>
//                    } label: {
//                        <#code#>
//                    }
//
//                    
//                    NavigationLink(destination: {
//                        MessageView (event: event, shouldNavigateToEventChat: $shouldNavigateToEventChat )
//                        .environmentObject(sessionService)
//                        
//                    }, label: {
//                        Image(systemName: "message.circle.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 40, height: 50).cornerRadius(40)
//                            .foregroundColor(Color.purple)
//                    })
//                }
//            
//                
//        
//            }
//
//            
//        }
//        .sheet(isPresented: $shouldShowResponses, content: {
//            UserResponsesView(selectedTab: self.responsesTab, event: event)
//                .environmentObject(vm)
//                .environmentObject(manager)
//                .environmentObject(sessionService)
//                .environmentObject(homeVM)
//        })
//        .fullScreenCover(isPresented: $showEditEvent, onDismiss: nil) {
//            UpdateEventView(showEditEvent: $showEditEvent, event: $event)
//                .environmentObject(sessionService)
//                .environmentObject(vm)
//                .environmentObject(manager)
//        }
//        .navigationBarTitle("", displayMode: .inline)
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: BackButtonView())
//
//        .onAppear {
//            self.date = event.date
//            self.going = self.event.going.count
//            self.invited = self.event.invited.count
//            self.maybe = self.event.interested.count
//            
//            if event.going.contains(sessionService.userDetails.uid) {
//                self.buttonText = "Going"
//            } else if event.interested.contains(sessionService.userDetails.uid) {
//                self.buttonText = "Maybe"
//            } else if event.declined.contains(sessionService.userDetails.uid) {
//                self.buttonText = "Can't Go"
//            } else {
//                self.buttonText = "Invited"
//            }
//            
//            dateFormatter.dateFormat = "dd-MM-yyyy"
//            guard let dateObj = dateFormatter.date(from: event.date) else {return}
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
//                
//            }
//        }
//        .if(event.imageurl != "") { $0.ignoresSafeArea() }
//        .if(event.hostIDs[0] == sessionService.userDetails.uid ) {
//            $0.navigationBarItems(trailing: UserEventEllipsis(showEditEvent: $showEditEvent, event: $event)
//                                    .environmentObject(homeVM)
//                                    .environmentObject(sessionService)
//                                    .environmentObject(vm)
//            )}
//
//        
//    }
//    
//    
//}
//

//
////struct UserEventView_Previews: PreviewProvider {
////    
////    static var previews: some View {
////        
////        
////        let event = EventObj(creator: "", date: "23-01-2022", description: "Let's trot", endTime: "", filename: "", id: "", imageurl: "https://s3-ap-southeast-2.amazonaws.com/production.assets.merivale.com.au/wp-content/uploads/2019/07/15171723/lost_sundays_gallery_2.jpg", label: "Party", startTime: "20:00", creatorID: "", invited: ["QV8WKYu09tUxjj5Iai827aBbbXD2"], going: [], interested: [], declined: [], performers: [], userCreated : true, linkedEvent: "", linkedVenue: "", address: "", ticketLink: "", hosts: [], hostNames: [])
////        
////        UserEventView(event: event, response: 1)
////            .environmentObject(SessionServiceImpl())
////            .environmentObject(LocationManager())
////    }
////}
