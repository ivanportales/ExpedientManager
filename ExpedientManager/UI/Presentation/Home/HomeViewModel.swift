//
//  HomeViewModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/20/24.
//

import Foundation

class HomeVideModel: ObservableObject {
    
    // MARK: - Binding Properties
    
    @Published var scheduledScales: [ScheduledNotification] = []
    @Published var filteredScheduledDates: [ScheduledNotification] = []
    
    // MARK: - Exposed Properties
    
    private(set) var scheduledScalesDict: [String: [ScheduledNotification]] = [:]
    
    // MARK: - Private Properties
    
    private let repository = CoreDataScheduledNotificationsRepository()
    
    // MARK: - Exposed Functions
    
    func filterScheduledDatesWith(date: Date) {
        filteredScheduledDates = scheduledScales.filter({Calendar.current.isDate(date: $0.date, inSameDayAs: date)!})
    }
    
    func load() {
        repository.getAllScheduledNotifications { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let itens):
                guard let self = self else {return}
                
                var newScheduledScaleDict: [String: [ScheduledNotification]] = [:]
                
                for scheduledScale in itens {
                    if let _ = newScheduledScaleDict[scheduledScale.date.dateString] {
                        newScheduledScaleDict[scheduledScale.date.dateString]!.append(scheduledScale)
                    } else {
                        newScheduledScaleDict[scheduledScale.date.dateString] = [scheduledScale]
                    }
                }
                
                self.scheduledScalesDict = newScheduledScaleDict
                self.scheduledScales = itens
                self.filterScheduledDatesWith(date: .init())
            }
        }
    }
    
    func deletAll() {
        CoreDataOnDutyRepository()
        CoreDataFixedScaleRepository().deleteAllShifts()
        let _ = repository.deleteAllScheduledNotifications()
    }
}

extension Date {
    var dateString: String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        return dateFormatterPrint.string(from: self)
    }
}
