//
//  ScaleListViewModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 01/12/23.
//

import Foundation

final class ScalesListViewModel: ScalesListViewModelProtocol {
    
    // MARK: - Binding Properties
    
    var state: Published<ScalesListViewModelState>.Publisher { $statePublished }
    
    @Published private(set) var statePublished: ScalesListViewModelState = .initial
    
    // MARK: - Private Properties
    
    private var selectedWorkScalePublished: WorkScaleType = .fixedScale
    private var fixedScales: [FixedScale] = []
    private var onDuties: [OnDuty] = []
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
        statePublished = .loading
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getFixedScalesUseCase.getFixedScales { [weak self] result in
            guard let self = self else { return }
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .failure(let error):
                self.statePublished = .error(message: error.localizedDescription)
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
                self.statePublished = .error(message: error.localizedDescription)
            case .success(let onDuties):
                self.onDuties = onDuties
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.statePublished = .content(scheduledNotifications: self.filteredScheduledNotifications(), 
                                           selectedWorkScale: self.selectedWorkScalePublished)
        }
    }
    
    func change(selectedWorkScale: WorkScaleType) {
        self.selectedWorkScalePublished = selectedWorkScale
        self.statePublished = .content(scheduledNotifications: filteredScheduledNotifications(),
                                       selectedWorkScale: selectedWorkScalePublished)
    }
    
    // MARK: - Private Functions
    
    private func filteredScheduledNotifications() -> [ScheduledNotification] {
        if selectedWorkScalePublished == .fixedScale {
            return fixedScales.map {
                ScheduledNotification.from(fixedScale: $0, with: $0.initialDate ?? .init())
            }
        }
        return onDuties.map {
            ScheduledNotification.from(onDuty: $0)
        }
    }
}
