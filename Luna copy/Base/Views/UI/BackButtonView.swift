//
//  BackButtonView.swift
//  Luna
//
//  Created by Will Polich on 4/2/2022.
//

import SwiftUI

struct BackButtonView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        Button(action: {
            presentationMode.wrappedValue.dismiss()
            
        }, label: {
            
            Image(systemName: "chevron.backward.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(Color("darkBackground"))
//                .colorInvert()
                .background(Color.primary).cornerRadius(20)
                .overlay(
                    Circle()
                        .stroke(Color("darkBackground"), lineWidth: 1)
                )
                
        })

        
    }
}

struct BackButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack (alignment: .leading) {
                HStack {
                    BackButtonView()
                    
                    Spacer()
                }.padding(.leading)
               
            }
        }
    }
}
