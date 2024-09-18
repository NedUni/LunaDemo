
//
//  CameraView.swift
//  Luna
//
//  Created by Ned O'Rourke on 19/4/22.
//

import SwiftUI
import AVFoundation
import AVKit
import Mixpanel

struct CameraView: View {
    
    @StateObject var camera = CameraModel()
    @EnvironmentObject var xd : storiesHandler
    @EnvironmentObject var sessionService : SessionServiceImpl
    @State var venueID : String
    @Binding var showCamera : Bool
    
    @State var isClicked = false
    @State var longTap = false
    
    @GestureState private var longPressTap = false
    
    @State var posting : Bool = false
    
    @State var frontBack : Int = 1
    
    var body: some View {
        
        ZStack {
            
        
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { value in
                            print(value.translation)
                            switch(value.translation.width, value.translation.height) {
        //                                case (...0, -30...30):  print("left swipe")
        //                                case (0..., -30...30):  print("right swipe")
        //                                case (-100...100, ...0):  print("up swipe")
                                case (-100...100, 1...): withAnimation {showCamera = false}
                                default: print("error")
                            }
                        }
                )
            
            
            
            VStack {
                
                HStack {
                    
                    Spacer()
                    
                    if !camera.isTaken {
                        Button {
                            camera.changePosition()
                            
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .padding()
                        }
                    }
                    
                    Button {
                        if camera.isTaken {
                            camera.reTake()
                        }
                        else {
                            showCamera = false
                        }
                        
                    } label: {
                        Image(systemName: "xmark")
                            .padding()
                    }
                    .padding(.trailing, 10)
                }
                .foregroundColor(.white)
                
                Spacer()
                
                HStack {
                    
                    if camera.isTaken {
                        Button {
                            
                            if !posting {
                                posting.toggle()
                                xd.postStory(uploaderID: sessionService.userDetails.uid, venueID: venueID, image: UIImage(data: camera.picData)!, completion: {
                                    Task {
                                        await xd.getStories(venueID: venueID, completion: { status in
                                            if status {
                                                Mixpanel.mainInstance().time(event: "Post Story")
                                                
                                            }
                                        })
                                    }
                                    posting.toggle()
                                    showCamera.toggle()
                                })
                            }
                            
                        } label: {
                            Text(posting ? "posting" : "post")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.white)
                                    .clipShape(Capsule())
//                            }
                            
                        }
                        .padding(.leading)
                        
                        Spacer()
                    }
                    else {
                        Button {
                            camera.takePic()
                        } label: {
                                ZStack {

                                    Circle()
                                        .fill(camera.isRecording ? Color.red : Color.white)
                                        .frame(width: 70, height: 70)

                                    Circle()
                                        .stroke(camera.isRecording ? Color.red : Color.white, lineWidth: 1)
                                        .frame(width: 75, height: 75)
                                }
                                
                                
                            
                        }
                    }
                }
                .frame(height: 75)
            }
        }
        .overlay(content: {
            if camera.showPreview {
                FinalPreview(url: camera.previewURL!, showPreview: $camera.showPreview)
                    .transition(.move(edge: .trailing))
            }
        })
        .animation(.easeInOut, value: camera.showPreview)
        .onAppear {
            camera.Check()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate {
    
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    @Published var output = AVCapturePhotoOutput()
    
    @Published var videoOutput = AVCaptureMovieFileOutput()
    
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    @Published var isSaved = false
    
    @Published var picData = Data(count: 0)
    
    @Published var frontBack : Int = 1
    
    //VIDEO VARIABLES
    @Published var isRecording : Bool = false
    @Published var recordedURL : [URL] = []
    @Published var previewURL: URL?
    @Published var showPreview : Bool = false
    
    func Check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        
        case .authorized:
            self.setUp(device: self.defaultCamera(frontBack: self.frontBack)!)
            return
        
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUp(device: self.defaultCamera(frontBack: self.frontBack)!)
                }
            }
        
        case .denied:
            self.alert.toggle()
            return
        
        default:
            return
        }
    }
    
    func setUp(device: AVCaptureDevice) {
        
        do {
            
            self.session.beginConfiguration()

            let input = try AVCaptureDeviceInput(device: AVCaptureDevice.default(for: .video)!)

            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }

            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }

            self.session.commitConfiguration()
            
        }
        
        catch {
            print(error.localizedDescription)
            
        }
    }
    
    func changePosition() {
        print("status is \(frontBack)")
        if self.frontBack == 1 {
            self.frontBack = 2
        }
        else {
            self.frontBack = 1
        }
        
        print("status is now \(frontBack)")
        
        do {
        
        for input in session.inputs {
                session.removeInput(input);
            }
            
        let newInput = try AVCaptureDeviceInput(device: defaultCamera(frontBack: self.frontBack)!)
            if self.session.canAddInput(newInput) {
                self.session.addInput(newInput)
            }
        }
        
        catch {
            print(error.localizedDescription)
        }
    }
    
    func defaultCamera(frontBack : Int) -> AVCaptureDevice? {
        if let device = AVCaptureDevice.default(.builtInDualCamera,
                                                for: AVMediaType.video,
                                                position: AVCaptureDevice.Position(rawValue: frontBack)!) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                            for: AVMediaType.video,
                                                       position: AVCaptureDevice.Position(rawValue: frontBack)!) {
            return device
        } else {
            return nil
        }
    }
    
    func takePic() {
        
        DispatchQueue.global(qos: .background).async {
            
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
           
            self.isTaken.toggle()
            self.session.stopRunning()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        print(outputFileURL)
        self.previewURL = outputFileURL
        self.showPreview = true
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if error != nil {
            return
        }
        
        print("pic taken...")
        
       
        
        
//        photo
        
        if self.frontBack == 1 {
            guard let imageData = photo.fileDataRepresentation()  else{return}

            self.picData = imageData
        }
        else {
            if let imageData = photo.fileDataRepresentation() {
                let image = UIImage(data: imageData)!
                
                let ciImage: CIImage = CIImage(cgImage: image.cgImage!).oriented(forExifOrientation: 6)
                let flippedImage = ciImage.transformed(by: CGAffineTransform(scaleX: -1, y: 1))
                
                self.picData = UIImage.convert(from: flippedImage).jpegData(compressionQuality: 1)!
                
            }
        }
       
        
        
        
//        else{return}
//
//        self.picData = imageData
    }
    
    func savePic() {

        let image = UIImage(data: self.picData)!

        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

        self.isSaved = true

        print("saved")
    }
    
    func reTake() {
        DispatchQueue.global(qos: .background).async {
            
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                    
                    self.isSaved = false
                }
            }

        }
    }
}

