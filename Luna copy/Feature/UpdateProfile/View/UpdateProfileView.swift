//
//  UpdateProfileView.swift
//  Luna
//
//  Created by Will Polich on 25/3/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage

struct UpdateProfileView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var service : UserProfileService
    
    @Binding var showUpdate: Bool
    @State var error = ""
    @State var firstName = ""
    @State var lastName = ""

    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    @State var loading = false
    @State var spotifyLink = ""
    @State var soundcloudLink = ""
    
    @State var isImporting = false
    @State var isUploading = false
    @State var uploadedSong = false
    @Binding var songURL : String
    
    var body: some View {
        NavigationView {
            if loading == true {
                ProgressView()
                    .opacity(0.5)
            }
            ZStack (alignment: .bottom) {
                ScrollView {
                    VStack {
                        
                        HStack {
                            
                            Spacer()
                            
                            Button {
                               shouldShowImagePicker
                                    .toggle()
                            } label: {
                                VStack {
                                    if let image = self.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(200)
                                            
                                    } else {
                                        WebImage(url: URL(string: "\(sessionService.userDetails.imageURL)"))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(200)

                                            
                                    }
                                    Text("Update Profile Picture")
                                        .foregroundColor(Color.secondary)
                                }
                            }
                            .padding(.bottom)
                            
                            
                            
                            Spacer()
                            
                        }
                        
                        Spacer()
                        
                        VStack (alignment: .leading) {
                        
                            Text("First Name")
                            
                            TextField("First Name", text: $firstName)
                                .padding(10)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.secondary.opacity(0.3), lineWidth: 1)
                                }
                            
                            Text("Last Name")
                            
                            TextField("Last Name", text: $lastName)
                                .padding(10)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.secondary.opacity(0.3), lineWidth: 1)
                                }
                        }
                        

                       
                        if sessionService.userDetails.performer {
                            VStack (alignment: .leading) {
//                                Text("Performer Name (Leave empty to use your real name)")
//                                TextField("Performer Name", text: $performerName)
//                                    .padding(10)
//                                    .overlay {
//                                        RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.secondary.opacity(0.3), lineWidth: 1)
//                                    }
//

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
                                
                            
                                Text("Top Track Upload (60 seconds max)")
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
                        }
                        
                        Spacer()
                        
                        Text(self.error)
                            .foregroundColor(Color("Error"))
                            .bold()

                    }
                    .padding()
                    .padding(.bottom, 100)
                   
                    
                    
                }
               
                .toolbar(content: {
                    Button {
                        showUpdate = false
     
                    } label: {
                        Image(systemName: "xmark")
                    }
                })
                .navigationBarTitle("Update Profile", displayMode: .inline)
            
                Button {
                    if isUploading {
                        return
                    }
                    loading = true
                    if let image = self.image {
                        let ref = storage.reference(withPath: "users/profilePictures/\(sessionService.userDetails.uid)/")
                        guard let imageData = image.jpegData(compressionQuality: 0.4) else {return}
                        ref.putData(imageData, metadata: nil) { metadata, error in
                            if let error = error {
                                print(error)
                                loading = false
                                return
                            }
                            print("Uploaded image data for user: ")
                            ref.downloadURL { url, error in
                                if let error = error {
                                    print(error)
                                    loading = false
                                    return
                                }
                                print("downloaded url: \(url?.absoluteString ?? "")")
                                
                                DispatchQueue.main.async {
                                    sessionService.userDetails.imageURL = (url?.absoluteString ?? "")
                                }
                                
                                let userData = [
                                    "firstName" : firstName,
                                    "lastName" : lastName,
                                    "imageURL" : url?.absoluteString ?? "",
                                    "headlineSong" : self.songURL,
                                    "spotify" : self.spotifyLink,
                                    "soundcloud" : self.soundcloudLink
                                ]
                                
                                db.collection("profiles").document(sessionService.userDetails.uid).updateData(userData) { error in
                                    if let error = error {
                                        print("Error updating user details: \(error)")
                                        loading = false
                                        return
                                    }
                                    
                                    sessionService.refreshUserDetails()
                                    loading = false
                                    showUpdate = false
                                }
                            }
                        }
                    }
                    else {
                        
                        db.collection("profiles").document(sessionService.userDetails.uid).updateData([
                            "firstName" : firstName,
                            "lastName" : lastName
                        ]) { error in
                            if let error = error {
                                print("Error updating user details: \(error)")
                                loading = false
                                return
                            }
                            
                            sessionService.refreshUserDetails()
                            loading = false
                            showUpdate = false
                        }
                    }
                    
                } label: {
                    HStack {
                        Text("Update")
                            .bold()
                            .foregroundColor(Color.white)
                        Image(systemName: "checkmark")
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 288, height: 40)
                    .background(Color.purple.opacity(isUploading ? 0.3 : 0.8)).cornerRadius(44)
                }
                .padding(.bottom, 30)
            }
        }
        
        .ignoresSafeArea(.keyboard)
        .navigationBarHidden(true)
        .onAppear {
            firstName = sessionService.userDetails.firstName
            lastName = sessionService.userDetails.lastName
            spotifyLink = service.spotifyLink
            soundcloudLink = service.soundcloudLink
            
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
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

