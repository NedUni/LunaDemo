//
//  P2PMessageService.swift
//  Luna
//
//  Created by Will Polich on 13/4/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class FriendMessageService: ObservableObject {
    
    @Published private(set) var messages : [Message] = []
    @Published private(set) var lastMessage = ""
    
    func getMessages(id: String, recipient: String) {
        
        if id == "" || recipient == "" { return }
        
        db.collection("messages").document(id).collection(recipient).order(by: "timestamp").addSnapshotListener { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else {
                print("Error fetching message documents: \(String(describing: error?.localizedDescription))")
                return
            }
            
            var localMessages : [Message] = []
            localMessages = documents.compactMap { document -> Message? in
                do {
                    return try document.data(as: Message.self)
                } catch {
                    print("Error decoding document into message: \(error)")
                    return nil
                }
            }
            
            if localMessages != self.messages {
//                localMessages.sort { $0.timestamp < $1.timestamp }
                self.messages = localMessages
            }
            
            
            
            if let id = self.messages.last?.id {
                self.lastMessage = id
            }
        }
    }
    
    func sendMessage(text: String, sender: SessionUser?, recipient: UserObj?, imageurl: String, name: String, linkedEvent: EventObj?, linkedVenue: VenueObj?, linkedDeal: DealObj?) {
        if sender == nil || recipient == nil {
            print("Insufficient ids provided.")
            return
        }

        let document = db.collection("messages")
            .document(sender!.uid)
            .collection(recipient!.uid)
            .document()

        let messageData = Message(id: document.documentID, text: text, timestamp: Date(), sender: sender!.uid, received: [sender!.uid], imageurl: imageurl, senderName: name, linkedEvent: linkedEvent?.id ?? "", linkedVenue: linkedVenue?.id ?? "", linkedDeal: linkedDeal?.id ?? "")
        
        do {
            try document.setData(from: messageData) { error in
                if let error = error {
                    print(error)
                    return
                }

                print("Successfully saved current user sending message")
            }

            let recipientMessageDocument = db.collection("messages")
                .document(recipient!.uid)
                .collection(sender!.uid)
                .document()

            try recipientMessageDocument.setData(from: messageData) { error in
                if let error = error {
                    print(error)
                    return
                }

                print("Recipient saved message as well")
            }
            
            
        } catch {
            print(error)
        }
        
        if linkedVenue != nil {
            db.collection("businessUsers").document(linkedVenue!.id).updateData(["engagementToday" : FieldValue.increment(10.0)])
        }
        
        var urlString : String
        if messageData.linkedEvent != "" {
            urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/friendmessagenotification?sender=\(sender!.uid)&recipient=\(recipient!.uid)&body=\(sender!.firstName) sent an event."
        } else if messageData.linkedVenue != "" {
            urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/friendmessagenotification?sender=\(sender!.uid)&recipient=\(recipient!.uid)&body=\(sender!.firstName) sent a venue."
        } else if messageData.linkedDeal != "" {
            urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/friendmessagenotification?sender=\(sender!.uid)&recipient=\(recipient!.uid)&body=\(sender!.firstName) sent a deal."
        } else {
            urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/friendmessagenotification?sender=\(sender!.uid)&recipient=\(recipient!.uid)&body=\(text)"
        }
        
    
        guard let encodedURL = (URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")) else { return }
        
        let task = URLSession.shared.dataTask(with: encodedURL) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(GenericGetResult2.self, from: data)
                
                if result.error_msg != "" {
                    print("Error sending message notification: \(result.error_msg)")
                }
                
            } catch {
                print(error)
            }
        }
        
        task.resume()
        
        persistRecentMessage(sender: sender!, recipient: recipient!, message: messageData)
    }
    
    private func persistRecentMessage(sender: SessionUser, recipient: UserObj, message: Message) {
        var recentMessage1 : RecentMessage
        var recentMessage2 : RecentMessage
        
        if message.linkedEvent != "" {
            recentMessage1 = RecentMessage(fromName: "\(recipient.firstName) \(recipient.lastName)", fromID: recipient.uid, fromImageurl: recipient.imageURL, text: "You sent an event", timestamp: message.timestamp, received:  [sender.uid], linkedEvent: "")
            recentMessage2 = RecentMessage(fromName: "\(sender.firstName) \(sender.lastName)", fromID: sender.uid, fromImageurl: sender.imageURL, text: "\(sender.firstName) sent an event.", timestamp: message.timestamp, received:  [sender.uid], linkedEvent: "")
        } else if message.linkedVenue != "" {
            recentMessage1 = RecentMessage(fromName: "\(recipient.firstName) \(recipient.lastName)", fromID: recipient.uid, fromImageurl: recipient.imageURL, text: "You sent a venue", timestamp: message.timestamp, received:  [sender.uid], linkedEvent: "")
            recentMessage2 = RecentMessage(fromName: "\(sender.firstName) \(sender.lastName)", fromID: sender.uid, fromImageurl: sender.imageURL, text: "\(sender.firstName) sent a venue.", timestamp: message.timestamp, received:  [sender.uid], linkedEvent: "")
        } else if message.linkedDeal != "" {
            recentMessage1 = RecentMessage(fromName: "\(recipient.firstName) \(recipient.lastName)", fromID: recipient.uid, fromImageurl: recipient.imageURL, text: "You sent a deal", timestamp: message.timestamp, received:  [sender.uid], linkedEvent: "")
            recentMessage2 = RecentMessage(fromName: "\(sender.firstName) \(sender.lastName)", fromID: sender.uid, fromImageurl: sender.imageURL, text: "\(sender.firstName) sent a deal.", timestamp: message.timestamp, received:  [sender.uid], linkedEvent: "")
        } else {
            recentMessage1 = RecentMessage(fromName: "\(recipient.firstName) \(recipient.lastName)", fromID: recipient.uid, fromImageurl: recipient.imageURL, text: message.text, timestamp: message.timestamp, received:  [sender.uid], linkedEvent: "")
            recentMessage2 = RecentMessage(fromName: "\(sender.firstName) \(sender.lastName)", fromID: sender.uid, fromImageurl: sender.imageURL, text: message.text, timestamp: message.timestamp, received:  [sender.uid], linkedEvent: "")
        }
        
            let document = db
                .collection("recentFriendMessages")
                .document(sender.uid)
                .collection("messages")
                .document(recipient.uid)
            

            // you'll need to save another very similar dictionary for the recipient of this message...how?
            
            do {
                try document.setData(from: recentMessage1) { error in
                    if let error = error {
                        print("Failed to save recent message: \(error)")
                        return
                    }
                }
                
                
                try db
                    .collection("recentFriendMessages")
                    .document(recipient.uid)
                    .collection("messages")
                    .document(sender.uid)
                    .setData(from: recentMessage2) { error in
                        if let error = error {
                            print("Failed to save recipient recent message: \(error)")
                            return
                        }
                    }
                }
        
        catch {
            print(error)
        }
    }
    
    func readAllMessages(uid: String, chatUserID: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/readfriendmessages?uid=\(uid)&chatuserid=\(chatUserID)") else {return}
        
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
