//
//  SaveFixedScaleUseCaseError.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 29/01/24.
//

import Foundation

enum SaveFixedScaleUseCaseError: Error {
    case corruptedData
}

extension SaveFixedScaleUseCaseError: LocalizedError {
    var errorDescription: String?{
        switch self {
        case .corruptedData:
            return "Corrupted Data"
        }
    }
}
