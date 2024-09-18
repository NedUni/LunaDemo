//
//  ImageUploadNextButton.swift
//  Luna
//
//  Created by Will Polich on 27/4/2022.
//

import SwiftUI
import Firebase
import FirebaseAuth
import Mixpanel

struct ImageUploadNextButton: View {
    @State var text : String
    @Binding var isTriggered : Bool
    @Binding var signUpTab : Int
    
    var body: some View {
        Button {
//            if isTriggered {
            self.signUpTab += 1
//                self.isTriggered = false
//            }
        } label: {
            VStack {
                Text(text)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .frame(width: UIScreen.main.bounds.width*0.9, height: 55)
            .background(.purple.opacity(0.8))
            .cornerRadius(20)
        }
    }
    
}

struct AccountCreationButton: View {
    @EnvironmentObject var sessionService : SessionServiceImpl
    @State var text : String
    @Binding var isTriggered : Bool
    @Binding var signUpTab : Int
    @Binding var image : UIImage?
    @Binding var firstName : String
    @Binding var lastName : String
    @Binding var dob : String
    @Binding var credential : PhoneAuthCredential?
    @Binding var phone: String
//    @Binding var errorMessage: String
    @Binding var phoneNumberError : String
    @Binding var completingSignUp : Bool
    
//    UIImage(named: "stockProfilePicture")
    
    var body: some View {
        Button {
            completingSignUp = true
            sessionService.completePhoneSignUp(phone: phone, image: (image ?? UIImage(named: "stockProfilePicture"))!, firstName: firstName, lastName: lastName, dob: dob, credential: credential!) { error in
                completingSignUp = false
                if let error = error {
                    print("Error creating user account: \(error)")
                    self.phoneNumberError = "Invalid verification code. Please re-enter your phone number so we can send you a new code."
                    self.signUpTab = 3
                    return
                }
                Mixpanel.mainInstance().time(event: "Sign Up")
                self.signUpTab += 1
                self.isTriggered = false
            }
           
        } label: {
            VStack {
                if completingSignUp == true {
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
            .background(.purple.opacity(0.8))
            .cornerRadius(20)
        }
    }
}

