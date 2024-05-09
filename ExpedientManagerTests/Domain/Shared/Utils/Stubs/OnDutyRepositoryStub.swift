//
//  OnDutyRepositoryStub.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 09/05/24.
//

@testable import ExpedientManager

class OnDutyRepositoryStub: OnDutyRepositoryProtocol {
    var error: Error?
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    func save(onDuty: OnDuty, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        if let error = error {
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(true))
        }
    }

    func getAllOnDuty(completionHandler: @escaping (Result<[ExpedientManager.OnDuty], any Error>) -> ()) {
        // TODO: Implement function
    }
    
    func delete(onDuty: ExpedientManager.OnDuty, completionHandler: @escaping (Result<Bool, any Error>) -> ()) {
        // TODO: Implement function
    }
    
    func update(onDuty: ExpedientManager.OnDuty, completionHandler: @escaping (Result<Bool, any Error>) -> ()) {
        // TODO: Implement function
    }
}
