//
//  Core.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/25/24.
//

import Foundation

extension UserDefaults {
    private enum UserDefaultsKeys: String {
        case hasOnboarded
    }
    
    var hasOnboarded: Bool {
        get {
            bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
        
        set {
            set(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
    }
}
