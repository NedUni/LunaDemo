//
//  PageHandler.swift
//  Luna
//
//  Created by Ned O'Rourke on 30/3/22.
//

import Foundation
import UIKit

struct GetPageResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: [PageObj]
}

struct GetSimilarPagesResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: [PageObj]
}

struct GetPageCategoriesResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: [String]
}

struct GetFollowedResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: Bool
}

struct GetFriendsResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: [UserObj]
}

struct GetEventsResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: [EventObj]
}

struct GetTotalResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: Int
}

struct GetPromotedEventResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: EventObj
}

struct FollowPageResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: String
}

struct PageObj: Codable, Hashable, Identifiable {
    
    let id: String
    let name: String
    let email: String
    let description: String
    let promotedEvent: String
    let events: [String]
    let banner_url: String
    let logo_url: String
    let categories: [String]
    let followers: [String]
    let admins: [String]
    let website: String
    
}

class PageHandler : ObservableObject {
    
    @Published var pageAdmins: [UserObj] = []
    @Published var gettingAdmins = false
    
    func getPageAdmins(id: String, completion: @escaping () -> ()) async {
    
        self.gettingAdmins = true

        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/page-admins?id=\(id)") else { return }
        print(url)
        
        do {
            let (data, error) = try await URLSession.shared.data(from: url)
            
            if let result = try?JSONDecoder().decode(GetUsersResult.self, from: data) {
                let users = result.result
                print("admins are \(users)")
                
                DispatchQueue.main.async {
                    if users != self.pageAdmins {
                        self.pageAdmins = users
                    }
                    self.gettingAdmins = false
                    completion()
                }
            } else {
                print("Failed to get admins: \(error)")
                DispatchQueue.main.async {
                    self.gettingAdmins = false
                }
            }
        } catch {
            print("Failed to get admins: \(error)")
            DispatchQueue.main.async {
                self.gettingAdmins = false
            }
        }
        
        completion()
    }

    
    @Published var myPages: [PageObj] = []
    
    @Published var creatingPageEvent : Bool = false
    
