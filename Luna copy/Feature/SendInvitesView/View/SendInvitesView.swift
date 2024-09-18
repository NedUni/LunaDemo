//
//  SendInvitesView.swift
//  Luna
//
//  Created by Will Polich on 30/1/2022.
//

import SwiftUI



struct SendInvitesView: View {
    
    @EnvironmentObject var vm : EventHandler
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @Binding var shouldShowFriendsList: Bool
    
    @State var wantToAbandon: Bool = false
    @State var term : String = ""
    
    var body: some View {
        
        NavigationView {
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
                }
                
                VStack {
                    Text("Invite")
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
                .background(vm.invited.count > 0 ? .purple.opacity(0.8) : .purple.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .onTapGesture {
                    self.shouldShowFriendsList = false
                }
                
                
                
            }
            .navigationBarTitle("Invite Friends", displayMode: .inline)
        }
        .navigationBarHidden(true)
    }
    
}

struct SendInvitesView_Previews: PreviewProvider {
    @StateObject static var sessionService = SessionServiceImpl()
    @State static var shouldShowFriendsList = true
    
    static var previews: some View {
        
        SendInvitesView(shouldShowFriendsList: $shouldShowFriendsList )
            .environmentObject(sessionService)
    }
}
