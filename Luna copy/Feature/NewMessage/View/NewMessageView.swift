//
//  NewMessageView.swift
//  Luna
//
//  Created by Will Polich on 14/4/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewMessageView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @Binding var showNewMessage : Bool
    let didSelectNewUser: (UserObj) -> ()
    
    var body: some View {
        NavigationView {
            ScrollView {
                if sessionService.currentFriends.count == 0 {
                    Text("To send messages, you need to add some friends first!")
                        .foregroundColor(Color.secondary)
                        .padding(.horizontal)
                } else {
                    ForEach(sessionService.currentFriends, id: \.self) { user in
                        
                        Button {
                            showNewMessage.toggle()
                            didSelectNewUser(user)
                            
                        } label: {
                            VStack (alignment: .leading) {
                                HStack (alignment: .center){
                                    WebImage(url: URL(string: user.imageURL))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 64, height: 64).cornerRadius(64)
                                        .clipped()
                                        .padding(.horizontal)
                                        .padding(.vertical, 5)

                                    Text("\(user.firstName) \(user.lastName)")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color.primary)

                                    Spacer()
                                }
//
                                   
                                Divider()
                            }
                            
                           
                        }

                        
                    }
                }
            }
            .navigationBarTitle("New Message")
            .onAppear {
                sessionService.getFriends(uid: sessionService.userDetails.uid, completion: {})
            }
            .applyClose()
//            .background(Color("darkBackground"))
            
            
        }
        .background(Color("darkBackground"))
        
        
        
    }
}


