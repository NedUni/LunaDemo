//
//  NewSignUP.swift
//  Luna
//
//  Created by Ned O'Rourke on 13/4/22.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseAuth

struct NewSignUp: View {
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    
    @State var signUpTab : Int = 0
    @State var isTriggered : Bool = false
    @State var error : Bool = false
    let dateFormatter : DateFormatter = DateFormatter()
    
    @State var credential : PhoneAuthCredential?
    @State var verificationID : String?
    @State var completingSignUp = false
    @State var phoneNumberError = ""
    
    //Switch 0
    
    
    
    //Switch 1
    @State var usersName : String = ""
    @State var firstName: String = ""
    @State var lastName : String = ""
    @State var usersDOB: String = ""
    @State var last: String = ""
    @State var state: Bool = false
    @State var state2: Bool = false
    @State var dob : Date = Date.now
    
    //Switch 2
    @State var usersPhoneNumber: String = ""
    
    //Switch 3
    @State var usersCode: String = ""
    
    //Switch 4
    @State var usersPassword: String = ""
    @State var usersConfirmedPassword: String = ""
    @State var errorMessage = ""
    
    //Switch 5
    @State var shouldShowImagePicker: Bool = false
    @State var usersProfileImage: UIImage?
    
    var body: some View {
        
        ZStack {
            Color("darkBackground")
                .ignoresSafeArea()
            
            VStack (alignment: .center) {
                
                switch signUpTab {
                    
                case 0:
                    VStack (alignment: .center, spacing: 0) {
                        VStack {
                            Text("LUNA")
                                .font(.system(size: 20))
                                .fontWeight(.heavy)
                                .foregroundColor(.primary)
                                .padding(.bottom, 10)
                            Text("Let's get you out there, what's your name?")
                                .foregroundColor(.primary)
                            
                            TextField("", text: $firstName)
                                .font(.system(size: 40, weight: .heavy))
                                .multilineTextAlignment(TextAlignment.center)
                                .foregroundColor(.primary)
                                .placeholder(when: firstName.isEmpty) {
                                    Text("First Name")
                                        .font(.system(size: 40, weight: .heavy))
                                        .foregroundColor(Color("darkSecondaryText")).opacity(0.3)
                                }
                                .onChange(of: firstName) { newValue in
                                    if newValue.count >= 3 && lastName.count >= 3{
                                        isTriggered = true
                                    }
                                    else {
                                        isTriggered = false
                                    }
                                }
                                .padding()
                             
                            
                            TextField("", text: $lastName)
                                .font(.system(size: 40, weight: .heavy))
                                .multilineTextAlignment(TextAlignment.center)
                                .foregroundColor(.primary)
                                .placeholder(when: lastName.isEmpty) {
                                    Text("Last Name")
                                        .font(.system(size: 40, weight: .heavy))
                                        .foregroundColor(Color("darkSecondaryText")).opacity(0.3)
                                }
                                .onChange(of: lastName) { newValue in
                                    if newValue.count >= 3 && firstName.count >= 3{
                                        isTriggered = true
                                    }
                                    else {
                                        isTriggered = false
                                    }
                                }
                                .padding()
                            
                            Spacer()
                        }
                        .ignoresSafeArea(.keyboard)
                        
                        VStack {
                            NextButton(text: "Continue", isTriggered: $isTriggered, signUpTab: $signUpTab)
                        }
                        .padding(.bottom)
                    }
                    .padding(.horizontal)
                
                case 1:
                    VStack (alignment: .center, spacing: 0) {
                        VStack {
                            Text("LUNA")
                                .font(.system(size: 20))
                                .fontWeight(.heavy)
                                .foregroundColor(.primary)
                                .padding(.bottom, 10)
                            Text("Enter your birthday")
                                .foregroundColor(.primary)
                            TextField("", text: $usersDOB)
                                .keyboardType(.numberPad)
                                .font(.system(size: 40, weight: .heavy))
                                .multilineTextAlignment(TextAlignment.center)
                                .foregroundColor(.primary)
                                .placeholder(when: usersDOB.isEmpty) {
                                    Text("DD MM YYYY")
                                        .font(.system(size: 40, weight: .heavy))
                                        .foregroundColor(Color("darkSecondaryText")).opacity(0.3)
                                }
                                .onChange(of: usersDOB) { newValue in
                                    
                                    if last.count <= newValue.count {
                                        if newValue.count == 2 {
                                            usersDOB = usersDOB + "-"
                                        }
                                        
                                        else if state && usersDOB.count != 1 {
                                            usersDOB.insert("-", at: usersDOB.index(before: usersDOB.endIndex))
                                            state = false
                                        }
                                        
                                        if newValue.count == 5 {
                                            usersDOB = usersDOB + "-"
                                            state2 = false
                                        }
                                        
                                        else if state2 {
                                            usersDOB.insert("-", at: usersDOB.index(before: usersDOB.endIndex))
                                            state2 = false
                                        }
                                    }
                                    
                                    else {
                                        if usersDOB.count == 2 && usersDOB.last != "-" {
                                            state = true
                                        }
                                        
                                        if usersDOB.count == 5 {
                                            state2 = true
                                        }
                                        
                                    }
                                    
                                    last = newValue
                                    
                                   
                                    dateFormatter.dateFormat = "dd-MM-yy"
                                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//                                    let dateS = usersDOB
                                    
                                    let date = dateFormatter.date(from: usersDOB)
                                    
                                    if date != nil && usersDOB.count == 10 {
                                        self.dob = date ?? Date.now
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
                            if error {
                                Text("You must be 18 to use Luna")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color("Error"))
                                    .fontWeight(.heavy)
                            }

                            NextButtonDOB(text: "Continue", dob: self.$dob, isTriggered: $isTriggered, signUpTab: $signUpTab, error: $error)
                        }
                        .padding(.bottom)
                        
                    }
                
                case 2:
                    ZStack {
                        VStack (alignment: .center, spacing: 0) {
                            VStack {
                                Text("LUNA")
                                    .font(.system(size: 20))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.primary)
                                    .padding(.bottom, 10)
                                Text("Let's put a face to the name")
                                    .foregroundColor(.primary)
                                
                                Button {
                                   shouldShowImagePicker.toggle()
                                } label: {
                                    VStack {
                                        if let image = self.usersProfileImage {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 256, height: 256)
                                                .cornerRadius(128)
    //                                            .overlay(Circle().stroke(Color.red, lineWidth: ))
                                                
                                        } else {
                                            Image("stockProfilePicture")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 256, height: 256)
                                                .cornerRadius(128)
                                                .overlay(Circle().stroke(Color("darkSecondaryText"), lineWidth: 0.2))
                                        }
                                        
                                        Text(usersProfileImage == nil ? "Select Profile Picture" : "Hot Damn, looking good")
                                            .foregroundColor(Color("darkSecondaryText"))
                                    }
                                    
                                }
                                
                            
                                Spacer()
                            }
                            .ignoresSafeArea(.keyboard)
                            
                            VStack {
                                ImageUploadNextButton(text: "Continue", isTriggered: $isTriggered, signUpTab: $signUpTab)
//                                ImageUploadNextButton(text: "Create", isTriggered: $isTriggered, signUpTab: $signUpTab, image: $usersProfileImage, firstName: $firstName, lastName: $lastName, dob: $usersDOB, credential: $credential, phone: $usersPhoneNumber, completingSignUp: $completingSignUp)
                            }
                            .padding(.bottom)
                            
                        }
                        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                               ImagePicker(image: $usersProfileImage)
                        }
                        .onChange(of: usersProfileImage) { newValue in
                            isTriggered = true
                        }
                        .onAppear {
                            firstName = firstName.replacingOccurrences(of: " ", with: "")
                            lastName = lastName.replacingOccurrences(of: " ", with: "")
                        }
                            
                        
                        
                    }
                    
                    
                case 3:
                    Group {
                        VStack (alignment: .center, spacing: 0) {
                            VStack {
                                Text("LUNA")
                                    .font(.system(size: 20))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.primary)
                                    .padding(.bottom, 10)
                                Text("Enter phone number (04...)")
                                    .foregroundColor(.primary)
                                TextField("", text: $usersPhoneNumber)
                                    .keyboardType(.phonePad)
                                    .font(.system(size: 40, weight: .heavy))
                                    .multilineTextAlignment(TextAlignment.center)
                                    .foregroundColor(.primary)
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
                                        
//                                        if usersPhoneNumber.count > 10 {
//                                            isTriggered = true
//                                        }
//                                        else {
//                                            isTriggered = false
//                                        }
                                }
                                
                                Spacer()
                            }
                            .ignoresSafeArea(.keyboard)
                            
                            VStack {
                                
                                Text(phoneNumberError)
                                    .font(.system(size: 15))
                                    .foregroundColor(Color("Error"))
                                    .fontWeight(.heavy)
                                
                                
                                PhoneAuthNextButton(text: "Continue", isTriggered: $isTriggered, signUpTab: $signUpTab, phoneNumber: $usersPhoneNumber, verificationID: $verificationID, phoneNumberError: $phoneNumberError)
                                    .environmentObject(sessionService)
                            }
                            .padding(.bottom)
                            
                        }
                    }
                    
                
                case 4:
                    VStack (alignment: .center, spacing: 0) {
                        VStack {
                            Text("LUNA")
                                .font(.system(size: 20))
                                .fontWeight(.heavy)
                                .foregroundColor(.primary)
                                .padding(.bottom, 10)
                            Text("We just sent you a secret code. Please enter it")
                                .foregroundColor(.primary)
                            TextField("", text: $usersCode)
                                .keyboardType(.numberPad)
                                .font(.system(size: 40, weight: .heavy))
                                .multilineTextAlignment(TextAlignment.center)
                                .foregroundColor(.primary)
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
                            VerificationNextButton(text: "Continue", isTriggered: $isTriggered, signUpTab: $signUpTab, code: $usersCode, credential: $credential, verificationID: $verificationID)
                                .environmentObject(sessionService)

                        }
                        .padding(.bottom)
                        
                    }
                
                    
                case 5:
                    ZStack {
                        VStack (alignment: .center, spacing: 0) {
                            VStack (alignment: .leading, spacing: 15) {
                                Text("LUNA")
                                    .font(.system(size: 20))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.primary)
                                    .padding(.bottom, 10)
                                
                                HStack (alignment: .top) {
                                    Image(systemName: "bell.fill")
                                        .imageScale(.large)
                                        .foregroundColor(.purple.opacity(0.3))
                                    VStack (alignment: .leading, spacing: 10) {
                                        Text("Allow Notifications")
                                            .font(.system(size: 20))
                                            .fontWeight(.heavy)
                                            .foregroundColor(.primary)
                                        Text("Keep best up to date with your friends, friend requests and messages. Also lets you know when a venue you're at pushes a fire sale!")
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                
                                Divider()
                                
                                HStack (alignment: .top) {
                                    Image(systemName: "map.fill")
                                        .imageScale(.large)
                                        .foregroundColor(.purple.opacity(0.3))
                                    VStack (alignment: .leading, spacing: 10) {
                                        Text("Allow Location Tracking")
                                            .font(.system(size: 20))
                                            .fontWeight(.heavy)
                                            .foregroundColor(.primary)
                                        Text("This sound scary, but this just shows you the closest venues and deals to you, aswell as showing your friends where you are. Make sure to enable 'Always' the second time you load up the app for auto checkins!")
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Text("By signing up you agree to our")
                                        .foregroundColor(.white)
                                    Button {
                                        guard let url = URL(string: "https://luna-group.com.au/privacypolicy") else {
                                            print("Cannot build privacy policy url")
                                            return
                                        }
                                        
                                        if UIApplication.shared.canOpenURL(url) {
                                              UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                        }
                                    } label: {
                                        Text("**Privacy Policy**")
                                            .foregroundColor(.purple)
                                        
                                    }
                                }
                                .font(.caption)
                                .padding(.bottom, 20)

                            }
                            
                            VStack {
                                AccountCreationButton(text: "Create", isTriggered: $isTriggered, signUpTab: $signUpTab, image: $usersProfileImage, firstName: $firstName, lastName: $lastName, dob: $usersDOB, credential: $credential, phone: $usersPhoneNumber, phoneNumberError: $phoneNumberError, completingSignUp: $completingSignUp)
                            }
                            .padding(.bottom)
                            
                        }
                        .padding(.horizontal)
                        
                    }
                    
                    
                case 6:
                    ProgressView()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                default:
                    Text("PLACEHOLDER")
                }
                
                
            }
            .navigationBarTitle("", displayMode: .inline)
//            .navigationBarHidden(true)
            
        }
        
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: BackButtonView())
        .navigationBarBackButtonHidden(true)
        

    }
}

extension View {

    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .center,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

