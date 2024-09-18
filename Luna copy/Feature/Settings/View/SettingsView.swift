//
//  SettingsView.swift
//  Luna
//
//  Created by Will Polich on 14/2/2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var sessionService : SessionServiceImpl
    
    @State var showSetupPerformer = false
    @State var showPerformerConfirmation = false
    @State var changingPerformerStatus = false
    @State var showPerformerError = false
    
    var body: some View {
        
        List {
            Button(action: {
                sessionService.logout()
            }, label: {
                Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
    
            })
            
            Button {
                showPerformerConfirmation.toggle()
            } label: {
                HStack {
                    Label("Performer Account", systemImage: "music.note")
                    Spacer()
                    if changingPerformerStatus {
                        ProgressView()
                    } else {
                        Text(sessionService.userDetails.performer ? "Enabled" : "Disabled")
                    }
                        
                }
            }
            
            Button(action: {
                
            }, label: {
                Label("Delete Account", systemImage: "person.fill.xmark")
                    .foregroundColor(Color.red)
            })

        }
        .fullScreenCover(isPresented: $showSetupPerformer) {
            SetupPerformerView(showSetupPerformer: $showSetupPerformer, changingPerformerStatus: $changingPerformerStatus)
                .environmentObject(sessionService)
        }
        .navigationBarTitle("Settings", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView())
        .alert("Are you sure you want to a change your accout?", isPresented: $showPerformerConfirmation, actions: {
            Button("Cancel", role: .cancel, action: {showPerformerConfirmation.toggle()})

            Button("Confirm", role: .destructive, action: {
                
                if !sessionService.userDetails.performer {
                    showSetupPerformer.toggle()
                } else {
                    changingPerformerStatus = true
                    sessionService.togglePerfomerAccount(uid: sessionService.userDetails.uid) { error in
                        changingPerformerStatus = false
                        if let error = error {
                            print(error)
                            showPerformerError.toggle()
                        } else {
                            sessionService.refreshUserDetails()
                            
                        }
                    }
                }
            })
            
        }, message: {
            Text("This will change your profile to performer mode.")
        })
        .alert("Error changing account status", isPresented: $showPerformerError, actions: {
            Button("Ok", role: .cancel, action: {showPerformerError.toggle()})

        }, message: {
            Text("Please try again later.")
        })
        


    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
                .environmentObject(SessionServiceImpl())
        }
       
    }
}
