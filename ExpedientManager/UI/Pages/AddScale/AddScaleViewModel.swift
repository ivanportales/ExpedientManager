//
//  AddScaleViewModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/11/24.
//

import Foundation

final class AddScaleViewModel: ObservableObject {
    
    // MARK: - Bindings Properties
    
    @Published private(set) var isLoading = false
    
    // MARK: - Exposed Properties
    
    private(set) var errorText = ""
    
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
        isLoading = true
        saveFixedScaleUseCase.save(fixedScale: fixedScale) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error):
                self.errorText = error.localizedDescription
            case .success(_):
                break
            }
            self.isLoading = false
        }
    }
    
    func save(onDuty: OnDuty) {
        isLoading = true
        saveOnDutyUseCase.save(onDuty: onDuty) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.errorText = error.localizedDescription
            case .success(_):
                break
            }
            self.isLoading = false
        }
    }
}
