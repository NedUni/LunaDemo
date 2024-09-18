//
//  InviteContactTileView.swift
//  Luna
//
//  Created by Ned O'Rourke on 27/4/2022.
//

import SwiftUI
import MessageUI

struct InviteContactTileView: View {
    
    @State var contact : ContactInfo
    @State var message : String = ""
    
    @State private var isShowingMessages = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                ZStack (alignment: .center) {
                    Text("\(String(contact.firstName.prefix(1)))\(String(contact.lastName.prefix(1)))")
                }
                .frame(width: 56, height: 56)
                .background(Color.random.saturation(1))
                .cornerRadius(64)
                
                Text("\(contact.firstName) \(contact.lastName)")
                    .font(.system(size: 20))
                    .foregroundColor(Color.primary)
                
                Spacer()
                
                Button {
                    getMessage { message in
                        self.message = message
                        isShowingMessages.toggle()
                    }
                    
                } label: {
                    Text("+ invite")
                        .fontWeight(.medium)
                        .foregroundColor(.purple)
                        .padding(7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.purple, lineWidth: 1)
                        )
                        .padding(.trailing, 1)
                }
//                .padding(.trailing)

                
            }
        }
        .sheet(isPresented: $isShowingMessages) {
            SendTextView(recipient: contact.phoneNumber!.stringValue,  message: $message)
                .ignoresSafeArea()
                .onDisappear {
                    co()
                }
        }
        .padding(.horizontal)
        .padding(.vertical, 2)
    }
    
    func co() {
        guard let urlShare = URL(string: "https://developer.apple.com/xcode/swiftui/") else { return }
        let activityView = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)

            let allScenes = UIApplication.shared.connectedScenes
            let scene = allScenes.first { $0.activationState == .foregroundActive }

            if let windowScene = scene as? UIWindowScene {
                windowScene.keyWindow?.rootViewController?.present(activityView, animated: true, completion: nil)
            }
//        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
//        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    func getMessage(completion: @escaping (String) -> ()) {
        
        let docRef = db.collection("admin").document("admin")

        docRef.getDocument { result, error in
            if let error = error {
                print("Error getting user document for location update: \(error)")
                return
            }
            else {
                let messageArray = result?["messages"] as? [String] ?? ["Get Luna!"]
                
                completion(messageArray.randomElement()!)
        }
    }
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}



struct SendTextView: UIViewControllerRepresentable {
    var recipient: String
    @Binding var message: String
    
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var completion: () -> Void
        init(completion: @escaping ()->Void) {
            self.completion = completion
        }
        
        // delegate method
        func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                   didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true, completion: nil)
            completion()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator() {} // not using completion handler
    }
    
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.messageComposeDelegate = context.coordinator
        
        vc.recipients = [recipient]
        vc.body = message
//        getMessage(completion: {message in
//            vc.body = message
//        })
        
//        "🌙🌙🌙🌙🌙🌙🌙 IYKYK"
        
        

//        self.presentViewController(vc, animated: true, completion: nil)
        return vc
    }
    
    
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}
    
    typealias UIViewControllerType = MFMessageComposeViewController
}
//struct InviteContactTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        InviteContactTileView()
//    }
//}
