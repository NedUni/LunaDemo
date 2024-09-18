//
//  LoginView.swift
//  Luna
//
//  Created by Ned O'Rourke on 8/1/22.
//

import SwiftUI
import Foundation
import UIKit
import FacebookLogin
import FacebookCore

//class ViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let loginButton = FBLoginButton()
//        loginButton.permissions = ["public_profile", "email"]
//
//        loginButton.center = view.center
//        view.addSubview(loginButton)
//    }
//}
var loginManager = LoginManager()

struct LoginView: View {
    
    @State private var showRegistration = false
    @State private var showForgotPassword = false
    
    
    @State var email : String = ""
    @State var password : String = ""
    @State var error : String = ""
    
    
//    @StateObject private var vm = LoginViewModelImpl(
//        service: LoginServiceImpl()
//    )
    @EnvironmentObject var sessionService : SessionServiceImpl

    
    var body: some View {
        
        VStack(spacing: 16) {
            
            NavigationLink(destination: LandingPage()
                            .environmentObject(sessionService)) {
                Text("new")
            }
            
            VStack(spacing: 16) {
                TextInputView(text: $email,
                              placeholder: "Email",
                              keyboardType: .emailAddress,
                              sfSymbol: "envelope")
                    .autocapitalization(.none)
                
                PasswordInputView(password: $password,
                                  placeholder: "Password",
                                  sfSymbol: "lock")
                
            }
            
            HStack {
                Spacer()
                Button(action: {
                    showForgotPassword.toggle()
                }, label: {
                    Text("Forgot Password?")
                        .foregroundColor(Color.purple)
                })
                    .font(.system(size: 16, weight: .bold))
                    .sheet(isPresented: $showForgotPassword, content: {
                        ForgotPasswordView()
                    })
 
            }
            HStack {
                Text(error)
                    .foregroundColor(.red).bold()
            }
            .frame(maxHeight: 50)
            
            ButtonView(title: "Login")  {
                sessionService.login(email: email, password: password, completion: {
                    if sessionService.loginError != "" {
                        error = sessionService.loginError
                    }
                })
            }
            
            ButtonView(title: "Register",
                           background: .clear,
                           foreground: .purple,
                           border: .purple) {
                showRegistration.toggle()
            }
               .sheet(isPresented: $showRegistration, content: {
                   RegisterView()
               })
            
//            FBLog()
//                .font(.system(size: 16, weight: .bold))
//                .frame(maxWidth: .infinity, maxHeight: 50).cornerRadius(60)
//                .padding()
//                .environmentObject(sessionService)
            
//            Button(action: {
                
//                loginManager.logIn(permissions: ["public_profile", "email", "user_birthday"], from: nil) { result, error in
//                    if let error = error {
//                        print("Error logging in with Facebook: \(error)")
//                        return
//                    }
//
//                    if !result!.isCancelled {
//                        print("Requesting Facebook user data...")
//
//                        let request = GraphRequest(graphPath: "me", parameters: ["fields" : "email"])
//
//                        request.start { _, result, error in
//                            if let error = error {
//                                print("Error requesting Facebook user data: \(error)")
//                                return
//                            }
//
//                            guard let profileData = result as? [String: Any] else {return}
//
//                            let email = profileData["email"] as! String
//                            print("Email: \(email)")
//
//
//                        }
//                    }
//
//                }
//            }, label: {
//                Text("FB Login")
//            })

            
        }
        .padding(.horizontal, 15)
        .navigationTitle("Login")
        .ignoresSafeArea(.keyboard)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}


struct FBLog: UIViewRepresentable {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    func makeCoordinator() -> Coordinator {
        return FBLog.Coordinator(parent1: self, session: sessionService)
        
    }
    
    func makeUIView(context: Context) -> FBLoginButton {
        let button = FBLoginButton()
        
        button.delegate = context.coordinator
        button.permissions = ["public_profile", "email", "user_birthday"]
        
        return button
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: Context) {
        
    }
    
    class Coordinator : NSObject, LoginButtonDelegate {
        
        var sessionService: SessionServiceImpl

        var parent: FBLog
        
        init (parent1 : FBLog, session: SessionServiceImpl) {
            parent = parent1
            self.sessionService = session
        }
        
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            if let error = error {
                print("Error logging in with Facebook: \(error)")
                return
            }
            
            if !result!.isCancelled {
                print("Requesting Facebook user data...")
                
                let request = GraphRequest(graphPath: "me", parameters: ["fields" : "email,first_name,last_name,picture,birthday"])
                
                
                
                request.start { _, data, error in
                    if let error = error {
                        print("Error requesting Facebook user data: \(error)")
                        return
                    }
                    
                    guard let profileData = data as? [String: Any] else {return}
                    print(profileData)
                    let imageData = profileData["picture"] as! [String : [String: Any]]
                    let isDefault = imageData["data"]?["is_silhouette"]
                    if isDefault as! Int == 1 {
                        self.sessionService.fbSignIn(loginResult: result!, data : profileData, url: "https://firebasestorage.googleapis.com/v0/b/appluna.appspot.com/o/userplaceholder.jpeg?alt=media&token=edfcc7eb-3092-40da-9d5e-c3ac866015d0")
                    } else {
                        let url = imageData["data"]?["url"]
                        self.sessionService.fbSignIn(loginResult: result!, data : profileData, url: url as! String )
                    }
                            
                    
                    
                    
                }
                
                
            }
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            
        }
    }
}
