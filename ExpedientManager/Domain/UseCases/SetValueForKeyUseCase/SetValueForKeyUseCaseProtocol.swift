//
//  SetValueForKeyUseCaseProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/02/24.
//

import Foundation

enum LocalStorageKeys: String {
    case hasOnboarded
}

protocol SetValueForKeyUseCaseProtocol {
    func save(value: Any?, forKey key: LocalStorageKeys)
}
