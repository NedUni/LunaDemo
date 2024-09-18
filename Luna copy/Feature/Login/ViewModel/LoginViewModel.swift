//
//  LoginViewModel.swift
//  Luna
//
//  Created by Ned O'Rourke on 17/1/22.
//

import Foundation
import Combine

enum LoginState {
    case successful
    case failed(error: Error)
    case na
}

protocol LoginViewModel {
    func login()
    var service: loginService { get }
    var state: LoginState { get }
    var credentials: LoginCredentials { get }
    init(service: loginService)
}

final class LoginViewModelImpl: ObservableObject, LoginViewModel {
    
    @Published var state: LoginState = .na
    @Published var credentials: LoginCredentials = LoginCredentials.new
    
    private var subscriptions = Set<AnyCancellable>()
    
    let service: loginService
    
    init(service: loginService) {
        self.service = service
    }
    
    func login() {
        
        service
            .login(with: credentials)
            .sink { res in
                
                switch res {
                case .failure(let err):
                    self.state = .failed(error: err)
                default: break
                }
                
            } receiveValue: { [weak self] in
                self?.state = .successful
            }
            .store(in: &subscriptions)
    }
}
