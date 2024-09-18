//
//  PresElipsis.swift
//  Luna
//
//  Created by Will Polich on 8/2/2022.
//

import SwiftUI

struct PresEllipsis: View {
    
    @Binding var showEditPres : Bool
    @Binding var event : EventObj
    
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var vm : UserEventViewHandler
    @EnvironmentObject var sessionService : SessionServiceImpl
    
    var body: some View {
            Menu {
        
                Button (action: {
                    showEditPres.toggle()
                }, label: {
                    HStack {
                        Text("Edit Pres")
                        Image(systemName: "pencil")
                    }.foregroundColor(Color.primary)
                })
                    
                
                Button (action: {
                    vm.deletePres(id: event.id, token: sessionService.userDetails.token)
                    Task {
                        await homeVM.getMyEvents(uid: sessionService.userDetails.uid, token: sessionService.token)
                    }
                }, label: {
                    HStack {
                        Text("Delete Pres")
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
                    .overlay(
                        Circle()
                            .stroke(Color("darkBackground"), lineWidth: 1)
                    )
                
            }
           
        
                    
        
        
    }
}

//struct PresElipsis_Previews: PreviewProvider {
//    static var previews: some View {
//        PresEllipsis()
//    }
//}
