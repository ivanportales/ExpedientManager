//
//  AddScaleViewModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/11/24.
//

import Foundation

public enum ViewStates {
    case onDuty, fixedScale
}

class AddScaleViewModel: ObservableObject {
    
    @Published private(set) var isLoading = false
    @Published private(set) var initialDutyDate: Date = .init()
    @Published private(set) var finalDutyDate: Date = .init()
    
    private(set) var errorText = ""
    private(set) var state: ViewStates = .fixedScale
    private let scheduler = UserNotificationService()
    private let repository: CoreDataScheduledNotificationsRepository = CoreDataScheduledNotificationsRepository()
    private let fixedScaleRepository: FixedScaleRepository = CoreDataFixedScaleRepository()
    private let onDutyRepository: OnDutyRepository = CoreDataOnDutyRepository()
    
    func changeViewStateTo(state: ViewStates) {
        self.state = state
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
    
//    private func calculateScaleOf(fixedScale: FixedScale) {
//        let calendar = Calendar.current
//        let finalDate = fixedScale.finalDate!
//        let scale = fixedScale.scale!
//        let dateComponent: Calendar.Component = (scale.type == ScaleType.hour) ? .hour : .day
//
//        var currentDate = fixedScale.initialDate!
//
//        set(scheduledNotification: .init(uid: UUID().uuidString, title: fixedScale.title ?? "", description: fixedScale.annotation ?? "", date: currentDate, scaleUid: fixedScale.id))
//
//        currentDate = calendar.date(byAdding: dateComponent, value: scale.scaleOfWork, to: currentDate)!
//
//        while(!calendar.isDate(date: currentDate, inSameDayOrAfter: finalDate)!) {
//            currentDate = calendar.date(byAdding: dateComponent, value: scale.scaleOfRest, to: currentDate)!
//            if(calendar.isDate(date: currentDate, inSameDayOrAfter: finalDate)!) { break }
//            set(scheduledNotification: .init(uid: UUID().uuidString, title: fixedScale.title ?? "", description: fixedScale.annotation ?? "", date: currentDate, scaleUid: fixedScale.id))
//            currentDate = calendar.date(byAdding: dateComponent, value: scale.scaleOfWork, to: currentDate)!
//        }
//
//        isLoading = false
//    }
    
    private func calculateScaleOf(onDuty: OnDuty) {
        set(scheduledNotification: .init(uid: UUID().uuidString, title: onDuty.titlo, description: onDuty.annotation ?? "", date: onDuty.initialDate, scaleUid: onDuty.id, colorHex: onDuty.colorHex!))
        isLoading = false
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

//func calculateScaleOf(fixedScale: FixedScale) {
//    let calendar = Calendar.current
//    let finalDate = fixedScale.finalDate!
//    let scale = fixedScale.scale!
//    let dateComponent: Calendar.Component = (scale.type == ScaleType.hour) ? .hour : .day
//
//    var currentDate = fixedScale.initialDate!
//    print("Initial date = \(calendar.getDescriptionOf(date: currentDate) )")
//    print("Final date = \(calendar.getDescriptionOf(date: finalDate) )\n")
//
//    print("scale started on: \(calendar.getDescriptionOf(date: currentDate))") //scheduler.set(scheduledNotification: .init(uid: UUID().uuidString, title: "", description: "", date: currentDate))
//    currentDate = calendar.date(byAdding: dateComponent, value: scale.scaleOfWork, to: currentDate)!
//    print("scale finished on: \(calendar.getDescriptionOf(date: currentDate))\n")
//
//    while(!calendar.isDate(date: currentDate, inSameDayOrAfter: finalDate)!) {
//        print("scale rested on: \(calendar.getDescriptionOf(date: currentDate))") //scheduler.set(scheduledNotification: .init(uid: UUID().uuidString, title: "", description: "", date: currentDate))
//        currentDate = calendar.date(byAdding: dateComponent, value: scale.scaleOfRest, to: currentDate)!
//        print("scale rested finished on: \(calendar.getDescriptionOf(date: currentDate))\n")
//
//        print("scale started on: \(calendar.getDescriptionOf(date: currentDate))") //scheduler.set(scheduledNotification: .init(uid: UUID().uuidString, title: "", description: "", date: currentDate))
//        currentDate = calendar.date(byAdding: dateComponent, value: scale.scaleOfWork, to: currentDate)!
//        print("scale finished on: \(calendar.getDescriptionOf(date: currentDate))\n")
//    }
//}