    func createPageEvent(pageID: String, eventName: String, eventDescription: String, eventDate: String, eventStartTime: String, eventEndTime: String, address: String, eventTags: String, eventHostIds: String, eventHostNames: String, linkedVenue: String, linkedVenueName: String, ticketlink: String, image: UIImage, completion: @escaping () -> ()) {
        let urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/create-page-event?id=\(pageID)&name=\(eventName)&description=\(eventDescription)&date=\(eventDate)&startTime=\(eventStartTime)&endTime=\(eventEndTime)&address=\(address)&tags=\(eventTags)&hosts=\(eventHostIds)&hostNames=\(eventHostNames)&linkedVenue=\(linkedVenue)&linkedVenueName=\(linkedVenueName)&ticketLink=\(ticketlink)"
        
        self.creatingPageEvent = true
        
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
                    print("Created page event.")
                    let ref = result.result
                    self.storePageEventImage(image: image, eventRef: ref, completion: {self.creatingPageEvent = false
                        completion()
                    })
                    
                } else {
                    print("Failed to create page event: \(result.error_msg)")
                    self.creatingPageEvent = false
                }
            } catch {
                print(error)
                self.creatingPageEvent = false
            }
        }
        
        task.resume()
    }
    
    @Published var updatingPageEvent : Bool = false
    
    func updatePageEvent(eventID: String, pageID: String, eventName: String, eventDescription: String, eventDate: String, eventStartTime: String, eventEndTime: String, address: String, eventTags: String, eventHostIds: String, eventHostNames: String, linkedVenue: String, linkedVenueName: String, ticketlink: String, image: UIImage?, completion: @escaping () -> ()) {
    
    
//    func updatePageEvent(eventID: String, pageID: String, eventName: String, eventDescription: String, eventLocation: String, eventDate: String, eventStart: String, eventEnd: String, eventTags: String, eventHosts: String, image: UIImage?, completion: @escaping () -> ()) {
        self.updatingPageEvent = true
        
        let urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/update-page-event?eventID=\(eventID)&pageID=\(pageID)&name=\(eventName)&description=\(eventDescription)&date=\(eventDate)&startTime=\(eventStartTime)&endTime=\(eventEndTime)&address=\(address)&tags=\(eventTags)&hosts=\(eventHostIds)&hostNames=\(eventHostNames)&linkedVenue=\(linkedVenue)&linkedVenueName=\(linkedVenueName)&ticketLink=\(ticketlink)"
        
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
                    print("Updated page event.")
                    let ref = result.result
                    if image != nil {
                        self.storePageEventImage(image: image!, eventRef: ref, completion: {
                            self.updatingPageEvent = false
                            completion()
                        })
                    } else {
                        completion()
                        self.updatingPageEvent = false
                    }
                    
                } else {
                    print("Failed to update page event: \(result.error_msg)")
                    self.updatingPageEvent = false
                }
            } catch {
                print("Failed to update page event: \(error)")
                self.updatingPageEvent = false
            }
        }
        
        task.resume()
    }
    
    @Published var creatingPage : Bool = false
    
    func createPage(pageName: String, pageDescription: String, pageCategories: String, pageAdmins: String, bannerImage: UIImage, logoImage: UIImage, completion: @escaping () -> ()) {
        let urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/createPage?pageName=\(pageName)&pageDescription=\(pageDescription)&pageCategories=\(pageCategories)&pageAdmin=\(pageAdmins)"
        self.creatingPage = true
        
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
                    print("Created page event.")
                    let ref = result.result
                    print("ref = \(ref)")
                    self.storePageLogoImage(image: logoImage, eventRef: ref, completion:{})
                    self.storePageBannerImage(image: bannerImage, eventRef: ref, completion:{
                        self.creatingPage = false
                        completion()
                    })
    
                    
                    
                } else {
                    print("Failed to create page event: \(result.error_msg)")
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func storePageEventImage(image: UIImage, eventRef : String, completion: @escaping () -> ()) {
        print("Trying to store event image")
        let ref = storage.reference(withPath: "pageEventImages/\(eventRef)")
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {return}
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print(error)
                return
            }
            print("Uploaded image data for new page event.")
            ref.downloadURL { url, error in
                if let error = error {
                    print(error)
                    return
                }
                let urlString = url?.absoluteString ?? ""
                print("downloaded url: \(urlString)")
                
                
                db.collection("pageEvents").document(eventRef).updateData(["imageurl" : url?.absoluteString ?? ""]) { error in
                    if let error = error {
                        print("Failed to store event image for event id: \(eventRef), error: \(error)")
                    } else {
                        print("Sucessfully stored event image for event id: \(eventRef)")
                        completion()
                    }
                }
            }
        }
    }
    
    func storePageBannerImage(image: UIImage, eventRef : String, completion: @escaping () -> ()) {
        print("Trying to page banner")
        let ref = storage.reference(withPath: "pageBannerImages/\(eventRef)")
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {return}
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print(error)
                return
            }
            print("Uploaded image data for new page banner.")
            ref.downloadURL { url, error in
                if let error = error {
                    print(error)
                    return
                }
                let urlString = url?.absoluteString ?? ""
                print("downloaded url: \(urlString)")
                
                
                db.collection("pages").document(eventRef).updateData(["banner_url" : url?.absoluteString ?? ""]) { error in
                    if let error = error {
                        print("Failed to store banner image for id: \(eventRef), error: \(error)")
                    } else {
                        print("Sucessfully stored banner image id: \(eventRef)")
                        completion()
                    }
                }
            }
        }
    }
    
    func storePageLogoImage(image: UIImage, eventRef : String, completion: @escaping () -> ()) {
        print("Trying to pagee logo")
        let ref = storage.reference(withPath: "pageLogoImages/\(eventRef)")
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {return}
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print(error)
                return
            }
            print("Uploaded image data for new page logo.")
            ref.downloadURL { url, error in
                if let error = error {
                    print(error)
                    return
                }
                let urlString = url?.absoluteString ?? ""
                print("downloaded url: \(urlString)")
                
                
                db.collection("pages").document(eventRef).updateData(["logo_url" : url?.absoluteString ?? ""]) { error in
                    if let error = error {
                        print("Failed to store page logo for id: \(eventRef), error: \(error)")
                    } else {
                        print("Sucessfully stored page logo for event id: \(eventRef)")
                        completion()
                    }
                }
            }
        }
    }
    
    func getMyPages(uid: String, completion: @escaping () -> ())  {
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-my-pages?id=\(uid)")) else {return}
        
        print("Getting my pages URL: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetPageResult.self, from: data)
                
                if result.status == "success" {
                    let sortedResults = result.result.sorted(by: {
                           ($0.name < $1.name)
                       })
       
                       DispatchQueue.main.async {
                           self.myPages = sortedResults
                       }
                    
                    print("Succesfully got pages")
                }
                
                else {
                    print("Error getting my pages: \(error)")
                }
                
            } catch {
                
                print(error)
                
            }
        }
        
        completion()
        task.resume()

    }
    
    func followPage(uid: String, pageID: String, completion: @escaping () -> ()) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/follow-page?id=\(uid)&pageID=\(pageID)")!
        
        print("Follow venue URL: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(FollowPageResult.self, from: data)
                print(result)
                
                if result.result == "success" {
                    print("Successfully followed page")
                    completion()
                }
                else {
                    print("Failed to follow page: \(result)")
                }
                
            } catch {
                print("Error following page: \(error)")
            }
        }
        
        task.resume()
    }
    
    func unfollowPage(uid: String, pageID: String, completion: @escaping () -> ()) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/unfollow-page?id=\(uid)&pageID=\(pageID)")!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(FollowPageResult.self, from: data)
                print(result)
                
                if result.result == "success" {
                    completion()
                    print("Successfully unfollowed page")
                }
                
                else {
                    print("Failed to unfollow page: \(result)")
                }
                
            } catch {
                print("Error unfollowing page: \(error)")
            }
        }
        
        task.resume()
    }
    
    @Published var isFollowed: Bool = false
    
    func checkFollowStatus(uid: String, pageID: String) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/check-page-follow-status?id=\(uid)&pageID=\(pageID)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(GetFollowedResult.self, from: data)
                
                if result.status == "success" {
                    DispatchQueue.main.async {
                        self.isFollowed = result.result
                    }
                }
                else {
                   print("Error getting isFollowed: \(error)")
               }
            }
            catch {
                print("Error unfollowing page: \(error)")
            }
        }
        
        task.resume()
    }
    
    @Published var friendsThatFollowPage: [UserObj] = []
    
    func getFriendsThatFollowPage(uid: String, pageID: String) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-friends-that-follow-page?id=\(uid)&pageID=\(pageID)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(GetFriendsResult.self, from: data)
                
                if result.status == "success" {
                    DispatchQueue.main.async {
                        self.friendsThatFollowPage = result.result
                    }
                }
                else {
                   print("Error getting friends that follow page: \(error)")
               }
            }
            catch {
                print("Error  getting friends that follow page: \(error)")
            }
        }
        
        task.resume()
    }
    
    @Published var totalThatFollowPage: Int = 0
    
    func getTotalThatFollowPage(pageID: String) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-total-follows-of-page?pageID=\(pageID)")!
    
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(GetTotalResult.self, from: data)
                
                if result.status == "success" {
                    DispatchQueue.main.async {
                        self.totalThatFollowPage = result.result
                    }
                }
                else {
                   print("Error getting friends that follow page: \(error)")
               }
            }
            catch {
                print("Error  getting friends that follow page: \(error)")
            }
        }
        
        task.resume()
    }
    
    @Published var totalFriendsThatFollowPage: Int = 0
    
    func getTotalFriendsThatFollowPage(uid: String, pageID: String) {
        
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-total-friends-that-follow-page?id=\(uid)&pageID=\(pageID)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(GetTotalCountResult.self, from: data)
                
                if result.status == "success" {
                    DispatchQueue.main.async {
                        self.totalFriendsThatFollowPage = result.result
                    }
                }
                else {
                   print("Error getting friends that follow page: \(error)")
               }
            }
            catch {
                print("Error  getting friends that follow page: \(error)")
            }
        }
        
        task.resume()
    }
    
    @Published var upcomingEvents: [EventObj] = []
    
    func getUpcomingEvents(pageID: String) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/getUpcomingEvents?pageID=\(pageID)") else {return}

        print("Getting upcoming events URL: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetEventsResult.self, from: data)
                
                DispatchQueue.main.async {
                    self.upcomingEvents = result.result
                }
                
            } catch {
                
                print(error)
                
            }
        }
        
        task.resume()
    }
    
    @Published var pastEvents: [EventObj] = []
    
    func getPastEvents(pageID: String)  {
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/getPastEvents?pageID=\(pageID)")) else {return}
        
        print("Getting past events URL: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetEventsResult.self, from: data)
                
                DispatchQueue.main.async {
                    self.pastEvents = result.result
                }
                
            } catch {
                
                print(error)
                
            }
        }
        
        task.resume()

    }
    
    @Published var similarPages: [PageObj] = []
    @Published var gettingSimilarPages : Bool = false
    
    func getSimilarPages(pageID: String) async {
        self.gettingSimilarPages = true
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/getSimilarPages?pageID=\(pageID)")) else {return}
        
        print("Getting similar pages URL: \(url)")

        do {

            let (data, error) = try await URLSession.shared.data(from: url)
            
            if let results = try?JSONDecoder().decode(GetSimilarPagesResult.self, from: data) {
                
                DispatchQueue.main.async {
                    self.similarPages = results.result
                }
                
            } else {
                print("Error getting similar pages URL: \(error)")
            }
        } catch {
            print("Error getting similar pages URL: \(error)")
        }
        
        DispatchQueue.main.async {
            self.gettingSimilarPages = false
        }
    }
    
    @Published var hosts : [PageObj] = []
    
    func getHosts(eventID : String, completion: @escaping () -> ()) {

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
                            completion()
                        }
                    }
                    
                } else {
                    print("Failed to get hosts: \(result.error_msg)")
                }
    
            } catch {
                print("tthis erroe \(error)")
            }
            
        }
        
        task.resume()
            
            
        
    }
        
    @Published var pageCategories: [String] = []
    
    func getPageCategories() {
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-categories")) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode(GetPageCategoriesResult.self, from: data)

                DispatchQueue.main.async {
                    self.pageCategories = result.result
                }

            } catch {

                print(error)

            }
        }

        task.resume()
        
        
        
    }
    
    @Published var promotedEvent: EventObj?
