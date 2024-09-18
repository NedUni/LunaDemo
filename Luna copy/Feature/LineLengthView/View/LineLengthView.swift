//
//  LineLengthView.swift
//  Luna
//
//  Created by Ned O'Rourke on 8/2/22.
//

import SwiftUI

struct LineLengthView: View {
    
    var ven : VenueObj
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @Binding var showTime : Bool
    @Binding var buttonText: String
    @Binding var buttonState : Int
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                Spacer()
                Spacer()
                
                Text("Welcome to \(ven.displayname)!")
                    .font(.title)
                Text("How long did it take waiting in the line?")
                    .font(.title2)
                                
                VStack (spacing: 30){
                    
                    Button {
                        sessionService.checkIn(venueID: ven.id, UID: sessionService.userDetails.uid, time: 0, completion: {
                            self.buttonText = "Check Out"
                            self.buttonState = 2
                            showTime = false
                            sessionService.getActiveCheckin(uid: sessionService.userDetails.uid, completion: {})
                        })
                       
                    } label: {
                        Text("No Line")
                            .frame(width: 288, height: 50)
                            .foregroundColor(.white)
                            .background(Color.purple.opacity(0.7))
                            .cornerRadius(40)
                            .padding(.top)
                    }
                    
                    Button {
                        sessionService.checkIn(venueID: ven.id, UID: sessionService.userDetails.uid, time: 5, completion: {
                            self.buttonText = "Check Out"
                            self.buttonState = 2
                            showTime = false
                            sessionService.getActiveCheckin(uid: sessionService.userDetails.uid, completion: {})
                        })
                    } label: {
                        Text("5 minutes")
                            .frame(width: 288, height: 50)
                            .foregroundColor(.white)
                            .background(Color.purple.opacity(0.7))
                            .cornerRadius(40)
                            .padding(.top)
                    }
                    
                    Button {
                        sessionService.checkIn(venueID: ven.id, UID: sessionService.userDetails.uid, time: 15, completion: {
                            self.buttonText = "Check Out"
                            self.buttonState = 2
                            showTime = false
                            sessionService.getActiveCheckin(uid: sessionService.userDetails.uid, completion: {})
                        })
                    } label: {
                        Text("15 minutes")
                            .frame(width: 288, height: 50)
                            .foregroundColor(.white)
                            .background(Color.purple.opacity(0.7))
                            .cornerRadius(40)
                            .padding(.top)
                    }
                    
                    Button {
                        sessionService.checkIn(venueID: ven.id, UID: sessionService.userDetails.uid, time: 30, completion: {
                            self.buttonText = "Check Out"
                            self.buttonState = 2
                            showTime = false
                            sessionService.getActiveCheckin(uid: sessionService.userDetails.uid, completion: {})
                        })
                    } label: {
                        Text("30 minutes")
                            .frame(width: 288, height: 50)
                            .foregroundColor(.white)
                            .background(Color.purple.opacity(0.7))
                            .cornerRadius(40)
                            .padding(.top)
                    }
                    
                    Button {
                        sessionService.checkIn(venueID: ven.id, UID: sessionService.userDetails.uid, time: 60, completion: {
                            self.buttonText = "Check Out"
                            self.buttonState = 2
                            showTime = false
                            sessionService.getActiveCheckin(uid: sessionService.userDetails.uid, completion: {})
                        })
                    } label: {
                        Text("Wayyyy too long")
                            .frame(width: 288, height: 50)
                            .foregroundColor(.white)
                            .background(Color.purple.opacity(0.7))
                            .cornerRadius(40)
                            .padding(.top)
                    }
                }
            }
            .padding(.horizontal)
            .toolbar {
                Button {
                    sessionService.checkIn(venueID: ven.id, UID: sessionService.userDetails.uid, time: -1, completion: {
                        self.buttonText = "Check Out"
                        self.buttonState = 2
                        showTime = false
                        sessionService.getActiveCheckin(uid: sessionService.userDetails.uid, completion: {})
                    })
                } label: {
                    Image(systemName: "xmark")
                }

                
            }
                
            
        }
        .background(Color("darkBackground"))
        .buttonStyle(.plain)
            
            
    }
}


