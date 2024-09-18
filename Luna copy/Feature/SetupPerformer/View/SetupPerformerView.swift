//
//  SetupPerformerView.swift
//  Luna
//
//  Created by Will Polich on 24/5/2022.
//

import SwiftUI
import AVFoundation
import Firebase
import FirebaseStorage

func getDocumentsDirectory() throws -> URL {
     return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
}

struct SetupPerformerView: View {
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    
    @Binding var showSetupPerformer : Bool
    @Binding var changingPerformerStatus : Bool
    
    @State var isImporting = false
    @State var uploadedSong = false
    @State var isUploading = false
    
    @State var spotifyLink = ""
    @State var soundcloudLink = ""
    @State var songURL = ""
    @State var error = ""
    
    
   
    var body: some View {
        NavigationView {
            VStack (spacing: 15) {
                
                VStack (alignment: .leading) {
                    
                    Text("Spotify Link")
                    TextField("https://", text: $spotifyLink)
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.secondary.opacity(0.3), lineWidth: 1)
                        }
                    
                    Text("Soundcloud Link")
                    TextField("https://", text: $soundcloudLink)
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.secondary.opacity(0.3), lineWidth: 1)
                        }
                }
                
                VStack {
                    
                
                    Text("Top Track Upload 10MB max")
                        .padding(.top, 10)
                    Text("This will be displayed on your profile.")
                        .foregroundColor(.secondary)
                    
                    
                    Button {
                        isImporting.toggle()
                    } label: {
                        Image(systemName: "waveform")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                    }
                    
                    if isUploading {
                        HStack {
                            Text("Uploading Song")
                            
                            ProgressView()
                        }
                    } else if uploadedSong {
                        HStack {
                            Text("Song uploaded")
                            
                            Image(systemName: "checkmark")
                        }
                    }

                }
                
                Spacer()
                
                Text(self.error)
                    .foregroundColor(Color("Error"))
                    .bold()
                
                
                Button {
                    if isUploading {
                        return
                    }
                    
                    self.error = ""
                    changingPerformerStatus = true
                    
                    let performerData = [
                            "headlineSong" : self.songURL,
                            "spotify" : self.spotifyLink,
                            "soundcloud" : self.soundcloudLink,
                    ]
                    
                    db.collection("profiles").document(sessionService.userDetails.uid).updateData(performerData) { error in
                        if let error = error {
                            print(error)
                            
                        }
                        
                        sessionService.togglePerfomerAccount(uid: sessionService.userDetails.uid) { error in
                            changingPerformerStatus = false
                            if let error = error {
                                print(error)
                            } else {
                                sessionService.refreshUserDetails()
                                showSetupPerformer.toggle()
                                
                            }
                        }
                    }
                    
                } label: {
                    VStack {
                        if changingPerformerStatus {
                            ProgressView()
                            
                        } else {
                            Text("**Submit**")
                                .foregroundColor(.white)
                        }
                            
                    }
                    .frame(width: UIScreen.main.bounds.width*0.8, height: 40)
                    .background(.purple.opacity(isUploading ? 0.3 : 0.9))
                    .cornerRadius(20)
                }
                
            }
            .padding(.horizontal)
            .navigationBarTitle("Setup Performer Profile", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSetupPerformer.toggle()
                    } label: {
                        Text("Cancel")
                    }
                }

            }
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.audio], allowsMultipleSelection: false) { result in
                isUploading = true
                print(result)
                if case .success = result {
                    do {
                        self.error = ""
                        let audioURL: URL = try result.get().first!
                        let uploadRef = storage.reference(withPath: "performerTracks/\(sessionService.userDetails.uid)")
                        let metadata = StorageMetadata()
                            metadata.contentType = "audio/mp3"
                        
                        if audioURL.startAccessingSecurityScopedResource() {
                            let fileData = try? Data.init(contentsOf: audioURL)
                            let fileName = audioURL.lastPathComponent
                            if fileData!.count > 10000000 {
                                self.error = "File size is greater than 10MB, please upload a smaller file"
                                isUploading = false
                                isImporting = false
                                return
                            }
                            let actualPath = try! getDocumentsDirectory().appendingPathComponent(fileName)
                            
                            do {
                                try fileData?.write(to: actualPath)
                                if(fileData == nil){
                                    print("Permission error!")
                                }
                                else {
                                    print("Success.")
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                            defer { audioURL.stopAccessingSecurityScopedResource() }
                           
                            uploadRef.putFile(from: actualPath, metadata: metadata) { metadata, error in
                                
                                
                                if let error = error {
                                    print("Error uploading top-track: \(error)")
                                }
                                
//                                audioURL.stopAccessingSecurityScopedResource()
                                
                              guard let metadata = metadata else {
                                // Uh-oh, an error occurred!
                                return
                              }
                                
                                print(metadata)
                              // Metadata contains file metadata such as size, content-type.
//                              let size = metadata.size
                              // You can also access to download URL after upload.
                              uploadRef.downloadURL { (url, error) in
                                guard let downloadURL = url else {
                                  // Uh-oh, an error occurred!
                                  return
                                }
                                  self.songURL = downloadURL.absoluteString
                                  uploadedSong = true
                                  isUploading = false
                                  
                                  
                              }
                            }
                            
                           
                        }
                            
                        

                        
                    } catch {
                        let nsError = error as NSError
                        fatalError("File Import Error \(nsError), \(nsError.userInfo)")
                    }
                } else {
                    print("File Import Failed")
                }
            }
            

        }
        
    }
}

