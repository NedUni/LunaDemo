//
//  SessionService.swift
//  Luna
//
//  Created by Ned O'Rourke on 8/1/22.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseDynamicLinks
import MapKit
import FirebaseMessaging
import FacebookCore
import FacebookLogin

struct SessionUser {
    var uid: String
    var firstName: String
    var lastName: String
    var dob: String
    var imageURL: String
    var email: String
    var friends: [String]
    var incomingRequests: [String]
    var outgoingRequests: [String]
    var interested: [String]
    var going: [String]
    var favourites: [String]
    var token : String
    var streak : Int
    var pages : [String]
    var followingPages: [String]
    var stories: [String]
    var phone: String
    var performer : Bool
}

struct GenericGetResult: Codable, Hashable {
    let error_msg : String
    let result: String
}
struct GetUserByUIDResult: Decodable, Hashable {
    let error_msg : String
    let result: UserObj
}

struct GetFriendsInterested: Decodable, Hashable {
    let error_msg : String
    let result: [UserObj]
    let status: String
}

struct getCheckinsResult: Decodable, Hashable {
    let error_msg : String
    let result: [String]
}

struct GenericGetResult2: Codable, Hashable {
    let status : String
    let error_msg: String
}

struct GetUsersResult: Decodable, Hashable {
    let status : String
    let error_msg: String
    let result: [UserObj]
}

struct GetUnreadResult: Decodable, Hashable {
    let status : String
    let error_msg: String
    let result: Int
}

struct GetEventByIDResult: Decodable, Hashable {
//    let status : String
    let error_msg: String
    let result: EventObj
}

struct GetMutualFriendCountResult: Decodable, Hashable {
    let status : String
    let error_msg: String
    let result: Int
}

struct GetVenueByIDResult : Decodable, Hashable {
    let error_msg: String
    let result: VenueObj
}

struct GetDealByIDResult : Decodable, Hashable {
    let status: String
    let error_msg: String
    let result: DealObj
}

struct getHeadlineResult: Decodable, Hashable {
    let status : String
    let error_msg: String
    let result: String
}








class SessionServiceImpl: ObservableObject {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Published var signedIn = false
    @Published var userDetails = SessionUser(uid: auth.currentUser?.uid ?? "", firstName: "", lastName: "", dob: "", imageURL: "", email: "", friends: [], incomingRequests: [], outgoingRequests: [], interested: [], going: [], favourites: [], token: "", streak: 0, pages: [], followingPages: [], stories: [], phone: "", performer: false)
    
    func parseComponents(from url: URL) -> String {
      // 1
      guard url.scheme == "https" else {
        return ""
      }
      // 2
      guard url.pathComponents.contains("event") else {
        return ""
      }
      // 3
      guard let query = url.query else {
        return ""
      }
      // 4
      let components = query.split(separator: ",").flatMap {
        $0.split(separator: "=")
      }
      // 5
      guard let idIndex = components.firstIndex(of: Substring("event")) else {
        return ""
      }
      // 6
      guard idIndex + 1 < components.count else {
        return ""
      }
      // 7
        let id = String(components[idIndex + 1])
        print(id)
      return id
    }
    
    func togglePerfomerAccount(uid: String, completion: @escaping (Error?) -> ()) {
        if userDetails.performer {
            db.collection("profiles").document(uid).updateData(["performer" : false]) { error in
                if let error = error {
                    completion(error)
                    return
                }
                
                completion(nil)
            }
        } else {
            db.collection("profiles").document(uid).updateData(["performer" : true]) { error in
                if let error = error {
                    completion(error)
                    return
                }
                
                completion(nil)
            }
        }
    }
    
    
    func createDynamicLinkEvent(event: EventObj, completion: @escaping (URL?) -> ()) {
//        do {
//            let jsonEncoder = JSONEncoder()
//            let jsonData = try jsonEncoder.encode(event)
//            let json = String(data: jsonData, encoding: String.Encoding.utf16)
            
            let urlString = "https://www.luna-group.com.au/event?event=\(event.id)"
            
            
            guard let link = URL(string: urlString) else {
                print("Failed to build URL")
                completion(nil)
                return
            }
            
            let dynamicLinksDomainURIPrefix = "https://luna-group.com.au/link"
            let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
            linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "Luna.App")
            linkBuilder?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
            linkBuilder?.socialMetaTagParameters?.title = event.label
            linkBuilder?.socialMetaTagParameters?.imageURL = URL(string: "https://luna-web-v2vnbf3xma-ts.a.run.app/static/images/lunalogo.png")
            
            guard let longDynamicLink = linkBuilder?.url else {
                completion(nil)
                return
            }
            print("The long URL is: \(longDynamicLink)")
            
