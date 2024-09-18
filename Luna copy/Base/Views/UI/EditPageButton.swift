//
//  EditPageButton.swift
//  Luna
//
//  Created by Ned O'Rourke on 13/4/22.
//

import SwiftUI

struct EditPageButton: View {
    
    @Binding var showEditPage : Bool
    @Binding var page : PageObj
    @Binding var showCreateEvent: Bool
    
    var body: some View {
        Menu {
            Button {
                showCreateEvent.toggle()
            } label: {
                Label("New Event", systemImage: "plus")
            }

            Button (action: {
                showEditPage.toggle()
            }, label: {
                Label("Edit Page", systemImage: "pencil")
            })
        } label: {
    
            Image(systemName: "ellipsis.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(Color("darkBackground"))
                .background(.white).cornerRadius(20)
                .overlay(
                    Circle()
                        .stroke(Color("darkBackground"), lineWidth: 1)
                )
        }
       
    }
}

//struct EditPageButton_Previews: PreviewProvider {
//    static var previews: some View {
//        let page = PageObj(id: "", name: "", email: "", description: "", promotedEvent: "", events: [], banner_url: "", logo_url: "", categories: [], followers: [], admins: [], website: "")
//        EditPageButton(page: page, showEditPage)
//    }
//}
