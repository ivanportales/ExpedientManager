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
        getFixedScalesUseCase.getFixedScales { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.statePublished = .error(message: error.localizedDescription)
            case .success(let scales):
                self.fixedScales = scales
                self.getOnDuties()
            }
        }
    }
    
    func change(selectedWorkScale: WorkScaleType) {
        self.selectedWorkScalePublished = selectedWorkScale
        self.statePublished = .content(scheduledNotifications: filteredScheduledNotifications(),
                                       selectedWorkScale: selectedWorkScalePublished)
    }
    
    // MARK: - Private Functions
    
    private func getOnDuties() {
        getOnDutyUseCase.getOnDuty { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.statePublished = .error(message: error.localizedDescription)
            case .success(let onDuties):
                self.onDuties = onDuties
                self.statePublished = .content(scheduledNotifications: self.filteredScheduledNotifications(),
                                               selectedWorkScale: self.selectedWorkScalePublished)
            }
        }
    }
    
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
