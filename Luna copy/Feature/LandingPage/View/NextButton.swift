//
//  NextButton.swift
//  Luna
//
//  Created by Ned O'Rourke on 14/4/22.
//

import SwiftUI

struct NextButton: View {
    
    @State var text : String
    @Binding var isTriggered : Bool
    @Binding var signUpTab : Int
    
    var body: some View {
        Button {
            if isTriggered {
                self.signUpTab += 1
                self.isTriggered = false
            }
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

//struct NextButton_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            NextButton(text: "Continue")
//        }
//        .padding(.horizontal)
//        
//    }
//}