            linkBuilder?.shorten { url, warnings, error in
              if let error = error {
                print("Oh no! Got an error! \(error)")
                completion(nil)
              }
              if let warnings = warnings {
                for warning in warnings {
                  print("Warning: \(warning)")
                }
              }
              guard let url = url else { return }
              print("short url is: \(url.absoluteString)")
                completion(url)

            }
            
            
            
//        } catch {
//            print("Error creating dynamic link for event: \(error)")
//        }
        
        
    }
    
    func getVenueByID(id: String, completion: @escaping (VenueObj?) -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-venue?venue=\(id)&token=\(token)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetVenueByIDResult.self, from: data)
                if result.error_msg == "" {
                    let venue = result.result
                    completion(venue)
                } else {
                    print("Error getting venue by id: \(result.error_msg)")
                    completion(nil)
                }
            } catch {
                print("Error getting venue by id: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func getEventByID(id: String, completion: @escaping (EventObj?) -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-event?event=\(id)&token=\(token)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetEventByIDResult.self, from: data)
                if result.error_msg == "" {
                    let event = result.result
                    completion(event)
                } else {
                    print("Error getting user by uid: \(result.error_msg)")
                    completion(nil)
                }
            } catch {
                print("Error getting user by uid: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func getDealByID(id: String, completion: @escaping (DealObj?) -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-deal?deal=\(id)&token=\(token)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetDealByIDResult.self, from: data)
                if result.error_msg == "" {
                    let deal = result.result
                    completion(deal)
                } else {
                    print("Error getting deal by id: \(result.error_msg)")
                    completion(nil)
                }
            } catch {
                print("Error getting deal by id: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func getVenueID(venue: VenueObj) -> String {
        return String(venue.id)
    }
    
    func getEventID(event: EventObj) -> String {
        return String(event.id)
    }
    
    func updateFCM() {
        let checkToken = Messaging.messaging().fcmToken ?? "No Token"
        if checkToken != "No Token" {
            let fcm = checkToken
            let uid = self.getUID()
            if uid != "" {
                db.collection("profiles").document(uid).updateData(["FCM" : fcm]) { error in
                    if let error = error {
                        print("Error updating FCM token: \(error)")
                        return
                    }
                    
                    self.refreshUserDetails()
                }
            }
            
        }
    }
    
    @Published var unread : Int = 0
    
    func getUnreadCount(uid: String, token: String) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/gettotalunread?uid=\(uid)&token=\(token)") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let response  = try JSONDecoder().decode(GetUnreadResult.self, from: data)
                
                if response.status == "success" {
                    DispatchQueue.main.async {
                        self.unread = response.result
                        UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (granted, error) in
                            if error != nil {
                                print("Error requesting notification auth: \(error!.localizedDescription)")
                            } else {
                                DispatchQueue.main.async {
                                    UIApplication.shared.applicationIconBadgeNumber = response.result
                                }
                            }
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
    
    func checkIn(venueID: String, UID: String, time: Int, completion: @escaping () -> ()) {
        
        getFCMToken()
        
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/checkin?id=\(UID)&venue=\(venueID)&time=\(time)&token=\(self.token)&FCM=\(self.FCMToken)")!
        
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result  = try JSONDecoder().decode([String: String].self, from: data)
                print(result)
                
                if result["result"] == "success" {
                    print("Successfully checked in with time \(time)")
                    completion()
                }
                
                else {
                    print("Failed to check in: \(String(describing: result["error_msg"]))")
                }
                
            } catch {
                print("Failed to check in: \(error)")
            }
        }
        
        task.resume()
    }
    
    @Published var activeCheckin : VenueObj?
    
    func getActiveCheckin(uid: String, completion: @escaping () -> ()) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/getactivecheckin?id=\(uid)")!
        print(url)
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            guard let data = data else { return }

            
            do {
                let result = try JSONDecoder().decode(ActiveCheckinResult.self, from: data)
                if result.status == "success" {
                    DispatchQueue.main.async {
                        self?.activeCheckin = result.result
                    }
                } else {
                    print("Failed to get active checkin: \(result.error_msg)")
                    self?.activeCheckin = nil
                }
                
            } catch {
                print("Failed to get active checkin: \(error)")
                
                DispatchQueue.main.async {
                    self?.activeCheckin = nil
                }
            }
        }
        
        completion()
        
        task.resume()
    }
    
    func updateCheckin(venue: String, uid: String, wait: Int, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/update-checkin?uid=\(uid)&venue=\(venue)&wait=\(wait)") else {return}

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result : [String: String] = try JSONDecoder().decode([String: String].self, from: data)
                print(result)
                
                if result["status"] == "success" {
                    print("Successfully updated checkin")
                    
                }
                
                else {
                    print("Failed to updaete checkin: \(String(describing: result["error_msg"]))")
                }
                
            } catch {
                print(error)
            }
        }
        completion()
        
        task.resume()
    }
    
    func checkOut(venueID: String, UID: String, completion: @escaping () -> ()) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/checkout?id=\(UID)&venue=\(venueID)&token=\(self.token)")!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result : [String: String] = try JSONDecoder().decode([String: String].self, from: data)
                print(result)
                
                if result["result"] == "success" {
                    print("Successfully checked out")
                    completion()
                }
                
                else {
                    print("Failed to check out: \(String(describing: result["error_msg"]))")
                }
                
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func updateStreak(id: String) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/updatestreak?id=\(id)&token=\(self.token)") else { return }
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GenericGetResult2.self, from: data)
                if result.error_msg == "" {
                    print("Updated streak")
                    
                } else {
                    print("Failed to update streak for user \(id): \(result.error_msg)")
                }
            } catch {
                print("Failed to update streak for user \(id): \(error)")
            }
        }
        
        task.resume()
    }
    
    
    func sendFriendRequest(sender: String, recipient: String, completion: @escaping () -> ()) {
        
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/send-friend-request?sender=\(sender)&recipient=\(recipient)&token=\(self.token)")!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                print("sender: \(sender), recipient: \(recipient)")
                let result : [String : String] = try JSONDecoder().decode([String: String].self, from: data)
                if result["result"] == "success" {
                    print("Succesfully sent friend request from user \(sender) to \(recipient)")
                    completion()
                } else {
                    print("Failed to send friend request, error: \(result["error_msg"] ?? "")")
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
        
    }
    
    
    
    @Published var currentFriends : [UserObj] = []
    
    func getFriends(uid: String, completion: @escaping () -> ()) {

        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/getfriends?id=\(uid)&token=\(self.token)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetUsersResult.self, from: data)
                if result.error_msg == "" {
                    print("Got friend requests.")
                    DispatchQueue.main.async {
                        self.currentFriends = result.result
                   }
    
                
                } else {
                    print("Failed to get current friends: \(error)")
                }
            } catch {
                print(error)
            }
        }
        
        completion()
        task.resume()
        
