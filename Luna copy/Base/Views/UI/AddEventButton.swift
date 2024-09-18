//
//  AddEventButton.swift
//  Luna
//
//  Created by Ned O'Rourke on 29/4/2022.
//

import SwiftUI

struct AddEventButton: View {
    
    @Binding var showCreateEvent : Bool
    
    var body: some View {
        Menu {
            Button (action: {
                showCreateEvent.toggle()
            }, label: {
                HStack {
                    Text("Create Event")
                    Image(systemName: "pencil")
                }.foregroundColor(Color.primary)
            })
        } label: {
    
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.primary)
                .colorInvert()
                .background(Color.primary).cornerRadius(20)
        }
       
    }
}

//struct AddEventButton_Previews: PreviewProvider {
//    static var previews: some View {
//        AddEventButton()
//    }
//}
