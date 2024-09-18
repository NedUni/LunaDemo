//
//  IndividualStory.swift
//  Luna
//
//  Created by Ned O'Rourke on 25/4/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Mixpanel

struct HotStoriesIndividualStory: View {
    
    @State var story : StoryObj
    @EnvironmentObject var storyHandler : storiesHandler
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var homeVM : ViewModel
    @Binding var storyView : Bool
    @Binding var currentImage : Int
    let numberOfStories : Int
        
    @State var pause : Bool = false
    
    @Binding var nextChange : String
    
    @State var components: DateComponents?
    
    var body: some View {
        ZStack (alignment: .top) {
            
            StoryImage(
                url: URL(string: story.url)!,
                placeholder: { Text("Loading ...") },
                image: { Image(uiImage: $0).resizable() }
            )
            .scaledToFit()
            .frame(width: UIScreen.main.bounds.width)
            .clipped()
            .cornerRadius(15)
            

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
//                                case (...0, -30...30):  withAnimation {venueNumber -= 1}
//                                case (0..., -30...30):  withAnimation {venueNumber += 1}
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
                                            else {
                                                var index = homeVM.popularStoryVenues.firstIndex(where: {$0 == story.venueID})
                                                index! -= 1
                                                print(index!)
                                                if index! >= 0 {
                                                    nextChange = homeVM.popularStoryVenues[index!]
                                                }
                                                
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
//                                case (...0, -30...30):  withAnimation {venueNumber -= 1}
//                                case (0..., -30...30):  withAnimation {venueNumber += 1
//                                    print(venueNumber)
//                                }
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
                                            else {
                                                var index = homeVM.popularStoryVenues.firstIndex(where: {$0 == story.venueID})
                                                index! += 1
                                                print(index!)
                                                if index! < homeVM.popularStoryVenues.count {
                                                    nextChange = homeVM.popularStoryVenues[index!]
                                                }
                                                else {
                                                    storyView = false
                                                }
                                                
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
                        
//                        Text("\(components?.hour ?? 1 > 0 ? String(components?.hour ?? 1) : String(components?.minute ?? 1)) left")
//                            .foregroundColor(Color.secondary)
//
//                        Image(systemName: "clock.arrow.circlepath")
//                            .foregroundColor(Color.secondary)
                        if story.uploaderID == sessionService.userDetails.uid {
                            
                            Menu {
                        
                                Button {
                                    storyHandler.deleteSory(storyID: story.id, completion: {
                                        homeVM.getPopularStoryVenues()
                                        storyView.toggle()
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
        
//        .frame(width: 100, height: 100, alignment: .center)
        .onAppear {
            storyHandler.getVenue(venue: story.venueID, token: sessionService.userDetails.token, completion: {venue in
                Mixpanel.mainInstance().track(event: "Story View")
            })
            let dateFormatter = DateFormatter()
            let date = dateFormatter.date(from: story.date)
//            self.components = Calendar.current.dateComponents([.hour, .minute], from: Date(), to: date!)
        }
        .cornerRadius(15)
        .task {
            await storyHandler.getCountOfStory(storyID: story.id)
            await storyHandler.checkLikeStatus(userID: sessionService.userDetails.uid, storyID: story.id)
        }
    }
}

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

