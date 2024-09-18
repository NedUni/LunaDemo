//
//  PageView.swift
//  Luna
//
//  Created by Ned O'Rourke on 28/3/22.
//

import SwiftUI
import SDWebImageSwiftUI
import AVFoundation
import AVKit

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct TabBarView: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    var tabBarOptions: [String] = ["Upcoming Events", "Past Events"]
    
    var body: some View {
            HStack (spacing: 20) {
                ForEach(Array(zip(self.tabBarOptions.indices,
                                  self.tabBarOptions)),
                        id:\.0,
                        content: {
                    index, name in
                    TabBarItem(currentTab: self.$currentTab,
                               namespace: namespace.self,
                               tabBarItemName: name,
                               tab: index)
                })
            }
            .padding(.horizontal)
            .background(.clear)
    }
}
struct TabBarItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    var tabBarItemName: String
    

    var tab: Int
    
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                Spacer()
                Text(tabBarItemName)
                    .foregroundColor(currentTab == tab ? .purple : .white)
//                    .fontWeight(currentTab == tab ? .med : .medium)
                if currentTab == tab {
//                    .fontWeight(.medium)
                    Color.purple
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace,
                                               properties: .frame)
                } else {
                    Color.clear
                        .frame(height: 2)
                }
            }
            .animation(.spring(), value: self.currentTab)
        }
        .buttonStyle(.plain)

    }
}

struct LongText: View {

    /* Indicates whether the user want to see all the text or not. */
    @State private var expanded: Bool = false

    /* Indicates whether the text has been truncated in its display. */
    @State private var truncated: Bool = false
    
    
    private var text: String
    
    @State var dark : Bool

    init(_ text: String, dark: Bool) {
        self.text = text
        self.dark = dark

    }

    private func determineTruncation(_ geometry: GeometryProxy) {
        // Calculate the bounding box we'd need to render the
        // text given the width from the GeometryReader.
        let total = self.text.boundingRect(
            with: CGSize(
                width: geometry.size.width,
                height: .greatestFiniteMagnitude
            ),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 16)],
            context: nil
        )

        if total.size.height > geometry.size.height {
            self.truncated = true
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(self.text)
                .font(.system(size: 16))
                .lineLimit(self.expanded ? nil : 3)
                .background(GeometryReader { geometry in
                    Color.clear.onAppear {
                        self.determineTruncation(geometry)
                    }
                })
                .foregroundColor(self.dark ? Color("darkSecondaryText") : Color.primary)

            if self.truncated {
                self.toggleButton
            }
        }
    }

    var toggleButton: some View {
        Button {
            withAnimation{
                self.expanded.toggle()
            }
        } label: {
            Text(self.expanded ? "Show less" : "Show more")
                .font(.caption)
        }
    }
}


