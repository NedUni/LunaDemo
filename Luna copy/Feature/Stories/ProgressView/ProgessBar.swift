//
//  ProgessBar.swift
//  Luna
//
//  Created by Ned O'Rourke on 26/4/2022.
//

import SwiftUI

struct ProgessBar: View {
    
    @State var currentProgress: CGFloat = 0.0
    @Binding var currentImage : Int
    @Binding var storyView : Bool
    let numberOfStories : Int
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @Binding var pause : Bool
    
    var body: some View {
            HStack (spacing: 2) {
                ForEach(0 ..< numberOfStories) { i in
                    
                    if i < currentImage {
                        Capsule()
                            .frame(width: UIScreen.main.bounds.size.width/CGFloat(numberOfStories)*0.9 ,height: 2)
//                            .frame(height: 2)
                    }
                    
                    else if i == currentImage {
                        ZStack (alignment: .leading) {

                            
                            Capsule()
                                .frame(width: UIScreen.main.bounds.size.width/CGFloat(numberOfStories)*0.9 ,height: 2)
                                .foregroundColor(.gray.opacity(0.3))
                            
                            Capsule()
                                .frame(width: UIScreen.main.bounds.size.width/CGFloat(numberOfStories)*0.9 * currentProgress, height: 2)
                                .foregroundColor(.white)
                                .onReceive(timer) { _ in
                                    if self.currentProgress < 1 && !pause {
                                        self.currentProgress += 0.0025
                                    }
                                    else if self.currentProgress >= 1 {
                                        if self.currentImage < numberOfStories - 1 {
                                            self.currentImage += 1
                                            self.currentProgress = 0
                                        }
                                        else {
//                                            storyView = false
                                        }

                                        
                                    }
                                }
                            
                        }
                       
                    }
                    
                    else {
                        Capsule()
//                            .frame(height: 2)
                            .frame(width: UIScreen.main.bounds.size.width/CGFloat(numberOfStories)*0.9 ,height: 2)
                            .foregroundColor(.gray.opacity(0.2))
                    }
                }
            }
            .onAppear {
                self.currentProgress = 0.0
            }
            .foregroundColor(.white)
//            .padding(.horizontal)
    }
}


//struct ProgessBar_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        ZStack {
//            Color.black
//            ProgessBar()
//        }
//    }
//}
