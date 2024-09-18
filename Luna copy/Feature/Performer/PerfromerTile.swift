//
//  PerfromerTile.swift
//  Luna
//
//  Created by Ned O'Rourke on 23/5/2022.
//

import SwiftUI
import AVFoundation
import SDWebImageSwiftUI



struct PerfromerTile: View {
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    @State var user: UserObj
    
    @State var song1 = false
    
    @State var songURL = ""
    
    @State var time : CGFloat = 0.0
    @State var player : AVPlayer!
    
    @State var loading = false
    
    var body: some View {
        NavigationLink(destination: user.uid == sessionService.userDetails.uid ? AnyView(ProfileView() .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM)) : AnyView(PerformerProfileView(user: user)
            .environmentObject(sessionService)
            .environmentObject(manager)
            .environmentObject(homeVM))) {
            VStack (spacing: 0) {
                WebImage(url: URL(string: user.imageURL))
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width*0.25, height: UIScreen.main.bounds.width*0.25)
                    .cornerRadius(100)
                    .shadow(color: .black, radius: 1)
                    .overlay {
                        Image(systemName: "music.note")
                            .frame(width: 30, height: 30)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .background(.purple.opacity(0.9))
                            .cornerRadius(40)
                            .offset(x: 35, y: 35)
                    }
                
                
                Text("\(user.firstName) \(user.lastName)")
                    .foregroundColor(Color.primary)
                    .padding(.vertical, 5)
                
                
                HStack {
                    Text("Top Track")
                        .foregroundColor(Color("darkSecondaryText"))
                    ZStack {
                        
                        Circle()
                            .stroke(lineWidth: 4)
                            .foregroundColor(.gray)
                            .opacity(0.1)
                        
                        Circle()
                            .trim(from: 0, to: min(time, 1.0))
                            .stroke(AngularGradient(gradient: Gradient(colors: [.purple, .blue, .purple]), center: .center), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                            .rotationEffect(Angle(degrees: 270))

                        Button {
                            
                        } label: {
                            
                            
                            if loading {
                                ProgressView()
                            }
                            
                            else {
                                Image(systemName: song1 ? "pause.circle.fill": "play.circle.fill")
                                    .font(.system(size: 15))
                            }
                            
                        }
                        .highPriorityGesture(TapGesture()
                            .onEnded {
                                if self.player != nil {
                                    song1.toggle()
                                    

                                    if song1{
                                       self.player?.play()
                                        loading = true
                                    } else {
                                       self.player?.pause()
                                        loading = false
                                        
                                    }
                                    
                                    DispatchQueue.global(qos: .background).async {
                                        
                                        while song1 {
                                            
                                            if self.player.timeControlStatus.rawValue == 2 && loading {
                                                loading.toggle()
                                            }
                                            
                                            guard let duration = player?.currentItem?.duration.seconds,
                                                    let currentMoment = player?.currentItem?.currentTime().seconds else { return }

                                            self.time = CGFloat(currentMoment / duration)
                                                                            
                                        }
                                        
                                    }
                                }
                            })

                       
                    }
                    .frame(width: 25, height: 25)
                    
                    
                   
                }
            }
            .frame(width: 120)
            .padding(5)
            .padding(.horizontal, 5)
            .background(Color("darkForeground").opacity(0.3))
            .cornerRadius(10)
            .onAppear{
                sessionService.getHeadline(id: user.uid) { songURL in
                    self.songURL = songURL
                    if let url = URL(string: self.songURL) {
                        self.player = try! AVPlayer(url: url)
                        do {
                            try AVAudioSession.sharedInstance().setCategory(.playback)
                        } catch (let error) {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            .onDisappear {
                self.player?.pause()
            }
        }
//        .onAppear{
//            sessionService.getHeadline(id: user.uid) { songURL in
//                self.songURL = songURL
//                if let url = URL(string: self.songURL) {
//                    self.player = try! AVPlayer(url: url)
//
//                }
//            }
//        }
//
//        .border(Color("darkForeground"), width: 2, cornerRadius(20))
//        .overlay(
//                RoundedRectangle(cornerRadius: 20)
//                    .stroke(Color("darkForeground"), lineWidth: 2)
//            )
        
//        .cornerRadius(20)
        
        
//        Image(systemName: song1 ? "pause.circle.fill": "play.circle.fill")
//                    .font(.system(size: 25))
//                    .padding(.trailing)
//                    .onTapGesture {
//                        soundManager.playSound(sound: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")
//                        song1.toggle()
//
//                        if song1{
//                            soundManager.audioPlayer?.play()
//                        } else {
//                            soundManager.audioPlayer?.pause()
//                        }
//                }
    }
}
//
//struct PerfromerTile_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let user = UserObj(firstName: "ned", lastName: "o'rourke", uid: "f", imageURL: "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F6%2F2022%2F03%2F20%2FKanye-West.jpg", friends: [], favourites: [], streak: 0)
//
//        PerfromerTile(user: user)
//    }
//}

//class SoundManager : ObservableObject {
//    var audioPlayer: AVPlayer?
//    var slider : Double = 0.0
//
//    func playSound(sound: String) {
//        if let url = URL(string: sound) {
//            self.audioPlayer = AVPlayer(url: url)
//
//            self.audioPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 30), queue: .main) { time in
//
//                let fraction = CMTimeGetSeconds(time) / CMTimeGetSeconds(self.audioPlayer!.currentItem!.duration)
//                print(fraction)
//                self.slider = fraction
//
//            }
//        }
//    }
//}

