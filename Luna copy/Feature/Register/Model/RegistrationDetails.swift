//
//  RegistrationDetails.swift
//  Luna
//
//  Created by Ned O'Rourke on 8/1/22.
//

import SwiftUI
import Foundation

let date = Date()
let dateFormatter = DateFormatter()
//dateFormatter.dateStyle = .short

struct RegistrationDetails {
    var email: String
    var password: String
    var firstName: String
    var lastName: String
//    var favouriteVenue: String
    var image: UIImage //added
    var dob: Date
    var dobString: String
}

extension RegistrationDetails {
    
    static var new: RegistrationDetails {
        RegistrationDetails(email: "",
                           password: "",
                           firstName: "",
                           lastName: "",
                            image: UIImage(),
                            dob: Date(),
                            dobString: ""
                            ) //added
    }
}
