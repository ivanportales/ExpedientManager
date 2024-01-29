//
//  SaveFixedScaleUseCase.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 28/01/24.
//

import Foundation

protocol SaveFixedScaleUseCaseProtocol {
    func save(fixedScale: FixedScale, completionHandler: @escaping (Result<Bool, Error>) -> ())
}

final class SaveFixedScaleUseCase: SaveFixedScaleUseCaseProtocol {
    
    // MARK: - Private Properties
    
    private let notificationManager: UserNotificationServiceProtocol
    private let fixedScaleRepository: FixedScaleRepositoryProtocol
    private let scheduledNotificationsRepository: ScheduledNotificationsRepositoryProtocol
    
    // MARK: - Init
    
    init(fixedScaleRepository: FixedScaleRepositoryProtocol,
         notificationManager: UserNotificationServiceProtocol,
         scheduledNotificationsRepository: ScheduledNotificationsRepositoryProtocol) {
        self.fixedScaleRepository = fixedScaleRepository
        self.notificationManager = notificationManager
        self.scheduledNotificationsRepository = scheduledNotificationsRepository
    }
    
    // MARK: - Exposed Functions
    
    func save(fixedScale: FixedScale, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        fixedScaleRepository.save(fixedScale: fixedScale) { [weak self] result in
            switch result {
            case .failure(let error):
                guard let self = self else {return}
                completionHandler(.failure(error))
            case .success(_):
                guard let self = self else {return}
                self.calculateScaleOf(fixedScale: fixedScale, completionHandler: completionHandler)
            }
        }
    }
    
    // MARK: - Private Properties
    
    private func calculateScaleOf(fixedScale: FixedScale, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let calendar = Calendar.current
        let finalDate = fixedScale.finalDate!
        let scale = fixedScale.scale!
        let dateComponent: Calendar.Component = (scale.type == ScaleType.hour) ? .hour : .day
        
        if dateComponent == .day {
            days(fixedScale: fixedScale, completionHandler: completionHandler)
            return
        }
        
        var currentDate = fixedScale.initialDate!
        
        set(scheduledNotification: ScheduledNotification.from(fixedScale: fixedScale, with: currentDate))
        currentDate = add(scale.scaleOfWork, to: .hour, ofDate: currentDate)
    
        while(calendar.isDate(currentDate, before: finalDate)) {
            currentDate = add(scale.scaleOfRest, to: .hour, ofDate: currentDate)
            
            if(!calendar.isDate(currentDate, before: finalDate)) { break }
            
            set(scheduledNotification: ScheduledNotification.from(fixedScale: fixedScale, with: currentDate))
            currentDate = add(scale.scaleOfWork, to: .hour, ofDate: currentDate)
        }
        completionHandler(.success(true))
    }
    
    private func days(fixedScale: FixedScale, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let calendar = Calendar.current
        let finalDate = fixedScale.finalDate!
        let scale = fixedScale.scale!
        
        var currentDate = fixedScale.initialDate!
        
        set(scheduledNotification: ScheduledNotification.from(fixedScale: fixedScale, with: currentDate))
        while(calendar.isDate(currentDate, before: finalDate)) {
            for _ in 1..<fixedScale.scale!.scaleOfWork {
                currentDate = add(scale.scaleOfWork, to: .day, ofDate: currentDate)
                set(scheduledNotification: ScheduledNotification.from(fixedScale: fixedScale, with: currentDate))
                if(!calendar.isDate(currentDate, before: finalDate)) { return }
            }
            currentDate = add(scale.scaleOfRest, to: .hour, ofDate: currentDate)
        }
        completionHandler(.success(true))
    }
    
    private func set(scheduledNotification: ScheduledNotification) {
        scheduledNotificationsRepository.save(scheduledNotification: scheduledNotification) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(_):
                guard let self = self else {return}
                self.notificationManager.set(scheduledNotification: scheduledNotification)
            }
        }
    }
    
    private func add(_ value: Int, to component: Calendar.Component, ofDate date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: component, value: value, to: date)!
    }
}
