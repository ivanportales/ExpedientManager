//
//  SetValueForKeyUseCaseStub.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 12/03/24.
//

@testable import ExpedientManager

final class SetValueForKeyUseCaseStub: SetValueForKeyUseCaseProtocol {

    var lastSavedKey: LocalStorageKeys?
    var lastSavedValue: Any?
    
    func save(value: Any?, forKey key: LocalStorageKeys) {
        self.lastSavedValue = value
        self.lastSavedKey = key
    }
}
