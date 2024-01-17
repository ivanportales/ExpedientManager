//
//  ScaleListViewModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 01/12/24.
//

import Foundation

class ScaleListViewModel {
    @Published var fixedScales: [FixedScale] = []
    @Published var onDuties: [OnDuty] = []
    @Published var errorText: String = ""
    
    private let fixedScaleRepository: CoreDataFixedScaleRepository = .init()
    private let onDutyRepository: CoreDataOnDutyRepository = .init()
    
    func load() {
        fixedScaleRepository.getAllFixedScales { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error):
                self.errorText = error.localizedDescription
            case .success(let scales):
                self.fixedScales = scales
                self.onDutyRepository.getAllOnDuty { [weak self] result in
                    guard let self = self else {return}
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
