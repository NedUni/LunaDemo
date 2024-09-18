//
//  ButtonComponentView.swift
//  Luna
//
//  Created by Ned O'Rourke on 8/1/22.
//

import SwiftUI

struct ButtonView: View {
    
    typealias ActionHandler = () -> Void
    
    let title: String
    let background: Color
    let foreground: Color
    let border: Color
    let handler: ActionHandler
    
    private let CornerRadius: CGFloat = 60
    
    internal init(title: String,
                  background: Color = .purple,
                  foreground: Color = .white,
                  border: Color = .clear,
                  handler: @escaping ButtonView.ActionHandler) {
        self.title = title
        self.background = background
        self.foreground = foreground
        self.border = border
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler, label: {
            Text(title)
                .frame(maxWidth: .infinity, maxHeight: 50)
        })
            .background(background)
            .foregroundColor(foreground)
            .font(.system(size: 16, weight: .bold))
            .cornerRadius(CornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius)
                    .stroke(border, lineWidth: 2)
            )
    }
}

struct ButtonComponentView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(title: "login") { }
    }
}