//        do {
//            let (data, error) = try await URLSession.shared.data(from: url)
//
//            if let result = try?JSONDecoder().decode(GetUsersResult.self, from: data) {
//                let users = result.result
//
//                DispatchQueue.main.async {
//                    if users != self.currentFriends {
//                        self.currentFriends = users
//                    }
//                    self.gettingFriends = false
//                }
//            } else {
//                print("Failed to get friends: \(error)")
//                DispatchQueue.main.async {
//                    self.gettingFriends = false
//                }
//            }
//        } catch {
//            print("Failed to get friends: \(error)")
//            DispatchQueue.main.async {
//                self.gettingFriends = false
//            }
//        }
            
        
            
    }
    
    func getUserByID(uid: String, token: String, completion: @escaping (_ user: UserObj?) -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-user?id=\(uid)&token=\(token)") else { return }
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetUserByUIDResult.self, from: data)
                if result.error_msg == "" {
                    let user = result.result
                    completion(user)
                } else {
                    print("Error getting user by uid: \(result.error_msg)")
                    completion(nil)
                }
            } catch {
                print(error)
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    @Published var currentFriendRequests : [UserObj] = []
    
    func getFriendRequests(uid: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/getfriendrequests?id=\(uid)&token=\(self.token)") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetUsersResult.self, from: data)
                if result.error_msg == "" {
                    print("Got friend requests.")
                    DispatchQueue.main.async {
                        self.currentFriendRequests = result.result
                   }
    
                
                } else {
                    print("Failed to add user to current friend requests: \(error)")
                }
            } catch {
                print(error)
            }
        }
        completion()
        task.resume()
    }
    
    func acceptFriendRequest(sender: String, recipient: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/accept-friend-request?sender=\(sender)&recipient=\(recipient)&token=\(self.token)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GenericGetResult.self, from: data)
                if result.error_msg == "" {
                    print("User \(recipient) accepted friend request from user \(sender)")

                    self.refreshUserDetails()
                    
                    completion()
                
                } else {
                    print("Failed to accept friend request: \(result.error_msg)")
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
        
        
    }
    
    func declineFriendRequest(sender: String, recipient: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/cancel-friend-request?sender=\(sender)&recipient=\(recipient)&token=\(self.token)") else { return }
        
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GenericGetResult.self, from: data)
                if result.error_msg == "" {
                    print("User \(recipient) declined friend request from user \(sender)")
                    self.refreshUserDetails()
                    
                    completion()

                } else {
                    print("Failed to decline friend request: \(result.error_msg)")
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
        
        
    }
    
    func removeFriend(user1: String, user2: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/remove-friend?user1=\(user1)&user2=\(user2)&token=\(self.token)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GenericGetResult.self, from: data)
                if result.error_msg == "" {
                    print("Removed friends")
                    
                    completion()
                    
                } else {
                    print("Failed to remove friends: \(result.error_msg)")
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
        
    }
    
    func userExists(phone: String, completion: @escaping (Bool) -> ()) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/user-exists?phone=\(phone)") else { return }
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GenericGetResult.self, from: data)
                if result.error_msg == "" {
                    
                    completion(Bool(result.result)!)
                    
                } else {
                    print("Failed to get user exists result: \(result.error_msg)")
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func phoneSignInVerification(phoneNumber: String, new: Bool, completion: @escaping (String?, String?) -> ()) {
    
        
//        let testPhoneNumber = "+1 499-999-9999"
        if !new {
            userExists(phone: phoneNumber) { result in
                if result == false {
                    completion(nil, "User does not exist")
                    return
                }
            
                else {
                 Auth.auth().settings?.isAppVerificationDisabledForTesting = false
                 PhoneAuthProvider.provider()
                   .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                       if let error = error {
                           print("error verifying phone number \(error.localizedDescription)")
                           completion(nil, error.localizedDescription)
                           return
                       }
                       
                       print("Phone verification id is: \(String(describing: verificationID))")
                       completion(verificationID, nil)

                   }
                             
                }
            }
        } else {
            userExists(phone: phoneNumber) { result in
                if result == true {
                    completion(nil, "User already exists.")
                    return
                }
            
                Auth.auth().settings?.isAppVerificationDisabledForTesting = false
                PhoneAuthProvider.provider()
                  .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                  if let error = error {
                      print("error verifying phone number \(error.localizedDescription)")
                      completion(nil, error.localizedDescription)
                      return
                  }
                  
                  print("Phone verification id is: \(String(describing: verificationID))")
                  completion(verificationID, nil)

              }
            }
        }
        
    }
    
    func getPhoneAuthCredential(code : String, verificationID: String, completion: @escaping (PhoneAuthCredential?) -> ()) {
//        let testVerificationCode = "123456"
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ,
                                                                 verificationCode: code)
        print("Credential is: \(credential)")
        completion(credential)
        
        
    }
    
    func phoneSignIn(credential: PhoneAuthCredential, completion: @escaping (Error?) -> ()) {
        auth.signIn(with: credential) { authData, error in
          if let error = error {
            // Handles error
              print("Error signing in with phone number: \(error)")
              completion(error)
              return
              
          }
            
            self.getToken()
            DispatchQueue.main.async {
                self.signedIn = true
            }
            
            self.refreshUserDetails()
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                print("Requested notifications")
                if let error = error {
                    print("Error requesting notification authorisation: \(error)")
                    // Handle the error here.
                }
                
                // Enable or disable features based on the authorization.
            }
            
            self.delegate.locationManager.requestPermissions()
            
            completion(nil)
            
            
//            print("\(authData)")
//            DispatchQueue.main.async {
//                self.signedIn = true
//            }
            
        }
    }
    @Published var signedUp = false
    
    func completePhoneSignUp(phone: String, image: UIImage, firstName: String, lastName: String, dob: String, credential: PhoneAuthCredential, completion: @escaping (Error?) -> ()) {
        var adjustedPhone = phone.dropFirst(1)
        adjustedPhone = "+61" + adjustedPhone
        
        auth.signIn(with: credential) { authData, error in
          if let error = error {
            // Handles error
              print("Error signing in with phone number: \(error)")
              completion(error)
              return
          }
            
            self.getFCMToken()
            self.getToken()
            
            DispatchQueue.main.async {
                  self.userDetails = SessionUser(
                    uid: auth.currentUser!.uid ,
                    firstName: firstName,
                    lastName: lastName,
                    dob: dob,
                    imageURL: "",
                    email: "",
                    friends: [],
                    incomingRequests: [],
                    outgoingRequests: [],
                    interested: [],
                    going: [],
                    favourites: [],
                    token: self.token,
                    streak: 0,
                    pages: [],
                    followingPages: [],
                    stories: [],
                    phone: String(adjustedPhone),
                    performer: false)
              }
            
            self.storeImage(image: image, completion: completion)
        }
            
//
        
    }
    
    func fbSignIn(loginResult : LoginManagerLoginResult, data : [String: Any], url: String) {
        // Exchange fb token for firebase credential
        let credential = FacebookAuthProvider
          .credential(withAccessToken: AccessToken.current!.tokenString)
        
        auth.signIn(with: credential) { result, error in
            if let error = error {
                print("Error signing in with facebook: \(error)")
            }
            
            print("Signed in with facebook \(String(describing: result?.user.uid))")
            
            self.getFCMToken()
            self.getToken()
            DispatchQueue.main.async {
                self.signedIn = true
            }
            
            let dob = data["birthday"] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let dobObj = dateFormatter.date(from: dob)
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let formattedDob = dateFormatter.string(from: dobObj!)
            
            
            self.storeUserInformation(email: (result?.user.email!)!, firstName: data["first_name"] as! String, lastName: data["last_name"] as! String, dob: formattedDob, imageURL: url, phone: "", completion: {error in})

        }
    }
    
    @Published var registerError : String = ""
    
    func register(email: String, password: String, firstName: String, lastName: String, dob: String, image: UIImage, completion: @escaping () -> ()) {
        getFCMToken()
        self.registerError = ""
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.registerError = error.localizedDescription
                
                print("Error creating new authenticated user: \(error)")
                completion()
                return
            }
           
            print("Succesfully created user: \(result?.user.uid ?? "") ")
            self.getToken()
            DispatchQueue.main.async {
                self.signedIn = true
            }
            
            self.refreshUserDetails()
            
            DispatchQueue.main.async {
                  self.userDetails = SessionUser(
                    uid: result?.user.uid ?? "",
                    firstName: firstName,
                    lastName: lastName,
                    dob: dob,
                    imageURL: "",
                    email: email,
                    friends: [],
                    incomingRequests: [],
                    outgoingRequests: [],
                    interested: [],
                    going: [],
                    favourites: [],
                    token: self.token,
                    streak: 0,
                    pages: [],
                    followingPages: [],
                    stories: [],
                    phone: "",
                    performer: false)
              }
