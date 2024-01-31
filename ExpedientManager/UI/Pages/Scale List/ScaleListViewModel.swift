//
//  ScaleListViewModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 01/12/24.
//

import Foundation

enum ScalesListViewModelStates {
    case initial
    case loading
    case content
    case error(message: String)
}

final class ScalesListViewModel {
    
    // MARK: - Binding Properties
    
    @Published private(set) var state: ScalesListViewModelStates = .initial
    @Published var selectedWorkScale: WorkScaleType = .fixedScale
    
    // MARK: - Exposed Properties
    
    private(set)var fixedScales: [FixedScale] = []
    private(set) var onDuties: [OnDuty] = []
    
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
        state = .loading
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fixedScaleRepository.getAllFixedScales { [weak self] result in
            guard let self = self else { return }
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .failure(let error):
                self.state = .error(message: error.localizedDescription)
            case .success(let scales):
                self.fixedScales = scales
            }
            print("fechou o fixed")
        }
        
        dispatchGroup.enter()
        onDutyRepository.getAllOnDuty { [weak self] result in
            guard let self = self else { return }
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .failure(let error):
                self.state = .error(message: error.localizedDescription)
            case .success(let onDuties):
                self.onDuties = onDuties
            }
            print("fechou o duty")
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.state = .content
            print("fechou o o notify")
        }
    }
}
