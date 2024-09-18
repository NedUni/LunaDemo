//
//  InboxService.swift
//  Luna
//
//  Created by Will Polich on 13/4/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct RecentMessage : Codable, Hashable {
    let fromName: String
    let fromID : String
    let fromImageurl : String
    let text: String
    let timestamp : Date
    let received : [String]
    let linkedEvent : String
}

class InboxService : ObservableObject {
    
    @Published var recentMessages : [RecentMessage] = []
    
    func getAllFriendMessages(uid: String, completion: @escaping () -> ()) {
        db.collection("recentFriendMessages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching message documents: \(String(describing: error?.localizedDescription))")
                    return
                }
                
                print("documents: \(documents)")
                
                var localMessages : [RecentMessage] = []
                localMessages = documents.compactMap { document -> RecentMessage? in
                    do {
                        return try document.data(as: RecentMessage.self)
                    } catch {
                        print("Error decoding document into message: \(error)")
                        return nil
                    }
                }
                
                localMessages.reverse()
                self.recentMessages = localMessages
                
                completion()
            
            

        }
    }
    
    @Published var recentEventMessages : [RecentMessage] = []
    
    func getAllEventMessages(uid: String, completion: @escaping () -> ()) {
        db.collection("recentPresMessages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching message documents: \(String(describing: error?.localizedDescription))")
                    return
                }
                
                print("documents: \(documents)")
                
                var localMessages : [RecentMessage] = []
                localMessages = documents.compactMap { document -> RecentMessage? in
                    do {
                        return try document.data(as: RecentMessage.self)
                    } catch {
                        print("Error decoding document into message: \(error)")
                        return nil
                    }
                }
                
                localMessages.reverse()
                self.recentEventMessages = localMessages
                
                completion()
            
            

        }
    }
    
    @Published var allMessages : [RecentMessage] = []
    @Published var gettingMessages = false
    
    func getAllMessages(uid: String, completion: @escaping () -> ()) {
        gettingMessages = true
        db.collection("recentPresMessages")
            .document(uid)
            .collection("messages")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching message documents: \(String(describing: error?.localizedDescription))")
                    return
                }
                
                var localPresMessages : [RecentMessage] = []
                localPresMessages = documents.compactMap { document -> RecentMessage? in
                    do {
                        return try document.data(as: RecentMessage.self)
                    } catch {
                        print("Error decoding document into message: \(error)")
                        return nil
                    }
                }
                            
                db.collection("recentFriendMessages")
                    .document(uid)
                    .collection("messages")
                    .addSnapshotListener { querySnapshot, error in
                        guard let documents = querySnapshot?.documents else {
                            print("Error fetching message documents: \(String(describing: error?.localizedDescription))")
                            return
                        }
                        
                        print("documents: \(documents)")
                        
                        var localFriendMessages : [RecentMessage] = []
                        localFriendMessages = documents.compactMap { document -> RecentMessage? in
                            do {
                                return try document.data(as: RecentMessage.self)
                            } catch {
                                print("Error decoding document into message: \(error)")
                                return nil
                            }
                        }
                        
                        var localAllMessages : [RecentMessage] = localFriendMessages + localPresMessages
//                        localAllMessages = localAllMessages.sorted(by: { $0.compare($1) == .orderedDescending })
                        localAllMessages.sort { $0.timestamp > $1.timestamp }

                        self.allMessages = localAllMessages
                        
                        self.gettingMessages = false
                        
                        completion()
                    
                    

                }
            

        }
        
        
        
    }
    
}
