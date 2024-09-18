//
//  ModalTest.swift
//  Luna
//
//  Created by Ned O'Rourke on 4/6/2022.
//

import SwiftUI

struct ModalTest: View {
    
    @State var halfModal_shown = false
    
    var body: some View {
        ZStack {
            Button(action: {
                halfModal_shown.toggle()
                            
                        }) {
                            Text("show card")
                        }
            HalfModalView(isShown: $halfModal_shown) {
                VStack {
                    Text("lol").background(Color("darkBackground"))
                }
            }
        }
    }
}

struct ModalTest_Previews: PreviewProvider {
    static var previews: some View {
        ModalTest()
    }
}