struct PageView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @StateObject var pageManager = PageHandler()
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var manager : LocationManager
    
    @State var isAnimating: Bool = true
    
    @State var page: PageObj
        
    @State var barHidden = false //true
    
    @State var lineLimit = 3
    @State var buttonText = "show more"
    
    @State var currentTab = 0
    @State var navShow = false
    @State var st = false
    @State var changePromoted = false
    @State var showEditPage : Bool = false
    @State var showCreateEvent : Bool = false
    @State var edit = false
    
    var body: some View {
        
        ZStack {
            ScrollView (.vertical, showsIndicators: false) {
                VStack (spacing: 0) {
                    HeaderView()
                    
                    VStack {
                        Content()
                    }
                }
            }
            
            //NavVEBar
            GeometryReader {proxy in
                let size = proxy.size
                if navShow {
                    HStack (alignment: .center) {
                        BackButtonView()
                        Spacer()
                        Text(page.name)
                        Spacer()
                        if page.admins.contains(sessionService.userDetails.uid) {
                            EditPageButton(showEditPage: $showEditPage, page: $page, showCreateEvent: $showCreateEvent)
                        }
                        else {
                            //Filler
                            Image(systemName: "ellipsis.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .opacity(0)
                        }
                    }
                    .padding(.horizontal)
                    .frame(width: size.width, height: 40, alignment: .center)
                    .background(Color("darkBackground"))
                    .foregroundColor(.white)
                }
                
                else {
                    HStack (alignment: .center) {
                        BackButtonView()
                        Spacer()
                        if page.admins.contains(sessionService.userDetails.uid) {
                            EditPageButton(showEditPage: $showEditPage, page: $page, showCreateEvent: $showCreateEvent)
                        }
                    }
                    .padding(.horizontal)
                    .frame(width: size.width, height: 40, alignment: .center)
                    .background(.clear)
                }
            }
        }
        .background(Color("darkBackground"))
        .navigationBarHidden(true)
        .onAppear {
            let queue = DispatchQueue(label: "page", attributes: .concurrent)
            
            queue.async {pageManager.getPromotedEvent(pageID: page.id)}
            queue.async {pageManager.getUpcomingEvents(pageID: page.id)}
            queue.async {pageManager.checkFollowStatus(uid: sessionService.userDetails.uid, pageID: page.id)}
            queue.async {pageManager.getTotalFriendsThatFollowPage(uid: sessionService.userDetails.uid, pageID: page.id)}
            queue.async {pageManager.getTotalThatFollowPage(pageID: page.id)}
            queue.async {pageManager.getFriendsThatFollowPage(uid: sessionService.userDetails.uid, pageID: page.id)}
            
        }
        .sheet(isPresented: $changePromoted, onDismiss: nil) {
            VStack (alignment: .center, spacing: 10) {
                Text("Select the event you want pinned!")
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                    .padding(.top)
                    
                Divider()
                    .background(Color("darkSecondaryText"))
                ScrollView {
                    ForEach(pageManager.upcomingEvents, id: \.self) { event in
                        
                        MyEventsEventView(event: event, clickable: false)
                                .environmentObject(sessionService)
                                .environmentObject(manager)
                                .environmentObject(homeVM)
                                .onTapGesture {
                                    pageManager.setPromoted(pageID: page.id, eventID: event.id, completion: {
                                        pageManager.getPromotedEvent(pageID: page.id)
                                        changePromoted.toggle()
                                    })
                                    
                                }
                    }
                    .padding(.bottom)
                }
            }
            .padding(.horizontal)
            
        }
        .fullScreenCover(isPresented: $showEditPage, onDismiss: nil, content: {
            EditPageView2(page: $page, showEditPage: $showEditPage)
                .environmentObject(sessionService)
                .environmentObject(pageManager)
            
        })
        .fullScreenCover(isPresented: $showCreateEvent, onDismiss: nil, content: {
            CreateEventView2(showCreateEvent: $showCreateEvent, page: page)
                .environmentObject(sessionService)
//                .environmentObject(manager)
//                .environmentObject(homeVM)
                .environmentObject(pageManager)
        })
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        GeometryReader {proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = (size.height + minY)
                        
                
                WebImage(url: URL(string: page.banner_url))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: height >= 250 ? height : 250, alignment: .top)
                    .overlay(content: {
                        ZStack (alignment: .bottom) {
                            LinearGradient(colors: [
                                .clear,
                                .black.opacity(0.5)
                            ], startPoint: .top, endPoint: .bottom)
                        }
                    })
                    .cornerRadius(1)
                    .offset(y: -minY)
                    .onChange(of: minY) { newValue in
                        if newValue < -130 {
                            withAnimation {
                                self.navShow = true
                            }

                        }
                        else {
                            withAnimation {
                                self.navShow = false
                            }
                        }
                    }
        }
        .frame(height: 200)
        
        
    }
    
    @ViewBuilder
    func Content()-> some View {
        VStack (alignment: .leading) {
            HStack (alignment: .center) {
                WebImage(url: URL(string: page.logo_url))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .cornerRadius(32)

                VStack (alignment: .leading) {
                    Text(page.name)
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .fontWeight(.heavy)
                        .lineLimit(1)

                    Text(page.categories[0])
                        .fontWeight(.light)
                        .foregroundColor(Color("darkSecondaryText"))
                        .font(.system(size: 15))
                }
                .font(.system(size: 8))
                .padding(.vertical)

                Spacer()
                
                Group {
                    HStack (alignment: .center) {
                        Text("\(pageManager.totalThatFollowPage) likes")
                            .foregroundColor(Color("darkSecondaryText"))
                            .font(.system(size: 15))

                        Button {
                            if pageManager.isFollowed {
                                pageManager.unfollowPage(uid: sessionService.userDetails.uid, pageID: page.id, completion: {
                                    pageManager.checkFollowStatus(uid: sessionService.userDetails.uid, pageID: page.id)
                                    pageManager.getTotalThatFollowPage(pageID: page.id)
                                    pageManager.getTotalFriendsThatFollowPage(uid: sessionService.userDetails.uid, pageID: page.id)
                                })
                            } else {
                                pageManager.followPage(uid: sessionService.userDetails.uid, pageID: page.id, completion: {
                                    pageManager.checkFollowStatus(uid: sessionService.userDetails.uid, pageID: page.id)
                                    pageManager.getTotalThatFollowPage(pageID: page.id)
                                    pageManager.getTotalFriendsThatFollowPage(uid: sessionService.userDetails.uid, pageID: page.id)
                                })
                            }
                        } label: {
                            Image(systemName: pageManager.isFollowed ? "heart.fill" : "heart")
                        }

                        
                    }
                }

            }
            .padding(.top)
            
            
            .onAppear {
                Task {
                    await pageManager.getPageAdmins(id: page.id) {
                        print("l")
                    }
                }
                
            }
            
            
//            Image(systemName: song1 ? "pause.circle.fill": "play.circle.fill")
//                        .font(.system(size: 25))
//                        .padding(.trailing)
//                        .onTapGesture {
//                            soundManager.playSound(sound: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/427979985&color=%23484235&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true&visual=true")
//                            song1.toggle()
////
////                            if song1{
////                                soundManager.audioPlayer?.play()
////                            } else {
////                                soundManager.audioPlayer?.pause()
////                            }
//                    }
            
//            Button {
//
////                guard let uid = Auth.auth().currentUser?.uid else {
////                    print("failed to get uid")
////                    return
////                }
//            } label: {
//                Text("upload")
//            }

            
            
            VStack (alignment: .leading, spacing: 0) {
                if pageManager.totalFriendsThatFollowPage  > 0 {
                    Divider()
                        .background(Color("darkSecondaryText"))
                
                    Text("\(pageManager.totalFriendsThatFollowPage) friends like this page")
                        .foregroundColor(.white)
                        .padding(.vertical, 4)
                    
                    ScrollView (.horizontal, showsIndicators: false) {
                        if pageManager.totalFriendsThatFollowPage > 0 {
                            LazyHStack {
                                ForEach(pageManager.friendsThatFollowPage, id: \.self) { friend in
                                    NavigationLink(destination: friend.performer ? AnyView(PerformerProfileView(user: friend)
                                        .environmentObject(sessionService)
                                        .environmentObject(manager)
                                        .environmentObject(homeVM))
                                       : AnyView(UserProfileView(user: friend)
                                        .environmentObject(sessionService)
                                        .environmentObject(manager)
                                        .environmentObject(homeVM)), label: {
                                        VStack {
                                            WebImage(url: URL(string: friend.imageURL))
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 32, height: 32).cornerRadius(64)
                                                .clipped()
                                        }
                                    })
                                }
                              }
                        }
                        else {
                            //Filler
                            VStack {
                                
                            }
                            frame(width: 32, height: 32).cornerRadius(64)
                            .clipped()
                        }
                          

                      }
                }
            }
            
            Divider()
                .background(Color("darkSecondaryText"))
            
            VStack (alignment: .leading) {
                Text("About these organisers")
                    .foregroundColor(.white)
                
                LongText(page.description, dark: true)
//                    .foregroundColor(Color("darkSecondaryText"))
            }
            Divider()
                .background(Color("darkSecondaryText"))
            
            
            if pageManager.promotedEvent != nil {
                VStack {
                    HStack {
                        Text("Pinned Event")
                        Image(systemName: "pin.fill")
                            .foregroundColor(.white)
                        Spacer()
                        if page.admins.contains(sessionService.userDetails.uid) {
                            Button {
                                self.changePromoted.toggle()
                            } label : {
                                Text("Change")
                                    .foregroundColor(.purple)
                            }
                        }
                    }
                    ZStack (alignment: .topTrailing) {
                        
                        HStack {
                            Spacer()
                            MyEventsEventView(event: pageManager.promotedEvent!, clickable: true)
                            Spacer()
                        }

                        
                    }
                    
                    Divider()
                        .background(Color("darkSecondaryText"))
                }
            }
            
            VStack {
                TabBarView(currentTab: self.$currentTab)
                
                
                if self.currentTab == 0 {
                    View1(page: page)
                        .environmentObject(pageManager)
                }
                
                else {
                    View2(page: page)
                        .environmentObject(pageManager)
                }
                
//                Divider()
                
                View3(page: page)
                    .environmentObject(pageManager)
                    .environmentObject(sessionService)
            }
            


                

        }
        .padding(.horizontal)
        .background(Color("darkBackground"))
        .cornerRadius(20)
        .offset(y: -18)
    
    }
}
