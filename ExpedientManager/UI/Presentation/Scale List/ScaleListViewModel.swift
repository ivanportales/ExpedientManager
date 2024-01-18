//
//  ScaleListViewModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 01/12/24.
//

import Foundation

final class ScalesListViewModel {
    
    // MARK: - Binding Properties
    
    @Published var fixedScales: [FixedScale] = []
    @Published var onDuties: [OnDuty] = []
    @Published var errorText: String = ""
    
    // MARK: - Private Properties
    
    private let fixedScaleRepository: FixedScaleRepositoryProtocol
    private let onDutyRepository: OnDutyRepositoryProtocol
    
    // MARK: - Init
    
    init(fixedScaleRepository: FixedScaleRepositoryProtocol,
         onDutyRepository: OnDutyRepositoryProtocol) {
        self.fixedScaleRepository = fixedScaleRepository
        self.onDutyRepository = onDutyRepository
    }
    
    // MARK: - Exposed Functions
    
    func getAllScales() {
        fixedScaleRepository.getAllFixedScales { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.errorText = error.localizedDescription
            case .success(let scales):
                self.fixedScales = scales
                self.onDutyRepository.getAllOnDuty { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .failure(let error):
                        self.errorText = error.localizedDescription
                    case .success(let onDuties):
                        self.onDuties = onDuties
                    }
                }
            }
        }   
    }
}
