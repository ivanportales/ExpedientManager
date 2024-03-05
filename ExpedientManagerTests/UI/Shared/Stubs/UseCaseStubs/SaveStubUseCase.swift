//
//  SaveStubUseCase.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 04/03/24.
//

import Foundation

class SaveStubUseCase<T> {
    let value: T?
    let error: Error?
    
    init(value: T? = nil,
         error: Error? = nil) {
        self.value = value
        self.error = error
    }
    
    func save(completion: @escaping (Result<Bool, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(true))
        }
    }
}
