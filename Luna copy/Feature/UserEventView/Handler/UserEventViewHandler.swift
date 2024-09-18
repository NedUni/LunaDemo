//
//  File.swift
//  Luna
//
//  Created by Will Polich on 1/2/2022.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct GetVenueObj: Decodable {
    let error_msg : String
    let result: VenueObj
}

struct GetEventObj : Decodable {
    let error_msg : String
    let result: EventObj
}

struct PlusOneResult: Decodable, Hashable {
    let status : String
    let error_msg : String
}

struct AcceptPlusOneResult: Decodable, Hashable {
    let status : String
    let error_msg : String
    let result : String
}

struct GetPresInvitedResult: Decodable, Hashable {
    let status : String
    let error_msg : String
    let result : [UserObj]
}

struct GetPollStatusResult: Decodable, Hashable {
    let status : String
    let error_msg : String
    let result : Bool
}

struct RequestPollResult: Decodable, Hashable {
    let status : String
    let error_msg : String
    let result : String
}

struct PollDataResult: Decodable, Hashable {
    let status : String
    let error_msg : String
    let result : Dictionary<String, Double>
}

class UserEventViewHandler: ObservableObject {
    
    @Published var eventResponse = "invited"
    @Published var gettingResponse = false
    
    func getEventResponse(uid: String, eventID: String) {
        DispatchQueue.main.async {
            self.gettingResponse = true
        }
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-pres-response?uid=\(uid)&event=\(eventID)") else { return }

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
    
    func changeEventResponse(uid: String, eventID: String, response: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/change-pres-response?uid=\(uid)&event=\(eventID)&response=\(response)") else { return }
        
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
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-friends-interested-pres?uid=\(uid)&event=\(eventID)&token=\(token)") else { return }
        
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
    
    @Published var invitedFriends: [UserObj] = []
    
    func getInvitedFriends(uid: String, eventID: String, token: String) {
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-friends-invited-pres?uid=\(uid)&event=\(eventID)&token=\(token)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetFriendsInterested.self, from: data)
                if result.error_msg == "" {
                    let friends = result.result
                    print("Got friends intersted in event \(eventID)")
                    
                    DispatchQueue.main.async {
                        self.invitedFriends = friends
                    }
                } else {
                    print("Failed to get friend invites in event \(eventID)")
                }
            } catch {
                print("Failed to get friend invites in event \(error)")
            }
        }
        
