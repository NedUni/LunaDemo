//
//  LandingPage.swift
//  Luna
//
//  Created by Ned O'Rourke on 13/4/22.
//

import SwiftUI

struct LandingPage: View {
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    
    var body: some View {
        ZStack (alignment: .bottom) {
            LoopingPlayer()
                .grayscale(1)
           
            HStack {
                NavigationLink (destination: NewLoginView()
                    .environmentObject(sessionService)) {
                        VStack {
                            Text("Login")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        .frame(width: UIScreen.main.bounds.width*0.47, height: 40)
                        .background(.white)
                        .cornerRadius(20)
                        
                    }
                
                Spacer()
                
                NavigationLink (destination: NewSignUp()
                                    .environmentObject(sessionService)) {
                        VStack {
                            Text("Register")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(width: UIScreen.main.bounds.width*0.47, height: 40)
                        .background(.purple.opacity(0.8))
                        .cornerRadius(20)
       
                }
            }
            .padding(.horizontal, UIScreen.main.bounds.width*0.05)
            .padding(.bottom, 50)
            .foregroundColor(.white)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
