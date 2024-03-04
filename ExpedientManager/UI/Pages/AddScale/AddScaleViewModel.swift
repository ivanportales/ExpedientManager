//
//  AddScaleViewModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/11/23.
//

import Foundation

final class AddScaleViewModel: ObservableObject, AddScaleViewModelProtocol {
    
    // MARK: - Bindings Properties
    
    @Published private(set) var publishedState: AddScaleViewModelState = .initial
    var state: Published<AddScaleViewModelState>.Publisher { $publishedState }

    // MARK: - Private Properties
    
    private let askForNotificationPermissionUseCase: AskForNotificationPermissionUseCaseProtocol
    private let saveFixedScaleUseCase: SaveFixedScaleUseCaseProtocol
    private let saveOnDutyUseCase: SaveOnDutyUseCaseProtocol
    
    // MARK: - Init
    
    init(askForNotificationPermissionUseCase: AskForNotificationPermissionUseCaseProtocol,
         saveFixedScaleUseCase: SaveFixedScaleUseCaseProtocol,
         saveOnDutyUseCase: SaveOnDutyUseCaseProtocol) {
        self.askForNotificationPermissionUseCase = askForNotificationPermissionUseCase
        self.saveFixedScaleUseCase = saveFixedScaleUseCase
        self.saveOnDutyUseCase = saveOnDutyUseCase
    }
    
    // MARK: - Exposed Properties
    
    func requestAuthorizationToSendNotifications() {
        askForNotificationPermissionUseCase.askForNotificationPermission()
    }
    
//    func calculateFinalDutyDateFrom(date: Date, withDuration duration: Int) {
//        finalDutyDate = Calendar.current.date(byAdding: .hour, value: duration, to: date) ?? Date()
//    }
    
    func save(fixedScale: FixedScale) {
        publishedState = .loading
        saveFixedScaleUseCase.save(fixedScale: fixedScale) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error):
                self.publishedState = .errorSavingScale(message: error.localizedDescription)
            case .success(_):
                self.publishedState = .successSavingScale
            }
        }
    }
    
    func save(onDuty: OnDuty) {
        publishedState = .loading
        saveOnDutyUseCase.save(onDuty: onDuty) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error):
                self.publishedState = .errorSavingScale(message: error.localizedDescription)
            case .success(_):
                self.publishedState = .successSavingScale
            }
        }
    }
}
