//
//  CreateEventView2.swift
//  Luna
//
//  Created by Ned O'Rourke on 3/6/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreateEventView2: View {
    
    //Environment Objects
    @EnvironmentObject var pageManager : PageHandler
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    //General
    @State var currentIndex : Int = 0
    @Binding var showCreateEvent : Bool
    @State var page : PageObj
    init(showCreateEvent: Binding<Bool>, page: PageObj) {
        UITextView.appearance().backgroundColor = .clear
        self._showCreateEvent = showCreateEvent
        _page = State(initialValue: page)
    }
    
    //Error Handling
    @State var error = false
    @State var errorText = ""
    
    //Index 0
    @State var eventName = ""
    @State var eventChosenCategories : [String] = []
    
    //Index 1
    @State var eventDate : Date = Date()
    @State var showEndTime : Bool = false
    @State var eventEnd : Date = Date()
    
    //Index 2
    @State var termLen = 0
    @State var searchTerm = ""
    @State var venueHolder : VenueObj?
    @State var eventLocation = ""
    @State var confirmedLocation = false
    @State var showImagePicker = false
    @State var eventImage : UIImage?
    
    //Index 3
    @State var eventDescription = "Description"
    
    //Index 4
    @State var eventHosts : [PageObj] = []
    @State var showSearch = false
    @State var hostSearch = ""
    @State var isCreating = false
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                
                switch currentIndex {
                    
                case 0:
                    VStack (alignment: .leading, spacing: 5) {
                        
                        //Name
                        Text("What is the name of your Event?")
                            .foregroundColor(.white)
                        TextField("", text: $eventName)
                            .font(.system(size: 40, weight: .heavy))
                            .multilineTextAlignment(TextAlignment.leading)
                            .foregroundColor(.white)
                            .disableAutocorrection(true)
                            .placeholder(when: eventName.isEmpty, alignment: .leading) {
                                Text("Event Name")
                                    .font(.system(size: 40, weight: .heavy))
                                    .foregroundColor(Color("darkSecondaryText")).opacity(0.3)
                            }
                        
                        //Categories
                        Text("What genre is your event? (up to 2)")
                            .foregroundColor(.white)
                        
                        ScrollView {
                            VStack(alignment: .leading) {
                                let xd = TagsView(items: pageManager.pageCategories)
                                ForEach(xd.groupedItems, id: \.self) { subItems in
                                    HStack {
                                        ForEach(subItems, id: \.self) { word in
                                            Text(word)
                                                .fixedSize()
                                                .padding()
                                                .background(eventChosenCategories.contains(word) ? .purple : .purple.opacity(0.4))
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                                .onTapGesture {
                                                    withAnimation {
                                                        if !eventChosenCategories.contains(word) && eventChosenCategories.count < 2 {
                                                            eventChosenCategories.append(word)
                                                        }
                                                        else {
                                                            withAnimation {
                                                                if let index = eventChosenCategories.firstIndex(of: word) {
                                                                    eventChosenCategories.remove(at: index)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack (alignment: .center) {
                            if self.error {
                                Text(self.errorText)
                                    .foregroundColor(Color("Error"))
                                    .onAppear {
                                        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {
                                            timer in
                                            withAnimation {
                                                self.errorText = ""
                                                self.error = false
                                            }
                                        }
                                    }
                            }
                            
                            Button {
                                if eventName.count < 2 {
                                    withAnimation {
                                        self.errorText = "You must name your page"
                                        self.error = true
                                    }
                                }
                                
                                else if eventChosenCategories.count < 1 {
                                    withAnimation {
                                        self.errorText = "You must select at least 1 category"
                                        self.error = true
                                    }
                                }
                                
                                else if eventName.count >= 2 && eventChosenCategories.count >= 1 {
                                    currentIndex += 1
                                }
                                
                            } label: {
                                
                                VStack {
                                    HStack (spacing: 5) {
                                        ForEach(0..<5, id: \.self) { tab in
                                            Rectangle()
                                                .fill(tab <= self.currentIndex ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, idealHeight: 5, maxHeight: 5, alignment: .center)
                                                .cornerRadius(10)
                                        }
                                    }
                                    
                                    VStack {
                                        Text("Continue")
                                            .font(.system(size: 20))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
                                    .background(eventName.count >= 2 && eventChosenCategories.count >= 1 ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                    .cornerRadius(10)
                                }
                                .padding(.bottom)
                            }
                        }
                    }
                    .onAppear {
                        pageManager.getPageCategories()
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                self.showCreateEvent = false
                            } label: {
                                Text("Cancel")
                            }

                        }
                    }
                    
                case 1:
                    VStack (alignment: .leading, spacing: 5) {
                        Text("When is your event?")
                            .foregroundColor(.white)
                        
                        VStack {
                            DatePicker("", selection: $eventDate, displayedComponents: [.date, .hourAndMinute])
                                .labelsHidden()
                                .datePickerStyle(WheelDatePickerStyle())
                                .frame(minWidth: 0, maxWidth: .infinity)
                            
                            Text("Add end time ↓")
                                .onTapGesture {
                                    withAnimation {
                                        showEndTime.toggle()
                                    }
                                }
                            
                            if showEndTime {
                                DatePicker("Optional End Time", selection: $eventEnd, displayedComponents: .hourAndMinute)
                            }
                           
                        }
                        
                        Spacer()
                        
                        VStack (alignment: .center) {
                            if self.error {
                                Text(self.errorText)
                                    .foregroundColor(Color("Error"))
                                    .onAppear {
                                        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {
                                            timer in
                                            withAnimation {
                                                self.errorText = ""
                                                self.error = false
                                            }
                                        }
                                    }
                            }
                            
                            Button {
                                print(Date())
                                if self.eventDate <= Date() {
                                    withAnimation {
                                        self.errorText = "Event must be in the future"
                                        self.error = true
                                    }
                                }
                                
                                else {
                                    currentIndex += 1
                                }
                                
                            } label: {
                                
                                VStack {
                                    HStack (spacing: 5) {
                                        ForEach(0..<5, id: \.self) { tab in
                                            Rectangle()
                                                .fill(tab <= self.currentIndex ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, idealHeight: 5, maxHeight: 5, alignment: .center)
                                                .cornerRadius(10)
                                        }
                                    }
                                    
                                    VStack {
                                        Text("Continue")
                                            .font(.system(size: 20))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
                                    .background(eventDate <= Date() ? .purple.opacity(0.3) : .purple.opacity(0.8))
                                    .cornerRadius(10)
                                }
                                .padding(.bottom)
                            }
                        }
                        
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                currentIndex -= 1
                            } label: {
                                Text("Back")
                            }
                        }
                    }
                    
                case 2:
                    VStack (alignment: .leading, spacing: 5) {
                        ScrollView (showsIndicators: false) {
                            
                                VStack (alignment: .leading) {
                                    Text("Where is the event?")
                                        .foregroundColor(.white)
                                    TextField("venue/address", text: $searchTerm)
                                    .font(.system(size: 20, weight: .heavy))
                                    .multilineTextAlignment(TextAlignment.leading)
                                    .foregroundColor(.white)
                                    .disableAutocorrection(true)
                                    .padding(10)
                                    .background(
                                        ZStack (alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 5,
                                                             style: .continuous)
                                                .stroke(Color.clear)
                                        }
                                    )
                                    .padding(.leading, -7)
                                    .onChange(of: searchTerm) { newTerm in
                                        sessionService.searchVenueResults = []
                                        sessionService.searchVenues(term: newTerm, option: 1)
                                        
                                        if newTerm.count < termLen {
                                            confirmedLocation = false
                                            eventLocation = ""
                                            venueHolder = nil
                                        }
                                        
                                        termLen = newTerm.count
                                    }
                                    
                                    if !confirmedLocation {
                                        ScrollView (.horizontal, showsIndicators: false) {
                                            HStack {
                                                ForEach(sessionService.searchVenueResults, id: \.self) { venue in
                                                    VenueTileView(ven: venue)
                                                        .highPriorityGesture(
                                                            TapGesture()
                                                                .onEnded {
                                                                    venueHolder = venue
                                                                    searchTerm = venue.displayname
                                                                    confirmedLocation = true
                                                                    eventLocation = venue.address
                                                                }
                                                            )
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                VStack (alignment: .leading) {
                                    Text("Select an event image")
                                        .foregroundColor(.white)
                                    
                                    VStack {
                                            if let image = self.eventImage {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                            } else {
                                                ZStack {
                                                    Color.purple.opacity(0.4)
                                                    Image(systemName: "photo")
                                                }
                                                
                                                
                                            }
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                    .frame(height: 200)
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            showImagePicker.toggle()
                                        }
                                }
                        }
                            
                            
                            Spacer()
                            
                            VStack (alignment: .center) {
                                if self.error {
                                    Text(self.errorText)
                                        .foregroundColor(Color("Error"))
                                        .onAppear {
                                            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {
                                                timer in
                                                withAnimation {
                                                    self.errorText = ""
                                                    self.error = false
                                                }
                                            }
                                        }
                                }
                                
                                Button {
                                    if eventLocation == "" && searchTerm == "" {
                                        withAnimation {
                                            self.errorText = "You must chose a location"
                                            self.error = true
                                        }
                                    }
                                    
                                    else if eventImage == nil {
                                        withAnimation {
                                            self.errorText = "Looks like you're missing an event image"
                                            self.error = true
                                        }
                                    }
                                    
                                    else {
                                        currentIndex += 1
                                    }
                                    
                                } label: {
                                    
                                    VStack {
                                        HStack (spacing: 5) {
                                            ForEach(0..<5, id: \.self) { tab in
                                                Rectangle()
                                                    .fill(tab <= self.currentIndex ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, idealHeight: 5, maxHeight: 5, alignment: .center)
                                                    .cornerRadius(10)
                                            }
                                        }
                                        
                                        VStack {
                                            Text("Continue")
                                                .font(.system(size: 20))
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
                                        .background(eventLocation != "" || searchTerm != "" && eventImage != nil ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                        .cornerRadius(10)
                                    }
                                    .padding(.bottom)
                                }
                            }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                currentIndex -= 1
                            } label: {
                                Text("Back")
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $showImagePicker) {
                           ImagePicker(image: $eventImage)
                    }
                    
                case 3:
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Describe your Event")
                            .foregroundColor(.white)
                        
                        TextEditor(text: $eventDescription)
                            .simultaneousGesture(TapGesture().onEnded({
                                if self.eventDescription == "Description" {
                                    self.eventDescription = ""
                                }
                            }))
                        
                        Spacer()
                        
                        Button {
                            if self.eventDescription != "Description" && self.eventDescription != "" {
                                currentIndex += 1
                                eventHosts.append(page)
                            }
                        } label: {
                            VStack {
                                HStack (spacing: 5) {
                                    ForEach(0..<5, id: \.self) { tab in
                                        Rectangle()
                                            .fill(tab <= self.currentIndex ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, idealHeight: 5, maxHeight: 5, alignment: .center)
                                            .cornerRadius(10)
                                    }
                                }
                                
                                VStack {
                                    Text("Continue")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
                                .background(self.eventDescription != "Description" && self.eventDescription != "" ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                .cornerRadius(10)
                            }
                            .padding(.bottom)
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                currentIndex -= 1
                            } label: {
                                Text("Back")
                            }

                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                if self.eventDescription == "Description" || self.eventDescription == "" {
                                    currentIndex += 1
                                    self.eventDescription = ""
                                }
                                
                            } label: {
                                if self.eventDescription == "Description" || self.eventDescription == "" {
                                    Text("Skip")
                                }
                            }
                        }
                    }
                    
                case 4:
                    VStack (alignment: .leading, spacing: 5) {
                        HStack (alignment: .center) {
                            Text("Add any other Co-Hosts")
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    self.showSearch.toggle()
                                }
                            } label: {
                                if self.showSearch {
                                    Image(systemName: "magnifyingglass")
                                        .padding(4)
                                        .background(.purple.opacity(0.3))
                                        .foregroundColor(.purple)
                                        .cornerRadius(40)
                                }
                                else {
                                    Image(systemName: "magnifyingglass")
                                        .padding(4)
                                        .cornerRadius(10)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        
                        if self.showSearch {
                            VStack {
                                TextField("Search Luna", text: $hostSearch)
                            }
                            .padding(.leading)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 45, alignment: .leading)
                            .background(Color("darkForeground").opacity(0.2))
                            .cornerRadius(5)
                            .onChange(of: hostSearch) { newTerm in
                                sessionService.searchVenues(term: newTerm, option: 3)
                            }
                        }
                       
                        
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack {
                                if showSearch && sessionService.searchPageResults.count > 0 {
                                    ForEach(sessionService.searchPageResults, id: \.self) { host in
                                        VStack {
                                            WebImage(url: URL(string: host.logo_url)!)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: UIScreen.main.bounds.width*0.15, height: UIScreen.main.bounds.width*0.15)
                                                .cornerRadius(100)
                                            
                                            Text("\(host.name)")
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(width: 100, height: 100)
                                        .padding(5)
                                        .padding(.horizontal, 5)
                                        .background(Color("darkForeground").opacity(0.3))
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            if !eventHosts.contains(host) {
                                                eventHosts.append(host)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        Text("Your Co-Hosts (tap to remove)")
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(self.eventHosts, id: \.self) { host in
                                    ZStack (alignment: .topTrailing) {
                                        VStack {
                                            WebImage(url: URL(string: host.logo_url)!)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: UIScreen.main.bounds.width*0.15, height: UIScreen.main.bounds.width*0.15)
                                                .cornerRadius(100)
                                            
                                            Text("\(host.name)")
                                                .multilineTextAlignment(.center)
                                        }
                                        
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .background(.white)
                                    }
                                    .frame(width: 100, height: 100)
                                    .padding(5)
                                    .padding(.horizontal, 5)
                                    .background(Color("darkForeground").opacity(0.3))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        if host.id != page.id {
                                            let index = Int(self.eventHosts.firstIndex(of: host)!)
                                            self.eventHosts.remove(at: index)
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        
                        Button {
                            if !self.isCreating {
                                self.isCreating = true
                                var hostIDS : [String] = []
                                for host in self.eventHosts {
                                    hostIDS.append(host.id)
                                }
                                
                                var hostNames : [String] = []
                                for host in self.eventHosts {
                                    hostNames.append(host.name)
                                }
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "dd-MM-yyyy"
                                let eventDateString = dateFormatter.string(from: eventDate)
                                
                                dateFormatter.dateFormat = "HH:mm"
                                let eventStartTimeString = dateFormatter.string(from: eventDate)
                                
                                var eventEndTimeString = ""
                                if showEndTime {
                                    eventEndTimeString = dateFormatter.string(from: eventEnd)
                                }
                                
                                pageManager.createPageEvent(pageID: page.id, eventName: eventName, eventDescription: eventDescription, eventDate: eventDateString, eventStartTime: eventStartTimeString, eventEndTime: eventEndTimeString, address: eventLocation == "" ? searchTerm : eventLocation, eventTags: eventChosenCategories.joined(separator: ","), eventHostIds: hostIDS.joined(separator: ","), eventHostNames: hostNames.joined(separator: ","), linkedVenue: venueHolder != nil ? venueHolder!.id : "", linkedVenueName: venueHolder != nil ? venueHolder!.displayname : "", ticketlink: "", image: eventImage!) {
                                    pageManager.getUpcomingEvents(pageID: page.id)
                                    pageManager.getPromotedEvent(pageID: page.id)
                                    self.showCreateEvent = false
                                }
                            }
                        } label: {
                            VStack {
                                HStack (spacing: 5) {
                                    ForEach(0..<5, id: \.self) { tab in
                                        Rectangle()
                                            .fill(tab <= self.currentIndex ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, idealHeight: 5, maxHeight: 5, alignment: .center)
                                            .cornerRadius(10)
                                    }
                                }
                                
                                VStack {
                                    Text(self.isCreating ? "Creating..." : "Create Event")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
                                .background(.purple.opacity(0.8))
                                .cornerRadius(10)
                            }
                            .padding(.bottom)
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                currentIndex -= 1
                            } label: {
                                Text("Back")
                            }
                        }
                    }
                    
                    
                default:
                    Text("nah")
                    
                    
                }
                
            }
            .padding(.horizontal)
            .background(Color("darkBackground"))
            .navigationBarTitle("Create Your Event")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CreateEventView2_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView2(showCreateEvent: .constant(true), page: PageObj(id: "", name: "", email: "", description: "", promotedEvent: "", events: [], banner_url: "", logo_url: "", categories: [], followers: [], admins: [], website: ""))
            .environmentObject(SessionServiceImpl())
            .environmentObject(PageHandler())
    }
}
