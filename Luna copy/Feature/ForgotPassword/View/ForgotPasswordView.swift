//
//  ForgotPasswordView.swift
//  Luna
//
//  Created by Ned O'Rourke on 8/1/22.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAlert = false
    @State private var errString: String?
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 16) {
                
//                TextField("Enter email address", text: $sessionService.userDetails.email)
                TextInputView(text: $sessionService.userDetails.email,
                              placeholder: "Enter email",
                              keyboardType: .emailAddress,
                              sfSymbol: "envelope")
                
                ButtonView(title: "Send Email") {
                    sessionService.resetPassword(email: self.sessionService.userDetails.email) { (result) in
                        switch result {
                        case .failure(let error):
                            self.errString = error.localizedDescription
                        default:
                            break
                        }
                        self.showAlert = true
                    }
                }
                
            }
            .padding(.horizontal, 16)
            .navigationTitle("Forgot Password?")
            .applyClose()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Passsword Reset"),
                      message: Text(self.errString ?? "Success. Check your email at \(sessionService.userDetails.email) to reset your password."),
                      dismissButton: .default(Text("ok")) {
                    self.presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
