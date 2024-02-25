//
//  GetOnDutyUseCaseStub.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 25/02/24.
//

@testable import ExpedientManager

final class GetOnDutyUseCaseStub: GetOnDutyUseCaseProtocol {
    
    let onDuties: [OnDuty]
    let error: Error?
    
    init(onDuties: [OnDuty] = [],
         error: Error? = nil) {
        self.onDuties = onDuties
        self.error = error
    }
    
    func getOnDuty(completionHandler: @escaping (Result<[OnDuty], Error>) -> ()) {
        if let error = error {
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(onDuties))
        }
    }
}
