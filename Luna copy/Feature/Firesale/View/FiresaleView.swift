//
//  FiresaleView.swift
//  Luna
//
//  Created by Ned O'Rourke on 31/5/2022.
//

import SwiftUI

struct FiresaleView: View {
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    @StateObject var manager = FiresaleManager()
    @State var firesaleID : String
    @Binding var showFiresale : Bool
    
    @State var status = false
    
    var body: some View {
        
        
        NavigationView {
            ZStack (alignment: .top) {
                Color("darkBackground")
                    .ignoresSafeArea()
                
                VStack {
                    
                    Text(manager.firesaleTitle)
                        .fontWeight(.heavy)
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 20)
                            .foregroundColor(.gray)
                            .opacity(0.1)

                        Circle()
                            .trim(from: 0, to: min(manager.progress, 1.0))
                            .stroke(AngularGradient(gradient: Gradient(colors: [.red, .yellow, .red]), center: .center), style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                            .rotationEffect(Angle(degrees: 270))
                            .animation(.easeInOut(duration: 1.5), value: manager.progress)
                            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                                manager.updateCountdown()
                            }

                        Text(manager.time)
                            .fontWeight(.heavy)
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                    .frame(width: 250, height: 250)
                    .padding()

    //                Spacer()
                    HStack {
                        VStack (alignment: .center) {
                            Button {
                                manager.registerFiresaleInterest(userID: sessionService.userDetails.uid , firesaleID: firesaleID) {
                                    manager.checkFiresaleInterest(userID: sessionService.userDetails.uid, firesaleID: firesaleID)
                                }
                            } label: {
                                Text("Yum")
                                    .padding()
                                    .foregroundColor(manager.status == 1 ? .purple : .white)
                                    .background(manager.status == 1 ? .purple.opacity(0.3) : .clear)
                                    .cornerRadius(20)
                            }
                        }
                        
                        Spacer()
                        
                        VStack (alignment: .center) {
                            Button {
                                manager.registerFiresaleDisinterest(userID: sessionService.userDetails.uid, firesaleID: firesaleID) {
                                    manager.checkFiresaleInterest(userID: sessionService.userDetails.uid, firesaleID: firesaleID)
                                }
                            } label: {
                                Text("Nah")
                                    .padding()
                                    .foregroundColor(manager.status == 2 ? .purple : .white)
                                    .background(manager.status == 2 ? .purple.opacity(0.3) : .clear)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .frame(width: 250)
                    .buttonStyle(.plain)


                }
                .background(Color("darkBackground"))
                .padding(.horizontal)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: BackButtonView()
                    .highPriorityGesture(TapGesture()
                        .onEnded {
                            showFiresale.toggle()
                        }))
            }
//            .redacted(reason: status)
        }
        .onAppear {
            manager.setup(userID: sessionService.userDetails.uid, firesaleID: firesaleID) { status in
                self.status = status
            }
        }
    }
}
//
//struct FiresaleView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            FiresaleView(firesaleID: "41bFm9CI1vYfqPCjUNig", showFiresale: .constant(true))
//                .environmentObject(FiresaleManager())
//        }
//    }
//}
