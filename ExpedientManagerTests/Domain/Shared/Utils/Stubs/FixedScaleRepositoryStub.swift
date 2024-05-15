//
//  FixedScaleRepositoryStub.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 15/05/24.
//

@testable import ExpedientManager

class FixedScaleRepositoryStub: FixedScaleRepositoryProtocol {
   
    let error: Error?
    let fixedScales: [FixedScale]
    
    init(error: Error? = nil,
         fixedScales: [FixedScale] = []) {
        self.error = error
        self.fixedScales = fixedScales
    }
    
    func getAllFixedScales(completionHandler: @escaping (Result<[ExpedientManager.FixedScale], any Error>) -> ()) {
        if let error = error {
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(fixedScales))
        }
    }
    
    func save(fixedScale: ExpedientManager.FixedScale, completionHandler: @escaping (Result<Bool, any Error>) -> ()) {
        // TODO: Implement function
    }
    
    func update(fixedScale: ExpedientManager.FixedScale, completionHandler: @escaping (Result<Bool, any Error>) -> ()) {
        // TODO: Implement function
    }
    
    func delete(fixedScale: ExpedientManager.FixedScale, completionHandler: @escaping (Result<Bool, any Error>) -> ()) {
        // TODO: Implement function
    }
}
