//
//  SetValueForKeyUseCase.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/02/24.
//

import Foundation

final class SetValueForKeyUseCase: SetValueForKeyUseCaseProtocol {
    
    // MARK: - Private Properties
    
    private let storage: LocalStorageRepositoryProtocol
    
    // MARK: - Init
    
    init(storage: LocalStorageRepositoryProtocol) {
        self.storage = storage
    }
    
    // MARK: - Exposed Functions
    
    func save(value: Any?, forKey key: LocalStorageKeys) {
        storage.save(value: value, forKey: key.rawValue)
    }
}
