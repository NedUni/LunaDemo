//
//  VenueService.swift
//  Luna
//
//  Created by Will Polich on 17/2/2022.
//

import Foundation
import SwiftUI

class VenueService : ObservableObject {
    
    @Published var friendsCheckedIn : [UserObj] = []
    
    func getFriendsCheckedIn(uid: String, venue: String, token: String) {
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/getfriendscheckedin?id=\(uid)&venue=\(venue)&token=\(token)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetUsersResult.self, from: data)
                if result.error_msg == "" {
                    let users = result.result
                    if users != self.friendsCheckedIn {
                        DispatchQueue.main.async {
                            
                            self.friendsCheckedIn = users
                        }
                    }
                   
                } else {
                    print("Failed to get friends checked in: \(result.error_msg)")
                }
            } catch {
                print("Failed to get friends checked in: \(error)")
            }
        }
        
        task.resume()
                
    }
    
    @Published var friendsLiked : [UserObj] = []
    
    func getFriendsLiked(uid: String, venue: String, token: String) {
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/friends-favourited-venue?uid=\(uid)&venue=\(venue)&token=\(token)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetUsersResult.self, from: data)
                if result.error_msg == "" {
                    let users = result.result
                    if users != self.friendsLiked  {
                        DispatchQueue.main.async {
                            self.friendsLiked = users
                        }
                    }
                   
                } else {
                    print("Failed to get friends liked venue: \(result.error_msg)")
                }
            } catch {
                print("Failed to get friends liked venue: \(error)")
            }
        }
        
        task.resume()
                
    }
}
