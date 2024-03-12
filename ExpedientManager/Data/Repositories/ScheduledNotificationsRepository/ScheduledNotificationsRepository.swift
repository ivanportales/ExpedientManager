//
//  ScheduledNotificationsRepository.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/11/24.
//

import Foundation
import CoreData

final class CoreDataScheduledNotificationsRepository: CoreDataRepository, ScheduledNotificationsRepositoryProtocol {
    
    // MARK: - Inits
    
    init(inMemory: Bool = false) {
        super.init(inMemory: inMemory,
                   storage: "ExpedientManager",
                   typeIdentifier: "CDScheduledNotification")
    }
    
    // MARK: - Exposed Functions
    
    func save(scheduledNotification: ScheduledNotificationModel,
              completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        
        let mapperClosure: (CDScheduledNotification) -> Void = { newScheduledNotification in
            newScheduledNotification.uid = scheduledNotification.uid
            newScheduledNotification.scaleUid = scheduledNotification.scaleUid
            newScheduledNotification.title = scheduledNotification.title
            newScheduledNotification.descriptions = scheduledNotification.description
            newScheduledNotification.date = scheduledNotification.date
            newScheduledNotification.colorHex = scheduledNotification.colorHex
        }
        
        save(mapperClosure: mapperClosure, completionHandler: completionHandler)
    }
    
    func getAllScheduledNotifications(completionHandler: @escaping (Result<[ScheduledNotificationModel], Error>) -> ()) {
        let mapperClosure: (CDScheduledNotification) -> ScheduledNotificationModel = { scheduledNotification in
            return ScheduledNotificationModel(uid: scheduledNotification.uid!,
                                              title: scheduledNotification.title!,
                                              description: scheduledNotification.descriptions!,
                                              date: scheduledNotification.date!,
                                              scaleUid: scheduledNotification.scaleUid!,
                                              colorHex: scheduledNotification.colorHex!)
        }
        
        getAllModels(mapperClosure: mapperClosure, completionHandler: completionHandler)
    }
    
    func update(scheduledNotification: ScheduledNotificationModel,
                completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let fetchRequest = makeFetchRequestFor(scheduledNotification: scheduledNotification)
        
        let mapperClosure: (CDScheduledNotification) -> Void = { newScheduledNotification in
            newScheduledNotification.uid = scheduledNotification.uid
            newScheduledNotification.scaleUid = scheduledNotification.scaleUid
            newScheduledNotification.title = scheduledNotification.title
            newScheduledNotification.descriptions = scheduledNotification.description
            newScheduledNotification.date = scheduledNotification.date
            newScheduledNotification.colorHex = scheduledNotification.colorHex
        }
        
        update(withFetchRequest: fetchRequest,
               mapperClosure: mapperClosure,
               completionHandler: completionHandler)
    }
    
    func delete(scheduledNotification: ScheduledNotificationModel,
                completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let fetchRequest = makeFetchRequestFor(scheduledNotification: scheduledNotification)
        
        delete(withFetchRequest: fetchRequest, completionHandler: completionHandler)
    }
    
    func deleteAllScheduledNotificationsWhere(scaleUid: String,
                                              completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: typeIdentifier)
        fetchRequest.predicate = NSPredicate(format: "scaleUid = %@", scaleUid)
        
        deleteAll(withFetchRequest: fetchRequest,
                  completionHandler: completionHandler)
    }
    
    // MARK: - Private Functions
    
    private func makeFetchRequestFor(scheduledNotification: ScheduledNotificationModel) -> NSFetchRequest<CDScheduledNotification> {
        let fetchRequest = NSFetchRequest<CDScheduledNotification>(entityName: typeIdentifier)
        fetchRequest.predicate = NSPredicate(format:"date = %@ AND uid = %@", scheduledNotification.date as NSDate, scheduledNotification.uid)
        
        return fetchRequest
    }
}
