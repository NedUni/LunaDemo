//
//  RegistrationService.swift
//  Luna
//
//  Created by Ned O'Rourke on 8/1/22.
//

import Combine
import SwiftUI
import Foundation
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage

enum RegistrationKeys: String {
    case firstName
    case lastName
//    case favouriteVenue
    case dob
}

protocol RegistrationService {
    func register(with details: RegistrationDetails) -> AnyPublisher<Void, Error>
}

var db = Firestore.firestore()
var storage = Storage.storage()
var auth = Auth.auth()

//final class RegistrationServiceImpl: RegistrationService {
//    
//    let dateFormatter = DateFormatter()
//    // let dob = self.dateFormatter.string(from: details.dob)
//
//    func register(with details: RegistrationDetails) {
//        auth.createUser(withEmail: String, password: <#T##String#>, completion: <#T##((AuthDataResult?, Error?) -> Void)?##((AuthDataResult?, Error?) -> Void)?##(AuthDataResult?, Error?) -> Void#>)
//    }
//}
