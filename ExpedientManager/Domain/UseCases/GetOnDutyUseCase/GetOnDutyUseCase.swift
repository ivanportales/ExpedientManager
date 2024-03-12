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
        onDutyRepository.getAllOnDuty(completionHandler: completionHandler)
    }
}
