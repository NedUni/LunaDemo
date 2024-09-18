//
//  MessagesManager.swift
//  Luna
//
//  Created by Will Polich on 20/3/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class MessagesManager : ObservableObject {
    
    @Published private(set) var messages : [Message] = []
    @Published private(set) var lastMessage = ""
    
    func getMessages(id: String, pres: Bool) {
        db.collection(pres == true ? "userPres" : "userEvents").document(id).collection("messages").order(by: "timestamp").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching message documents: \(String(describing: error?.localizedDescription))")
                return
            }
            
            self.messages = documents.compactMap { document -> Message? in
                do {
                    return try document.data(as: Message.self)
                } catch {
                    print("Error decoding document into message: \(error)")
                    return nil
                }
            }
            
//            self.messages.sort { $0.timestamp < $1.timestamp }
            
            if let id = self.messages.last?.id {
                self.lastMessage = id
            }
        }
    }
    
    func sendMessage(text: String, uid: String, id: String, pres: Bool, imageurl: String, name: String, linkedEvent: EventObj?, linkedVenue: VenueObj?, linkedDeal: DealObj?, event: EventObj, sender: SessionUser) {
        do {
            
            let ref = db.collection(pres == true ? "userPres" : "userEvents").document(id).collection("messages").document()
            
            var newMessage = Message(id: ref.documentID, text: text, timestamp: Date(), sender: uid, received: [uid], imageurl: imageurl, senderName: name, linkedEvent: linkedEvent?.id ?? "", linkedVenue: linkedVenue?.id ?? "", linkedDeal: linkedDeal?.id ?? "")
            
            if linkedVenue != nil {
                db.collection("businessUsers").document(linkedVenue!.id).updateData(["engagementToday" : FieldValue.increment(10.0)])
            }
            
            var urlString : String
            if  newMessage.linkedEvent != "" {
                newMessage.text = "\(name) sent an event."
                urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/chatnotification?senderID=\(uid)&eventID=\(id)&pres=\(String(pres))&text=\(name) sent an event."
            } else if newMessage.linkedVenue != "" {
                newMessage.text = "\(name) sent a venue."
                urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/chatnotification?senderID=\(uid)&eventID=\(id)&pres=\(String(pres))&text=\(name) sent a venue."
            } else if newMessage.linkedDeal != "" {
                newMessage.text = "\(name) sent a deal."
                urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/chatnotification?senderID=\(uid)&eventID=\(id)&pres=\(String(pres))&text=\(name) sent a deal."
            } else {
                urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/chatnotification?senderID=\(uid)&eventID=\(id)&pres=\(String(pres))&text=\(text)"
            }
            
            try ref.setData(from: newMessage)
//            let urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/chatnotification?senderID=\(uid)&eventID=\(id)&pres=\(String(pres))&text=\(text)"
        
            guard let encodedURL = (URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")) else { return }
            
            let task = URLSession.shared.dataTask(with: encodedURL) { data, response, error in
                guard let data = data else { return }
                
                do {
                    let result = try JSONDecoder().decode(GenericGetResult2.self, from: data)
                    
                    if result.error_msg != "" {
                        print("Error sending chat notification: \(result.error_msg)")
                    }
                    
                } catch {
                    print(error)
                }
            }
            
            task.resume()
            
            persistRecentMessage(sender: sender, event: event, message: newMessage)
            
        } catch {
           print("Failed to send message: \(error)")
        }
    }
    
    
    private func persistRecentMessage(sender: SessionUser, event: EventObj, message: Message) {
        
        
        let ref = db.collection("profiles").document(event.hostIDs[0])
        ref.getDocument { document, error in
            if let err = error {
                print("Error getting creator document: \(err)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    let imageURL = data["imageURL"] as? String ?? ""
                    
                    var recentMessage : RecentMessage
                    var recentMessage2 : RecentMessage
                    
                    if message.linkedEvent != "" {
                        recentMessage = RecentMessage(fromName: event.label, fromID: event.id, fromImageurl: imageURL, text: "\(sender.firstName) sent an event.", timestamp: message.timestamp, received:  [sender.uid], linkedEvent: event.id)
                        recentMessage2 = RecentMessage(fromName: event.label, fromID: event.id, fromImageurl: imageURL, text: "You sent an event.", timestamp: message.timestamp, received:  [sender.uid], linkedEvent: event.id)
                        
                    } else if message.linkedVenue != "" {
                        recentMessage = RecentMessage(fromName: event.label, fromID: event.id, fromImageurl: imageURL, text: "\(sender.firstName) sent a venue.", timestamp: message.timestamp, received:  [sender.uid], linkedEvent: event.id)
                        recentMessage2 = RecentMessage(fromName: event.label, fromID: event.id, fromImageurl: imageURL, text: "You sent a venue.", timestamp: message.timestamp, received:  [sender.uid], linkedEvent: event.id)
                    } else if message.linkedDeal != "" {
                        recentMessage = RecentMessage(fromName: event.label, fromID: event.id, fromImageurl: imageURL, text: "\(sender.firstName) sent a deal.", timestamp: message.timestamp, received:  [sender.uid], linkedEvent: event.id)
                        recentMessage2 = RecentMessage(fromName: event.label, fromID: event.id, fromImageurl: imageURL, text: "You sent a deal.", timestamp: message.timestamp, received:  [sender.uid], linkedEvent: event.id)
                    } else {
                        recentMessage = RecentMessage(fromName: event.label, fromID: event.id, fromImageurl: imageURL, text: message.text, timestamp: message.timestamp, received:  [sender.uid], linkedEvent: event.id)
                        recentMessage2 = RecentMessage(fromName: event.label, fromID: event.id, fromImageurl: imageURL, text: "\(sender.firstName) \(sender.lastName): \(message.text)", timestamp: message.timestamp, received:  [sender.uid], linkedEvent: event.id)
                    }
                    
                    let users = event.invited + event.going + event.interested
                    
                    for user in users {
                        
                        let document = db
                            .collection("recentPresMessages")
                            .document(user)
                            .collection("messages")
                            .document(event.id)
                        

                        // you'll need to save another very similar dictionary for the recipient of this message...how?
                        
                        do {
                            
                            try document.setData(from: user == sender.uid ? recentMessage2 : recentMessage) { error in
                                if let error = error {
                                    print("Failed to save recent message: \(error)")
                                    return
                                }
                            }
                            
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    func readAllMessages(uid: String, id: String, pres: Bool, completion: @escaping () -> ()) {
        
        if uid == "" || id == "" { return }
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/readallmessages?uid=\(uid)&id=\(id)&pres=\(pres)") else {return}

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode([String: String].self, from: data)
                
                if result["error_msg"] == "" {
                    print("Read all messages")
                } else {
                    print("Failed to read all messages: \(String(describing: result["error_msg"]))")
                }
                
            } catch {
                print("Failed to read all messages: \(error)")
            }
        }
        
        task.resume()
        
        completion()
    }
}