//
            
//            print("image data is \(image.configuration)")
//            print("image data is \(image.pngData())")
//            print("image data is \(image.ciImage)")
//            print("image data is \(image.sd_imageFormat)")
//            print("image data is ssytem \(image.isSymbolImage)")
//
//            if image.isSymbolImage {
//                self.storeImage(image: UIImage)
//            }
//
            self.storeImage(image: image, completion: { error in
                completion()
            })
                
            
            
        }
    }
    
    func resetPassword(email: String, resetCompletion:@escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if let error = error {
                resetCompletion(.failure(error))
            }
            else {
                resetCompletion(.success(true))
            }
        })
    }
    
//    @Published var signedUp = false
    
    func storeUserInformation(email: String, firstName: String, lastName: String, dob: String, imageURL: String, phone: String, completion: @escaping (Error?) -> ()) {
        let userDoc = db.collection("profiles").document(self.getUID())
        
        userDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                print("User doc already exists, updating information.")
                let userData = [
                    "firstName" : firstName,
                    "lastName" : lastName,
                    "email" : email,
                    "imageURL" : imageURL,
                    "FCM": self.FCMToken,
                    "dob" : dob,
                    "phone" : phone
                ] as [String : Any]
                
                userDoc.updateData(userData) { error in
                    if let error = error {
                        print("Error updating user document: \(error)")
                        completion(error)
                    } else {
                        print("Successfully updated user document.")
                    }
                }
            } else {
                print("Creating new user in firestore.")
                let userData = [
                    "uid" : self.getUID(),
                    "firstName" : firstName,
                    "lastName" : lastName,
                    "dob" : dob,
                    "email" : email,
                    "imageURL" : imageURL,
                    "FCM": self.FCMToken,
                    "friends" : [],
                    "favourites" : [],
                    "incomingRequests" : [],
                    "outgoingRequests" : [],
                    "streak" : 0,
                    "pages" : [],
                    "followingPages" : [],
                    "phone": phone,
                    "performer" : false
                ] as [String : Any]
                
                userDoc.setData(userData) { error in
                    if let error = error {
                        print("Error uploading user data to database: \(error)")
                        completion(error)
                        return
                    }
                    else {
                        print("Successfully uploaded user data for user: \(self.getUID())")
                    }
                }
                
                DispatchQueue.main.async {
                  self.userDetails = SessionUser(
                    uid: self.getUID(),
                    firstName: firstName,
                    lastName: lastName,
                    dob: dob,
                    imageURL: imageURL,
                    email: email,
                    friends: [],
                    incomingRequests: [],
                    outgoingRequests: [],
                    interested: [],
                    going: [],
                    favourites: [],
                    token: self.token,
                    streak: 0,
                    pages: [],
                    followingPages: [],
                    stories: [],
                    phone: phone,
                    performer: false)
                }
                
                self.signedIn = true
                
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    print("Requested notifications")
                    if let error = error {
                        print("Error requesting notification authorisation: \(error)")
                        // Handle the error here.
                    }
                    
                    // Enable or disable features based on the authorization.
                }
                self.delegate.locationManager.requestPermissions()
            }
                
        }
         
            
        self.refreshUserDetails()
        
    }
    
    @Published var loginError : String = ""
    
    func login(email: String, password: String, completion: @escaping () -> ()) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.loginError = error.localizedDescription
                print("Error signing in: \(error)")
                completion()
                return
            }
            print("Succesfully signed in user: \(result?.user.uid ?? "") ")
            self.getToken()
            
            DispatchQueue.main.async {
                self.signedIn = true
            }

            let uid = result?.user.uid ?? ""
            let ref = db.collection("profiles").document(uid)
            ref.getDocument { document, error in
                if let error = error {
                    self.loginError = error.localizedDescription
                    print("Error refreshing user data: \(error)")
                    completion()
                    return
                }
                
                if let document = document, document.exists {
                      let data = document.data()
                      if let data = data {
                          let firstName = data["firstName"] as? String ?? ""
                          let lastName = data["lastName"] as? String ?? ""
                          let dob = data["dob"] as? String ?? ""
                          let imageURL = data["imageURL"] as? String ?? ""
                          let email = data["email"] as? String ?? ""
                          let friends = data["friends"] as? [String]
                          let incomingRequests = data["incomingRequests"] as? [String]
                          let outgoingRequests = data["outgoingRequests"] as? [String]
                          let interested = data["interested"] as? [String]
                          let going = data["going"] as? [String]
                          let favourites = data["favourites"] as? [String]
                          let streak = data["streak"] as? Int ?? 0
                          let pages = data["pages"] as? [String]
                          let followingPages = data["followingPages"] as? [String]
                          let stories = data["stories"] as? [String]
                          let phone = data["phone"] as? String ?? ""
                          let performer = data["performer"] as? Bool ?? false
                          
                          DispatchQueue.main.async {
                                self.userDetails = SessionUser(
                                  uid: uid,
                                  firstName: firstName,
                                  lastName: lastName,
                                  dob: dob,
                                  imageURL: imageURL,
                                  email: email,
                                  friends: friends ?? [],
                                  incomingRequests: incomingRequests ?? [],
                                  outgoingRequests: outgoingRequests ?? [],
                                  interested: interested ?? [],
                                  going: going ?? [],
                                  favourites: favourites ?? [],
                                  token: self.token,
                                  streak : streak,
                                  pages: pages ?? [],
                                  followingPages: followingPages ?? [],
                                  stories: stories ?? [],
                                  phone: phone,
                                  performer: performer)
                          }
                          self.refreshUserDetails()
                      }
                }
            }
            completion()
        }
    }
    
    func tokenRturn(completion: @escaping (String) -> ()) {
        guard let currentUser = auth.currentUser else {return}
        currentUser.getIDTokenForcingRefresh(true) { idToken, error in
          if let error = error {
                print("Error getting user ID Token: \(error)")
                completion("")
          } else {
              DispatchQueue.main.async {
                  self.token = idToken ?? ""
              }
              completion(idToken ?? "")
          }
        }
    }
    
    @Published var asynctoken : String = ""
    func getTokenAsync() {
        guard let currentUser = auth.currentUser else {return}
        currentUser.getIDTokenForcingRefresh(true) { idToken, error in
          if let error = error {
            print("Error getting user ID Token: \(error)")
            return
          } else {
              print("Retrieved user ID Token: \(idToken ?? "")")
              DispatchQueue.main.async {
                  self.token = idToken ?? ""
              }
          }

          // Send token to your backend via HTTPS
          // ...
        }
    }
    
    @Published var token : String = ""
    func getToken() {
        guard let currentUser = auth.currentUser else {return}
        currentUser.getIDTokenForcingRefresh(true) { idToken, error in
          if let error = error {
            print("Error getting user ID Token: \(error)")
            return
          } else {
              print("Retrieved user ID Token: \(idToken ?? "")")
              DispatchQueue.main.async {
                  self.token = idToken ?? ""
              }
          }

          // Send token to your backend via HTTPS
          // ...
        }
    }
    
    func getAuthToken() {
        guard let currentUser = auth.currentUser else {return}
        currentUser.getIDTokenForcingRefresh(true) { idToken, error in
          if let error = error {
            print("Error getting user ID Token: \(error)")
            return
          } else {
              print("Retrieved user ID Token: \(idToken ?? "")")
              DispatchQueue.main.async {
                  self.token = idToken ?? ""
              }
          }

          // Send token to your backend via HTTPS
          // ...
        }
    }
    
    
    @Published var FCMToken = ""
    func getFCMToken() {
        let checkToken = Messaging.messaging().fcmToken ?? "No Token"
        if checkToken != "No Token" {
            print("FCM token: \(checkToken)")
            FCMToken = checkToken
        }
        
    }
    
