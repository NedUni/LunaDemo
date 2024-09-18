//
//  UserProfileService.swift
//  Luna
//
//  Created by Will Polich on 11/2/2022.
//

import SwiftUI

struct GetMutualsResult : Decodable, Hashable {
    let status : String
    let error_msg : String
    let result : [UserObj]
}

struct GetRelationshipResult : Decodable, Hashable {
    let status : String
    let error_msg : String
    let result : String
}

struct GetLinksResult : Decodable, Hashable {
    let status : String
    let error_msg : String
    let result : [String]
}

class UserProfileService: ObservableObject {
    
    @Published var favourites : [VenueObj] = []
    func getUserFavourites(id: String, token: String) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-favourites?id=\(id)&token=\(token)") else {return}
        
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            guard let data = data else { return }
            print("Got data: \(data)")
            print(String(data: data, encoding: .utf8)!)
            
            do {
                let results = try JSONDecoder().decode(FavouritesResult.self, from: data)
                if results.error_msg == "" {
                    if results.result != self?.favourites {
                        DispatchQueue.main.async {
                            self?.favourites = results.result
                        }
                    }
                    
                } else {
                    print("Failed to get favourites: \(results.error_msg)")
                }
                
            } catch {
                print(error)
            }
        }

        task.resume()
    }
    
    
    @Published var mutualFriends : [UserObj] = []
    
    func getProfileMutualFriends(uid: String, target: String) {
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-profile-mutuals?uid=\(uid)&target=\(target)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetMutualsResult.self, from: data)
                if result.error_msg == "" {
                    let mutuals = result.result
                    if self.mutualFriends != mutuals {
                        DispatchQueue.main.async {
                            self.mutualFriends = mutuals
                        }
                    }
                    
                } else {
                    print("Failed to fetch mutual friends for uid \(uid) & target \(target): \(result.error_msg)")
                    
                }
            } catch {
                print("Failed to fetch mutual friends for uid \(uid) & target \(target): \(error)")
                
            }
        }
        
        task.resume()
            
        
            
    }
    
    @Published var relationshipStatus : String?
    
    func getRelationshipStatus(uid: String, target: String) {
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-relationship-status?uid=\(uid)&target=\(target)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetRelationshipResult.self, from: data)
                if result.error_msg == "" {
                    let status = result.result
                    if status != self.relationshipStatus {
                        DispatchQueue.main.async {
                            self.relationshipStatus = status
                        }
                    }
                    
                } else {
                    print("Failed to fetch relationship status for uid \(uid) & target \(target): \(result.error_msg)")
                    
                }
            } catch {
                print("Failed to fetch relationship status for uid \(uid) & target \(target): \(error)")
                
            }
        }
        
        task.resume()
            
        
            
    }
    
    @Published var interestedEvents : [EventObj] = []
    
    func getInterestedEvents(uid: String, token: String) async {
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/profile-events?id=\(uid)&token=\(token)")) else {return}

        do {

            let (data, error) = try await URLSession.shared.data(from: url)
            
            if let results = try?JSONDecoder().decode([EventObj].self, from: data) {
                let sortedResults = results.sorted(by: {
                    ($0.date, $0.startTime) <
                       ($1.date, $1.startTime)
                })
                
                if self.interestedEvents != sortedResults {
                    DispatchQueue.main.async {
                        self.interestedEvents = sortedResults
                    }
                }
                
            } else {
                print("Error getting my events: \(error)")
            }
        } catch {
            print("Error getting my events: \(error)")
        }
    }
    
    func followPerformer(uid: String, performer: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/follow-performer?uid=\(uid)&performer=\(performer)") else { return }
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GenericGetResult2.self, from: data)
                if result.error_msg == "" {
                    completion()

                } else {
                    print("Failed to follow performer: \(result.error_msg)")
                }
            } catch {
                print("Failed to follow performer: \(error)")
            }
        }
        
        task.resume()
        
    }
    
    func unfollowPerformer(uid: String, performer: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/unfollow-performer?uid=\(uid)&performer=\(performer)") else { return }
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GenericGetResult2.self, from: data)
                if result.error_msg == "" {
                    completion()

                } else {
                    print("Failed to unfollow performer: \(result.error_msg)")
                }
            } catch {
                print("Failed to unfollow performer: \(error)")
            }
        }
        
        task.resume()
        
    }
    
    @Published var friendsFollowing : [UserObj] = []
    
    func getFriendsFollowing(uid: String, target: String) {
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/performer-friends-following?uid=\(uid)&performer=\(target)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetMutualsResult.self, from: data)
                if result.error_msg == "" {
                    let mutuals = result.result
                    if self.friendsFollowing != mutuals {
                        DispatchQueue.main.async {
                            self.friendsFollowing = mutuals
                        }
                    }
                    
                } else {
                    print("Failed to fetch friends following for uid \(uid) & target \(target): \(result.error_msg)")
                    
                }
            } catch {
                print("Failed to fetch friends following for uid \(uid) & target \(target): \(error)")
                
            }
        }
        
        task.resume()
            
        
            
    }
    
    @Published var followers : [UserObj] = []
    
    func getFollowers(target: String) {
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-performer-followers?performer=\(target)") else { return }
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetMutualsResult.self, from: data)
                if result.error_msg == "" {
                    let followers = result.result
                    if self.followers != followers {
                        DispatchQueue.main.async {
                            self.followers = followers
                        }
                    }
                    
                } else {
                    print("Failed to fetch followers for target \(target): \(result.error_msg)")
                    
                }
            } catch {
                print("Failed to fetch followers for target \(target): \(error)")
                
            }
        }
        
        task.resume()
            
        
            
    }
    
    @Published var followerCount : Int = 0
    
    func getFollowerCount(id: String) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/performer-follower-count?id=\(id)") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let response  = try JSONDecoder().decode(GetUnreadResult.self, from: data)
                
                if response.status == "success" {
                    DispatchQueue.main.async {
                        self.followerCount = response.result
                    }
                    
                    
                }
                else {
                    print("Failed to get unread count: \(response.error_msg)")
                }
                
            } catch {
                print("Failed to get unread count: \(error)")
            }
        }
        
        task.resume()
    }
    
    @Published var spotifyLink = ""
    @Published var soundcloudLink = ""
    
    func getPerformerLinks(id: String) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-performer-links?id=\(id)") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let response  = try JSONDecoder().decode(GetLinksResult.self, from: data)
                
                if response.status == "success" {
                    let links = response.result
                    if links[0] != "" {
                        DispatchQueue.main.async {
                            self.spotifyLink = links[0]
                        }
                    }
                    if links[1] != "" {
                        DispatchQueue.main.async {
                            self.soundcloudLink = links[1]
                        }
                    }
                    
                }
                else {
                    print("Failed to get unread count: \(response.error_msg)")
                }
                
            } catch {
                print("Failed to get unread count: \(error)")
            }
        }
        
        task.resume()
    }
    
    @Published var upcomingEvents: [EventObj] = []
    
    func getUpcomingEvents(id: String)  {
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-performer-upcoming-events?id=\(id)")) else {return}
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetEventsResult.self, from: data)
                if result.status == "success" {
                    if result.result != self.upcomingEvents {
                        DispatchQueue.main.async {
                            self.upcomingEvents = result.result
                        }
                    }
                } else {
                    print("Error getting performer upcoming events: \(result.error_msg)")
                }
                        
                
            } catch {
                
                print("Error getting performer past events: \(error)")
                
            }
        }
        
        task.resume()

    }
    
    @Published var pastEvents: [EventObj] = []
    
    func getPastEvents(id: String)  {
        
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-performer-past-events?id=\(id)")) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetEventsResult.self, from: data)
                
                if result.status == "success" {
                    if result.result != self.pastEvents {
                        DispatchQueue.main.async {
                            self.pastEvents = result.result
                        }
                    }
                } else {
                    print("Error getting performer past events: \(result.error_msg)")
                }
                
                
            } catch {
                
                print("Error getting performer past events: \(error)")
                
            }
        }
        
        task.resume()

    }
    
    
    
    
}