//    = EventObj(creator: "", date: "", description: "", endTime: "", filename: "", id: "", imageurl: "", label: "", startTime: "", creatorID: "", invited: [], going: [], interested: [], declined: [], performers: [], userCreated: false, linkedEvent: "", linkedVenue: "", address: "", ticketLink: "", hosts: [], hostNames: [])
    @Published var gettingPromotedEvent : Bool = false
    
    func getPromotedEvent(pageID: String) {
//        self.gettingTotalThatFollowPage = true
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/getPromotedEvent?pageID=\(pageID)")) else {return}
        print("Getting past events URL: \(url)")

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode(GetPromotedEventResult.self, from: data)

                DispatchQueue.main.async {
                    self.promotedEvent = result.result
                }

            } catch {

                print(error)

            }
        }

        task.resume()
        
        

    }
    
    func setPromoted(pageID: String, eventID: String, completion: @escaping () -> ()) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/setPromotedEvent?pageID=\(pageID)&eventID=\(eventID)")!
        
        print("set promoted event URL: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result : [String: String] = try JSONDecoder().decode([String: String].self, from: data)
                print(result)
                
                if result["result"] == "success" {
                    completion()
                    print("Successfully changed promoted event")
                }
                
                else {
                    print("Failed to change promoted event: \(result)")
                }
                
            } catch {
                print("Error changing promoted event: \(error)")
            }
        }
        
        task.resume()
    }
    
    @Published var updatedPage : PageObj?
    
    func refreshPage(page: PageObj, completion: @escaping () -> ()) {
 
        let ref = db.collection("pages").document(page.id)
        ref.getDocument { document, error in
            if let err = error {
                print("Error refreshing user data: \(err)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                  if let data = data {
                      let id = data["id"] as? String ?? ""
                      let name = data["name"] as? String ?? ""
                      let email = data["email"] as? String ?? ""
                      let description = data["description"] as? String ?? ""
                      let promotedEvent = data["promotedEvent"] as? String ?? ""
                      let events = data["events"] as? [String]
                      let banner_url = data["banner_url"] as? String ?? ""
                      let logo_url = data["logo_url"] as? String ?? ""
                      let categories = data["categories"] as? [String]
                      let followers = data["followers"] as? [String]
                      let admins = data["admins"] as? [String]
                      let website = data["website"] as? String ?? ""
                      
//                      DispatchQueue.main.async {
                      self.updatedPage = PageObj(
                          id: id,
                          name: name,
                          email: email,
                          description: description,
                          promotedEvent: promotedEvent,
                          events: events  ?? [],
                          banner_url: banner_url,
                          logo_url: logo_url,
                          categories: categories ?? [],
                          followers: followers ?? [],
                          admins: admins ?? [],
                          website: website)
//                        }
                      completion()
                  }
            }
        }
    }

}
