//
//  ProfileDetailsView.swift
//  Luna
//
//  Created by Ned O'Rourke on 24/3/22.
//

import SwiftUI
import SDWebImageSwiftUI
import AVFoundation

struct ProfileDetailsView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    @StateObject var service = UserProfileService()
    
    @State var showUpdate = false
    @State var song1 = false
    @State var songURL = ""
    @State var time : CGFloat = 0.0
    @State var player : AVPlayer!
    @State var loading = false
    
    var body: some View {
        ScrollView {
            HStack {
                
                Spacer()
                
                WebImage(url: URL(string: "\(sessionService.userDetails.imageURL)"))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .cornerRadius(200)
                
                
                Spacer()
                
            }
            
            Spacer()
            
            Divider()
            
            
            VStack (alignment: .leading) {
                Text("First Name")
                    .foregroundColor(Color.secondary)
                    .font(.system(size: 15))
                Text(sessionService.userDetails.firstName)
                    .font(.system(size: 20))
                
                Spacer()
                
                Text("Last Name")
                    .foregroundColor(Color.secondary)
                    .font(.system(size: 15))
                Text(sessionService.userDetails.lastName)
                    .font(.system(size: 20))
                
                Spacer()
                
                Text("Date of Birth")
                    .foregroundColor(Color.secondary)
                    .font(.system(size: 15))
                Text(sessionService.userDetails.dob)
                    .font(.system(size: 20))
                
                Spacer()
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            
            if sessionService.userDetails.performer {
                Divider()
                
                VStack (alignment: .leading) {
                    Text("Performer Details")
                    
                    if self.songURL != "" {
                        Text("Top Track")
                            .foregroundColor(Color.secondary)
                            .font(.system(size: 15))
                        Button  {
                            
                        } label: {
                            Button {
                                
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
                            } label: {
                                
                                if loading {
                                    ProgressView()
                                }
                                
                                else {
                                    Image(systemName: song1 ? "pause.circle.fill": "play.circle.fill")
                                        .font(.system(size: 30))
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    
                    if service.spotifyLink != "" {
                        Text("Spotify Link")
                            .foregroundColor(Color.secondary)
                            .font(.system(size: 15))
                        Text(service.spotifyLink)
                            .font(.system(size: 20))
                        Spacer()
                    }
                    
                    if service.soundcloudLink != "" {
                        Text("Soundcloud Link")
                            .foregroundColor(Color.secondary)
                            .font(.system(size: 15))
                        Text(service.soundcloudLink)
                            .font(.system(size: 20))
                        Spacer()
                        
                    }

                }
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.bottom, 50)
                
            }
            
        }
        .padding(.horizontal)
        .onAppear {
            sessionService.refreshUserDetails()
            service.getPerformerLinks(id: sessionService.userDetails.uid)
            sessionService.getHeadline(id: sessionService.userDetails.uid) { songURL in
                self.songURL = songURL
                if let url = URL(string: self.songURL) {
                    self.player = AVPlayer(url: url)
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playback)
                    } catch (let error) {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView())
        .toolbar {
            Button (action: {
                showUpdate = true
            }, label: {
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
                    .background(.white).cornerRadius(64)

            })
        }
        .background(Color("darkBackground"))
        .sheet(isPresented: $showUpdate, content: {
            UpdateProfileView(showUpdate: $showUpdate, songURL: $songURL)
                .environmentObject(sessionService)
                .environmentObject(service)
        })

        
        
    }
}

struct ProfileDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailsView()
    }
}
