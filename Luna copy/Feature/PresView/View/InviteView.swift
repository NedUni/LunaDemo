//
//  InviteView.swift
//  Luna
//
//  Created by Will Polich on 20/5/2022.
//

import SwiftUI

struct InviteView: View {
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var vm : EventHandler
    
    @Binding var event: EventObj
    
    @Binding var showInvites: Bool
    
    @State var wantToAbandon: Bool = false
    @State var term : String = ""
    
    var body: some View {
        NavigationView {
            ZStack (alignment: .bottom) {
                
                VStack {
                    TextField("Search Luna", text: $term)
                        .disableAutocorrection(true)
                        .padding(5)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                        .onChange(of: term) { newTerm in
                            sessionService.searchVenues(term: term, option: 2)
                        }
                    
                    
                    ScrollView {
                        if term != "" {
                            ForEach(sessionService.searchPeopleResults, id: \.self) { user in
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
                    .navigationBarTitle("Invite Friends", displayMode: .inline)
                    .onAppear {
                        sessionService.refreshUserDetails()
                        
                    }
                    .padding(.bottom, 30)
//                    .task {
//                        await sessionService.getFriends(uid: sessionService.userDetails.uid)
//                    }
                }
                .padding(.horizontal)
                
                Spacer()
                Spacer()
                
//                if vm.addedInvites.count != 0 {
               
               
//
                Button(action: {
                    vm.updateAllInvites(event: event.id, completion: {
                        sessionService.getEventByID(id: event.id) { event in
                            if event != nil {
                                self.event = event!
                            } else {
                                print("Event is nil")
                            }
                        }
                        showInvites.toggle()
                    })
                    
                }, label: {
                    HStack {
                        Text("Save")
                            .foregroundColor(Color.white)
                        Image(systemName: "plus")
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 288, height: 40)
                    .background(Color.purple).cornerRadius(44)
                    .padding()

                })
                    
                    
//                } else {
//                    HStack  {
//                        Button(action: {
//
//                        }, label: {
//                            Text("Add")
//                                .foregroundColor(Color.white)
//                        })
//
//                        Image(systemName: "plus")
//                            .foregroundColor(Color.white)
//                    }
//                    .frame(width: 288, height: 40)
//                    .background(Color.gray).cornerRadius(44)
//                    .padding()
//                }
                

            }
            .onAppear {
//                let allUsers = event.invited + event.going + event.interested
//                print("allUsers: \(allUsers)")
//                vm.getInvited(invited: allUsers, token: sessionService.token, completion: {
                vm.addedInvites = vm.invited
//                })
                
                
            }
            .toolbar {
                
                Button (action: {
                    // remove friend + confirmation popup
                    if vm.invited.count != 0 {
                        wantToAbandon.toggle()
                    }
                    else {
                        showInvites.toggle()
                    }
                },
                
                    label: {
                    Image(systemName: "xmark")
                })
            }
            
            .alert("Are you sure you want to abandon progress?", isPresented: $wantToAbandon, actions: {
                // 1
                  Button("Cancel", role: .cancel, action: {})

                  Button("I'm sure", role: .destructive, action: {showInvites.toggle()})
                }, message: {
                  Text("This can't be undone.")
                })
                        
            
                   
        }.navigationBarHidden(true)
        
        
        
    }
    

}

