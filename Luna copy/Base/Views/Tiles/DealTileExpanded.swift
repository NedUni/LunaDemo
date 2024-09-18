//
//  DealTileExpanded.swift
//  Luna
//
//  Created by Ned O'Rourke on 8/4/22.
//

import SwiftUI
import SDWebImageSwiftUI

class DealTileService : ObservableObject {
    
    @Published var venue : VenueObj?
    
    func getVenue(venue: String, token: String, completion: @escaping (_ venue: VenueObj?) -> ()) {

        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-venue?venue=\(venue)&token=\(token)") else {
            print("Failed to build getVenue URL")
            completion(nil)
            return
            
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Failed to get data from server")
                completion(nil)
                return
                
            }
            
            if let error = error {
                print("Failed to get venue from event: \(error)")
                completion(nil)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(GetVenueResult.self, from: data)
                print("result : \(result)")
                if result.error_msg == "" {
                    let venue = result.result
                    print("Got venue from event : \(venue)")
                    
                    DispatchQueue.main.async {
                        self.venue = venue
                    }
                    completion(venue)
                } else {
                    print("Failed to get venue: \(result.error_msg)")
                }
    
            } catch {
                print(error)
            }
            
            
            
            
           
            
        }
        
        task.resume()
            
            
        
    }
}

struct DealTileExpanded: View {
    
    @StateObject var service = DealTileService()
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    @Environment(\.colorScheme) var colorScheme
    
    let df = DateFormatter()
    let calendar = Calendar.current
        
    let deal : DealObj
    @State var venue: VenueObj?
    @Binding var dealIsPresented: Bool
    
    
    @State var date = ""
    
    var body: some View {
        
//        ZStack (alignment: .topLeading) {
//
//
//            VStack (alignment: .leading) {
//                ZStack (alignment: .bottomTrailing) {
//                    WebImage(url: URL(string: deal.imageURL))
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 290, height: 150)
//                            .clipped()
//                            .cornerRadius(10)
//                    }
////                Spacer()
//
//                    HStack {
//                        Text("@ \(deal.venueName)")
//
//                    }
//                    .font(.system(size: 15))
//                    .padding(.leading, 5)
//                    .padding(.trailing, 3)
//                    .padding(.vertical, 5)
//                    .background(Color("darkForeground").opacity(0.8))
//                    .cornerRadius(40)
//                    .offset(x: -10, y: -6)
//                }
//
//                VStack (alignment: .leading) {
//                    Text("\(deal.name)")
//                        .font(.system(size: 20))
//                        .fontWeight(.bold)
//
//
//
//                    Text(deal.days.count == 7 ? "Everyday" : "On \(deal.days.joined(separator: ", "))")
//                        .font(.system(size: 15))
//                        .foregroundColor(.purple)
//                        .fontWeight(.medium)
//                        .multilineTextAlignment(.leading)
//
//
//                    if deal.startTime != "" && deal.endTime != "" {
//                        Text("From \(deal.startTime) till \(deal.endTime)")
//                            .font(.system(size: 12))
//                            .foregroundColor(.purple)
//                            .fontWeight(.medium)
//                            .multilineTextAlignment(.leading)
//                    }
//
//                    Text("\(deal.description)")
//                        .multilineTextAlignment(.leading)
//
//
//
//                    Spacer()
//                    HStack {
//
//                        Spacer()
//
//                        if deal.endDate != "" {
//                            Text("Until \(self.date)")
//                                .font(.system(size: 10))
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                    .padding(.trailing)
//
//                }
//                .padding(.leading)
//
//                Spacer()
//            }
        ZStack (alignment: .topTrailing) {
            ZStack (alignment: .trailing) {
                VStack (alignment: .leading, spacing: 0) {
                    WebImage(url: URL(string: deal.imageURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 275, height: 150)
                        .clipped()
                    
                    VStack (alignment: .leading) {
                        Text("\(deal.name)")
                            .font(.system(size: 20))
                            .fontWeight(.bold)



                        Text(deal.days.count == 7 ? "Everyday" : "On \(deal.days.joined(separator: ", "))")
                            .font(.system(size: 15))
                            .foregroundColor(.purple)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.leading)


                        if deal.startTime != "" && deal.endTime != "" {
                            Text("From \(deal.startTime) till \(deal.endTime)")
                                .font(.system(size: 12))
                                .foregroundColor(.purple)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.leading)
                        }

                        Text("\(deal.description)")
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal)
                    .frame(width: 275, height: 175, alignment: .topLeading)
                }
                
                HStack {
                    Text("@ \(deal.venueName)")
                }
                .font(.system(size: 15))
                .padding(.leading, 5)
                .padding(.trailing, 3)
                .padding(.vertical, 5)
                .background(Color("darkForeground").opacity(0.8))
                .cornerRadius(40)
                .offset(x: -10, y: -35)
                
            }
            .frame(width: 275, height: 325, alignment: .topLeading)
            .background(Color("darkForeground").opacity(0.8))
            .cornerRadius(30)
            
            Button(action: {dealIsPresented = false}, label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30).cornerRadius(120)
                    .background(colorScheme == .dark ? Color.black : Color.white).cornerRadius(120)
                    .offset(x: 6, y: -6)

            })
        }
//            .overlay(
//                    RoundedRectangle(cornerRadius: 30)
//                        .strokeBorder(Color.black, lineWidth: 0.5)
//
////                    Button(action: {dealIsPresented = false}, label: {
////                        Image(systemName: "xmark.circle.fill")
////                            .resizable()
////                            .scaledToFill()
////                            .frame(width: 30, height: 30).cornerRadius(120)
////                            .background(colorScheme == .dark ? Color.black : Color.white).cornerRadius(120)
////                            .offset(x: 6, y: -6)
////
////                    })
//
//            )

            .onAppear {
                service.getVenue(venue: deal.venue, token: sessionService.token, completion: {venue in})
                dateFormatter.dateFormat = "dd-MM-yyyy"
                guard let dateObj = dateFormatter.date(from: deal.endDate) else {return}

                
                if calendar.isDateInToday(dateObj) {
                    self.date = "Today"
                } else if calendar.isDateInTomorrow(dateObj) {
                    self.date = "Tomorrow"

                } else if calendar.isDateInThisWeek(dateObj) {

                    dateFormatter.dateFormat = "EEEE"
                    let dayOfTheWeekString = dateFormatter.string(from: dateObj)
                    self.date = dayOfTheWeekString
                }
                
                else {
                    let weekdays = [
                                "Sun",
                                "Mon",
                                "Tues",
                                "Wed",
                                "Thurs",
                                "Fri",
                                "Sat"
                            ]
                    let weekDay = calendar.component(.weekday, from: dateObj)
                    let day = calendar.component(.day, from: dateObj)
                    let month = calendar.component(.month, from: dateObj)
                    self.date = weekdays[weekDay - 1] + " \(day)/\(month)"
                }
            }
            
//            Button(action: {dealIsPresented = false}, label: {
//                Image(systemName: "xmark.circle.fill")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 30, height: 30).cornerRadius(120)
//                    .background(colorScheme == .dark ? Color.black : Color.white).cornerRadius(120)
//                    .offset(x: 6, y: -6)
//
//            })

        }
        
        
    }
        
        
    


