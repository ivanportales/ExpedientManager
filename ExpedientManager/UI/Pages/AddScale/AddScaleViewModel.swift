//
//  AddScaleViewModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/11/24.
//

import Foundation

enum AddScaleViewModelState {
    case initial
    case loading
    case errorSavingScale(message: String)
    case successSavingScale
}

final class AddScaleViewModel: ObservableObject {
    
    // MARK: - Bindings Properties
    
    @Published private(set) var state: AddScaleViewModelState = .initial
    
    // MARK: - Private Properties
    
    private let notificationManager: UserNotificationsManagerProtocol
    private let saveFixedScaleUseCase: SaveFixedScaleUseCaseProtocol
    private let saveOnDutyUseCase: SaveOnDutyUseCaseProtocol
    
    // MARK: - Init
    
    init(notificationManager: UserNotificationsManagerProtocol,
         saveFixedScaleUseCase: SaveFixedScaleUseCaseProtocol,
         saveOnDutyUseCase: SaveOnDutyUseCaseProtocol) {
        self.notificationManager = notificationManager
        self.saveFixedScaleUseCase = saveFixedScaleUseCase
        self.saveOnDutyUseCase = saveOnDutyUseCase
    }
    
    // MARK: - Exposed Properties
    
    func requestAuthorizationToSendNotifications() {
        notificationManager.askUserNotificationPermission()
    }
    
//    func calculateFinalDutyDateFrom(date: Date, withDuration duration: Int) {
//        finalDutyDate = Calendar.current.date(byAdding: .hour, value: duration, to: date) ?? Date()
//    }
    
    func save(fixedScale: FixedScale) {
        state = .loading
        saveFixedScaleUseCase.save(fixedScale: fixedScale) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error):
                self.state = .errorSavingScale(message: error.localizedDescription)
            case .success(_):
                self.state = .successSavingScale
            }
        }
    }
    
    func save(onDuty: OnDuty) {
        state = .loading
        saveOnDutyUseCase.save(onDuty: onDuty) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error):
                self.state = .errorSavingScale(message: error.localizedDescription)
            case .success(_):
                break
            }
            self.state = .successSavingScale
        }
    }
}
