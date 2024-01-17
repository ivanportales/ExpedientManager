//
//  ScaleDetailsViewModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 01/12/24.
//

import Foundation

class ScaleDetailsViewModel {
    @Published private(set) var isLoading = false
    @Published private(set) var initialDutyDate: Date = .init()
    @Published private(set) var finalDutyDate: Date = .init()
    
    private(set) var errorText = ""
    let state: ViewStates
    private let scheduler = UserNotificationService()
    private let repository: CoreDataScheduledNotificationsRepository = CoreDataScheduledNotificationsRepository()
    private let fixedScaleRepository: FixedScaleRepository = CoreDataFixedScaleRepository()
    private let onDutyRepository: OnDutyRepository = CoreDataOnDutyRepository()
    
    var selectedFixedScale: FixedScale?
    var selectedOnDuty: OnDuty?
    
    init(state: ViewStates, selectedFixedScale: FixedScale?, selectedOnDuty: OnDuty?) {
        self.selectedFixedScale = selectedFixedScale
        self.selectedOnDuty = selectedOnDuty
        self.state = state
    }
    
    func update() {
        if state == .fixedScale {
            update(fixedScale: selectedFixedScale!)
        } else {
            update(onDuty: selectedOnDuty!)
        }
    }
    
    func delete() {
        if state == .fixedScale {
            delete(fixedScale: selectedFixedScale!)
        } else {
            delete(onDuty: selectedOnDuty!)
        }
    }

    func setInitialDutyDate(_ date: Date) {
        initialDutyDate = date
    }
    
    func requestAuthorizationToSendNotifications() {
        scheduler.askUserNotificationPermission()
    }
    
    func calculateFinalDutyDateFrom(date: Date, withDuration duration: Int) {
        finalDutyDate = Calendar.current.date(byAdding: .hour, value: duration, to: date) ?? Date()
    }
    
    private func delete(fixedScale: FixedScale) {
        let _ = fixedScaleRepository.delete(fixedScale: fixedScale)
        let _ = repository.deleteAllScheduledNotificationsWhere(scaleUid: fixedScale.id)
        scheduler.removeAllPendingNotificationsWith(uid: fixedScale.id)
    }
    
    private func delete(onDuty: OnDuty) {
        let _ = onDutyRepository.delete(onDuty: onDuty)
        let _ = repository.deleteAllScheduledNotificationsWhere(scaleUid: onDuty.id)
        scheduler.removeAllPendingNotificationsWith(uid: onDuty.id)
    }
    
    private func update(fixedScale: FixedScale) {
        scheduler.removeAllPendingNotificationsWith(uid: fixedScale.id)
        let _ = repository.deleteAllScheduledNotificationsWhere(scaleUid: fixedScale.id)
        let _ = fixedScaleRepository.update(fixedScale: fixedScale)
        calculateScaleOf(fixedScale: fixedScale)
    }
    
    private func update(onDuty: OnDuty) {
        scheduler.removeAllPendingNotificationsWith(uid: onDuty.id)
        let _ = repository.deleteAllScheduledNotificationsWhere(scaleUid: onDuty.id)
        let _ = onDutyRepository.update(onDuty: onDuty)
        calculateScaleOf(onDuty: onDuty)
    }
    
    private func calculateScaleOf(fixedScale: FixedScale) {
        let calendar = Calendar.current
        let finalDate = fixedScale.finalDate!
        let scale = fixedScale.scale!
        let dateComponent: Calendar.Component = (scale.type == ScaleType.hour) ? .hour : .day
        
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
        
        //isLoading = false
    }
    
    private func calculateScaleOf(onDuty: OnDuty) {
        set(scheduledNotification: .init(uid: UUID().uuidString, title: onDuty.titlo, description: onDuty.annotation ?? "", date: onDuty.initialDate, scaleUid: onDuty.id, colorHex: onDuty.colorHex!))
        //isLoading = false
    }
    
    private func set(scheduledNotification: ScheduledNotification) {
        repository.save(scheduledNotification: scheduledNotification) { [weak self] result in
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