//    @Published var imageURL = ""
    
    func storeImage(image: UIImage, completion: @escaping (Error?) -> ()) {
        print("Trying to store")
        let uid = auth.currentUser!.uid
//        else {
//            print("failed to get uid")
//            return
//        }
//        let uid = Auth.auth().currentUser?.uid
        print("got uid \(uid)")
        let ref = storage.reference(withPath: "users/profilePictures/\(uid)/")
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {return}
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print(error)
                completion(error)
                return
            }
            print("Uploaded image data for user: \(uid)")
            ref.downloadURL { url, error in
                if let error = error {
                    print(error)
                    completion(error)
                    return
                }
                print("downloaded url: \(url?.absoluteString ?? "")")
                
                DispatchQueue.main.async {
                    self.userDetails.imageURL = (url?.absoluteString ?? "")
                }
                
                self.storeUserInformation(email: self.userDetails.email, firstName: self.userDetails.firstName, lastName: self.userDetails.lastName, dob: self.userDetails.dob, imageURL: url?.absoluteString ?? "", phone: self.userDetails.phone, completion: completion)
                
            }
        }

        
    }
    
//    func storeSong() {
//        print("Trying to store")
//        guard let uid = Auth.auth().currentUser?.uid else {
//            print("failed to get uid")
//            return
//        }
//        let ref = storage.reference(withPath: "users/songs/\(uid)/")
//
//        ref.putData(imageData, metadata: nil) { metadata, error in
//            if let error = error {
//                print(error)
//                completion(error)
//                return
//            }
//            print("Uploaded image data for user: \(uid)")
//            ref.downloadURL { url, error in
//                if let error = error {
//                    print(error)
//                    completion(error)
//                    return
//                }
//                print("downloaded url: \(url?.absoluteString ?? "")")
//
////                DispatchQueue.main.async {
////                    self.userDetails.imageURL = (url?.absoluteString ?? "")
////                }
//
////                self.storeUserInformation(email: self.userDetails.email, firstName: self.userDetails.firstName, lastName: self.userDetails.lastName, dob: self.userDetails.dob, imageURL: url?.absoluteString ?? "", phone: self.userDetails.phone, completion: completion)
//
//            }
//        }
//    }
    
    
    func logout() {
        if auth.currentUser != nil {
            do {
                let uid = auth.currentUser!.uid
//                else {return}
                try auth.signOut()
                loginManager.logOut()
                
                db.collection("profiles").document(uid).updateData(["FCM" : ""]) { error in
                    if let error = error {
                        print("Error wiping FCM : \(error)")
                    }
                }
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
                return
                
            }
            
        }
        
        DispatchQueue.main.async {
            self.signedIn = false
        }
    }
    
    func isSignedIn() -> Bool {
        if auth.currentUser != nil {
           
            return true
        } else {
            return false
        }
    }
    
    func getUID() -> String {
        if auth.currentUser == nil {
            return ""
        } else {
            return auth.currentUser!.uid
        }
    }
    
    func refreshUserDetails() {
        
        let uid = auth.currentUser!.uid
        print("uid is \(uid)")
 
        let ref = db.collection("profiles").document(uid)
        ref.getDocument { document, error in
            if let err = error {
                print("Error refreshing user data: \(err)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()

                  if let data = data {
                      let firstName = data["firstName"] as? String ?? ""
                      let lastName = data["lastName"] as? String ?? ""
                      let dob = data["dob"] as? String ?? ""
                      let imageURL = data["imageURL"] as? String ?? ""
                      let email = data["email"] as? String ?? ""
                      let friends = data["friends"] as? [String]
                      let incomingRequests = data["incomingRequests"] as? [String]
                      let outgoingRequests = data["outgoingRequests"] as? [String]
                      let interested = data["interested"] as? [String]
                      let going = data["going"] as? [String]
                      let favourites = data["favourites"] as? [String]
                      let streak = data["streak"] as? Int ?? 0
                      let pages = data["pages"] as? [String]
                      let followingPages = data["followingPages"] as? [String]
                      let stories = data["stories"] as? [String]
                      let phone = data["phone"] as? String ?? ""
                      let performer = data["performer"] as? Bool ?? false
                      
                      DispatchQueue.main.async {
                            self.userDetails = SessionUser(
                              uid: uid,
                              firstName: firstName,
                              lastName: lastName,
                              dob: dob,
                              imageURL: imageURL,
                              email: email,
                              friends: friends ?? [],
                              incomingRequests: incomingRequests ?? [],
                              outgoingRequests: outgoingRequests ?? [],
                              interested: interested ?? [],
                              going: going ?? [],
                              favourites: favourites ?? [],
                              token: self.token,
                              streak: streak,
                              pages: pages ?? [],
                              followingPages: followingPages ?? [],
                              stories: stories ?? [],
                              phone: phone,
                              performer: performer)
                        }
                  }
            }
        }
    }
    
    
    func eventInterest(venueID: String, uid: String, eventID: String) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/interested-event?id=\(uid)&venue=\(venueID)&event=\(eventID)&token=\(self.token)")!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result : [String: String] = try JSONDecoder().decode([String: String].self, from: data)
                print(result)
                
                if result["result"] == "success" {
                    print("Successfully lodged interest")
                }
                
                else {
                    print("bad interest")
                }
                
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func eventInterestRemove(venueID: String, uid: String, eventID: String) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/remove-interest?id=\(uid)&venue=\(venueID)&event=\(eventID)&token=\(self.token)")!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result : [String: String] = try JSONDecoder().decode([String: String].self, from: data)
                print(result)
                
                if result["result"] == "success" {
                    print("Successfully removed interest")
                }
                
                else {
                    print("Failed to remove interest")
                }
                
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    @Published var searchPeopleResults: [UserObj] = []
    @Published var searchEventResults: [EventObj] = []
    @Published var searchVenueResults: [VenueObj] = []
    @Published var searchPageResults: [PageObj] = []
    
    func searchVenues(term: String, option: Int) {
        self.searchVenueResults = []
        self.searchPeopleResults = []
        let urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/search?term=\(term)&option=\(option)&token=\(self.token)"
        guard let encodedURL = (URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")) else { return }

        let task = URLSession.shared.dataTask(with: encodedURL) {[weak self] data, response, error in
            guard let data = data else { return }
            print("Searching for \(term)")
            print("Got data: \(data)")

            
            do {
                if option == 1 {
                    let results = try JSONDecoder().decode([VenueObj].self, from: data)
                    print("Got the following results from search: \n \(results)")
                    DispatchQueue.main.async {
                        self?.searchVenueResults = results
                    }
                }
                
                else if option == 4 {
                    let results = try JSONDecoder().decode([EventObj].self, from: data)
                    print("Got the following results from search: \n \(results)")
                    DispatchQueue.main.async {
                        self?.searchEventResults = results
                    }
                }
                else if option == 3 {
                    let results = try JSONDecoder().decode([PageObj].self, from: data)
                    print("Got the following results from search: \n \(results)")
                    DispatchQueue.main.async {
                        self?.searchPageResults = results
                    }
                }
                else {
                    let results = try JSONDecoder().decode([UserObj].self, from: data)
                    print("Got the following results from search: \n \(results)")
                    DispatchQueue.main.async {
                        self?.searchPeopleResults = results
                    }
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
//    @Published var searchUserResults: [UserObj] = []
//
//    func searchUsers(term: String) {
//        
//        let urlString = "https://luna-api-v2vnbf3xma-ts.a.run.app/search?term=\(term)&token=\(self.token)"
//        guard let encodedURL = (URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")) else { return }
//
//        let task = URLSession.shared.dataTask(with: encodedURL) {[weak self] data, response, error in
//            guard let data = data else { return }
//            print("Searching for \(term)")
//            print("Got data: \(data)")
////            print(String(data: data, encoding: .utf8)!)
//
//            do {
////                var json_result : [String: Any] = [:]
//                let results = try JSONDecoder().decode([UserObj].self, from: data)
//                print("Got the following results from search: \n \(results)")
//                DispatchQueue.main.async {
//                    self?.searchUserResults = results
//                }
//            } catch {
//                print(error)
//            }
//        }
//
//        task.resume()
//    }
    
    func followVenue(venueID: String, UID: String) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/follow-venue?id=\(UID)&venue=\(venueID)&token=\(self.token)")!
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result : [String: String] = try JSONDecoder().decode([String: String].self, from: data)
                print(result)
                
                if result["result"] == "success" {
                    print("Successfully followed venue")
                }
                
                else {
                    print("Failed to follow venue: \(result)")
                }
                
            } catch {
                print("Error following venue: \(error)")
            }
        }
        
        task.resume()
    }
    
    func unfollowVenue(venueID: String, UID: String) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/unfollow-venue?id=\(UID)&venue=\(venueID)&token=\(self.token)")!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result : [String: String] = try JSONDecoder().decode([String: String].self, from: data)
                print(result)
                
                if result["result"] == "success" {
                    print("Successfully unfollowed venue")
                }
                
                else {
                    print("Failed to unfollow venue: \(result)")
                }
                
            } catch {
                print("Error unfollowing venue: \(error)")
            }
        }
        
        task.resume()
    }
    
    @Published var mutualFriends: [UserObj] = []
    @Published var gettingMutualFriends = false
    
    func getMutualFriends(uid: String) async {
        self.gettingMutualFriends = true
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/getmutualfriends?id=\(uid)")) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let result = try?JSONDecoder().decode(GetMutualsResult.self, from: data) {
                
                if result.error_msg == "" {
                    if result.result != self.mutualFriends {
                        DispatchQueue.main.async {
                            self.mutualFriends = result.result
                            
                            
                        }
                    }
                    DispatchQueue.main.async {
                        self.gettingMutualFriends = false
                    }
                } else {
                    print("Failed to decode mutual friends: \(result.error_msg)")
                }
            }
        } catch {
            print("Error getting mutual friends : \(error)")
            DispatchQueue.main.async {
                self.gettingMutualFriends = false
            }
        }
        
        
        
    }
    
    func removeSuggested(uid: String, user: String) {
        db.collection("profiles").document(uid).updateData(["ignoredSuggestions" : FieldValue.arrayUnion([user])]) { error in
            if let error = error {
                print("Failed to remove suggested user: \(error)")
            }
        }
    }
    
    @Published var gettingMutualFriendCount = false
    
    func getMutualFriendsCount(userID: String, friendID: String, completion: @escaping (Int) -> ()) {
        guard let url = (URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-mutual-friend-count?userid=\(userID)&friendid=\(friendID)")) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let response  = try JSONDecoder().decode(GetMutualFriendCountResult.self, from: data)
                
                if response.status == "success" {
                    DispatchQueue.main.async {
                        completion(response.result)
                    }
                }
                else {
                    print("Failed to get mutuals count: \(response.error_msg)")
                }
                DispatchQueue.main.async {
                    self.gettingMutualFriendCount = false
                }
                
                
            } catch {
                print("Failed to get mutuals count: \(error)")
                DispatchQueue.main.async {
                    self.gettingMutualFriendCount = false
                }
               
            }
        }
        
        task.resume()
        
        
        
        
        
    }
    
    @Published var drinkEligibility = false
    
    func hasClaimedDrink(uid: String) {
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/check-elgibility?uid=\(uid)") else {return}

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result : [String: String] = try JSONDecoder().decode([String: String].self, from: data)
                
                if result["result"] == "true" {
                    DispatchQueue.main.async {
                        self.drinkEligibility = true
                        print("Eligible for free drink")
                    }
                
                }
                
                else {
                    DispatchQueue.main.async {
                        self.drinkEligibility = false
                        print("Not eligible for free drink")
                    }
                    
                }
                
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func adjustDrinkEligibility(uid: String, completion: @escaping () -> ()) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/adjust-elgibility?uid=\(uid)")!
        
        print("Follow adjust drink eligibility URL: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result : [String: String] = try JSONDecoder().decode([String: String].self, from: data)
                print(result)
                
                if result["status"] == "success" {
                    completion()
                    print("Successfully changed status")
                }
                
                else {
                    print("Failed to change status: \(result)")
                }
                
            } catch {
                print("Error changing stauts: \(error)")
            }
        }
        
        task.resume()
    }
    
    func getHeadline(id: String, completion: @escaping (String) -> ()) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-headline?id=\(id)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(getHeadlineResult.self, from: data)
                
                if result.status == "success" {
                    print("Successfully got song")
                }
                
                else {
                    print("Failed to get song")
                }
                completion(result.result)
                
            } catch {
                print("Error changing stauts: \(error)")
            }
        }
        
        task.resume()
    }
    
    
    
//    func adjustDrinkEligibility(uid: String) {
//
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else { return }
//
//            do {
//                let result : [String: String] = try JSONDecoder().decode([String: String].self, from: data)
//                print(result)
//
//                if result["result"] == "true" {
//                    self.drinkEligibility = true
//                    print("Eligible for free drink")
//                }
//
//                else {
//                    print("Not eligible for free drink")
//                }
//
//            } catch {
//                print(error)
//            }
//        }
//
//        task.resume()
//    }
    
}

