//
//  MessageFieldView.swift
//  Luna
//
//  Created by Will Polich on 19/3/2022.
//

import SwiftUI

struct MessageFieldView: View {
    @State private var message = ""
    
    var event : EventObj
    
    @EnvironmentObject var viewModel : ViewModel
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var messagesManager : MessagesManager
    @EnvironmentObject var sessionService : SessionServiceImpl
    
    @State var showSearch = false
    @State var send : Bool = false
    
    @State var linkedEvent : EventObj?
    @State var linkedVenue : VenueObj?
    @State var linkedDeal : DealObj?
    
    @State var selectedTab : Int = 0
    
    var isEmpty : Bool {
        if message == "" && linkedEvent == nil && linkedVenue == nil && linkedDeal == nil {
            return true
        }
        return false
    }
    
    var body: some View {

        HStack {

            HStack (alignment: .center, spacing: 10) {
                if !send {
                    Button {
        //                showSearch.toggle()
                        withAnimation {
                            send.toggle()
                        }
        
        
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .frame(width: 15, height: 15, alignment: .center)
                            .padding(7)
                            .background(.purple)
                            .cornerRadius(15)
                            .foregroundColor(.white)
//                            .cornerRadius(50)
                    }
                }
                
                else {
                    
                    Button {
                        withAnimation {
                            send.toggle()
                        }
                        
                    } label: {
                        Image(systemName: "chevron.left")
                            .frame(width: 15, height: 15, alignment: .center)
                            .padding(7)
                            .background(.purple)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                    }
                    
                    Button {
                        setTab(tab: 0) {
                            showSearch.toggle()
                        }
//                        selectedTab = 1
                        
                        
                    } label: {
                        Image(systemName: "calendar")
                            .frame(width: 15, height: 15, alignment: .center)
                            .padding(7)
                            .background(.purple)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                    }
                    
                    Button {
                        setTab(tab: 1) {
                            showSearch.toggle()
                        }
                        
                    } label: {
                        Image(systemName: "music.note.house")
                            .frame(width: 15, height: 15, alignment: .center)
                            .padding(7)
                            .background(.purple)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                    }
                    
                    Button {
                        setTab(tab: 2) {
                            showSearch.toggle()
                        }
                        
                    } label: {
                        Text("$")
                            .frame(width: 15, height: 15, alignment: .center)
                            .padding(7)
                            .background(.purple)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(5)
            .frame(minWidth: 0, maxWidth: send ? 180 : 40, alignment: .leading)
            
//            CustomTextField(placeholder: "Aa", text: $message)
            CustomTextField(placeholder: Text("Text"), text: $message)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 25)
                .padding(5)
                .background(.gray.opacity(0.7))
                .cornerRadius(15)
            
            Button {
                if isEmpty {
                    return
                } else {
                    messagesManager.sendMessage(text: message, uid: sessionService.userDetails.uid, id: event.id, pres: event.endTime == "" ? true : false, imageurl: sessionService.userDetails.imageURL, name: "\(sessionService.userDetails.firstName) \(sessionService.userDetails.lastName)", linkedEvent: linkedEvent, linkedVenue: linkedVenue, linkedDeal: linkedDeal, event: event, sender: sessionService.userDetails)
                    linkedEvent = nil
                    linkedVenue = nil
                    linkedDeal = nil
                    self.message = ""
                }

            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(Color.white)
                    .padding(5)
                    .background(.purple)
                    .cornerRadius(50)
                    .opacity(isEmpty ? 0.5 : 1)

            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal)
        .padding(.vertical)
        .background(Color("darkBackground").opacity(0.5))
//        .frame(minWidth: 0, maxWidth: .infinity)
//        .background(.red)
//        .frame(height: 10)
//        .padding(.bottom)
        
        .sheet(isPresented: $showSearch) {
            LinkSearchView(linkedEvent: $linkedEvent, linkedVenue: $linkedVenue, linkedDeal: $linkedDeal, shouldShowNewLink: $showSearch, selectedTab: $selectedTab)
        }
        .onChange(of: linkedVenue) { change in
            if change != nil {
                messagesManager.sendMessage(text: message, uid: sessionService.userDetails.uid, id: event.id, pres: event.endTime == "" ? true : false, imageurl: sessionService.userDetails.imageURL, name: "\(sessionService.userDetails.firstName) \(sessionService.userDetails.lastName)", linkedEvent: linkedEvent, linkedVenue: linkedVenue, linkedDeal: linkedDeal, event: event, sender: sessionService.userDetails)
                message = ""
                linkedEvent = nil
                linkedVenue = nil
                linkedDeal = nil
            }
            
        }
        .onChange(of: linkedEvent) { change in
            if change != nil {
                messagesManager.sendMessage(text: message, uid: sessionService.userDetails.uid, id: event.id, pres: event.endTime == "" ? true : false, imageurl: sessionService.userDetails.imageURL, name: "\(sessionService.userDetails.firstName) \(sessionService.userDetails.lastName)", linkedEvent: linkedEvent, linkedVenue: linkedVenue, linkedDeal: linkedDeal, event: event, sender: sessionService.userDetails)
                message = ""
                linkedEvent = nil
                linkedVenue = nil
                linkedDeal = nil
            }
            
        }
        .onChange(of: linkedDeal) { change in
            if change != nil {
                messagesManager.sendMessage(text: message, uid: sessionService.userDetails.uid, id: event.id, pres: event.endTime == "" ? true : false, imageurl: sessionService.userDetails.imageURL, name: "\(sessionService.userDetails.firstName) \(sessionService.userDetails.lastName)", linkedEvent: linkedEvent, linkedVenue: linkedVenue, linkedDeal: linkedDeal, event: event, sender: sessionService.userDetails)
                message = ""
                linkedEvent = nil
                linkedVenue = nil
                linkedDeal = nil
            }
            
        }

    }
    
    func setTab(tab: Int, completion: @escaping () -> ()) {
        self.selectedTab = tab
        completion()
    }
    
}



struct CustomTextField : View {

    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit : () -> () = {}

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .opacity(0.5)
            }

            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }

}

//struct CustomTextField : UIViewRepresentable {
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(text: $text)
//
//    }
//
//
//    @Binding var text: String
//    let placeholder: String
//    var editingChanged: (Bool) -> () = {_ in}
//    var commit : () -> () = {}
//
//    class Coordinator: NSObject, UITextFieldDelegate {
//        @Binding var text: String
//        var becameFirstResponder = false
//
//        init(text: Binding<String>) {
//            self._text = text
//        }
//
//        func textFieldDidChangeSelection(_ textField: UITextField) {
//            text = textField.text ?? ""
//        }
//
////        func makeCoordinator() -> Coordinator {
////        }
//
//    }
//
//    func makeUIView(context: Context) -> some UIView {
//        let textField = UITextField()
//        textField.delegate = context.coordinator
//        textField.placeholder = placeholder
//        return textField
//    }
//
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//        if !context.coordinator.becameFirstResponder {
//            uiView.becomeFirstResponder()
//            context.coordinator.becameFirstResponder = true
//        }
////        context.coordinator.text = ""
//    }
//
////    var placeholder: Text
////
////    var editingChanged: (Bool) -> () = {_ in}
////    var commit : () -> () = {}
////
////    var body: some View {
////        ZStack(alignment: .leading) {
////            if text.isEmpty {
////                placeholder
////                    .opacity(0.5)
////            }
////
////            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
////        }
////    }
//
//}

//struct MessageFieldView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        let event = EventObj(creator: "", date: "23-01-2022", description: "Let's trot", endTime: "", filename: "", id: "", imageurl: "https://s3-ap-southeast-2.amazonaws.com/production.assets.merivale.com.au/wp-content/uploads/2019/07/15171723/lost_sundays_gallery_2.jpg", label: "Pres", startTime: "20:00", creatorID: "", invited: ["QV8WKYu09tUxjj5Iai827aBbbXD2"], going: [], interested: [], declined: [], performers: [], userCreated : true, linkedEvent: "", linkedVenue: "", address: "", ticketLink: "", hosts: [], hostNames: [])
//        
//        MessageFieldView(event: event)
//            .environmentObject(MessagesManager())
//    }
//}
