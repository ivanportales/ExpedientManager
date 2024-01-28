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
    
    private let scheduler: UserNotificationServiceProtocol
    private let scheduledNotificationsRepository: ScheduledNotificationsRepositoryProtocol
    private let fixedScaleRepository: FixedScaleRepositoryProtocol
    private let onDutyRepository: OnDutyRepositoryProtocol
    
    // MARK: - Init
    
    init(scheduler: UserNotificationServiceProtocol,
         scheduledNotificationsRepository: ScheduledNotificationsRepositoryProtocol,
         fixedScaleRepository: FixedScaleRepositoryProtocol,
         onDutyRepository: OnDutyRepositoryProtocol) {
        self.scheduler = scheduler
        self.scheduledNotificationsRepository = scheduledNotificationsRepository
        self.fixedScaleRepository = fixedScaleRepository
        self.onDutyRepository = onDutyRepository
    }
    
    // MARK: - Exposed Properties
    
    func requestAuthorizationToSendNotifications() {
        scheduler.askUserNotificationPermission()
    }
    
//    func calculateFinalDutyDateFrom(date: Date, withDuration duration: Int) {
//        finalDutyDate = Calendar.current.date(byAdding: .hour, value: duration, to: date) ?? Date()
//    }
    
    func save(fixedScale: FixedScale) {
        isLoading = true
        fixedScaleRepository.save(fixedScale: fixedScale) { [weak self] result in
            switch result {
            case .failure(let error):
                guard let self = self else {return}
                self.isLoading = false
                self.errorText = error.localizedDescription
            case .success(_):
                guard let self = self else {return}
                self.calculateScaleOf(fixedScale: fixedScale)
            }
        }
    }
    
    func save(onDuty: OnDuty) {
        isLoading = true
        onDutyRepository.save(onDuty: onDuty) { [weak self] result in
            switch result {
            case .failure(let error):
                guard let self = self else {return}
                self.isLoading = false
                self.errorText = error.localizedDescription
            case .success(_):
                guard let self = self else {return}
                self.calculateScaleOf(onDuty: onDuty)
            }
        }
    }
    
    // MARK: - Private Properties
    
    private func calculateScaleOf(fixedScale: FixedScale) {
        let calendar = Calendar.current
        let finalDate = fixedScale.finalDate!
        let scale = fixedScale.scale!
        let dateComponent: Calendar.Component = (scale.type == ScaleType.hour) ? .hour : .day
        
        if dateComponent == .day {
            days(fixedScale: fixedScale)
            isLoading = false
            return
        }
        
        var currentDate = fixedScale.initialDate!
        
        print("Work on: \(calendar.getDescriptionOf(date: currentDate))")
        set(scheduledNotification: .init(uid: UUID().uuidString, title: fixedScale.title ?? "", description: fixedScale.annotation ?? "", date: currentDate, scaleUid: fixedScale.id, colorHex: fixedScale.colorHex!))
        
        currentDate = calendar.date(byAdding: dateComponent, value: scale.scaleOfWork, to: currentDate)!
    
        while(calendar.isDate(date: currentDate, before: finalDate)!) {
            currentDate = calendar.date(byAdding: dateComponent, value: scale.scaleOfRest, to: currentDate)!
            if(!calendar.isDate(date: currentDate, before: finalDate)!) { break }
            
            print("Work on: \(calendar.getDescriptionOf(date: currentDate))")
            set(scheduledNotification: .init(uid: UUID().uuidString, title: fixedScale.title ?? "", description: fixedScale.annotation ?? "", date: currentDate, scaleUid: fixedScale.id, colorHex: fixedScale.colorHex!))
            
            currentDate = calendar.date(byAdding: dateComponent, value: scale.scaleOfWork, to: currentDate)!
        }
        
        isLoading = false
    }
    
    private func days(fixedScale: FixedScale) {
        let calendar = Calendar.current
        let finalDate = fixedScale.finalDate!
        let scale = fixedScale.scale!
        let dateComponent: Calendar.Component = .day
        
        var currentDate = fixedScale.initialDate!
        
        set(scheduledNotification: .init(uid: UUID().uuidString, title: fixedScale.title ?? "", description: fixedScale.annotation ?? "", date: currentDate, scaleUid: fixedScale.id, colorHex: fixedScale.colorHex!))
        while(calendar.isDate(date: currentDate, before: finalDate)!) {
            for _ in 1..<fixedScale.scale!.scaleOfWork {
                currentDate = calendar.date(byAdding: dateComponent, value: 1, to: currentDate)!
                set(scheduledNotification: .init(uid: UUID().uuidString, title: fixedScale.title ?? "", description: fixedScale.annotation ?? "", date: currentDate, scaleUid: fixedScale.id, colorHex: fixedScale.colorHex!))
                if(!calendar.isDate(date: currentDate, before: finalDate)!) { return }
            }
            currentDate = calendar.date(byAdding: dateComponent, value: scale.scaleOfRest, to: currentDate)!
        }
    }
    
    private func calculateScaleOf(onDuty: OnDuty) {
        set(scheduledNotification: .init(uid: UUID().uuidString, 
                                         title: onDuty.titlo,
                                         description: onDuty.annotation ?? "",
                                         date: onDuty.initialDate,
                                         scaleUid: onDuty.id,
                                         colorHex: onDuty.colorHex!))
        isLoading = false
    }
    
    private func set(scheduledNotification: ScheduledNotification) {
        scheduledNotificationsRepository.save(scheduledNotification: scheduledNotification) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(_):
                guard let self = self else {return}
                self.scheduler.set(scheduledNotification: scheduledNotification)
            }
        }
    }
}
