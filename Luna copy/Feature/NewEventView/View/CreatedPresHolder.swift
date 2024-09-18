//
//  CreatedPresHolder.swift
//  Luna
//
//  Created by Ned O'Rourke on 5/6/2022.
//

//import SwiftUI
//
//struct CreatedPresHolder: View {
//    
//    @EnvironmentObject var vm : EventHandler
//    
//    @Binding var pres : EventObj
//    @State var showInvite = false
//    @Binding var createdEvent : Bool
//    @Binding var showCreatePres : Bool
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text(pres.label)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                   BackButtonView()
//                        .highPriorityGesture(TapGesture().onEnded({
//                            self.showCreatePres = false
//                            self.createdEvent = false
//                            
//                        }))
//                }
//            }
//            .onAppear {
//                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {
//                    self.showInvite = true
//                }
//            }
//            .sheet(isPresented: $showInvite) {
//                SendInvitesView(shouldShowFriendsList: $showInvite)
//                    .environmentObject(vm)
//            }
//        }
//    }
//}
//
//struct CreatedPresHolder_Previews: PreviewProvider {
//    static var previews: some View {
//        CreatedPresHolder(pres: EventObj(id: "", label: "", description: "", imageurl: "", tags: [], date: "", startTime: "", endTime: "", invited: [], going: [], interested: [], declined: [], hostIDs: [], hostNames: [], performers: [], address: "", linkedVenueName: "", linkedVenue: "", linkedEvent: "", userCreated: false, pageCreated: false, ticketLink: ""), createdEvent: .constant(true))
//    }
//}
