//
//  GetOnDutyUseCase.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 30/01/24.
//

import Foundation

final class GetOnDutyUseCase: GetOnDutyUseCaseProtocol {
    
    // MARK: - Private Properties
    
    private let onDutyRepository: OnDutyRepositoryProtocol
    
    // MARK: - Init
    
    init(onDutyRepository: OnDutyRepositoryProtocol) {
        self.onDutyRepository = onDutyRepository
    }
    
    // MARK: - Exposed Functions
    
    func getOnDuty(completionHandler: @escaping (Result<[OnDuty], Error>) -> ()) {
        let innerCompletion: (Result<[OnDutyModel], Error>) -> () = { result in
            switch result {
            case .success(let onDutiesModels):
                let domainOnDuties = onDutiesModels.map({ $0.toDomain() })
                completionHandler(.success(domainOnDuties))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        onDutyRepository.getAllOnDuty(completionHandler: innerCompletion)
    }
}

// MARK: - Private Mapping Extensions

fileprivate extension OnDutyModel {
    func toDomain() -> OnDuty {
        return OnDuty(
            id: id,
            title: titlo,
            initialDate: initialDate,
            hoursDuration: hoursDuration,
            annotation: annotation!,
            colorHex: colorHex!
        )
    }
}
