//
//  CreateEventView.swift
//  Luna
//
//  Created by Ned O'Rourke on 31/3/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreateEventView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var pageManager : PageHandler
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var manager : LocationManager
    
    @Binding var showCreateEvent : Bool
    @State var tab : Int = 0
    @State var continueBool : Bool = false
    @State var error : Bool = false
    @State var error2 : Bool = false
    @State var page : PageObj
    
    //Case 0
    let tags = ["Techno", "House", "Lo-Fi", "Rock", "Live", "Guitar", "Sing-Alongs", "Pop", "Comedy"]
    @State var eventName : String = ""
    @State var eventDescription : String = ""
    @State var placeholderText : String = "Description"
   
    @State var eventChosenCategories : [String] = []
    @State var showEndTime : Bool = false
    //Case 1
    @State var eventDate : Date = Date.now
//    @State var eventStart : Date = Date.distantPast
    @State var eventEnd : Date = Date.now
    //Case 2
    @State var shouldShowImagePicker = false
    @State var eventImage : UIImage? //done
    @State var eventLocation : String = "" //done
    @State var eventLocationName : String = ""
    @State var term: String = ""
    @State var addressBool : Bool = false
    @State var venueHolder : VenueObj?
    @State var confirmed : Bool = false
    
    //Case 3
    @State var eventHosts : [PageObj] = []
    @State var eventHostsIDs : [String] = []
    @State var enentNotification : Bool = false
    @State var eventNotificationText : String = ""
    @State var pageTerm: String = ""
    @State var searchPadding: CGFloat = 0
    
    //Case 4
    let df = DateFormatter()
    let calendar = Calendar.current
    @State var date = ""
    @State var startTime = ""
    @State var endTime = "late"
    @State var location = ""
    @State var hostText = ""
    
    @State var termlen = 0
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                switch tab {
                case 0:
                    VStack (alignment: .leading, spacing: 0) {
                        VStack (alignment: .leading) {
                            Text("What is the name of your Event?")
                                .foregroundColor(.white)
                            TextField("", text: $eventName)
                                .font(.system(size: 40, weight: .heavy))
                                .multilineTextAlignment(TextAlignment.leading)
                                .foregroundColor(.white)
                                .disableAutocorrection(true)
                                .placeholder(when: eventName.isEmpty, alignment: .leading) {
                                    Text("Name")
                                        .font(.system(size: 40, weight: .heavy))
                                        .foregroundColor(Color("darkSecondaryText")).opacity(0.3)
                                }
                                .onChange(of: eventName) { newValue in
                                    if eventName.count >= 2 {
                                        continueBool = true
                                    }
                                    else {
                                        continueBool = false
                                    }
                                }
                        }
                        .ignoresSafeArea(.keyboard)
                        
                        VStack (alignment: .leading) {
                            
                            Text("What is your event description?")
                                .foregroundColor(.white)
                            
                            ZStack {
                                if self.eventDescription.isEmpty {
                                        TextEditor(text: $placeholderText)
                                            .font(.body)
                                            .foregroundColor(.gray)
                                            .disabled(true)
                                            .padding(-3)
                                            .frame(maxHeight: 150)
                                }
                                TextEditor(text: $eventDescription)
                                    .font(.body)
                                    .opacity(self.eventDescription.isEmpty ? 0.25 : 1)
                                    .padding(-3)
                                    .frame(maxHeight: 150)
                            }
                        }
                        .padding(.top, 30)
                        Spacer()
                        
                        VStack {
                            
                            NextButton(text: "Continue", isTriggered: $continueBool, signUpTab: $tab)
                        }
                        .padding(.bottom)
                        
                    }
                    .padding(.horizontal)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                showCreateEvent = false
                            } label: {
                                Text("cancel")
                            }
                        }
                    }
                
                case 1:
                    VStack (alignment: .center, spacing: 0) {
                        VStack (alignment: .leading) {
                            Text("When is your event?")
                                .foregroundColor(.white)
                            
                            VStack {
                                DatePicker("", selection: $eventDate, displayedComponents: [.date, .hourAndMinute])
                                    .labelsHidden()
                                    .datePickerStyle(WheelDatePickerStyle())
                                    .frame(width: UIScreen.main.bounds.size.width*0.85)
                                    .onChange(of: eventDate) { newValue in
                                        if newValue > Date.now {
                                            continueBool = true
                                            error = false
                                            eventEnd = newValue.addingTimeInterval(180)
                                        }
                                        else {
                                            continueBool = false
                                            error = true
                                        }
                                    }
                                
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

                        }
                        .padding()
                        
                        Spacer()
                        
                        VStack {
                            
                            if error {
                                Text("Event must start before right now")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color("Error"))
                                    .fontWeight(.heavy)
                            }
                            
                            
                            NextButton(text: "Continue", isTriggered: $continueBool, signUpTab: $tab)
                        }
                        .padding(.bottom)
                    }

                case 2:
                    VStack (alignment: .leading, spacing: 0) {
                        VStack (alignment: .leading) {
                            Text("Do you have any co-hosts?")
                                .foregroundColor(.white)
                            TextField("Co-Hosts", text: $pageTerm)
                            .font(.system(size: 40, weight: .heavy))
                            .multilineTextAlignment(TextAlignment.leading)
                            .foregroundColor(.white)
                            .disableAutocorrection(true)
                            .padding(10)
                            .padding(.leading, searchPadding)
                            .background(
                                ZStack (alignment: .leading) {
                                    ScrollView (.horizontal, showsIndicators: false) {
                                        HStack (spacing: 5){
                                            ForEach(self.eventHosts, id: \.self) { page in
                                                HStack (spacing: 0) {
                                                    WebImage(url: URL(string: page.logo_url))
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 40, height: 40).cornerRadius(20)
                                                        .clipped()
                                                    
                                                    Spacer()
                                                    
                                                    Image(systemName: "xmark")
                                                }
                                                .padding(.horizontal)
                                                .frame(width: 80, height: 50).cornerRadius(20)
                                                .background(.purple.opacity(0.3))
                                                .cornerRadius(20)
                                                .onTapGesture {
                                                    withAnimation {
                                                        if eventHosts.count > 1 {
                                                            if let index = eventHosts.firstIndex(of: page) {
                                                                eventHosts.remove(at: index)
                                                                self.searchPadding = CGFloat((self.eventHosts.count) * 85)
                                                            }

                                                            if let index = eventHostsIDs.firstIndex(of: page.id) {
                                                                eventHostsIDs.remove(at: index)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding(.leading, 10)

                                    RoundedRectangle(cornerRadius: 5,
                                                     style: .continuous)
                                        .stroke(Color.clear)
                                }
                            )
                            .padding(.leading, -7)
                            .onChange(of: pageTerm) { newTerm in
                                sessionService.searchPageResults = []
                                sessionService.searchVenues(term: pageTerm, option: 3)
                            }
                            
                            if sessionService.searchPageResults.count != 0 {
                                withAnimation {
                                    VStack (alignment: .leading, spacing: 0) {
                                        ScrollView {
                                            ForEach(sessionService.searchPageResults, id: \.self) { page in
                                                HStack {
                                                    WebImage(url: URL(string: page.logo_url))
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 20, height: 20).cornerRadius(20)
                                                        .clipped()

                                                    Spacer()

                                                    Text(page.name)
                                                }
                                                .frame(height: 20)
                                                .padding(.top, 5)
                                                .onTapGesture {
                                                    withAnimation {
                                                        if !eventHostsIDs.contains(page.id) {
                                                            self.eventHostsIDs.append(page.id)
                                                            self.eventHosts.append(page)
                                                            self.pageTerm = ""
                                                            sessionService.searchPageResults = []
                                                            self.searchPadding = CGFloat((self.eventHosts.count) * 85)
                                                            if self.searchPadding > 340 {
                                                                self.searchPadding = 340
                                                            }
                                                        }
                                                    }
                                                }
                                                Divider()
                                            }
                                        }
                                    }
                                    .frame(height: 75)
                                }
                            }
                        }
                        
                        
                        VStack (alignment: .leading) {
                            Text("What categories fit this event best? (3 max)")
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
                                                            if !eventChosenCategories.contains(word) && eventChosenCategories.count < 3 {
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
                                                        
                                                        if eventChosenCategories.count >= 1 {
                                                            continueBool = true
                                                        }
                                                        else {
                                                            continueBool = false
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                        
                        NextButton(text: "Continue", isTriggered: $continueBool, signUpTab: $tab)
                            .padding(.bottom)
                        
                        
                    }
                    .padding(.horizontal)
                    .task {
                        await pageManager.getPageCategories()
                    }
                    .onAppear {
                        eventHosts.append(page)
                        eventHostsIDs.append(page.id)
                        searchPadding = 85
                    }
                    
                case 3:
                    VStack (alignment: .leading, spacing: 0) {
                        ScrollView {
                            
                            VStack (alignment: .leading) {
                                Text("Where is the event?")
                                    .foregroundColor(.white)
                                TextField("venue/address", text: $pageTerm)
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
                                .onChange(of: pageTerm) { newTerm in
                                    sessionService.searchVenueResults = []
                                    sessionService.searchVenues(term: pageTerm, option: 1)
                                    
                                    if newTerm.count < termlen {
                                        confirmed = false
                                        eventLocation = ""
                                        venueHolder = nil
                                    }
                                    
                                    termlen = newTerm.count
                                }
                                
                                if !confirmed {
                                    ScrollView (.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(sessionService.searchVenueResults, id: \.self) { venue in
                                                VenueTileView(ven: venue)
                                                    .highPriorityGesture(
                                                        TapGesture()
                                                            .onEnded {
                                                                venueHolder = venue
                                                                pageTerm = venue.displayname
                                                                confirmed = true
                                                                eventLocation = venue.address
                                                            }
                                                        )
                                                
                                            }
                                        }
                                    }
                                }
                            }
                            .ignoresSafeArea(.keyboard)
                            
                            VStack (alignment: .leading) {
                                Text("Select an event image")
                                    .foregroundColor(.white)
                                
                                HStack {
                                    Spacer()
                                    VStack {
                                            if let image = self.eventImage {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                            } else {
                                                Color.purple.opacity(0.4)
                                            }
                                        }
                                    .frame(width: UIScreen.main.bounds.size.width*0.85, height: 200, alignment: .center)
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            shouldShowImagePicker.toggle()
                                        }
                                    Spacer()
                                }
                                
                            }
                            .ignoresSafeArea(.keyboard)
                        
                            
                        }
                        
                        Spacer()
                        
                        VStack {
                            Button {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "dd-MM-yyyy"
                                let eventDateString = dateFormatter.string(from: eventDate)
                                
                                dateFormatter.dateFormat = "HH:mm"
                                let eventStartTimeString = dateFormatter.string(from: eventDate)
                                
                                var eventEndTimeString = ""
                                if showEndTime {
                                    eventEndTimeString = dateFormatter.string(from: eventEnd)
                                }
                                let hostNames = eventHosts.map { $0.name }
                                
                                //name x
                                //description x
                                //tags
                                //imageurl
                                //start time
                                //end time
                                //date
                                //address
                                //linkedVenueName
                                //linkedVenue
                                //hosts
                                
//                                print(eventLocation)
//                                print(pageTerm)
//                                print(eventHosts.joined(separator: ","))
                                
                                
                               if eventImage != nil {
                                    pageManager.createPageEvent(pageID: page.id, eventName: eventName, eventDescription: eventDescription, eventDate: eventDateString, eventStartTime: eventStartTimeString, eventEndTime: eventEndTimeString, address: eventLocation == "" ? pageTerm : eventLocation, eventTags: eventChosenCategories.joined(separator: ","), eventHostIds: eventHostsIDs.joined(separator: ","), eventHostNames: hostNames.joined(separator: ","), linkedVenue: venueHolder != nil ? venueHolder!.id : "", linkedVenueName: venueHolder != nil ? venueHolder!.displayname : "", ticketlink: "", image: eventImage!, completion:  {showCreateEvent = false})
                                }
                                
                                
                                
//                                pageManager.createPageEvent(pageID: page.id, eventName: eventName, eventDescription: eventDescription, eventLocation: eventLocation == "" ? pageTerm : eventLocation, eventDate: eventDateString, eventStart: eventStartTimeString, eventEnd: eventEndTimeString, eventTags: eventChosenCategories.joined(separator: ","), eventHosts: eventHostsIDs.joined(separator: ","), image: eventImage!, completion: {showCreateEvent = false})
                                
                            } label: {
                                VStack {
                                    Text(pageManager.creatingPageEvent ? "Creating" : "Create")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .frame(width: UIScreen.main.bounds.width*0.9, height: 55)
                                .background(eventImage != nil ? .purple.opacity(0.8) : .purple.opacity(0.3))
                                .cornerRadius(20)
                            }
                        }
                        .padding(.bottom)

                        
                    }
                    .padding(.horizontal)
                    .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: {
                        if eventImage != nil {
                            continueBool = true
                        }
                    }) {
                           ImagePicker(image: $eventImage)
                    }

                default:
                    Text("")
                }
            }
            .navigationTitle("Create your event")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
