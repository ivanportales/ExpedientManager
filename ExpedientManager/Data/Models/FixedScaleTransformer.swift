//
//  FixedScaleTransformer.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 06/03/24.
//

import Foundation

final class FixedScaleTransformer: NSSecureUnarchiveFromDataTransformer {
    override class var allowedTopLevelClasses: [AnyClass] {
        [FixedScaleModel.self]
    }
    
    static func register() {
        let className = String(describing: FixedScaleTransformer.self)
        let name = NSValueTransformerName(className)
        
        let transformer = FixedScaleTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
