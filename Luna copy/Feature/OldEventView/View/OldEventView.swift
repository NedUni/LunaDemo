////
////  EventView.swift
////  Luna
////
////  Created by Ned O'Rourke on 23/1/22.
////
//
//import SwiftUI
//import SDWebImageSwiftUI
//
//struct OldEventView: View {
//    
//    @State var buttonText = ""
//    
//    @State var buttonState: Int = 1
//    
//    @EnvironmentObject var sessionService: SessionServiceImpl
//    
//    var event : EventObj
//    
//    var body: some View {
//        
//        VStack {
//            ScrollView {
//                
//                VStack {
//                    
//                    ZStack (alignment: .bottomLeading) {
//
//                        WebImage(url: URL(string: event.imageurl))
//                            .resizable()
//                            .scaledToFill()
//                        
//                        HStack {
//                            Text(event.label)
//                                .foregroundColor(.white)
//
//                            Spacer()
//
//                            Text("🔥🔥🔥")
//                        }
//                        .font(.system(size: 25).bold())
//                        .frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
//                        .background(Color.gray.opacity(0.4))
//                    }
//                    
//                    
//                    VStack (alignment: .leading) {
//                        
//                        
//                        VStack (alignment: .leading) {
//                            HStack {
//                                Image(systemName: "clock")
//                                Text("when")
//                                Spacer()
//                            }
//                            .font(.system(size: 20, weight: .heavy))
//                            Text("Sunday from 2pm")
//                                .padding(.leading, 25.0)
//                        }.padding(.horizontal)
//                        
//                        Divider()
//                        
//                        Button(action: {
//                            
//                            let latitude = -33.86636808363841
//                            let longitude = 151.20761272874483
//                            let url = URL(string: "maps://?saddr=&daddr=\(latitude),\(longitude)")
//
//                            if UIApplication.shared.canOpenURL(url!) {
//                                  UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//                            }
//                            
//                            print("Button action")
//                        }) {
//                            VStack (alignment: .leading) {
//                                HStack {
//                                    Image(systemName: "mappin")
//                                    Text("where")
//                                    Spacer()
//                                }
//                                .font(.system(size: 20, weight: .heavy))
//                                
//                                Text("The Ivy")
//                                    .padding(.leading, 25.0)
//                            }.padding(.horizontal)
//                        }
//                        
//                        
//                        Divider()
//                        
//                        VStack (alignment: .leading) {
//                            HStack {
//                                Image(systemName: "music.note")
//                                Text("beats")
//                                Spacer()
//                            }
//                            .font(.system(size: 20, weight: .heavy))
//                            
//                            Text("House")
//                                .padding(.leading, 25.0)
//                        }.padding(.horizontal)
//                    }.font(.system(size: 20))
//                    
//                    
//                    VStack (alignment: .leading) {
//                        Text(event.description)
//                        Divider()
//                        
//                        
//                        Text("Friends Going")
//                            .padding(.top, 200.0)
//                        HStack {
//                            ScrollView (.horizontal) {
//                                ForEach(sessionService.interestedFriends, id: \.self) { user in
//                                    VStack {
//                                        WebImage(url: URL(string: user.imageURL))
//                                            .resizable()
//                                            .frame(width: 80, height: 80)
//                                            .cornerRadius(100)
//                                            .scaledToFill()
//                                            .overlay(RoundedRectangle(cornerRadius: 128).strokeBorder(Color.primary, lineWidth: 3))
//                                        Text(user.firstName)
//                                    }
//                                }
//                            }
//                        }
//                    }.padding(.horizontal)
//                    
//                    
//                    VStack (alignment: .center) {
//                        Text("Meet the Music Makers")
//                        VStack {
//                            HStack {
//                                Spacer()
//                                VStack {
//                                    WebImage(url: URL(string: event.imageurl))
//                                        .frame(width: 80, height: 80)
//                                        .cornerRadius(100)
//                                    Text("Friend")
//                                }
//                                Spacer()
//                                VStack {
//                                    WebImage(url: URL(string: event.imageurl))
//                                        .frame(width: 100, height: 100)
//                                        .cornerRadius(100)
//                                    Text("Friend")
//                                }
//                                Spacer()
//                            }
//                            HStack {
//                                Spacer()
//                                VStack {
//                                    WebImage(url: URL(string: event.imageurl))
//                                        .frame(width: 100, height: 100)
//                                        .cornerRadius(100)
//                                    Text("Friend")
//                                }
//                                Spacer()
//                                VStack {
//                                    WebImage(url: URL(string: event.imageurl))
//                                        .frame(width: 100, height: 100)
//                                        .cornerRadius(100)
//                                    Text("Friend")
//                                }
//                                Spacer()
//                            }
//                        }
//                    }
//                    
//                    
//                    VStack {
//                        Text("Good bog")
//                        //STACK VENUES HERE SIMILAR TO FRONT PAGE
//                        
//                        
//                    }
//                }
//            }
//            .ignoresSafeArea()
//            
//            VStack {
//                
//                
//
//                        Button(action: {
//                            
//                            if self.buttonState == 1 {
//                                self.buttonText = "Check in"
//                                self.buttonState = 2
//                                sessionService.userEventInterest(venueID: event.creatorID, UID: sessionService.userDetails.uid, eventID: event.id)
//                            } else if self.buttonState == 2 {
//                                self.buttonText = "Check Out"
//                                self.buttonState = 3
//                                sessionService.checkIn(venueID: event.creatorID, UID: sessionService.userDetails.uid, time: 69)
//                            } else if self.buttonState == 3 {
//                                self.buttonText = "Check in"
//                                self.buttonState = 2
//                                sessionService.checkOut(venueID: event.creatorID, UID: sessionService.userDetails.uid)
//                            }
//                            
//                            
//                        }, label: {
//                            HStack {
//                                
//                                Spacer()
//                                
//                                Text(self.buttonText)
//                                
//                                Spacer()
//                            }
//                            .foregroundColor(Color.primary)
//                            .padding(.vertical, 10)
//                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.primary, lineWidth: 2))
//                                
//                        }).padding(.horizontal)
//                        
//                       
//                    }
//                    Spacer()
//        }
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: BackButtonView())
//        .onAppear {
//            sessionService.getCheckins(uid: sessionService.userDetails.uid)
//            if sessionService.userDetails.interested.contains(event.id) {
//                self.buttonText = "Check in"
//                self.buttonState = 2
//            } else if sessionService.currentCheckins.contains(event.creatorID) {
//                self.buttonText = "Check out"
//                self.buttonState = 3
//            } else {
//                self.buttonText = "Interested"
//                self.buttonState = 1
//            }
//            
//            sessionService.refreshUserDetails()
//            sessionService.getInterestedFriends(venueID: event.creatorID, UID: sessionService.userDetails.uid, eventID: event.id)
//        }
//        
//    }
//}
//