struct CameraPreview: UIViewRepresentable {

    @ObservedObject var camera : CameraModel

    func makeUIView(context: Context) ->  UIView {

        let view = UIView(frame: UIScreen.main.bounds)

        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame

        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        DispatchQueue.main.async {
            camera.session.startRunning()
        }
        
        return view

        
    }

    func updateUIView(_ uiView: UIView, context: Context) {

    }
}


//struct CameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraView(venueID: "0Ag3xBxsGflVCdbiObTw", showCamera: .constant(true))
//    }
//}

struct FinalPreview : View {
    var url : URL
    @Binding var showPreview : Bool
    
    var body: some View {
//        GeometryReader { proxy in
                
//        LoopingPlayer()
//            .ignoresSafeArea()
//            .overlay(alignment: .center) {
//                Button {
//                    showPreview = false
//                    print("lol")
//                } label: {
//                    Text("back")
//                }
//            }
            VideoPlayer(player: AVPlayer(url: url))
                .ignoresSafeArea()
                .aspectRatio(contentMode: .fill)
                .overlay(alignment: .center) {
                    Button {
                        showPreview = false
                    } label: {
                        Text("back")
                    }
                }
//                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
////                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
//                .overlay(alignment: .center) {
//                    Button {
//                        showPreview = false
//                    } label: {
//                        Text("back")
//                    }
//
//                }
//        }
    }
}

extension UIImage{
    static func convert(from ciImage: CIImage) -> UIImage {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(ciImage, from: ciImage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
}
