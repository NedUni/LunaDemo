//
//  UpdatePageEventView.swift
//  Luna
//
//  Created by Will Polich on 3/5/2022.
//

import SwiftUI
import Foundation
import SDWebImageSwiftUI

struct UpdatePageEventView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var pageManager : PageHandler
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var manager : LocationManager
    
    @State var showAlert = false
    @State var alertText = ""
    @State var shouldShowImagePicker = false
    @State var showEndTime = false
    @Binding var showUpdate : Bool
    @Binding var event : EventObj
    
    
    @FocusState private var isFocused : Bool
    
    @State var eventHosts : [PageObj] = []
    @State var hostIds : [String] = []
    
    @State var confirmed : Bool = true
    @State var eventLocation : String = ""
    @State var venueHolder : VenueObj?
    @State var termlen = 0
    @State var placeholderText = ""
    @State var name = ""
    @State var description = ""
    @State var address = ""
    @State var pageTerm = ""
    @State var dateString = ""
    @State var startDate = Date()
    @State var coHosts = ""
    @State var searchPadding: CGFloat = 0
    @State var endTime = Date()
    @State var tags : [String] = []
//    @State var hosts : [String] = []
    @State var image : UIImage?
    
    var body: some View {
        NavigationView {
            VStack (spacing: 10){
                if pageManager.updatingPageEvent {
                    ProgressView()
                }
                ScrollView {
                    VStack (alignment: .leading) {
                        HStack {
                            Text("Name")
                            Spacer()
                        }
    
                        TextField("Event Name", text: $name)
                            .padding(10)
                            .focused($isFocused)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5,
                                                     style: .continuous)
                                        .stroke(isFocused ? Color.purple : Color.gray.opacity(0.5))
                                }
                            )
                        
                        Text("Description")
                        
                        ZStack {
                            TextEditor(text: $description)
                                .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 200)
                                .padding(.trailing)
//                                .padding(.leading, 12)
                                .padding(.top, 6)
                                .foregroundColor(Color.primary)
                            
                            if description == "" {
                                HStack {
                                    Text("Description")
                                        .foregroundColor(Color.gray.opacity(0.5))
//                                        .padding(.leading)
                                        .padding(.trailing)
                                    Spacer()
                                }

                                    
                            }
                        }
                        
                        Text("Location")
                           
                        TextField("Location", text: $pageTerm)
                            .padding(10)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5,
                                                     style: .continuous)
                                        .stroke(isFocused ? Color.purple : Color.gray.opacity(0.5))
                                }
                            )
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
                        
                        
                    Text("Date")
                        .foregroundColor(.white)
                    
                    VStack {
                        DatePicker("", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                            .frame(width: UIScreen.main.bounds.size.width*0.85)
//                            .onChange(of: startDate) { newValue in
//                                if newValue > Date.now {
////                                    error = false
//                                    endTime = newValue.addingTimeInterval(180)
//                                }
//                                else {
////                                    continueBool = false
////                                    error = true
//                                }
//                            }
                        
                        Text("End time ↓")
                            .onTapGesture {
                                withAnimation {
                                    showEndTime.toggle()
                                }
                            }
                        
                        if showEndTime {
                            DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                        }
                       

                    }
                    
                    
                    Text("Do you have any co-hosts?")
                        .foregroundColor(.white)
                    TextField("Co-Hosts", text: $coHosts)
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
                                                if let index = eventHosts.firstIndex(of: page) {
                                                    eventHosts.remove(at: index)
                                                    self.searchPadding = CGFloat((self.eventHosts.count) * 85)
                                                }

                                                if let index = hostIds.firstIndex(of: page.id) {
                                                    hostIds.remove(at: index)
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
                    .onChange(of: coHosts) { newTerm in
                        sessionService.searchPageResults = []
                        sessionService.searchVenues(term: coHosts, option: 3)
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
                                                self.hostIds.append(page.id)
                                                self.eventHosts.append(page)
                                                self.coHosts = ""
                                                sessionService.searchPageResults = []
                                                self.searchPadding = CGFloat((self.eventHosts.count) * 85)
                                                if self.searchPadding > 340 {
                                                    self.searchPadding = 340
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
                    
                    Text("Categories? (3 max)")
                        .foregroundColor(.white)
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            let tagsView = TagsView(items: pageManager.pageCategories)
                            ForEach(tagsView.groupedItems, id: \.self) { subItems in
                                HStack {
                                    ForEach(subItems, id: \.self) { word in
                                        Text(word)
                                            .fixedSize()
                                            .padding()
                                            .background(tags.contains(word) ? .purple : .purple.opacity(0.4))
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                            .onTapGesture {
                                                withAnimation {
                                                    if !tags.contains(word) && tags.count < 3 {
                                                        tags.append(word)
                                                    }
                                                    else {
                                                        withAnimation {
                                                            if let index = tags.firstIndex(of: word) {
                                                                tags.remove(at: index)
                                                            }
                                                        }
                                                    }
                                                }
                                                
//                                                if tags.count >= 1 {
//                                                    continueBool = true
//                                                }
//                                                else {
//                                                    continueBool = false
//                                                }
                                            }
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack (alignment: .leading) {
                        Text("Image")
                            .foregroundColor(.white)
                        
                        HStack {
                            Spacer()
                            VStack {
                                    if let image = image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                    } else if event.imageurl != "" {
                                        WebImage(url: URL(string: event.imageurl))
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
                .opacity(pageManager.updatingPageEvent ? 0.5 : 1)
        
                
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"),
                      message: Text(alertText),
                      dismissButton: .default(Text("Ok")) {
                    alertText = ""
                })
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showUpdate.toggle()
                    } label: {
                        Text("Cancel")
                    }
                    

                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                        if startDate < Date() {
                            alertText = "Event date cannot be in the past."
                            showAlert.toggle()
                            return
                        }
//                        else if {
//                            
//                        }
                        
//                        if canUpdate {
                        
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yyyy"
                            let eventDateString = dateFormatter.string(from: startDate)
                            
                            dateFormatter.dateFormat = "HH:mm"
                            let eventStartTimeString = dateFormatter.string(from: startDate)
                            
                            var eventEndTimeString = ""
                            if showEndTime {
                                eventEndTimeString = dateFormatter.string(from: endTime)
                            }
                        
                        let hostNames = eventHosts.map {$0.name}
                            
//                        print(hostNames)
//                        print(hostIds.joined(separator: ","))
//                        print("linked venue")
//                        print(venueHolder != nil ? venueHolder!.id : "")
//                        print("linked venue name")
//                        print(venueHolder != nil ? venueHolder!.displayname : "")
//                        print("address")
//                        print(eventLocation == "" ? pageTerm : eventLocation)
//                        print
//                        print()
//                        print(venueHolder)
                        print(pageTerm)
                        print(eventLocation)
//                        print(venueHolder)
                        
                        
                        
                        pageManager.updatePageEvent(eventID: event.id, pageID: "", eventName: self.name, eventDescription: self.description, eventDate: eventDateString, eventStartTime: eventStartTimeString, eventEndTime: eventEndTimeString, address: venueHolder != nil ? venueHolder!.address : pageTerm, eventTags: tags.joined(separator: ","), eventHostIds: hostIds.joined(separator: ","), eventHostNames: hostNames.joined(separator: ","), linkedVenue: venueHolder != nil ? venueHolder!.id : "", linkedVenueName: venueHolder != nil ? venueHolder!.displayname : "", ticketlink: "", image: image) {
                            sessionService.getEventByID(id: event.id) { event in
                                if event != nil {
                                    self.event = event!
                                }
                                showUpdate.toggle()
                            }
                        }
                        
//                            pageManager.updatePageEvent(eventID: event.id, pageID: "", eventName: self.name, eventDescription: self.description, eventLocation: self.location, eventDate: eventDateString, eventStart: eventStartTimeString, eventEnd: eventEndTimeString, eventTags: tags.joined(separator: ","), eventHosts: hostIds.joined(separator: ","), image: image) {
//                                sessionService.getEventByID(id: event.id) { event in
//                                    if event != nil {
//                                        self.event = event!
//                                    }
//                                    showUpdate.toggle()
//                                }
//
//                            }
//                        } else {
//
//                        }
                        
                    } label: {
                        Text("Update")
//                            .foregroundColor(Color.purple.opacity(canUpdate ? 1 : 0.3))
                    }
                }
            }
            .navigationBarTitle("Update Event", displayMode: .inline)
            .padding(.horizontal)
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker) {
               ImagePicker(image: $image)
        }
        .task {
            await pageManager.getPageCategories()
        }
        .onAppear {
            self.name = event.label
            self.description = event.description
            
            if event.linkedVenueName != "" {
                self.pageTerm = event.linkedVenueName
            }
            else {
                self.pageTerm = event.address
            }
            
//            self.eventHosts = event.
            
//            self.location = event.address
            pageManager.getHosts(eventID: event.id, completion: {self.eventHosts = pageManager.hosts
                print("here \(self.eventHosts)")
            })
            
            sessionService.getVenueByID(id: event.linkedVenue) { venue in
                self.venueHolder = venue
            }
            
            self.dateString = event.date
            let dateFormatter = DateFormatter()
            let calendar = Calendar.current
            dateFormatter.dateFormat = "dd-MM-yyyy"
            self.startDate = dateFormatter.date(from: event.date) ?? Date()
            self.endTime = dateFormatter.date(from: event.date) ?? Date()
            dateFormatter.dateFormat = "HH:mm"
//            dateFormatter.dateFormat = "HH:mm"
            self.startDate = calendar.date(byAdding: .minute, value: calendar.component(.minute, from: dateFormatter.date(from: event.startTime)!), to: startDate)!
//            dateFormatter.dateFormat = "HH"
            self.startDate = calendar.date(byAdding: .hour, value: calendar.component(.hour, from: dateFormatter.date(from: event.startTime)!), to: startDate)!
            
            print(self.startDate)
//            dateFormatter.dateFormat = "HH:mm"
            if event.endTime != "" {
                self.endTime = dateFormatter.date(from: event.endTime)!
                showEndTime = true
            }

            self.tags = event.tags
            self.hostIds = event.hostIDs
            self.searchPadding = CGFloat((self.eventHosts.count) * 85)
            
        }
    }
}
