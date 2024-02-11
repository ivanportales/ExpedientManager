//
//  GetValueForKeyUseCase.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 06/02/24.
//

import Foundation

final class GetValueForKeyUseCase: GetValueForKeyUseCaseProtocol {
    
    // MARK: - Private Properties
    
    private let localStorage: LocalStorageRepositoryProtocol
    
    // MARK: - Init
    
    init(localStorage: LocalStorageRepositoryProtocol) {
        self.localStorage = localStorage
    }
    
    // MARK: - Exposed Properties
    
    func getValue(forKey key: LocalStorageKeys) -> Any? {
        localStorage.getValue(forKey: key)
    }
}
