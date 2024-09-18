//
//  LoginService.swift
//  Luna
//
//  Created by Ned O'Rourke on 17/1/22.
//

import Combine
import Foundation
import FirebaseAuth

protocol loginService {
    func login(with credentials: LoginCredentials) -> AnyPublisher<Void, Error>
}

final class LoginServiceImpl: loginService {
    
    func login(with credentials: LoginCredentials) -> AnyPublisher<Void, Error> {
        
        Deferred {
            
            Future { promise in
                
                Auth
                    .auth()
                    .signIn(withEmail: credentials.email,
                            password: credentials.password) { res, error in
                        
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
