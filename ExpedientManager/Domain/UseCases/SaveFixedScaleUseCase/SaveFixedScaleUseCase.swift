//
//  SaveFixedScaleUseCase.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 28/01/24.
//

import Foundation

final class SaveFixedScaleUseCase: SaveFixedScaleUseCaseProtocol {
    
    // MARK: - Private Properties
    
    private let fixedScaleRepository: FixedScaleRepositoryProtocol
    private let scheduledNotificationsRepository: ScheduledNotificationsRepositoryProtocol
    private let calendarManager: CalendarManagerProtocol
    private let notificationManager: UserNotificationsManagerProtocol
    
    // MARK: - Init
    
    init(fixedScaleRepository: FixedScaleRepositoryProtocol,
         scheduledNotificationsRepository: ScheduledNotificationsRepositoryProtocol,
         notificationManager: UserNotificationsManagerProtocol,
         calendarManager: CalendarManagerProtocol) {
        self.fixedScaleRepository = fixedScaleRepository
        self.scheduledNotificationsRepository = scheduledNotificationsRepository
        self.notificationManager = notificationManager
        self.calendarManager = calendarManager
    }
    
    // MARK: - Exposed Functions
    
    func save(fixedScale: FixedScale, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        fixedScaleRepository.save(fixedScale: fixedScale) { [weak self] result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(_):
                guard let self = self else {return}
                self.calculateScaleOf(fixedScale: fixedScale, completionHandler: completionHandler)
            }
        }
    }
    
    // MARK: - Private Properties
    
    private func calculateScaleOf(fixedScale: FixedScale, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        guard let scale = fixedScale.scale else {
            completionHandler(.failure(SaveFixedScaleUseCaseError.corruptedData))
            return
        }
        
        var scheduledNotifications: [ScheduledNotification] = []
        
        if scale.type == .hour {
            scheduledNotifications = setupHoursScales(of: fixedScale, completionHandler: completionHandler)
        } else {
            scheduledNotifications = setupDaysScales(of: fixedScale, completionHandler: completionHandler)
        }
                
        for scheduledNotification in scheduledNotifications {
            set(scheduledNotification: scheduledNotification) { result in
                switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
                case .success(_):
                    return
                }
            }
        }
        
        completionHandler(.success(true))
    }
    
    private func setupHoursScales(of fixedScale: FixedScale, completionHandler: @escaping (Result<Bool, Error>) -> ()) -> [ScheduledNotification] {
        guard let finalDate = fixedScale.finalDate,
              let scale = fixedScale.scale,
              var currentDate = fixedScale.initialDate else {
            completionHandler(.failure(SaveFixedScaleUseCaseError.corruptedData))
            return []
        }
        
        var scheduledNotifications = [ScheduledNotification.from(fixedScale: fixedScale, with: currentDate)]
        
        currentDate = calendarManager.add(scale.scaleOfWork, to: .hour, ofDate: currentDate)
    
        while(calendarManager.isDate(currentDate, before: finalDate)) {
            currentDate = calendarManager.add(scale.scaleOfRest, to: .hour, ofDate: currentDate)
            
            if(!calendarManager.isDate(currentDate, before: finalDate)) {
                break
            }
            
            scheduledNotifications.append(ScheduledNotification.from(fixedScale: fixedScale, with: currentDate))

            currentDate = calendarManager.add(scale.scaleOfWork, to: .hour, ofDate: currentDate)
        }
        
        return scheduledNotifications
    }
    
    private func setupDaysScales(of fixedScale: FixedScale, completionHandler: @escaping (Result<Bool, Error>) -> ()) -> [ScheduledNotification] {
        guard let finalDate = fixedScale.finalDate,
              let scale = fixedScale.scale,
              var currentDate = fixedScale.initialDate else {
            completionHandler(.failure(SaveFixedScaleUseCaseError.corruptedData))
            return []
        }
        
        var scheduledNotifications = [ScheduledNotification.from(fixedScale: fixedScale, with: currentDate)]

        while(calendarManager.isDate(currentDate, before: finalDate)) {
            for _ in 1..<scale.scaleOfWork {
                currentDate = calendarManager.add(scale.scaleOfWork, to: .day, ofDate: currentDate)

                scheduledNotifications.append(ScheduledNotification.from(fixedScale: fixedScale, with: currentDate))
                if(!calendarManager.isDate(currentDate, before: finalDate)) {
                    break
                }
            }
            currentDate = calendarManager.add(scale.scaleOfRest, to: .day, ofDate: currentDate)
        }
        
        return scheduledNotifications
    }
    
    private func set(scheduledNotification: ScheduledNotification,
                     completion: @escaping (Result<Bool, Error>) -> ()) {
        scheduledNotificationsRepository.save(scheduledNotification: scheduledNotification) { [weak self] result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(_):
                guard let self = self else { return }
                self.notificationManager.set(scheduledNotification: scheduledNotification,
                                             completion: completion)
            }
        }
    }
}
