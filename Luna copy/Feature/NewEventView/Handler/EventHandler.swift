//
//  EventHandler.swift
//  Luna
//
//  Created by Will Polich on 30/1/2022.
//

import Foundation
import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct CreateEventResult : Decodable {
    let error_msg : String
    let status : String
    let result : String
}

struct InviteToPresResult: Decodable, Hashable {
    let status : String
    let error_msg : String
    let result : String
}

class EventHandler : ObservableObject {
    
    @Published var addedInvites : [UserObj] = []
    @Published var invited: [UserObj] = []
    let dateFormatter = DateFormatter()
    
    func invite(user: UserObj) {
        self.addedInvites.append(user)
    }
    
    func removeInvite(user: UserObj) {
        if let index = self.addedInvites.firstIndex(of: user) {
            self.addedInvites.remove(at: index)
        }
    }
    
    func sendAllInvites() {
        self.invited = self.addedInvites
    }
    
    func getAllUsers(event: String) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-pres-users?event=\(event)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetFriendsResult.self, from: data)
                if result.error_msg == "" {
                    DispatchQueue.main.async {
                        self.invited = result.result
                    }
                    
                } else {
                    print("Failed to get pres users \(result.error_msg)")
                }
            } catch {
                print("Failed to get pres users: \(error)")
            }
        }
        
        
        task.resume()
    }
    
    //invite
    
    func inviteToPres(eventID: String, uid: String, completion: @escaping () -> ()) {
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/add-user-invite?event=\(eventID)&uid=\(uid)") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(InviteToPresResult.self, from: data)
                if result.error_msg == "" {
                    print("Invited succesfully")
                
                } else {
                    print("Failed to invite: \(result.error_msg)")
                }
            } catch {
                print("Failed to invite: \(error)")
            }
            completion()
        }
        task.resume()
    }
    
    func removeFromPres(eventID: String, uid: String, completion: @escaping () -> ()) {
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/remove-user-invite?event=\(eventID)&uid=\(uid)") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(InviteToPresResult.self, from: data)
                if result.error_msg == "" {
                    print("Removed succesfully")
                
                } else {
                    print("Failed to remove: \(result.error_msg)")
                }
            } catch {
                print("Failed to remove: \(error)")
            }
            completion()
        }
        task.resume()
    }
    
    
    
    
    
    
    func updateAllInvites(event: String, completion: @escaping () -> ()) {
        self.invited = self.addedInvites
        var inviteArray : [String] = []
        for user in self.invited {
            inviteArray.append(user.uid)
        }
        let invited = inviteArray.joined(separator: ",")

        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/update-pres-invites?event=\(event)&invites=\(invited)") else { return }
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(CreateEventResult.self, from: data)
                if result.error_msg == "" {
                    print("Successfully updated invites")
                    
                    
                } else {
                    print("Failed to update invites: \(result.error_msg)")
                }
            } catch {
                print("Failed to update invites: \(error)")
            }
        }
        
        completion()
        
        task.resume()
    
    }
    
    func getInvited(invited: [String], token: String, completion: @escaping () -> ()) {
        self.invited = []
        
        for id in invited {
            guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-user?id=\(id)&token=\(token)") else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
            
                do {
                    let result = try JSONDecoder().decode(GetUserByUIDResult.self, from: data)
                    if result.error_msg == "" {
                        let user = result.result
                        print("Adding user \(user) to friends invited")
                        
                        DispatchQueue.main.async {
                            self.invited.append(user)
                        }
                    } else {
                        print("Failed to add user to friends invited: \(result.error_msg)")
                    }
                } catch {
                    print("Failed to add user to friends invited: \(error)")
                }
            }
            
            completion()
            
            task.resume()
            
        }
        
            
            
    }
    
    
    
    
    
    func createPres(uid: String, name: String, description: String, date: Date, address: String, linkedEvent: String, linkedVenue: String, token: String, completion: @escaping (String) -> ()) {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: date)

        var inviteArray : [String] = []
        for user in self.invited {
            inviteArray.append(user.uid)
        }
        let invited = inviteArray.joined(separator: ",")
        
        let urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/create-pres?id=\(uid)&name=\(name)&description=\(description)&date=\(dateString)&time=\(timeString)&address=\(address)&invited=\(invited)&linkedEvent=\(linkedEvent)&linkedVenue=\(linkedVenue)&token=\(token)"
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
                    print("Created pres.")
                    completion(result.result)
                } else {
                    print("Failed to create pres: \(result.error_msg)")
                    completion("Failed")
                }
            } catch {
                print(error)
                completion("Failed")
            }
            
            
        }
        
        
        task.resume()
        
        
        
        
    }
    
    func updatePres(id: String, name: String, description: String, date: Date, time: Date, address: String, linkedEvent: String, linkedVenue: String, token: String) {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: time)

        var inviteArray : [String] = []
        for user in self.invited {
            inviteArray.append(user.uid)
        }
        
        let urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/update-pres?event=\(id)&name=\(name)&description=\(description)&date=\(dateString)&time=\(timeString)&address=\(address)&linkedEvent=\(linkedEvent)&linkedVenue=\(linkedVenue)&token=\(token)"
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
                    print("Updated pres.")
                } else {
                    print("Failed to update pres: \(result.error_msg)")
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
        
        
    }
    
    func createUserEvent(uid: String, name: String, description: String, date: Date, startTime: Date, endTime: Date, address: String, image: UIImage, token: String, completion: @escaping () -> ()) {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm"
        let startString = dateFormatter.string(from: startTime)
        let endString = dateFormatter.string(from: endTime)
        
        var inviteArray : [String] = []
        for user in self.invited {
            inviteArray.append(user.uid)
        }
        let invited = inviteArray.joined(separator: ",")
        
        let urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/create-user-event?id=\(uid)&name=\(name)&description=\(description)&date=\(dateString)&startTime=\(startString)&endTime=\(endString)&address=\(address)&invited=\(invited)&token=\(token)"
        let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        print("url string: \(urlString)")
        print("encoded url: \(encodedURL)")
        
        guard let url = URL(string: encodedURL) else {
            print("Failed to build URL")
            return
        }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(CreateEventResult.self, from: data)
                if result.error_msg == "" {
                    print("Created user event.")
                    let ref = result.result
                    self.storeEventImage(image: image, eventRef: ref)
                    completion()
                    
                } else {
                    print("Failed to create user event: \(result.error_msg)")
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
        
        
        
    }
    
    func updateUserEvent(id: String, name: String, description: String, date: Date, startTime: Date, endTime: Date, address: String, image: UIImage?, token: String, oldEvent: EventObj) {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm"
        let startString = dateFormatter.string(from: startTime)
        let endString = dateFormatter.string(from: endTime)
        
        var inviteArray : [String] = []
        for user in self.invited {
            inviteArray.append(user.uid)
        }
        let invited = inviteArray.joined(separator: ",")
        
        let urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/update-user-event?event=\(id)&name=\(name)&description=\(description)&date=\(dateString)&startTime=\(startString)&endTime=\(endString)&address=\(address)&invited=\(invited)&token=\(token)"
        let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        print("url string: \(urlString)")
        print("encoded url: \(encodedURL)")
        
        guard let url = URL(string: encodedURL) else {
            print("Failed to build URL")
            return
        }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GenericGetResult.self, from: data)
                if result.error_msg == "" {
                    print("Updated user event.")
                    if image != nil && image!.size.width != 0 {
                        self.storeEventImage(image: image!, eventRef: id)
                    }
                    
                } else {
                    print("Failed to update user event: \(result.error_msg)")
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
        
        
        
    }
    
    func storeEventImage(image: UIImage, eventRef : String) {
        print("Trying to store event image")
//        let uid = Auth.auth().currentUser?.uid
        let ref = storage.reference(withPath: "userEventImages/\(eventRef)")
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {return}
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print(error)
                return
            }
            print("Uploaded image data for new user event.")
            ref.downloadURL { url, error in
                if let error = error {
                    print(error)
                    return
                }
                let urlString = url?.absoluteString ?? ""
                print("downloaded url: \(urlString)")
                
                
                db.collection("userEvents").document(eventRef).updateData(["imageurl" : url?.absoluteString ?? ""]) { error in
                    if let error = error {
                        print("Failed to store event image for event id: \(eventRef), error: \(error)")
                    } else {
                        print("Sucessfully stored event image for event id: \(eventRef)")
                    }
                }
                
                
               
                
            }
        }
        
        
        
    }

}
