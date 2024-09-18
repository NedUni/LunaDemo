//
//  FetchContacts.swift
//  Luna
//
//  Created by Ned O'Rourke on 27/4/2022.
//

import Foundation
import Contacts

struct ContactInfo : Identifiable, Hashable{
    var id = UUID()
    var firstName: String
    var lastName: String
    var phoneNumber: CNPhoneNumber?
}

class FetchContacts : ObservableObject {
    
    @Published var contactsBool = false
    
    func fetchingContacts() -> [ContactInfo]{
        var contacts = [ContactInfo]()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        do {
            try CNContactStore().enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                contacts.append(ContactInfo(firstName: contact.givenName, lastName: contact.familyName, phoneNumber: contact.phoneNumbers.first?.value))
            })
        } catch let error {
            print("Failed", error)
        }
        contacts = contacts.sorted {
            $0.firstName < $1.firstName
        }
        return contacts
    }
    
    func requestAccess(userID : String, completion: @escaping () -> ()) {
            let store = CNContactStore()
            switch CNContactStore.authorizationStatus(for: .contacts) {
            case .authorized:
                contactsBool = true
            case .denied:
                store.requestAccess(for: .contacts) { granted, error in
                    if granted {
                        print("asked")
                    }
                }
            case .restricted, .notDetermined:
                store.requestAccess(for: .contacts) { granted, error in
                    if granted {
                        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                        do {
                            try CNContactStore().enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                                self.checkContact(userID: userID, phone: contact.phoneNumbers.first!.value.stringValue)
                            })
                        }
                        catch {
                            print("fail")
                        }
                        print("faded")
                    }
                }
            @unknown default:
                print("error")
            }
            completion()
        }
    
    func checkContact(userID : String, phone: String) {
        var phoneNumber = phone
        
        if !phoneNumber.hasPrefix("+61") {
            phoneNumber = "+61\(phone.dropFirst(1))"
        }
        phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        
        let encodedPhone = phoneNumber.replacingOccurrences(of: "+", with: "%2B")
        guard let url = URL(string: "https://luna-api-v2vnbf3xma-ts.a.run.app/check-contact-on-luna?userID=\(userID)&phone=\(encodedPhone)") else {return}
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
        
            do {
//                print("success")
//                let result = try JSONDecoder().decode(GetUserResult.self, from: data)
            } catch {
//                print("fail")
//                DispatchQueue.main.async {
//                    self.contactsNotOnLuna.append(contact)
//                }
                    
            }
        }
        task.resume()
    }
}
