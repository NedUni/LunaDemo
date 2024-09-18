//
//  UserEventEllipsis.swift
//  Luna
//
//  Created by Will Polich on 8/2/2022.
//

import SwiftUI

struct UserEventEllipsis: View {
    
    @Binding var showEditEvent : Bool
    @Binding var event : EventObj
    
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var vm : UserEventViewHandler
    @EnvironmentObject var sessionService : SessionServiceImpl
    
    var body: some View {
        Menu {
//            Button (action: {
//                showEditEvent.toggle()
//            }, label: {
//                HStack {
//                    Text("Edit Event")
//                    Image(systemName: "pencil")
//                }.foregroundColor(Color.primary)
//            })
            
            Button (action: {
                vm.deleteEvent(id: event.id, token: sessionService.userDetails.token)
                Task {
                    await homeVM.getMyEvents(uid: sessionService.userDetails.uid, token: sessionService.token)
                }
            }, label: {
                HStack {
                    Text("Delete Event")
                    Image(systemName: "trash")
                }.foregroundColor(Color.red)
            })

        } label: {
    
            Image(systemName: "ellipsis.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(Color("darkBackground"))
                .background(Color.primary).cornerRadius(20)
        }
    }
}


