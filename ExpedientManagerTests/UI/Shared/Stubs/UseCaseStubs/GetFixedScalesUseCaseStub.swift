//
//  GetFixedScalesUseCaseStub.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 24/02/24.
//

@testable import ExpedientManager

final class GetFixedScalesUseCaseStub: GetFixedScalesUseCaseProtocol {
    
    let fixedScales: [FixedScale]
    let error: Error?
    
    init(fixedScales: [FixedScale] = [],
         error: Error? = nil) {
        self.fixedScales = fixedScales
        self.error = error
    }
    
    func getFixedScales(completionHandler: @escaping (Result<[FixedScale], Error>) -> ()) {
        if let error = error {
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(fixedScales))
        }
    }
}
