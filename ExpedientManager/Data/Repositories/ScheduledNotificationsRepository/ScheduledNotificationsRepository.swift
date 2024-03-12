//
//  CoreDataScheduledNotificationRepository.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/11/24.
//

import Foundation
import CoreData

final class CoreDataScheduledNotificationRepository: CoreDataRepository, ScheduledNotificationRepositoryProtocol {
    
    // MARK: - Inits
    
    init(inMemory: Bool = false) {
        super.init(inMemory: inMemory,
                   storage: "ExpedientManager",
                   typeIdentifier: "CDScheduledNotification")
    }
    
    // MARK: - Exposed Functions
    
    func save(scheduledNotification: ScheduledNotification,
              completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let scheduledNotificationModel = scheduledNotification.toData()
        let mapperClosure: (CDScheduledNotification) -> Void = { newScheduledNotification in
            newScheduledNotification.uid = scheduledNotificationModel.uid
            newScheduledNotification.scaleUid = scheduledNotificationModel.scaleUid
            newScheduledNotification.title = scheduledNotificationModel.title
            newScheduledNotification.descriptions = scheduledNotificationModel.description
            newScheduledNotification.date = scheduledNotificationModel.date
            newScheduledNotification.colorHex = scheduledNotificationModel.colorHex
        }
        
        save(mapperClosure: mapperClosure, completionHandler: completionHandler)
    }
    
    func getAllScheduledNotifications(completionHandler: @escaping (Result<[ScheduledNotification], Error>) -> ()) {
        let mapperClosure: (CDScheduledNotification) -> ScheduledNotification = { scheduledNotification in
            return ScheduledNotificationModel(uid: scheduledNotification.uid!,
                                              title: scheduledNotification.title!,
                                              description: scheduledNotification.descriptions!,
                                              date: scheduledNotification.date!,
                                              scaleUid: scheduledNotification.scaleUid!,
                                              colorHex: scheduledNotification.colorHex!).toDomain()
        }
        
        getAllModels(mapperClosure: mapperClosure, completionHandler: completionHandler)
    }
    
    func update(scheduledNotification: ScheduledNotification,
                completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let scheduledNotificationModel = scheduledNotification.toData()
        let fetchRequest = makeFetchRequestFor(scheduledNotification: scheduledNotificationModel)
        
        let mapperClosure: (CDScheduledNotification) -> Void = { newScheduledNotification in
            newScheduledNotification.uid = scheduledNotificationModel.uid
            newScheduledNotification.scaleUid = scheduledNotificationModel.scaleUid
            newScheduledNotification.title = scheduledNotificationModel.title
            newScheduledNotification.descriptions = scheduledNotificationModel.description
            newScheduledNotification.date = scheduledNotificationModel.date
            newScheduledNotification.colorHex = scheduledNotificationModel.colorHex
        }
        
        update(withFetchRequest: fetchRequest,
               mapperClosure: mapperClosure,
               completionHandler: completionHandler)
    }
    
    func delete(scheduledNotification: ScheduledNotification,
                completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let scheduledNotificationModel = scheduledNotification.toData()
        let fetchRequest = makeFetchRequestFor(scheduledNotification: scheduledNotificationModel)
        
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
