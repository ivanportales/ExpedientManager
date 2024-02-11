//
//  GetValueForKeyUseCase.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 06/02/24.
//

import Foundation

final class GetValueForKeyUseCase: GetValueForKeyUseCaseProtocol {
    
    // MARK: - Private Properties
    
    private let storage: LocalStorageRepositoryProtocol
    
    // MARK: - Init
    
    init(storage: LocalStorageRepositoryProtocol) {
        self.storage = storage
    }
    
    // MARK: - Exposed Properties
    
    func getValue(forKey key: LocalStorageKeys) -> Any? {
        storage.getValue(forKey: key.rawValue)
    }
}
