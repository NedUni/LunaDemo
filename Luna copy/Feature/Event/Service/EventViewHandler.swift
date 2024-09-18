//
//  EventViewHandler.swift
//  Luna
//
//  Created by Will Polich on 13/2/2022.
//

import Foundation

struct GetVenueResult: Decodable, Hashable {
    let error_msg : String
    let result: VenueObj
}

struct GetHostsResults: Decodable, Hashable {
    let error_msg : String
    let result: [PageObj]
    let status: String
}

struct GetResponseResult: Decodable, Hashable {
    let error_msg : String
    let result: String
    let status: String
}

struct GetPerformerResult: Decodable, Hashable {
    let result : [UserObj]
    let error_msg : String
}


class EventViewHandler: ObservableObject {
    
    @Published var eventResponse = "none"
    @Published var gettingResponse = false
    
    func getEventResponse(uid: String, eventID: String) {
        DispatchQueue.main.async {
            self.gettingResponse = true
        }
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-event-response?uid=\(uid)&event=\(eventID)") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetResponseResult.self, from: data)
                if result.error_msg == "" {
                    let response = result.result
                    print(response)
                    if self.eventResponse != response {
                        DispatchQueue.main.async {
                            self.eventResponse = response
                        }
                    }
                } else {
                    print(result.error_msg)
                }
            } catch {
                print(error)
            }
            
            DispatchQueue.main.async {
                self.gettingResponse = false
            }
        }
        
        
        
        task.resume()
        
    }
    
    func deleteEvent(id: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/delete-page-event?id=\(id)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetResponseResult.self, from: data)
                if result.error_msg == "" {
                    print("Successfully deleted event.")
                
                } else {
                    print("Failed to delete event: \(result.error_msg)")
                }
            } catch {
                print("Failed to delete event: \(error)")
            }
            
            completion()
        }
        
        task.resume()
    }
    
    func changeEventResponse(uid: String, eventID: String, response: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/change-event-response?uid=\(uid)&event=\(eventID)&response=\(response)") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetResponseResult.self, from: data)
                if result.error_msg == "" {
                    print("Changed event response successfully.")
                
                } else {
                    print("Failed to change event response: \(result.error_msg)")
                }
            } catch {
                print("Failed to change event response: \(error)")
            }
            
            completion()
        }
        
        task.resume()
    }
    
    @Published var interestedFriends: [UserObj] = []
    
    func getInterestedFriends(uid: String, eventID: String, token: String) {
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-friends-interested?uid=\(uid)&event=\(eventID)&token=\(token)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetFriendsInterested.self, from: data)
                if result.error_msg == "" {
                    let friends = result.result
                    print("Got friends intersted in event \(eventID)")
                    
                    DispatchQueue.main.async {
                        self.interestedFriends = friends
                    }
                } else {
                    print("Failed to get friend interest in event \(eventID)")
                }
            } catch {
                print("Failed to get friend interest in event \(error)")
            }
        }
        
        task.resume()
        
    }
    
    @Published var goingFriends: [UserObj] = []
    
    func getGoingFriends(uid: String, eventID: String, token: String) {
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-friends-going?uid=\(uid)&event=\(eventID)&token=\(token)") else { return }
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetFriendsInterested.self, from: data)
                if result.error_msg == "" {
                    let friends = result.result
                    print("Got friends going to event \(eventID)")
                    
                    DispatchQueue.main.async {
                        self.goingFriends = friends
                        
                    }
                } else {
                    print("Failed to get friends going to event \(eventID)")
                }
            } catch {
                print("Failed to get friends going to event \(error)")
            }
        }
        
        task.resume()
        
    }
    
    @Published var performers: [UserObj] = []
    
    func getPerformers(eventID: String) {
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/getPerformers?eventID=\(eventID)")
            else { return }
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetPerformerResult.self, from: data)
               
                if result.error_msg == "" {
                    let performers = result.result
                    print("Got performers \(eventID)")
                    
                    DispatchQueue.main.async {
                        self.performers = performers
//                        print(self.performers)
                    }
                } else {
                    print("Failed to get performer in event \(eventID)")
                }
            } catch {
                print("Failed to get performer in event \(error)")
            }
        }
        
        task.resume()
        
    }
    
    
    
    
    @Published var venue : VenueObj?
    
    func getVenue(venue: String, token: String, completion: @escaping () -> ()) {

        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-venue?venue=\(venue)&token=\(token)") else {
            print("Failed to build getVenue URL")
            completion()
            return
            
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Failed to get data from server")
                
                return
                
            }
            
            if let error = error {
                print("Failed to get venue from event: \(error)")
        
                return
            }
            
            do {
                let result = try JSONDecoder().decode(GetVenueResult.self, from: data)
                print("result : \(result)")
                if result.error_msg == "" {
                    let venue = result.result
                    print("Got venue from event : \(venue)")
                    if self.venue == nil {
                        DispatchQueue.main.async {
                            self.venue = venue
                        }
                    }
                    completion()
                } else {
                    print("Failed to get venue: \(result.error_msg)")
                }
    
            } catch {
                print(error)
            }
            
        }
        
        task.resume()
            
            
        
    }
    
    @Published var hosts : [PageObj] = []
    
    func getHosts(eventID : String) {

        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-hosts?eventID=\(eventID)") else {
            print("Failed to build get hosts URL")
            return
            
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Failed to get data from server")
                
                return
            }
            
            if let error = error {
                print("Failed to get hosts from event: \(error)")
        
                return
            }
            
            do {
                let result = try JSONDecoder().decode(GetHostsResults.self, from: data)
                print("result : \(result)")
                if result.error_msg == "" {
                    if self.hosts != result.result {
                        DispatchQueue.main.async {
                            self.hosts = result.result
                            print("got hosts")
                        }
                    }
                    
                } else {
                    print("Failed to get hosts: \(result.error_msg)")
                }
    
            } catch {
                print(error)
            }
            
        }
        
        task.resume()
            
            
        
    }
    
    func editPerformers(eventID: String, performers: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/addPerformers?eventID=\(eventID)&performers=\(performers)") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetResponseResult.self, from: data)
                if result.error_msg == "" {
                    print("Changed performers successfully successfully.")
                
                } else {
                    print("Failed to change performers: \(result.error_msg)")
                }
            } catch {
                print("Failed to change performers: \(error)")
            }
            
            completion()
        }
        
        task.resume()
    }

    
    
    
}