        task.resume()
        
    }
    
    @Published var goingFriends: [UserObj] = []
    
    func getGoingFriends(uid: String, eventID: String, token: String) {
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-friends-going-pres?uid=\(uid)&event=\(eventID)&token=\(token)") else { return }
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
    
    func deletePres(id : String, token: String) {
        
        let urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/delete-pres?event=\(id)&token=\(token)"
        let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        print("url string: \(urlString)")
        print("encoded url: \(encodedURL)")
        guard let url = URL(string: encodedURL) else {
            print("Failed to build URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GenericGetResult.self, from: data)
                if result.error_msg == "" {
                    print("Deleted pres.")
                } else {
                    print("Failed to deleted pres: \(result.error_msg)")
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
        
        
    }
    
    func deleteEvent(id : String, token: String) {
        
        let urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/delete-event?event=\(id)&token=\(token)"
        let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        print("url string: \(urlString)")
        print("encoded url: \(encodedURL)")
        guard let url = URL(string: encodedURL) else {
            print("Failed to build URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GenericGetResult.self, from: data)
                if result.error_msg == "" {
                    print("Deleted event.")
                } else {
                    print("Failed to deleted event: \(result.error_msg)")
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    @Published var linkedEvent : EventObj?
    
    func getLinkedEvent(id: String, token: String) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-event?event=\(id)&token=\(token)") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetEventObj.self, from: data)
                if result.error_msg == "" {
                    let event = result.result
                    print("Got linked event \(event)")
                    
                    if self.linkedEvent != event {
                        DispatchQueue.main.async {
                            self.linkedEvent = event
                        }
                    }
                } else {
                    print("Failed to get linked event")
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    @Published var linkedVenue : VenueObj?
    
    func getLinkedVenue(id: String, token: String, completion: @escaping() -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-venue?venue=\(id)&token=\(token)") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetVenueObj.self, from: data)
                if result.error_msg == "" {
                    let venue = result.result
                    print("Got linked venue \(venue)")
                    if self.linkedVenue != venue {
                        DispatchQueue.main.async {
                            self.linkedVenue = venue
                            completion()
                        }
                    }
                } else {
                    print("Failed to get linked venue")
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func getUserEventStatus(uid: String) -> Int {
        print(self.invitedUsers)
        print(self.goingUsers)
        print(self.maybeUsers)
        print(self.declinedUsers)
        for user in self.invitedUsers {
            if user.uid == uid {
                return 1
            }
        }
        for user in self.maybeUsers {
            if user.uid == uid {
                return 2
            }
        }
        for user in self.goingUsers {
            if user.uid == uid {
                return 3
            }
        }
        for user in self.declinedUsers {
            if user.uid == uid {
                return 4
            }
        }
        
        print("Could not find user \(uid) in event components.")
        
        return 1
    }
    
    func changeEventResponse(eventID: String, pres: String, uid: String, response: String, token: String) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/event-response?event=\(eventID)&pres=\(pres)&id=\(uid)&response=\(response)&token=\(token)") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Failed to get data from API call")
                return
                
            }
        
            do {
                let result = try JSONDecoder().decode(GenericGetResult.self, from: data)
                if result.error_msg == "" {
                    print("Changed event response for event \(eventID)")
                } else {
                    print("Failed change response for event: \(result.error_msg)")
                }
            } catch {
                print("Error changing event response: \(error)")
            }
        }
        
        task.resume()
    }
    
    @Published var invitedUsers : [UserObj] = []
    
    func getInvitedUsers(users: [String], token: String, completion: @escaping () -> ()) {
        DispatchQueue.main.async {
            self.invitedUsers = []
        }
        
        if (users.count) == 0 {
            print("No invited users")
            return
        }
        for id in users {
            guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-user?id=\(id)&token=\(token)") else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
            
                do {
                    let result = try JSONDecoder().decode(GetUserByUIDResult.self, from: data)
                    if result.error_msg == "" {
                        let user = result.result
                        print("Adding user \(user) to invited users.")
                        
                        DispatchQueue.main.async {
                            self.invitedUsers.append(user)
                        }
                    } else {
                        print("Failed to add user to invited users.")
                    }
                } catch {
                    print(error)
                }
            }
            
            completion()
            task.resume()
            
        }
    }
    
    @Published var goingUsers : [UserObj] = []
    func getGoingUsers(users: [String], token: String) {
        DispatchQueue.main.async {
            self.goingUsers = []
        }
        
        if (users.count) == 0 {
            print("No going users")
            return
        }
        for id in users {
            guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-user?id=\(id)&token=\(token)") else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
            
                do {
                    let result = try JSONDecoder().decode(GetUserByUIDResult.self, from: data)
                    if result.error_msg == "" {
                        let user = result.result
                        print("Adding user \(user) to going users.")
                        
                        DispatchQueue.main.async {
                            self.goingUsers.append(user)
                        }
                    } else {
                        print("Failed to add user to going users.")
                    }
                } catch {
                    print(error)
                }
            }
            
            task.resume()
            
        }
    }
    
    @Published var declinedUsers : [UserObj] = []
    func getDeclinedUsers(users: [String], token: String) {
        DispatchQueue.main.async {
            self.declinedUsers = []
        }
        
        if (users.count) == 0 {
            print("No declined users")
            return
        }
        for id in users {
            guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-user?id=\(id)&token=\(token)") else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
            
                do {
                    let result = try JSONDecoder().decode(GetUserByUIDResult.self, from: data)
                    if result.error_msg == "" {
                        let user = result.result
                        print("Adding user \(user) to declined users.")
                        
                        DispatchQueue.main.async {
                            self.declinedUsers.append(user)
                        }
                    } else {
                        print("Failed to add user to declined users.")
                    }
                } catch {
                    print(error)
                }
            }
            
            task.resume()
            
        }
    }
    
    @Published var maybeUsers : [UserObj] = []
    func getMaybeUsers(users: [String], token: String) {
        DispatchQueue.main.async {
            self.maybeUsers = []
        }
        
        if (users.count) == 0 {
            print("No invited users")
            return
        }
        for id in users {
            guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-user?id=\(id)&token=\(token)") else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
            
                do {
                    let result = try JSONDecoder().decode(GetUserByUIDResult.self, from: data)
                    if result.error_msg == "" {
                        let user = result.result
                        print("Adding user \(user) to maybe users.")
                        
                        DispatchQueue.main.async {
                            self.maybeUsers.append(user)
                        }
                    } else {
                        print("Failed to add user to maybe users.")
                    }
                } catch {
                    print(error)
                }
            }
            
            task.resume()
            
        }
    }
    
    
    func requestPlusOne(uid: String, eventID: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/request-plus-one?uid=\(uid)&eventID=\(eventID)") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(PlusOneResult.self, from: data)
                if result.error_msg == "" {
                    print("Lodged plus one requests succesfuly")
                
                } else {
                    print("Failed to lodge plus one request: \(result.error_msg)")
                }
            } catch {
                print("Failed to lodge plus one request: \(error)")
            }
            
            completion()
        }
        
        task.resume()
    }
    
    
    @Published var plusOnes : [UserObj] = []
    
    func getPlusOnes(eventID: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-plus-ones?eventID=\(eventID)") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetFriendsInterested.self, from: data)
                if result.error_msg == "" {
                    DispatchQueue.main.async {
                        self.plusOnes = result.result
                    }
                    print("Got plus ones succesfully")
                
                } else {
                    print("Failed to get plus ones: \(result.error_msg)")
                }
            } catch {
                print("Failed to get plus ones: \(error)")
            }
            
            completion()
        }
        
        task.resume()
    }
    
    func acceptPlusOne(uid: String, eventID: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/accept-plus-one?uid=\(uid)&eventID=\(eventID)") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(AcceptPlusOneResult.self, from: data)
                if result.error_msg == "" {
                    print("Accepted plus one result")
                
                } else {
                    print("Failed to accept plus one: \(result.error_msg)")
                }
            } catch {
                print("Failed to accept plus one: \(error)")
            }
            
            completion()
        }
        
        task.resume()
    }
    
    func getPresInvited(eventID: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-pres-invited?eventID=\(eventID)") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetPresInvitedResult.self, from: data)
                if result.error_msg == "" {
                    DispatchQueue.main.async {
                        self.invitedUsers = result.result
                    }
                    
                    print("Got invited succesfully succesfully")
                
                } else {
                    print("Failed to get invited: \(result.error_msg)")
                }
            } catch {
                print("Failed to get invited: \(error)")
            }
            
            completion()
        }
        
        task.resume()
    }
    
    func getPresGoing(eventID: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-pres-going?eventID=\(eventID)") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetPresInvitedResult.self, from: data)
                if result.error_msg == "" {
                    DispatchQueue.main.async {
                        self.goingUsers = result.result
                    }
                    
                    print("Got going succesfully succesfully")
                
                } else {
                    print("Failed to get going: \(result.error_msg)")
                }
            } catch {
                print("Failed to get going: \(error)")
            }
            
            completion()
        }
        
        task.resume()
    }
    
    func requestPoll(eventID: String, uid: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/request-poll?uid=\(uid)&eventID=\(eventID)") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(RequestPollResult.self, from: data)
                if result.error_msg == "" {
                    print("Requested poll")
                
                } else {
                    print("Failed to request poll: \(result.error_msg)")
                }
            } catch {
                print("Failed to request poll: \(error)")
            }
            
            completion()
        }
        
        task.resume()
    }
    
    @Published var pollActive = false
    
    func getPollStatus(eventID: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-poll-status?eventID=\(eventID)") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetPollStatusResult.self, from: data)
                if result.error_msg == "" {
                    print("got poll status")
                    self.pollActive = true
                
                } else {
                    print("Failed to get poll status: \(result.error_msg)")
                }
            } catch {
                print("Failed to get poll status: \(error)")
            }
            
            completion()
        }
        
        task.resume()
    }
    
    @Published var pollData = [String: Double]()
    
    func getPollData(eventID: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-poll?eventID=\(eventID)") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(PollDataResult.self, from: data)
                if result.error_msg == "" {
                    print("got poll data")
                    print(result.result)
                    DispatchQueue.main.async {
                        self.pollData = result.result
                    }
                    
                    
                
                } else {
                    print("Failed to get poll data: \(result.error_msg)")
                }
            } catch {
                print("Failed to get poll data: \(error)")
            }
            
            completion()
        }
        
        task.resume()
    }
    
    func submitSelection(eventID: String, uid: String, venueID: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/request-poll?uid=\(uid)&eventID=\(eventID)") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(RequestPollResult.self, from: data)
                if result.error_msg == "" {
                    print("Requested poll")
                
                } else {
                    print("Failed to request poll: \(result.error_msg)")
                }
            } catch {
                print("Failed to request poll: \(error)")
            }
            
            completion()
        }
        
        task.resume()
    }
    
    
    
    
    
    
    
}

