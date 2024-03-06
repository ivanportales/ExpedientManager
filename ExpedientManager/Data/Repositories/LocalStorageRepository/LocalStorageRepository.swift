//
//  LocalStorageRepository.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 17/01/24.
//

import Foundation

extension UserDefaults: LocalStorageRepositoryProtocol {
    func getValue(forKey key: String) -> Any? {
        object(forKey: key)
    }
    
    func save(value: Any?, forKey key: String) {
        set(value, forKey: key)
    }
}
