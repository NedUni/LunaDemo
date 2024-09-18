//
//  FiresaleManager.swift
//  Luna
//
//  Created by Ned O'Rourke on 31/5/2022.
//

import Foundation
import Firebase


struct CheckFireSaleInterestResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: Int
}

struct FiresaleRegisterInterestResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: String
}

struct FiresaleTitleResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: String
}

struct FiresaleIDResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: String
}


class FiresaleManager : ObservableObject {
    
    @Published var firesaleTitle : String = "Firesale..."
    @Published var isActive = false
    @Published var showingAlert = false
    @Published var time : String = "Loading..."
    @Published var progress = 0.0
    @Published var minutes : Float = 5.0 {
        didSet {
            self.time = "\(Int(minutes))"
        }
    }
    
    private var initialTime = 0
    private var endDate = Date()
    private var startDate = Date()
    
    func start(firesaleID: String) {
        self.initialTime = Int(minutes)
        DispatchQueue.main.async {
            self.isActive = true
        }
        
        self.getDates(firesaleID: firesaleID)
        
        
    }
    
    func reset() {
        self.minutes = Float(initialTime)
        self.isActive = false
        self.time = "\(Int(minutes)):00"
    }
    
    func updateCountdown() {
        guard isActive else { return }
        let now = Date()
        
        
        let range = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
        let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
        
        self.progress = (range - diff) / (range)
        
//        print(progress)
        
//        print(progress)

        if diff <= 0 {
            self.isActive = false
            self.time = "0:00"
            self.showingAlert = true
            return
        }
        
        let date = Date(timeIntervalSince1970: diff)
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        self.minutes = Float(minutes)
        self.time = String(format: "%d:%02d", minutes, seconds)
    }
    
    func getDates(firesaleID: String) {
        db.collection("firesales")
        
        let docRef = db.collection("firesales").document(firesaleID)

        docRef.getDocument { result, error in
            if let error = error {
                print("Error getting user document for location update: \(error)")
                return
            }
            else {
                let startTimeTimeStamp = result!["startDate"] as! Timestamp
                let endTimeTimeStamp = result!["endDate"] as! Timestamp
                
                self.startDate = startTimeTimeStamp.dateValue()
                self.endDate = endTimeTimeStamp.dateValue()
            }
        }
    }
    
    func getTitle(firesaleID : String) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-firesale-title?firesaleID=\(firesaleID)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(FiresaleTitleResult.self, from: data)
                
                if result.status == "success" {
                    DispatchQueue.main.async {
                        self.firesaleTitle = result.result
                    }
                    
                }
                
                else {
                    print("Failed to register interested in firesale: \(result)")
                }
                
            } catch {
                print("Error registering intereset in firesale: \(error)")
            }
        }
        
        task.resume()
    }
    
    @Published var firesaleID : String = ""
    
    func getID(venueID : String, completion: @escaping () -> ()) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/get-active-firesale?venueID=\(venueID)")!
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(FiresaleIDResult.self, from: data)
                
                if result.status == "success" {
                    DispatchQueue.main.async {
                        self.firesaleID = result.result
                        completion()
                    }
                    
                }
                
                else {
                    print("Failed to get firesaleID: \(result)")
                }
                
            } catch {
                print("Error getting firesaleID: \(error)")
            }
        }
        
        
        
        task.resume()
    }
    
    func registerFiresaleInterest(userID : String, firesaleID : String, completion : @escaping() -> ()) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/register-firesale-interest?userID=\(userID)&firesaleID=\(firesaleID)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(FiresaleRegisterInterestResult.self, from: data)
                print(result)
                
                if result.status == "success" {
                    completion()
                }
                
                else {
                    print("Failed to register interested in firesale: \(result)")
                }
                
            } catch {
                print("Error registering intereset in firesale: \(error)")
            }
        }
        
        task.resume()
    }
    
    func registerFiresaleDisinterest(userID : String, firesaleID : String, completion : @escaping() -> ()) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/register-firesale-disinterest?userID=\(userID)&firesaleID=\(firesaleID)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(FiresaleRegisterInterestResult.self, from: data)
                print(result)
                
                if result.status == "success" {
                    completion()
                }
                
                else {
                    print("Failed to register disinterested in firesale: \(result)")
                }
                
            } catch {
                print("Error registering disintereset in firesale: \(error)")
            }
        }
        
        task.resume()
        
    }
    
    @Published var status = 0
    
    func checkFiresaleInterest(userID : String, firesaleID : String) {
        let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/check-firesale-interest?userID=\(userID)&firesaleID=\(firesaleID)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(CheckFireSaleInterestResult.self, from: data)
                print(result)
                
                if result.status == "success" {
                    DispatchQueue.main.async {
                        self.status = result.result
                    }
                }
                
                else {
                    print("Failed to check firesale interest: \(result)")
                }
                
            } catch {
                print("Error checking firesale interest: \(error)")
            }
        }
        
        task.resume()
        
    }
    
    func setup(userID : String, firesaleID : String, completion : @escaping (Bool) -> ()) {
        
//        let queue = DispatchQueue(label: "firesale", attributes: .concurrent)
        
        self.getTitle(firesaleID: firesaleID)
        self.getDates(firesaleID: firesaleID)
        self.checkFiresaleInterest(userID: userID, firesaleID: firesaleID)
        self.start(firesaleID: firesaleID)
        
        completion(true)
        
    }
}
