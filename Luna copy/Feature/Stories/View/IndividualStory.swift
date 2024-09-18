//
//  IndividualStory.swift
//  Luna
//
//  Created by Ned O'Rourke on 25/4/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Mixpanel

struct IndividualStory: View {
    
    @State var story : StoryObj
    @EnvironmentObject var storyHandler : storiesHandler
    @EnvironmentObject var sessionService: SessionServiceImpl
    @Binding var storyView : Bool
    @Binding var currentImage : Int
    let numberOfStories : Int
    
    @State var components: DateComponents?
    
    
    @State var hours = ""
    @State var minutes = ""
    
    
    @State var pause : Bool = false
    
    var body: some View {
        ZStack (alignment: .top){
            
            if story.url != "" {
                StoryImage(
                    url: URL(string: story.url)!,
                    placeholder: { Text("Loading ...") },
                    image: { Image(uiImage: $0).resizable() }
                )
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
                .clipped()
                .cornerRadius(15)
            }
            
            HStack (alignment: .top, spacing: 0) {
                Button {
                } label: {
                    VStack {
                    }
                    .frame(width: UIScreen.main.bounds.size.width*0.5, height: UIScreen.main.bounds.size.height*0.9)
                    .background(.white.opacity(0.00001))
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            pause = true
                        }
                        .onEnded { value in
                            print(value.translation)
                            switch(value.translation.width, value.translation.height) {
//                                case (...0, -30...30):  print("left swipe")
                                case (0..., -30...30):  print("right swipe")
//                                case (-100...100, ...0):  print("up swipe")
                                case (-100...100, 1...): withAnimation {storyView = false}
                                default:  pause = false
                            }
                        }
                )
                .highPriorityGesture(TapGesture()
                                        .onEnded { _ in
                                            if self.currentImage >= 1 {
                                               self.currentImage -= 1
                                           }
                                        })
                
                Button {
                } label: {
                    VStack {
                    }
                    .frame(width: UIScreen.main.bounds.size.width*0.5, height: UIScreen.main.bounds.size.height*0.9)
                    .background(.white.opacity(0.00001))
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            pause = true
                        }
                        .onEnded { value in
                            print(value.translation)
                            switch(value.translation.width, value.translation.height) {
//                                case (...0, -30...30):  print("left swipe")
                                case (0..., -30...30):  print("right swipe")
//                                case (-100...100, ...0):  print("up swipe")
                                case (-100...100, 1...): withAnimation {storyView = false}
                                default:  pause = false
                            }
                        }
                )
                .highPriorityGesture(TapGesture()
                                        .onEnded { _ in
                                            if self.currentImage < numberOfStories - 1 {
                                                self.currentImage += 1
                                            }
                                        })
                
            }
            
