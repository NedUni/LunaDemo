//
//  ViewModel.swift
//  Luna
//
//  Created by Will Polich on 2/2/2022.
//

import Foundation
import SwiftUI

struct VenueObj: Codable, Hashable, Identifiable {
    
    let id: String
    let displayname: String
    let abn: String
    let email: String
    let description: String
    let address: String
    let events: [EventObj]
    let filename: String
    let imageurl: String
    let deals: [DealObj]
    let favourites: [String]
    let longitude: Double
    let latitude: Double
    let hasPokerMachines: Bool
    let hasLiveMusic: Bool
    let hasDanceFloor: Bool
    let checkins: [String]
    let tags: [String]
    let averageTime: Int
    let stories: [String]
    let activeFiresale: String
    let firesales: [String]
    
}

struct DealObj: Codable, Hashable, Identifiable {
    var name: String
    let description: String
    let days: [String]
    let startDate: String
    let endDate: String
    let startTime: String
    let endTime: String
    let venue: String
    let id: String
    let isDrinkDeal: String
    let imageURL: String
    let venueName: String
}

struct GenEventObj {
    
}

struct EventObj: Codable, Hashable, Identifiable {
    
    let id: String
    let label: String
    let description: String
    let imageurl: String
    let tags: [String]
    let date: String
    let startTime: String
    let endTime: String
    let invited : [String]
    let going: [String]
    let interested: [String]
    let declined: [String]
    let hostIDs: [String]
    let hostNames : [String]
    let performers: [String]
    let address: String
    let linkedVenueName: String
    let linkedVenue: String
    let linkedEvent: String
    let userCreated: Bool
    let pageCreated: Bool
    let ticketLink: String
}

struct VenueImage: Codable, Hashable {
    let filename: String
    let imageurl: String
}

struct UserObj: Decodable, Hashable {
    let firstName: String
    let lastName: String
    let uid: String
    let imageURL: String
    let friends: [String]
    let favourites: [String]
    let streak : Int
    let performer: Bool
}

struct FavouritesResult: Decodable, Hashable {
    let error_msg: String
    let result: [VenueObj]
}

struct ForYouResult: Decodable, Hashable {
    let error_msg: String
    let result: [VenueObj]
    let status: String
}

struct ActiveCheckinResult: Decodable, Hashable {
    let error_msg: String
    let result: VenueObj
    let status: String
}

struct DiscoverResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: [EventObj]
}

struct SundaySeshResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: [VenueObj]
}

struct DealsResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: [DealObj]
}

struct VenueResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: [VenueObj]
}

struct PopularStoryVenueResult: Decodable, Hashable {
    let error_msg: String
    let result: [String]
    let status: String
}

//struct EventsResult : Decodable, Hashable {
//    let result: VenueObj
//}

class ViewModel : ObservableObject {
    
    
    @Published var friendsIn: [String] = []
    
    @Published var friendsPages: [PageObj] = []
    
