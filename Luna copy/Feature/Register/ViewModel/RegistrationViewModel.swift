//
//  RegistrationViewModel.swift
//  Luna
//
//  Created by Ned O'Rourke on 8/1/22.
//

import Foundation
import Combine

enum RegistrationState {
    case Successful
    case failed(error : Error)
    case na
}

protocol RegistrationViewModel {
    func register()
    var service: RegistrationService { get }
    var state: RegistrationState { get }
    var userDetails: RegistrationDetails { get }
    init(service: RegistrationService)
}

final class RegistrationViewModelImp: ObservableObject, RegistrationViewModel {
    
    let service: RegistrationService
    
    var state: RegistrationState = .na
    
    var userDetails: RegistrationDetails = RegistrationDetails.new
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: RegistrationService) {
        self.service = service
    }
    
    func register() {

        service
            .register(with: userDetails)
            .sink { [weak self] res in
        switch res {
        case .failure(let error):
            self?.state = .failed(error: error)
        default: break
        }
        
            } receiveValue: { [weak self] in
                self?.state = .Successful
            }
            .store(in: &subscriptions)
    }
}
