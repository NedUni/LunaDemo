//
//  ReferFriendView.swift
//  Luna
//
//  Created by Ned O'Rourke on 25/3/22.
//

import SwiftUI
import MobileCoreServices

struct ReferFriendView: View {
    
    @State var timeRemaining = 120
    @State var progress = 0.0
    @State var name : String
    @Binding var showDrink : Bool
    
    @State var wantToClose : Bool = false
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                Text(name)
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundColor(.primary).opacity(0.8)
                    .multilineTextAlignment(.center)
                
                ZStack {
                    
                    Circle()
                        .stroke(lineWidth: 20)
                        .foregroundColor(.gray)
                        .opacity(0.1)
                    
                    Circle()
                        .trim(from: 0, to: min(progress, 1.0))
                        .stroke(AngularGradient(gradient: Gradient(colors: [.purple, .blue, .purple]), center: .center), style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                        .rotationEffect(Angle(degrees: 270))
                        .animation(.easeInOut(duration: 1.5), value: progress)
                        .onReceive(timer) { _ in
                           if timeRemaining > 0 {
                               progress = Double(120 - timeRemaining) / Double(120)
                               timeRemaining -= 1
                           }
                            else {
                                sessionService.hasClaimedDrink(uid: sessionService.userDetails.uid)
                                self.showDrink = false
                            }
                        }
                    
                    Text(String(timeRemaining))
                        .fontWeight(.heavy)
                        .font(.system(size: 40))
                }
                .frame(width: 250, height: 250)
                .padding()
            }
            .onAppear {
                sessionService.adjustDrinkEligibility(uid: sessionService.userDetails.uid, completion: {
                    sessionService.hasClaimedDrink(uid: sessionService.userDetails.uid)
                })
            }
            .toolbar {
                Image(systemName: "xmark")
                    .foregroundColor(Color.purple)
                    .onTapGesture {
                        self.wantToClose = true
                    }
            }
            .alert("Are you sure you want to close?", isPresented: $wantToClose, actions: {
                // 1
                  Button("Cancel", role: .cancel, action: {})

                  Button("I'm sure", role: .destructive, action: {
                      sessionService.hasClaimedDrink(uid: sessionService.userDetails.uid)
                      showDrink = false
                  })
                }, message: {
                  Text("You will lose free drink if not claimed.")
                })
        }
//        .navigationBarHidden(true)
        
        
        
        
         
//        VStack {
//
//
//            VStack {
//                Text("Scan to use Luna")
//                    .font(.system(size: 20, weight: .light))
//
//                Image("qr")
//                    .resizable()
//                    .scaledToFit()
////
//            }
//            .padding(40)
//
//            Divider()
//
//            VStack {
//                Text("Or send link to friends")
//                    .font(.system(size: 20, weight: .light))
//                Button {
//                    UIPasteboard.general.string = "https://docs.google.com/forms/d/1P-VgG-N2_2HU5Qfrs--LLmfbOtU9S3Lh84e3a7xuofM/edit"
//                    withAnimation {
//                        copied = true
//                    }
//                } label: {
//                    HStack {
//                        Text("Press to copy Link")
//                            .font(.system(size: 30, weight: .medium))
//                        Image(systemName: "rectangle.portrait.and.arrow.right")
//                            .font(.system(size: 13))
//                    }
//                    .foregroundColor(.purple.opacity(0.8))
//
//                }
//                .buttonStyle(.plain)
//
//                if copied == true {
//                    Text("Link Copied")
//                        .foregroundColor(.blue)
//                }
//            }
//            .padding(40)
//
//
//            Spacer()
//
//
//
//
//        }
//        .navigationBarTitle("Refer Friend", displayMode: .inline)
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: BackButtonView())
    }
}

//struct ReferFriendView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReferFriendView()
//    }
//}
