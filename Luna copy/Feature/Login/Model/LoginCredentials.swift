//
//  LoginCredentials.swift
//  Luna
//
//  Created by Ned O'Rourke on 17/1/22.
//

import Foundation

struct LoginCredentials {
    var email: String
    var password: String
}


extension LoginCredentials {
    
    static var new: LoginCredentials {
        LoginCredentials(email: "", password: "")
    }
}
