//
//  LocalStorageRepository.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 17/01/24.
//

import Foundation

enum LocalStorageKeys: String {
    case hasOnboarded
}

final class LocalStorageRepository: LocalStorageRepositoryProtocol {
    
    private let storage: UserDefaults
    
    init(storage: UserDefaults = UserDefaults.standard) {
        self.storage = storage
    }
    
    func getValue(forKey key: LocalStorageKeys) -> Any? {
        storage.object(forKey: key.rawValue)
    }
    
    func save(value: Any?, forKey key: LocalStorageKeys) {
        storage.set(value, forKey: key.rawValue)
    }
}
