//
//  LocalStorageRepositoryProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 17/01/24.
//

import Foundation

protocol LocalStorageRepositoryProtocol {
    func getValue(forKey key: String) -> Any?
    func save(value: Any?, forKey key: String)
}
