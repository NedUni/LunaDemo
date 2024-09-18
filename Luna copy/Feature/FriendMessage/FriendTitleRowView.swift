//
//  FriendTitleRowView.swift
//  Luna
//
//  Created by Will Polich on 14/4/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct FriendTitleRowView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    var chatUser: UserObj?
    
    @Binding var shouldNavigateToChat : Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        HStack {
            Button(action: {
                shouldNavigateToChat = false
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
//            Button(action: {
//               shouldNavigateToChat = false
//
//            }, label: {
//
//                Image(systemName: "chevron.backward.circle.fill")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 30, height: 30)
//                    .foregroundColor(Color("darkBackground"))
//    //                .colorInvert()
//                    .background(Color.primary).cornerRadius(20)
//                    .overlay(
//                        Circle()
//                            .stroke(Color("darkBackground"), lineWidth: 1)
//                    )
//
//            })
            NavigationLink(destination: chatUser!.performer ? AnyView(PerformerProfileView(user: chatUser!)
                .environmentObject(sessionService)
                .environmentObject(manager)
                .environmentObject(homeVM))
               : AnyView(UserProfileView(user: chatUser!)
                .environmentObject(sessionService)
                .environmentObject(manager)
                .environmentObject(homeVM))) {
                if chatUser != nil {
                    WebImage(url: URL(string: chatUser!.imageURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45).cornerRadius(64)
                        .clipped()

                }
                Text("\(chatUser?.firstName ?? "") \(chatUser?.lastName ?? "")")
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
//                   .font(.title).bold()
//                   .font(.system(size: 20)).bold()
//                   .foregroundColor(Color.black)
                }
            
            Spacer()
        }
        
        .background(Color("darkBackground").opacity(0.2))
        .padding(.horizontal)
        
        
//        HStack (spacing : 20) {
//            BackButtonView()
//
//            if chatUser != nil {
//
//                NavigationLink(destination: chatUser!.performer ? AnyView(PerformerProfileView(user: chatUser!)
//                    .environmentObject(sessionService)
//                    .environmentObject(manager)
//                    .environmentObject(homeVM))
//                   : AnyView(UserProfileView(user: chatUser!)
//                    .environmentObject(sessionService)
//                    .environmentObject(manager)
//                    .environmentObject(homeVM))) {
//                    if chatUser != nil {
//                        WebImage(url: URL(string: chatUser!.imageURL))
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 64, height: 64).cornerRadius(64)
//                            .clipped()
//
//                    }
//
//
//                    VStack (alignment: .leading) {
//                        Text("\(chatUser?.firstName ?? "") \(chatUser?.lastName ?? "")")
//        //                    .font(.title).bold()
//                            .font(.system(size: 20)).bold()
//                            .foregroundColor(Color.black)
//        //                Text("Online")
//        //                    .font(.caption)
//        //                    .foregroundColor(Color.secondary)
//
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                    Image(systemName: "rectangle.portrait.and.arrow.right")
//                }
//                .foregroundColor(.black)
//            }
//        }
//        .padding()
//        .background(Color("facade"))
        
        
    }
}

    
