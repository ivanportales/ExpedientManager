//
//  OnDutyRepositoryStub.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 09/05/24.
//

@testable import ExpedientManager

class OnDutyRepositoryStub: OnDutyRepositoryProtocol {
    let error: Error?
    let onDuties: [OnDuty]
    
    init(error: Error? = nil,
         onDuties: [OnDuty] = []) {
        self.error = error
        self.onDuties = onDuties
    }
    
    func save(onDuty: OnDuty, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        if let error = error {
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(true))
        }
    }

    func getAllOnDuty(completionHandler: @escaping (Result<[ExpedientManager.OnDuty], any Error>) -> ()) {
        if let error = error {
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(onDuties))
        }
    }
    
    func delete(onDuty: ExpedientManager.OnDuty, completionHandler: @escaping (Result<Bool, any Error>) -> ()) {
        // TODO: Implement function
    }
    
    func update(onDuty: ExpedientManager.OnDuty, completionHandler: @escaping (Result<Bool, any Error>) -> ()) {
        // TODO: Implement function
    }
}
