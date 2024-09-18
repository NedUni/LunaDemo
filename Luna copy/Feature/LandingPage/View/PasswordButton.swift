//
//  CreateAccountButton.swift
//  Luna
//
//  Created by Ned O'Rourke on 14/4/22.
//

import SwiftUI

struct PasswordButton: View {
    @State var text : String
    @Binding var signUpTab : Int
    @Binding var error : Bool
    @Binding var usersPassword : String
    @Binding var usersConfirmedPassword : String
    
    @State var timeRemaining : Int = 2
    @State var currentDate = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Button {
            self.timeRemaining = 2
            
            if usersPassword != usersConfirmedPassword {
                self.error = true
            }
            else {
                self.signUpTab += 1
            }
        } label: {
            VStack {
                Text(error ? "Passwords don't match" : text)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .onReceive(timer) { _ in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        }
                        else {
                            withAnimation {
                                self.error = false
                            }
                        }
                    }
            }
            .frame(width: UIScreen.main.bounds.width*0.9, height: 55)
            .background(error ? Color("Error") : .purple.opacity(0.8))
            .cornerRadius(20)
        }
    }
}
//
//struct CreateAccountButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateAccountButton()
//    }
//}
