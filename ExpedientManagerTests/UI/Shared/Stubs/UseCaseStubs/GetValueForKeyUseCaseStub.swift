//
//  GetValueForKeyUseCaseStub.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 15/02/24.
//

@testable import ExpedientManager

final class GetValueForKeyUseCaseStub: GetValueForKeyUseCaseProtocol {
    
    let returnedValue: Any?
    var requestedKey: LocalStorageKeys?
    
    init(returnedValue: Any?) {
        self.returnedValue = returnedValue
    }
    
    func getValue(forKey key: LocalStorageKeys) -> Any? {
        self.requestedKey = key
        return returnedValue
    }
}