            VStack (alignment: .leading) {
                
                VStack {
                    
                    ProgessBar(currentImage: $currentImage, storyView: $storyView, numberOfStories: numberOfStories, pause: $pause)

                    HStack {
                        WebImage(url: URL(string: story.uploaderURL))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32, alignment: .center)
                            .cornerRadius(16)
                        
                        VStack (alignment: .leading) {
                            Text(story.uploaderName)
                                .fontWeight(.heavy)
                                .font(.system(size: 15))
                            Text("@ \(storyHandler.venue?.displayname ?? "nowhere") • \(story.time)")
                                .fontWeight(.heavy)
                                .font(.system(size: 10))
                        }
                        
                        Spacer()
                        
//                        Text("\(components?.hour ?? 1 > 0 ? String(components?.hour ?? 1) : String(components?.minute ?? 1)) \(components?.hour ?? 1 > 0 ? "hours" : "mins") left")
//                            .foregroundColor(Color.secondary)
//                        
//                        Image(systemName: "clock.arrow.circlepath")
//                            .foregroundColor(Color.secondary)
//
                        if story.uploaderID == sessionService.userDetails.uid {
                            
                            Menu {
                        
                                Button {
                                    storyHandler.deleteSory(storyID: story.id, completion: {
                                        Task {
                                            await storyHandler.getStories(venueID: story.venueID, completion: { _ in
                                                storyView.toggle()
                                            })
                                        }
                                    })
                                } label: {
                                    Text("Delete Story")
                                }
                                .buttonStyle(.plain)

                            } label: {
                                Image(systemName: "ellipsis")
                                    .padding()
                            }
                            
                            
                        }
                        
                        Button {
                            storyView.toggle()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(.plain)
                    }

                }
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: [.black.opacity(0.3), .black.opacity(0.01)]), startPoint: .top, endPoint: .bottom)
                )
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    HStack (spacing: 0) {
                        Button {
                            if storyHandler.isLiked == 1 {
                                storyHandler.unlikeStory(userID: sessionService.userDetails.uid, storyID: story.id, completion: {
                                    Task {
                                        await storyHandler.checkLikeStatus(userID: sessionService.userDetails.uid, storyID: story.id)
                                        await storyHandler.getCountOfStory(storyID: story.id)
                                    }
                                })
                            }
                            else {
                                storyHandler.likeStory(userID: sessionService.userDetails.uid, storyID: story.id, completion: {
                                    Task {
                                        await storyHandler.checkLikeStatus(userID: sessionService.userDetails.uid, storyID: story.id)
                                        await storyHandler.getCountOfStory(storyID: story.id)
                                    }
                                })
                            }
                        } label: {
                            Image(systemName: storyHandler.isLiked == 1 ? "arrow.up.circle.fill" : "arrow.up.circle")
                                .imageScale(.small)
                                .frame(width: 40, height: 40)
                                .foregroundColor(storyHandler.isLiked == 1 ? .purple : .white)
                        }
                        
                        Text(String(storyHandler.totalCount))
                            .padding(.horizontal, 1)
                            
                        
                        Button {
                            if storyHandler.isLiked == 2 {
                                storyHandler.undislikeStory(userID: sessionService.userDetails.uid, storyID: story.id, completion: {
                                    Task {
                                        await storyHandler.checkLikeStatus(userID: sessionService.userDetails.uid, storyID: story.id)
                                        await storyHandler.getCountOfStory(storyID: story.id)
                                        
                                    }
                                })
                            }
                            else {
                                storyHandler.dislikeStory(userID: sessionService.userDetails.uid, storyID: story.id, completion: {
                                    Task {
                                        await storyHandler.checkLikeStatus(userID: sessionService.userDetails.uid, storyID: story.id)
                                        await storyHandler.getCountOfStory(storyID: story.id)
                                    }
                                })
                            }
                        } label: {
                            Image(systemName: storyHandler.isLiked == 2 ? "arrow.down.circle.fill" : "arrow.down.circle")
                                .imageScale(.small)
                                .frame(width: 40, height: 40)
                                .foregroundColor(storyHandler.isLiked == 2 ? .purple : .white)
                        }
                    }
                    .padding(4)
                    .background(Color("darkForeground").opacity(0.8))
                    .cornerRadius(50)
                    

                }
                .buttonStyle(.plain)
                .font(.system(size: 25))
                .padding()
                
            }
            .foregroundColor(.white)
            
        }
        .onAppear {
            storyHandler.getVenue(venue: story.venueID, token: sessionService.userDetails.token, completion: {venue in
                Mixpanel.mainInstance().track(event: "Story View")
            })
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "HH:mm a"
////             "yyyy-MM-dd'T'HH:mm:ssZ"
////            let formatter = ISO8601DateFormatter()
//            print(story.date)
//            let date = (dateFormatter.date(from: story.time) ?? Date())
//            print(date)
//            let hours = Calendar.current.dateComponents([.hour], from: date)
//            print("hours: \(hours)")
//            let cutOff = Calendar.current.date(byAdding: .hour, value: 18, to: Date())
//
//            var dateObj = Calendar.current.date(byAdding: hours, to: Date())
//            let minutes = Calendar.current.dateComponents([.minute], from: date)
//            print("minutes: \(minutes)")
//            dateObj =  Calendar.current.date(byAdding: minutes, to: Date())
//            print("cutoff: \(cutOff)")
//            print("current progress: \(dateObj)")
//            self.components = Calendar.current.dateComponents([.hour, .minute], from: cutOff ?? Date(), to: dateObj ?? Date())
//            print(components)
//            let hours = diffComponents.hour
//            if hours ?? 1 < 1 {
//                let minutes = diffComponents.minute
//                self.minutes = df.string(from: minutes)
//            }
        }
        .cornerRadius(15)
        .task {
            await storyHandler.getCountOfStory(storyID: story.id)
            await storyHandler.checkLikeStatus(userID: sessionService.userDetails.uid, storyID: story.id)
        }
    }
}
//
//struct IndividualStory_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let story = StoryObj(url: "https://firebasestorage.googleapis.com:443/v0/b/appluna.appspot.com/o/storyImages%2FoEprXcNfWTU7qBIlFmHO?alt=media&token=433331c5-8d6a-4bb8-9220-0eef70bf7c42", id: "", uploaderID: "", venueID: "", time: "", date: "", likes: [], dislikes: [], uploaderURL: "", uploaderName: "")
//
//        ZStack {
//            IndividualStory(story: story, storyView: .constant(false), currentImage: .constant(1), numberOfStories: 3)
//                .environmentObject(SessionServiceImpl())
//                .environmentObject(storiesHandler())
//        }
//    }
//}