    func getFriendsPages(uid: String)  {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/friends-pages?uid=\(uid == "" ? auth.currentUser!.uid : uid)") else {return}
        print(url)

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetSimilarPagesResult.self, from: data)
                if result.error_msg == "" {
                    DispatchQueue.main.async {
                        self.friendsPages = result.result
                    }
                } else {
                    print("Error getting friend's pages: \(result.error_msg)")
                }
                
                
            } catch {
                print("Error getting friend's pages: \(error)")
            }
        }
        
        task.resume()
        
    }
    
    @Published var hotVenues: [VenueObj] = []
    
    func fetchHotVenues(token : String)  {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/hotrightnow?token=\(token)") else {return}
        print(url)

   
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(ForYouResult.self, from: data)
                
                DispatchQueue.main.async {
                    self.hotVenues = result.result
                }
                
            } catch {
                
                print(error)
                
            }
        }
        
        task.resume()
        
    }
    
    @Published var topToday: [VenueObj] = []
    
    func fetchTopToday()  {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/top-today") else {return}

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(ForYouResult.self, from: data)
                
                DispatchQueue.main.async {
                    self.topToday = result.result
                }
                
            } catch {
                
                print(error)
                
            }
        }
        
        task.resume()
        
    }
    
    @Published var friendsEvents : [EventObj] = []
    func fetchFriendsEvents(uid: String, token : String)  {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/getfriendsevents?uid=\(uid == "" ? auth.currentUser!.uid : uid)&token=\(token)") else {return}

   
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(DiscoverResult.self, from: data)
                if result.error_msg == "" {
                    DispatchQueue.main.async {
                        self.friendsEvents = result.result
                    }
                } else {
                    print("Error fetching friend's events: \(result.error_msg)")
                }
                
            } catch {
                print("Error fetching friend's events: \(error)")
            }
        }
        
        task.resume()
        
    }
    
    @Published var topUpcomingEvents : [EventObj] = []
    func fetchTopUpcomingEvents()  {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/top-upcoming-events") else {return}

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(DiscoverResult.self, from: data)
                if result.error_msg == "" {
                    DispatchQueue.main.async {
                        self.topUpcomingEvents = result.result
                    }
                } else {
                    print("Error fetching top upcoming events: \(result.error_msg)")
                }
                
            } catch {
                print("Error fetching top upcoming events: \(error)")
            }
        }
        
        task.resume()
        
    }
    
    @Published var venues: [VenueObj] = []

    func fetch(token : String, completion: @escaping () -> ()) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/venues?token=\(token)")!
            
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(ForYouResult.self, from: data)
                
                DispatchQueue.main.async {
                    self.venues = result.result
                    completion()
                }
                
            } catch {
                
                print(error)
                
            }
        }
        
        task.resume()
        
    }
    
    @Published var forYou: [VenueObj] = []
    
    func getForYou(uid: String, token : String) {
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/foryou?id=\(uid == "" ? auth.currentUser!.uid : uid)&token=\(token)")) else {return}
        print("For you url: \(url)")
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(ForYouResult.self, from: data)
                
                DispatchQueue.main.async {
                    self.forYou = result.result
                }
                
            } catch {
                
                print("Failed to get for you result: \(error)")
                
            }
        }
        
        task.resume()
    }
    
    @Published var sundaySesh: [VenueObj] = []
    
    func getSundaySesh() {
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/sundaySesh")) else {return}
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(SundaySeshResult.self, from: data)
                
                DispatchQueue.main.async {
                    self.sundaySesh = result.result
                }
                
            } catch {
                
                print("sunday sesh \(error)")
                
            }
        }
        
        task.resume()
    }
    
    
    @Published var myEvents: [EventObj] = []
    @Published var gettingMyEvents : Bool = false
    
    func getMyEvents(uid: String, token : String) async {
        self.gettingMyEvents = true
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/myevents?id=\(uid == "" ? auth.currentUser!.uid : uid)&token=\(token)")) else {return}

        do {
            let (data, error) = try await URLSession.shared.data(from: url)
            
            if let results = try?JSONDecoder().decode([EventObj].self, from: data) {
                let sortedResults = results.sorted(by: {
                    ($0.date, $0.startTime) <
                       ($1.date, $1.startTime)

//                    $0.date.compare($1.date) == .orderedAscending
                })
                
                DispatchQueue.main.async {
                    self.myEvents = sortedResults
                }
                
                
                
            } else {
                print("Error getting my events: \(error)")
            }
        } catch {
            print("Error getting my events: \(error)")
        }
        
        DispatchQueue.main.async {
            self.gettingMyEvents = false
        }
        
        

    }
    
    @Published var myPastEvents: [EventObj] = []
    @Published var gettingMyPastEvents : Bool = false
    
    func getMyPastEvents(uid: String, token : String) async {
        self.gettingMyPastEvents = true
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/mypastevents?id=\(uid == "" ? auth.currentUser!.uid : uid)&token=\(token)")) else {return}
        print(url)

        do {

            let (data, error) = try await URLSession.shared.data(from: url)
            
            if let results = try?JSONDecoder().decode([EventObj].self, from: data) {
                let sortedResults = results.sorted(by: {
                    $0.date.compare($1.date) == .orderedAscending
                })
                
                DispatchQueue.main.async {
                    self.myPastEvents = sortedResults
                }
                
                
                
            } else {
                print("Error getting my past events: \(error)")
            }
        } catch {
            print("Error getting my past events: \(error)")
        }
        
        DispatchQueue.main.async {
            self.gettingMyPastEvents = false
        }
        
        

    }
    
    
    @Published var myFavourites: [VenueObj] = []
    
    func getFavourites(UID: String, token : String) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-favourites?id=\(UID == "" ? auth.currentUser!.uid : UID)&token=\(token)") else {return}
        print("favouritesURL: \(url)")
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(FavouritesResult.self, from: data)
                
                if result.error_msg != "" {
                    print("Error getting favourites: \(result.error_msg)")
                    return
                }
                DispatchQueue.main.async {
                    self.myFavourites = result.result
                }
                
            } catch {
                
                print("Error getting favourites: \(error)")
                
            }
        }
        
        task.resume()

    }
    
    @Published var nearYou : [VenueObj] = []
    
    func getNearYou(uid: String) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/near-you?uid=\(uid == "" ? auth.currentUser!.uid : uid)") else {return}

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(FavouritesResult.self, from: data)
                
                if result.error_msg != "" {
                    print("Error getting near you: \(result.error_msg)")
                    return
                }
                DispatchQueue.main.async {
                    self.nearYou = result.result
                }
                
            } catch {
                
                print("Error getting near you: \(error)")
                
            }
        }
        
        task.resume()

    }
    
    @Published var pubFeed: [VenueObj] = []
    
    func getPubFeed(uid: String) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/pub-feed?uid=\(uid == "" ? auth.currentUser!.uid : uid)") else {return}

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(FavouritesResult.self, from: data)
                
                if result.error_msg != "" {
                    print("Error getting pub feeds: \(result.error_msg)")
                    return
                }
                DispatchQueue.main.async {
                    self.pubFeed = result.result
                }
                
            } catch {
                
                print("Error getting pub feeds: \(error)")
                
            }
        }
        
        task.resume()

    }
    
    @Published var girlsNight: [VenueObj] = []
    
    func getGirlsNight(uid: String) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/girls-night?uid=\(uid == "" ? auth.currentUser!.uid : uid)") else {return}

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(FavouritesResult.self, from: data)
                
                if result.error_msg != "" {
                    print("Error getting girls night: \(result.error_msg)")
                    return
                }
                DispatchQueue.main.async {
                    self.girlsNight = result.result
                }
                
            } catch {
                
                print("Error getting girls night: \(error)")
                
            }
        }
        
        task.resume()

    }
    
    @Published var somethingDifferent: [VenueObj] = []
    
    func getSomethingDifferent(uid: String) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/something-different?uid=\(uid == "" ? auth.currentUser!.uid : uid)") else {return}

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(FavouritesResult.self, from: data)
                
                if result.error_msg != "" {
                    print("Error getting something different: \(result.error_msg)")
                    return
                }
                DispatchQueue.main.async {
                    self.somethingDifferent = result.result
                }
                
            } catch {
                
                print("Error getting something different: \(error)")
                
            }
        }
        
        task.resume()

    }
    
    @Published var todaysDeals: [DealObj] = []
    
    func getTodaysDeals(uid: String, token: String) {
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-home-page-deals?id=\(uid == "" ? auth.currentUser!.uid : uid)&token=\(token)")) else {return}
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(DealsResult.self, from: data)
                if result.error_msg != "" {
                    print("Error getting today's deals: \(result.error_msg)")
                    return
                }
                DispatchQueue.main.async {
                    self.todaysDeals = result.result
                }
            } catch {
                print("Error getting today's deals: \(error)")
                return
            }
        }
        task.resume()
    }
    
    
    
    func updateAllWaitTimes() async {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/update-all-wait-times") else {return}
        do {

            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let result = try?JSONDecoder().decode(GenericGetResult.self, from: data) {
                if result.error_msg == "" {
                    print("succesfully updated all wait times")
                } else {
                    print("Failed to update wait times: \(result.error_msg)")
                }
               
            }
           
        } catch {
            print("Error updating wait times : \(error)")
        }
        

    }
    
    
    
