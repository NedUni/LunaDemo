//
//  AutoLineLengthView.swift
//  Luna
//
//  Created by Will Polich on 9/5/2022.
//

import SwiftUI

struct AutoLineLengthView: View {
    
    var venue : VenueObj
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @Binding var showTime : Bool
//    @Binding var buttonText: String
//    @Binding var buttonState : Int
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                Spacer()
                Spacer()
                
                Text("Thanks for checking in to \(venue.displayname)!")
                    .font(.title)
                Text("How long did it take waiting in the line?")
                    .font(.title2)
                                
                VStack (spacing: 30){
                    
                    Button {
                        
                        sessionService.updateCheckin(venue: venue.id, uid: sessionService.userDetails.uid, wait: 0) {
                            showTime.toggle()
                        }
                       
                    } label: {
                        Text("No Line")
                            .frame(width: 288, height: 50)
                            .foregroundColor(.white)
                            .background(Color.purple)
                            .cornerRadius(40)
                            .padding(.top)
                    }
                    
                    Button {
                        sessionService.updateCheckin(venue: venue.id, uid: sessionService.userDetails.uid, wait: 5) {
                            showTime.toggle()
                        }
                    } label: {
                        Text("5 minutes")
                            .frame(width: 288, height: 50)
                            .foregroundColor(.white)
                            .background(Color.purple)
                            .cornerRadius(40)
                            .padding(.top)
                    }
                    
                    Button {
                        sessionService.updateCheckin(venue: venue.id, uid: sessionService.userDetails.uid, wait: 15) {
                            showTime.toggle()
                        }
                    } label: {
                        Text("15 minutes")
                            .frame(width: 288, height: 50)
                            .foregroundColor(.white)
                            .background(Color.purple)
                            .cornerRadius(40)
                            .padding(.top)
                    }
                    
                    Button {
                        sessionService.updateCheckin(venue: venue.id, uid: sessionService.userDetails.uid, wait: 30) {
                            showTime.toggle()
                        }
                    } label: {
                        Text("30 minutes")
                            .frame(width: 288, height: 50)
                            .foregroundColor(.white)
                            .background(Color.purple)
                            .cornerRadius(40)
                            .padding(.top)
                    }
                    
                    Button {
                        sessionService.updateCheckin(venue: venue.id, uid: sessionService.userDetails.uid, wait: 60) {
                            showTime.toggle()
                        }
                    } label: {
                        Text("Wayyyy too long")
                            .frame(width: 288, height: 50)
                            .foregroundColor(.white)
                            .background(Color.purple)
                            .cornerRadius(40)
                            .padding(.top)
                    }
                }
            }
            .padding(.horizontal)
            .toolbar {
                Button {
                    sessionService.updateCheckin(venue: venue.id, uid: sessionService.userDetails.uid, wait: -1) {
                        showTime.toggle()
                    }
                } label: {
                    Image(systemName: "xmark")
                }

                
            }
                
            
        }
        .buttonStyle(.plain)
            
            
    }
}



