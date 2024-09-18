//
//  TextInputView.swift
//  Luna
//
//  Created by Ned O'Rourke on 8/1/22.
//

import SwiftUI

struct TextInputView: View {
    
    @Binding var text: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    let sfSymbol: String?
    
    private let textFieldLeading: CGFloat = 30
    
    var body: some View {
        TextField(placeholder, text: $text)
            .frame(maxWidth: .infinity,
                   minHeight: 44)
            .padding(.leading, sfSymbol == nil ? textFieldLeading / 2 : textFieldLeading)
            .keyboardType(keyboardType)
            .disableAutocorrection(true)
            .background(
            
                ZStack(alignment: .leading) {
                    
                    if let systemImage = sfSymbol {
                        
                        Image(systemName: systemImage)
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.leading, 5)
                            .foregroundColor(Color.gray.opacity(0.5))
                    }
                    RoundedRectangle(cornerRadius: 44,
                                     style: .continuous)
                        .stroke(Color.gray.opacity(0.5))
                }
            )
    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(text: .constant(""),
                      placeholder: "Email",
                      keyboardType: .emailAddress,
                      sfSymbol: "envelope")
            .preview(with: "Email")
    }
}