//    @Published var imageDict = [String : UIImage]()
    
    //DO NOT DELETE
//    func getImagesFromURL() {
//        var dict = [String : UIImage]()
//        for ven in venues {
//            let Ref = Storage.storage().reference(forURL: ven.imageurl)
//            print(Ref)
//            Ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
//                if error != nil {
//                    print("Error: Image could not download!")
////                    print(error)
//                } else {
//                    let image = UIImage(data: data!)
//                    print("made image : \(image)")
//                    dict[ven.displayname] = image
//                    print(dict[ven.displayname])
//                }
//            }
//        }
//        print("at end : \(dict)")
//        DispatchQueue.main.async {
//            self.imageDict = dict
//        }
//
//    }
    func getFriendsCheckedIn(friends : [String], checkins: [String]) -> Bool {
        
        friendsIn = []
        for friend in friends {
            if checkins.contains(friend) {
                friendsIn.append(friend)
            }
        }
        
        if friendsIn.count == 0 {
            return false
        }
        else {
            return true
        }
    }
    
    @Published var eventsToday : [EventObj] = []
    @Published var gettingEventsToday = false
    
    func getEventsToday(token : String) async {
        self.gettingEventsToday = true
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/discoverevents?option=1&token=\(token)")) else {return}
        print(url)

        do {

            let (data, error) = try await URLSession.shared.data(from: url)
            
            if let results = try?JSONDecoder().decode(DiscoverResult.self, from: data) {
                let events = results.result
                let sortedResults = events.sorted(by: {
                    ($0.date, $0.startTime) <
                       ($1.date, $1.startTime)
                    
//                    $0.date.compare($1.date) == .orderedAscending
                })
                
                DispatchQueue.main.async {
                    self.eventsToday = sortedResults
                }
                
                
                
            } else {
                print("Error getting discover today events: \(error)")
            }
        } catch {
            print("Error getting discover today events: \(error)")
        }
        
        DispatchQueue.main.async {
            self.gettingEventsToday = false
        }
        
        

    }
    
    @Published var eventsWeek : [EventObj] = []
    @Published var gettingEventsWeek = false
    
    func getEventsWeek(token : String) async {
        self.gettingEventsWeek = true
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/discoverevents?option=2&token=\(token)")) else {return}
        print(url)

        do {

            let (data, error) = try await URLSession.shared.data(from: url)
            
            if let results = try?JSONDecoder().decode(DiscoverResult.self, from: data) {
                let events = results.result
                let sortedResults = events.sorted(by: {
                    ($0.date, $0.startTime) <
                       ($1.date, $1.startTime)
                    
//                    $0.date.compare($1.date) == .orderedAscending
                })
                
                DispatchQueue.main.async {
                    self.eventsWeek = sortedResults
                }
                
                
                
            } else {
                print("Error getting discover week events: \(error)")
            }
        } catch {
            print("Error getting discover week events: \(error)")
        }
        
        DispatchQueue.main.async {
            self.gettingEventsWeek = false
        }
        
        

    }
    
    
    @Published var eventsMonth : [EventObj] = []
    @Published var gettingEventsMonth = false
    
    func getEventsMonth(token : String) async {
        self.gettingEventsMonth = true
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/discoverevents?option=3&token=\(token)")) else {return}
        print(url)

        do {

            let (data, error) = try await URLSession.shared.data(from: url)
            
            if let results = try?JSONDecoder().decode(DiscoverResult.self, from: data) {
                let events = results.result
                let sortedResults = events.sorted(by: {
                    ($0.date, $0.startTime) <
                       ($1.date, $1.startTime)
                    
//                    $0.date.compare($1.date) == .orderedAscending
                })
                
                DispatchQueue.main.async {
                    self.eventsMonth = sortedResults
                }
                
                
                
            } else {
                print("Error getting discover month events: \(error)")
            }
        } catch {
            print("Error getting discover month events: \(error)")
        }
        
        DispatchQueue.main.async {
            self.gettingEventsMonth = false
        }
        
        

    }
    
    @Published var recentlyPopularVenues: [VenueObj] = []
    
    func getRecentlyPopularVenues() {
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/popular-recently")) else {return}
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(VenueResult.self, from: data)
                if result.error_msg != "" {
                    print("Error getting popular recently: \(result.error_msg)")
                    return
                }
                DispatchQueue.main.async {
                    self.recentlyPopularVenues = result.result
                }
            } catch {
                print("Error getting popular recently: \(error)")
                return
            }
        }
        task.resume()
    }
    
    @Published var popularLastNight: [VenueObj] = []
    
    func getPopularLastNight() {
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/last-night")) else {return}
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(VenueResult.self, from: data)
                if result.error_msg != "" {
                    print("Error getting popular last night: \(result.error_msg)")
                    return
                }
                DispatchQueue.main.async {
                    self.popularLastNight = result.result
                }
            } catch {
                print("Error getting popular last night: \(error)")
                return
            }
        }
        task.resume()
    }
    
    @Published var popularLastWeek: [VenueObj] = []
    
    func getPopularLastWeek() {
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/popular-week-ago")) else {return}
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(VenueResult.self, from: data)
                if result.error_msg != "" {
                    print("Error getting popular last week: \(result.error_msg)")
                    return
                }
                DispatchQueue.main.async {
                    self.popularLastWeek = result.result
                }
            } catch {
                print("Error getting popular last week: \(error)")
                return
            }
        }
        task.resume()
    }
    
    @Published var pageCategories: [String] = []
    
    func getPageCategories() async {
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-categories")) else {return}
        
        print("Getting similar pages URL: \(url)")

        do {

            let (data, error) = try await URLSession.shared.data(from: url)
            
            if let results = try?JSONDecoder().decode(GetPageCategoriesResult.self, from: data) {
                
                DispatchQueue.main.async {
                    self.pageCategories = results.result
                }
                
            } else {
                print("Error getting similar pages URL: \(error)")
            }
        } catch {
            print("Error getting similar pages URL: \(error)")
        }
    }
    
    @Published var friendsFavourites: [VenueObj] = []
    
    func getFriendsFavourites(uid: String) {
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/friends-favourites?uid=\(uid == "" ? auth.currentUser!.uid : uid)")) else {return}

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(VenueResult.self, from: data)
                if result.error_msg != "" {
                    print("Error getting friends favourites: \(result.error_msg)")
                    return
                }
                DispatchQueue.main.async {
                    self.friendsFavourites = result.result
                }
            } catch {
                print("Error getting friends favourites: \(error)")
                return
            }
        }
        task.resume()
    }
    
    @Published var popularStoryVenues: [String] = []
    
    func getPopularStoryVenues() {
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-stories")) else {return}
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(PopularStoryVenueResult.self, from: data)
                if result.error_msg != "" {
                    print("Error getting popular stories: \(result.error_msg)")
                    return
                }
                DispatchQueue.main.async {
                    self.popularStoryVenues = result.result
                }
            } catch {
                print("Error getting popular stories: \(error)")
                return
            }
        }
        task.resume()
    }
    
    @Published var drinkControl : Bool = false
    
    func checkDrinkControl() {
        
        let docRef = db.collection("admin").document("admin")

        docRef.getDocument { result, error in
            if let error = error {
                print("Error getting user document for location update: \(error)")
                return
            }
            else {
                if (result?["drinkControl"] ?? 0) as! Int == 1 {
                    self.drinkControl = true
                }
                else {
                    self.drinkControl = false
                }
            }
        }
    }
    
    @Published var venueFreeDrinks: [VenueObj] = []
    
    func getVenueFreeDrinks() {
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-free-drink-venues")) else {return}
        print("For you url: \(url)")
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(ForYouResult.self, from: data)
                
                DispatchQueue.main.async {
                    self.venueFreeDrinks = result.result
                }
                
            } catch {
                
                print("Failed to get venue free drinks: \(error)")
                
            }
        }
        
        task.resume()
    }
    

}
