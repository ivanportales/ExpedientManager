//
//  GetValueForKeyUseCaseProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 06/02/24.
//

import Foundation

protocol GetValueForKeyUseCaseProtocol {
    func getValue(forKey key: LocalStorageKeys) -> Any?
}
