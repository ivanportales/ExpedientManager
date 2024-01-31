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
    
    private let getFixedScalesUseCase: GetFixedScalesUseCaseProtocol
    private let getOnDutyUseCase: GetOnDutyUseCaseProtocol
    
    // MARK: - Init
    
    init(getFixedScalesUseCase: GetFixedScalesUseCaseProtocol,
         getOnDutyUseCase: GetOnDutyUseCaseProtocol) {
        self.getFixedScalesUseCase = getFixedScalesUseCase
        self.getOnDutyUseCase = getOnDutyUseCase
    }
    
    // MARK: - Exposed Functions
    
    func getAllScales() {
        state = .loading
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getFixedScalesUseCase.getFixedScales { [weak self] result in
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
        }
        
        dispatchGroup.enter()
        getOnDutyUseCase.getOnDuty { [weak self] result in
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
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.state = .content
        }
    }
}
