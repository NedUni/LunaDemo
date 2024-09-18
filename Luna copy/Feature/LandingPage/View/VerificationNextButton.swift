//
//  VerificationNextButton.swift
//  Luna
//
//  Created by Will Polich on 27/4/2022.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct VerificationNextButton: View {
    @State var text : String
    @Binding var isTriggered : Bool
    @Binding var signUpTab : Int
    @Binding var code: String
    @Binding var credential : PhoneAuthCredential?
    @Binding var verificationID : String?
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        Button {
            sessionService.getPhoneAuthCredential(code: code, verificationID: verificationID!, completion: { credential in
                
                self.credential = credential
                self.signUpTab += 1
                self.isTriggered = false
            })
            
        } label: {
            VStack {
                Text(text)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .frame(width: UIScreen.main.bounds.width*0.9, height: 55)
            .background(isTriggered ? .purple.opacity(0.8) : .purple.opacity(0.3))
            .cornerRadius(20)
        }
    }
}


