//
//  FeedbackView.swift
//  Luna
//
//  Created by Will Polich on 30/5/2022.
//

import SwiftUI
import Firebase

struct FeedbackView: View {
    
    @State var text = "Please leave some anonymous feedback. Whether it be positive or negative, we'd love to hear from you."
    @State var isSending = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    func submitFeedback(text: String) {
        isSending = true
        db.collection("submissions").document().setData(["text" : text, "timestamp" : Date()]) { error in
            if let error = error {
                print(error)
            }
            isSending = false
            
        }
    }
    
    
    var body: some View {
        
        VStack (alignment: .leading) {
            Text("Submit Feedback / Bug Report")
            TextEditor(text: $text)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 200, maxHeight: 300)
                .background(Color("darkBackground"))
                .foregroundColor(Color("darkSecondaryText"))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.secondary.opacity(0.3), lineWidth: 1)
                )
                .simultaneousGesture(
                    TapGesture()
                        .onEnded({
                            self.text = ""
                        })
                )
            
            Spacer()
            
            Button {
                submitFeedback(text: text)
                text = "Thanks for your feedback!"
            } label: {
                HStack {
                    Text("Send")
                       .bold()
                       .foregroundColor(Color.white)
                   Image(systemName: "paperplane")
                       .foregroundColor(Color.white)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, idealHeight: 40, maxHeight: 40, alignment: .center)
                .background(.purple.opacity(0.7))
                .cornerRadius(10)
                .padding(.bottom)
            }

            
        }
        .padding(.horizontal)
        .background(Color("darkBackground"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
            }
        }
        
//        .nav
        
        
        
        
//        VStack {
//            Text("Submit Feedback / Bug Report")
//            TextEditor(text: $text)
//                .frame(minHeight: 60, maxHeight: 300)
//                .overlay {
//                    RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.secondary.opacity(0.3), lineWidth: 1)
//                }
//
//            Spacer()
//
//            Button {
//                submitFeedback(text: text)
//                text = ""
//            } label: {
//                HStack {
//                    if isSending {
//                        ProgressView()
//                    } else {
//                        Text("Send")
//                            .bold()
//                            .foregroundColor(Color.white)
//                        Image(systemName: "paperplane")
//                            .foregroundColor(Color.white)
//                    }
//                }
//                .frame(width: 288, height: 40)
//                .background(Color.purple.opacity(isSending ? 0.3 : 0.8)).cornerRadius(44)
//            }
//
//        }
//        .padding()

    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}
