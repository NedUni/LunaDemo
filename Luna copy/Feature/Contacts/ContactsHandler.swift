//
//  ContactsHandler.swift
//  Luna
//
//  Created by Ned O'Rourke on 27/4/2022.
//

import Foundation

struct GetUserResult: Decodable, Hashable {
    let error_msg: String
    let status: String
    let result: UserObj
}

class ContactsHandler: ObservableObject {
    
    @Published var contactsOnLuna : [UserObj] = []
    @Published var contactsNotOnLuna : [ContactInfo] = []
    
    func getContactsOnLuna(contact : ContactInfo, completion: () -> ())  {
        guard let numberObj = contact.phoneNumber else {
            print("Contact does not have phone number: \(contact.firstName) \(contact.lastName)")
            return
            
        }
        var number = numberObj.stringValue
        if !number.hasPrefix("+61") {
            number = "+61\(number.dropFirst(1))"
        }
        number = number.replacingOccurrences(of: " ", with: "")
        
        let encodedPhone = number.replacingOccurrences(of: "+", with: "%2B")
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/check-on-app?phone=\(encodedPhone)") else {return}
   
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
                let result = try JSONDecoder().decode(GetUserResult.self, from: data)
                
                DispatchQueue.main.async {
                    if result.status != "failed" && !self.contactsOnLuna.contains(result.result) {
                        self.contactsOnLuna.append(result.result)
                    }
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.contactsNotOnLuna.append(contact)
                }
                    
            }
        }
        
        task.resume()
        
    }
    
    
}
