//
//  MessagesInboxView.swift
//  Luna
//
//  Created by Will Polich on 19/3/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct TitleRowView: View {
    
    @EnvironmentObject var viewModel : ViewModel
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    
    @Binding var shouldNavigateToEventChat : Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var event: EventObj
    
    var body: some View {
        
        HStack (spacing : 20) {
            Button(action: {
                shouldNavigateToEventChat = false
                presentationMode.wrappedValue.dismiss()
                
            }, label: {
                
                Image(systemName: "chevron.backward.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("darkBackground"))
    //                .colorInvert()
                    .background(Color.primary).cornerRadius(20)
                    .overlay(
                        Circle()
                            .stroke(Color("darkBackground"), lineWidth: 1)
                    )
                    
            })
//            if shouldNavigateToEventChat != nil {
//                Button(action: {
//                   shouldNavigateToEventChat = false
//
//                }, label: {
//
//                    Image(systemName: "chevron.backward.circle.fill")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 30, height: 30)
//                        .foregroundColor(Color("darkBackground"))
//        //                .colorInvert()
//                        .background(Color.primary).cornerRadius(20)
//                        .overlay(
//                            Circle()
//                                .stroke(Color("darkBackground"), lineWidth: 1)
//                        )
//
//                })
//            } else {
//                BackButtonView()
//            }
            
            NavigationLink(destination: PresView(event: event)
                .environmentObject(sessionService)
                .environmentObject(manager)
                .environmentObject(viewModel)) {
                VStack (alignment: .leading) {
                    Text(event.label)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Image(systemName: "rectangle.portrait.and.arrow.right")
        }
        .background(Color("darkBackground").opacity(0.2))
        .padding()
        
        
        
    }
}

//struct TitleRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        let event = EventObj(creator: "", date: "23-01-2022", description: "Let's trot", endTime: "", filename: "", id: "", imageurl: "https://s3-ap-southeast-2.amazonaws.com/production.assets.merivale.com.au/wp-content/uploads/2019/07/15171723/lost_sundays_gallery_2.jpg", label: "Party", startTime: "20:00", creatorID: "", invited: ["QV8WKYu09tUxjj5Iai827aBbbXD2"], going: [], interested: [], declined: [], performers: [], userCreated : true, linkedEvent: "", linkedVenue: "", address: "", ticketLink: "", hosts: [], hostNames: [])
//        
//        TitleRowView(event: event)
//    }
//}
