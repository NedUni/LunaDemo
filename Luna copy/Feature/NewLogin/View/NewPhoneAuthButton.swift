import SwiftUI
import Firebase
import FirebaseAuth

struct NewPhoneAuthButton: View {
    @State var text : String
    @Binding var isTriggered : Bool
    @Binding var signUpTab : Int
    @Binding var phoneNumber : String
    @Binding var verificationID : String?
    @Binding var phoneNumberError: String
    @State var checkingPhoneNumber = false
    
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        Button {
            if isTriggered {
                checkingPhoneNumber = true
                var adjustedPhone = phoneNumber.dropFirst(1)
                adjustedPhone = "+61" + adjustedPhone
                print(adjustedPhone)
                sessionService.phoneSignInVerification(phoneNumber: String(adjustedPhone), new: false) { verificationID, error in
                    checkingPhoneNumber = false
                    if error != nil  {
                        phoneNumberError = error ?? "User does not exist"
                        print("Error with phone sign in: \(error)")
                        return
                    } else if verificationID == "" {
                        phoneNumberError = "User does not exist."
                        return
                    }
                    
                    self.verificationID = verificationID
                    self.signUpTab += 1
                    self.isTriggered = false
                }
            }
            
        } label: {
            VStack {
                if checkingPhoneNumber {
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

