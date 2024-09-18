//
//  StoriesHandler.swift
//  Luna
//
//  Created by Ned O'Rourke on 20/4/2022.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct StoryObj: Codable, Hashable {
    var url: String
    var id: String
    var uploaderID: String
    var venueID: String
    var time: String
    var date: String
    var likes: [String]
    var dislikes: [String]
    var uploaderURL: String
    var uploaderName: String
}

struct PostStoryResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: String
}

struct GetIsLikedResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: Int
}

struct GetTotalCountResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: Int
}

class storiesHandler: ObservableObject {
    
    @Published var stories : [StoryObj] = []
    @Published var gettingStories : Bool = false
    
    func getStories(venueID: String, completion: @escaping (Bool) -> ()) async {
        
        self.gettingStories = true

        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/getStories?venueID=\(venueID)") else { return }
        
        do {
            let (data, error) = try await URLSession.shared.data(from: url)
            
            if let result = try?JSONDecoder().decode([StoryObj].self, from: data) {
                let stories = result
                
                DispatchQueue.main.async {
                    self.stories = stories
                    self.gettingStories = false
                    if stories.count != 0 {
                        completion(true)
                    }
                    else {
                        completion(false)
                    }
                    
                }
                
            } else {
                print("Failed to get stories: \(error)")
                DispatchQueue.main.async {
                    self.gettingStories = false
                    completion(false)
                }
            }
        } catch {
            print("Failed to get stories: \(error)")
            DispatchQueue.main.async {
                self.gettingStories = false
                completion(false)
            }
        }
            
        
    }
    
