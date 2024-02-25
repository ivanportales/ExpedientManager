//
//  GetStubUseCase.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 25/02/24.
//

@testable import ExpedientManager

class GetStubUseCase<T> {
    let values: [T]
    let error: Error?
    
    init(values: [T] = [],
         error: Error? = nil) {
        self.values = values
        self.error = error
    }
    
    func get(completion: @escaping (Result<[T], Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(values))
        }
    }
}
