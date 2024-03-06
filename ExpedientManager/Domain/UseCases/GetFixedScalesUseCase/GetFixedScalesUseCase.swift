//
//  GetFixedScalesUseCase.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 30/01/24.
//

import Foundation

final class GetFixedScalesUseCase: GetFixedScalesUseCaseProtocol {
    
    // MARK: - Private Properties
    
    private let fixedScaleRepository: FixedScaleRepositoryProtocol
    
    // MARK: - Init
    
    init(fixedScaleRepository: FixedScaleRepositoryProtocol) {
        self.fixedScaleRepository = fixedScaleRepository
    }
    
    // MARK: - Exposed Functions
    
    func getFixedScales(completionHandler: @escaping (Result<[FixedScale], Error>) -> ()) {
        let innerCompletion: (Result<[FixedScaleModel], Error>) -> () = { result in
            switch result {
            case .success(let fixedScalesModels):
                let domainFixedScales = fixedScalesModels.map({ $0.toDomain() })
                completionHandler(.success(domainFixedScales))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        fixedScaleRepository.getAllFixedScales(completionHandler: innerCompletion)
    }
}

// MARK: - Private Mapping Extensions

fileprivate extension FixedScaleModel {
    func toDomain() -> FixedScale {
        return FixedScale(
            id: id,
            title: title ?? "",
            scale: scale!.toDomain(),
            initialDate: initialDate!,
            finalDate: finalDate!,
            annotation: annotation!,
            colorHex: colorHex!
        )
    }
}

fileprivate extension ScaleModel {
    func toDomain() -> Scale {
        return Scale(
            type: ScaleType(rawValue: type) ?? ScaleType.hour,
            scaleOfWork: scaleOfWork,
            scaleOfRest: scaleOfRest
        )
    }
}
