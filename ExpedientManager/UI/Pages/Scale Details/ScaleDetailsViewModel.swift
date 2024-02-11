//
//  ScaleDetailsViewModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 01/12/24.
//

import Foundation

final class ScaleDetailsViewModel {
    
    // MARK: - Bindings
    
    @Published private(set) var isLoading = false
    @Published private(set) var initialDutyDate: Date = .init()
    @Published private(set) var finalDutyDate: Date = .init()
    
    // MARK: - Exposed Properties
    
    private(set) var errorText = ""
    let state: WorkScaleType
    var selectedFixedScale: FixedScale?
    var selectedOnDuty: OnDuty?
    
    // MARK: - Private Properties
    
    private let scheduler: UserNotificationsManagerProtocol
    private let scheduledNotificationsRepository: ScheduledNotificationsRepositoryProtocol
    private let fixedScaleRepository: FixedScaleRepositoryProtocol
    private let onDutyRepository: OnDutyRepositoryProtocol
    
    // MARK: - Init
    
    init(state: WorkScaleType,
         selectedFixedScale: FixedScale?,
         selectedOnDuty: OnDuty?,
         scheduler: UserNotificationsManagerProtocol,
         scheduledNotificationsRepository: ScheduledNotificationsRepositoryProtocol,
         fixedScaleRepository: FixedScaleRepositoryProtocol,
         onDutyRepository: OnDutyRepositoryProtocol) {
        self.selectedFixedScale = selectedFixedScale
        self.selectedOnDuty = selectedOnDuty
        self.state = state
        self.scheduler = scheduler
        self.scheduledNotificationsRepository = scheduledNotificationsRepository
        self.fixedScaleRepository = fixedScaleRepository
        self.onDutyRepository = onDutyRepository
    }
    
    // MARK: - Exposed Properties
    
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
    
    // MARK: - Private Functions
    
    private func delete(fixedScale: FixedScale) {
        fixedScaleRepository.delete(fixedScale: fixedScale, completionHandler: { _ in })
        scheduledNotificationsRepository.deleteAllScheduledNotificationsWhere(scaleUid: fixedScale.id, completionHandler: { [weak self] result in
            switch result {
            case .failure(let error):
                self?.errorText = error.localizedDescription
            case .success(_):
                break
            }
            
        })
        scheduler.removeAllPendingNotificationsWith(uid: fixedScale.id)
    }
    
    private func delete(onDuty: OnDuty) {
        let _ = onDutyRepository.delete(onDuty: onDuty, completionHandler: {_ in })
        scheduledNotificationsRepository.deleteAllScheduledNotificationsWhere(scaleUid: onDuty.id, completionHandler: { [weak self] result in
            switch result {
            case .failure(let error):
                self?.errorText = error.localizedDescription
            case .success(_):
                break
            }
            
        })
        scheduler.removeAllPendingNotificationsWith(uid: onDuty.id)
    }
    
    private func update(fixedScale: FixedScale) {
        scheduler.removeAllPendingNotificationsWith(uid: fixedScale.id)
        scheduledNotificationsRepository.deleteAllScheduledNotificationsWhere(scaleUid: fixedScale.id, completionHandler: { [weak self] result in
            switch result {
            case .failure(let error):
                self?.errorText = error.localizedDescription
            case .success(_):
                break
            }
            
        })
        fixedScaleRepository.update(fixedScale: fixedScale, completionHandler: { _ in })
        calculateScaleOf(fixedScale: fixedScale)
    }
    
    private func update(onDuty: OnDuty) {
        scheduler.removeAllPendingNotificationsWith(uid: onDuty.id)
        scheduledNotificationsRepository.deleteAllScheduledNotificationsWhere(scaleUid: onDuty.id, completionHandler: { [weak self] result in
            switch result {
            case .failure(let error):
                self?.errorText = error.localizedDescription
            case .success(_):
                break
            }
            
        })
        onDutyRepository.update(onDuty: onDuty, completionHandler: {_ in })
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
    
        while(calendar.isDate(currentDate, before: finalDate)) {
            currentDate = calendar.date(byAdding: dateComponent, value: scale.scaleOfRest, to: currentDate)!
            if(!calendar.isDate(currentDate, before: finalDate)) { break }
            
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
        scheduledNotificationsRepository.save(scheduledNotification: scheduledNotification) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(_):
                guard let self = self else {return}
                self.scheduler.set(scheduledNotification: scheduledNotification, completion: { result in })
            }
        }
    }
}
