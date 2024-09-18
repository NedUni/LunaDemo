//
//  NewLoginView.swift
//  Luna
//
//  Created by Will Polich on 27/4/2022.
//

import SwiftUI
import FirebaseAuth

struct NewLoginView: View {
    @EnvironmentObject var sessionService : SessionServiceImpl
    
    @State var loginTab : Int = 0
    @State var isTriggered : Bool = false
    @State var error : Bool = false
    @State var credential : PhoneAuthCredential?
    @State var verificationID : String?
    @State var completingSignUp = false
    @State var phoneNumberError = ""
    @State var usersPhoneNumber: String = ""
    @State var usersCode: String = ""
    @State var loggingIn = false
    @State var loginError = ""
    
    
    var body: some View {
       
            ZStack {
                Color("darkBackground")
                    .ignoresSafeArea()
                
                VStack (alignment: .center) {
                    
                    switch loginTab {
                        
                    case 0:
                        Group {
                            VStack (alignment: .center, spacing: 0) {
                                VStack {
                                    Text("LUNA")
                                        .font(.system(size: 20))
                                        .fontWeight(.heavy)
                                        .foregroundColor(.white)
                                        .padding(.bottom, 10)
                                    Text("Login with phone number (04...)")
                                        .foregroundColor(.white)
                                    TextField("", text: $usersPhoneNumber)
                                        .keyboardType(.phonePad)
                                        .font(.system(size: 40, weight: .heavy))
                                        .multilineTextAlignment(TextAlignment.center)
                                        .foregroundColor(.white)
                                        .placeholder(when: usersPhoneNumber.isEmpty) {
                                            Text("04XXXXXXXXX")
                                                .font(.system(size: 40, weight: .heavy))
                                                .foregroundColor(Color("darkSecondaryText")).opacity(0.3)
                                        }
                                        .onChange(of: usersPhoneNumber) { newValue in
                                            if newValue.count == 10 {
                                                isTriggered = true
                                            } else {
                                                isTriggered = false
                                            }
                                            
                                    }
                                    
                                    Spacer()
                                }
                                .ignoresSafeArea(.keyboard)
                                
                                VStack {
                                    
                                    Text(phoneNumberError)
                                        .font(.system(size: 15))
                                        .foregroundColor(Color("Error"))
                                        .fontWeight(.heavy)
                                    
                                    
                                    NewPhoneAuthButton(text: "Continue", isTriggered: $isTriggered, signUpTab: $loginTab, phoneNumber: $usersPhoneNumber, verificationID: $verificationID, phoneNumberError: $phoneNumberError)
                                        .environmentObject(sessionService)
                                }
                                .padding(.bottom)
                                
                            }
                        }
                    
                    case 1:
                        VStack (alignment: .center, spacing: 0) {
                            VStack {
                                Text("LUNA")
                                    .font(.system(size: 20))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .padding(.bottom, 10)
                                Text("We just sent you a secret code. Please enter it")
                                    .foregroundColor(.white)
                                TextField("", text: $usersCode)
                                    .keyboardType(.numberPad)
                                    .font(.system(size: 40, weight: .heavy))
                                    .multilineTextAlignment(TextAlignment.center)
                                    .foregroundColor(.white)
                                    .placeholder(when: usersCode.isEmpty) {
                                        Text("******")
                                            .font(.system(size: 40, weight: .heavy))
                                            .foregroundColor(Color("darkSecondaryText")).opacity(0.3)
                                    }
                                    .onChange(of: usersCode) { newValue in
                                        
                                        if newValue.count == 6 {
                                            isTriggered = true
                                        }
                                        else {
                                            isTriggered = false
                                        }
                                }
                                
                                Spacer()
                            }
                            .ignoresSafeArea(.keyboard)
                            
                            VStack {
                                Text(loginError)
                                    .font(.system(size: 15))
                                    .foregroundColor(Color("Error"))
                                    .fontWeight(.heavy)
                                
                                LoginVerificationNextButton(text: "Continue", isTriggered: $isTriggered, signUpTab: $loginTab, code: $usersCode, credential: $credential, verificationID: $verificationID, loginError: $loginError)
                                    .environmentObject(sessionService)

                            }
                            .padding(.bottom)
                            
                        }

                        
                    default:
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            .scaleEffect(2)
                    }
                }
                .navigationBarTitle("", displayMode: .inline)
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: BackButtonView())
            .navigationBarBackButtonHidden(true)
            
        
        
    }
}