    func postStory(uploaderID: String, venueID: String, image: UIImage, completion: @escaping () -> ()) {
        let urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/postStory?uploaderID=\(uploaderID)&venueID=\(venueID)"
        
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
                let result = try JSONDecoder().decode(PostStoryResult.self, from: data)
                if result.error_msg == "" {
                    print("post story")
                    let ref = result.result
                    self.storeStoryImage(image: image, eventRef: ref, completion: {
                        completion()
                    })
                    
                } else {
                    print("Failed to post story: \(result.error_msg)")
                }
            } catch {
                print(error)
            }
        }
        
        
        task.resume()
    }
    
    func storeStoryImage(image: UIImage, eventRef : String, completion: @escaping() -> ()) {
        print("Trying to store story image")
        let ref = storage.reference(withPath: "storyImages/\(eventRef)")
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {return}
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print(error)
                return
            }
            print("Uploaded image data for new story.")
            ref.downloadURL { url, error in
                if let error = error {
                    print(error)
                    return
                }
                let urlString = url?.absoluteString ?? ""
                print("downloaded url: \(urlString)")
                
                
                db.collection("stories").document(eventRef).updateData(["url" : url?.absoluteString ?? ""]) { error in
                    if let error = error {
                        print("Failed to store story for id: \(eventRef), error: \(error)")
                    } else {
                        print("Sucessfully stored story for id: \(eventRef)")
                        completion()
                    }
                }
            }
        }
    }
    
    func likeStory(userID: String, storyID: String, completion: @escaping () -> ()) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/like-story?userID=\(userID)&storyID=\(storyID)")!
        
        print("Like story url: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result : [String: String] = try JSONDecoder().decode([String: String].self, from: data)
                print(result)
                
                if result["result"] == "success" {
                    completion()
                    print("Successfully liked story")
                }
                
                else {
                    print("Failed to like story: \(result)")
                }
                
            } catch {
                print("Error liking story: \(error)")
            }
        }
        
        task.resume()
    }
    
    func unlikeStory(userID: String, storyID: String, completion: @escaping () -> ()) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/unlike-story?userID=\(userID)&storyID=\(storyID)")!
        
        print("Unlike story url: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result : [String: String] = try JSONDecoder().decode([String: String].self, from: data)
                print(result)
                
                if result["result"] == "success" {
                    completion()
                    print("Successfully unliked story")
                }
                
                else {
                    print("Failed to unlike story: \(result)")
                }
                
            } catch {
                print("Error unliking story: \(error)")
            }
        }
        
        task.resume()
    }

    
    func dislikeStory(userID: String, storyID: String, completion: @escaping () -> ()) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/dislike-story?userID=\(userID)&storyID=\(storyID)")!
        
        print("Dislike story url: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result : [String: String] = try JSONDecoder().decode([String: String].self, from: data)
                print(result)
                
                if result["result"] == "success" {
                    completion()
                    print("Successfully disliked story")
                }
                
                else {
                    print("Failed to dislike story: \(result)")
                }
                
            } catch {
                print("Error disliking story: \(error)")
            }
        }
        
        task.resume()
    }
    
    func undislikeStory(userID: String, storyID: String, completion: @escaping () -> ()) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/undislike-story?userID=\(userID)&storyID=\(storyID)")!
        
        print("Undislike story url: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result : [String: String] = try JSONDecoder().decode([String: String].self, from: data)
                print(result)
                
                if result["result"] == "success" {
                    completion()
                    print("Successfully undisliked story")
                }
                
                else {
                    print("Failed to undislike story: \(result)")
                }
                
            } catch {
                print("Error undisliking story: \(error)")
            }
        }
        
        task.resume()
    }
    
    @Published var isLiked: Int = 0
    @Published var gettingisLiked : Bool = false
    
    func checkLikeStatus(userID: String, storyID: String) async {
        self.gettingisLiked = true
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/check-like-status?userID=\(userID)&storyID=\(storyID)")) else {return}
        
        print("Check like status URL: \(url)")

        do {

            let (data, error) = try await URLSession.shared.data(from: url)
            
            if let results = try?JSONDecoder().decode(GetIsLikedResult.self, from: data) {
                print("the result is \(results.result)")
                
                DispatchQueue.main.async {
                    self.isLiked = results.result
                }
                
            } else {
                print("Error getting isFollowed: \(error)")
            }
        } catch {
            print("Error getting isFollowed: \(error)")
        }
        
        DispatchQueue.main.async {
            self.gettingisLiked = false
        }
    }
    
    @Published var totalCount: Int = 0
    @Published var gettingTotalCount : Bool = false
    
    func getCountOfStory(storyID: String) async {
        self.gettingTotalCount = true
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-count-of-story?storyID=\(storyID)")) else {return}
        
        print("Getting total count of story URL: \(url)")

        do {

            let (data, error) = try await URLSession.shared.data(from: url)
            
            if let results = try?JSONDecoder().decode(GetTotalCountResult.self, from: data) {
                
                DispatchQueue.main.async {
                    self.totalCount = results.result
                }
                
            } else {
                print("Error getting total count of story URL: \(error)")
            }
        } catch {
            print("Error getting total count of story URL: \(error)")
        }
        
        DispatchQueue.main.async {
            self.gettingTotalCount = false
        }
    }
    
    @Published var venue : VenueObj?
    
    func getVenue(venue: String, token: String, completion: @escaping (_ venue: VenueObj?) -> ()) {

        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-venue?venue=\(venue)&token=\(token)") else {
            print("Failed to build getVenue URL")
            completion(nil)
            return
            
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Failed to get data from server")
                completion(nil)
                return
                
            }
            
            if let error = error {
                print("Failed to get venue from event: \(error)")
                completion(nil)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(GetVenueResult.self, from: data)
                print("result : \(result)")
                if result.error_msg == "" {
                    let venue = result.result
                    print("Got venue from event : \(venue)")
                    
                    DispatchQueue.main.async {
                        self.venue = venue
                    }
                    completion(venue)
                } else {
                    print("Failed to get venue: \(result.error_msg)")
                }
    
            } catch {
                print(error)
            }
            
            
            
            
           
            
        }
        
        task.resume()
            
            
        
    }
    
    @Published var tileStories : [StoryObj] = []
    @Published var gettingTileStory : Bool = false
    func getTileStory(venueID: String, completion: @escaping (StoryObj?) -> ()) async {
        
        self.gettingTileStory = true

        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/getStories?venueID=\(venueID)") else { return }
        
        do {
            let (data, error) = try await URLSession.shared.data(from: url)
            
            if let result = try?JSONDecoder().decode([StoryObj].self, from: data) {
                let stories = result
                
                DispatchQueue.main.async {
                    self.tileStories = stories
                    self.gettingTileStory = false
                    if result.count > 0 {
                        completion(result[0])
                    } else {
                        completion(nil)
                    }
                }
                
            } else {
                print("Failed to get stories: \(error)")
                DispatchQueue.main.async {
                    self.gettingTileStory = false
                }
                completion(nil)
            }
        } catch {
            print("Failed to get stories: \(error)")
            DispatchQueue.main.async {
                self.gettingTileStory = false
            }
            completion(nil)
        }
            
        
    }
    
    func deleteSory(storyID : String, completion: @escaping () -> ()) {
        
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/delete-story?storyID=\(storyID)") else { return }
        
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result : [String: String] = try JSONDecoder().decode([String: String].self, from: data)
                print(result)
                
                if result["status"] == "success" {
                    completion()
                    print("Successfully deleted story")
                }
                
                else {
                    print("Failed to delete story: \(result)")
                }
                
            } catch {
                print("Error deleting story: \(error)")
            }
        }
        
        task.resume()
    }
}
