//
//  SaveStubUseCase.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 04/03/24.
//

import Foundation

class SaveStubUseCase<T> {
    var value: T?
    let error: Error?
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    func save(value: T?, completion: @escaping (Result<Bool, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            self.value = value
            completion(.success(true))
        }
    }
}
