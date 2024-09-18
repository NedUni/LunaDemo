//
//  LoginVerificationNextButton.swift
//  Luna
//
//  Created by Will Polich on 27/4/2022.
//

import SwiftUI
import FirebaseAuth

struct LoginVerificationNextButton: View {
    @State var text : String
    @Binding var isTriggered : Bool
    @Binding var signUpTab : Int
    @Binding var code: String
    @Binding var credential : PhoneAuthCredential?
    @Binding var verificationID : String?
    @State var loggingIn = false
    @Binding var loginError : String
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        Button {
            loggingIn = true
            loginError = ""
            sessionService.getPhoneAuthCredential(code: code, verificationID: verificationID!, completion: { credential in
                self.credential = credential
                sessionService.phoneSignIn(credential: credential!) { error in
                    loggingIn = false
                    self.isTriggered = false
                    if let error = error {
                        loginError = error.localizedDescription
                        return
                    }
                    self.signUpTab += 1
                    
                }
            })
            
        } label: {
            VStack {
                if loggingIn {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .scaleEffect(2)
                } else {
                    Text(text)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .frame(width: UIScreen.main.bounds.width*0.9, height: 55)
            .background(isTriggered ? .purple.opacity(0.8) : .purple.opacity(0.3))
            .cornerRadius(20)
        }
    }
}

