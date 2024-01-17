//
//  ScheduledNotificationsRepository.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/11/24.
//

import Foundation
import CoreData

class CoreDataScheduledNotificationsRepository {
    private let container: NSPersistentContainer
    
    struct Constants {
        static let storage = "RotinaApp"
        static let typeIdentifier = "CDScheduledNotification"
    }
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: Constants.storage)
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description")
        }
        
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        //description.cloudKitContainerOptions?.databaseScope = .private
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func save(scheduledNotification: ScheduledNotification, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let context = container.viewContext
        
        let newScheduledNotification = NSEntityDescription.insertNewObject(forEntityName: Constants.typeIdentifier, into: context) as! CDScheduledNotification
        
        newScheduledNotification.uid = scheduledNotification.uid
        newScheduledNotification.scaleUid = scheduledNotification.scaleUid
        newScheduledNotification.title = scheduledNotification.title
        newScheduledNotification.descriptions = scheduledNotification.description
        newScheduledNotification.date = scheduledNotification.date
        newScheduledNotification.colorHex = scheduledNotification.colorHex
        
        do {
            try context.save()
            DispatchQueue.main.async {
                completionHandler(.success(true))
            }
        } catch {
            DispatchQueue.main.async {
                completionHandler(.failure(error))
            }
        }
    }
    
    func getAllScheduledNotifications(completionHandler: @escaping (Result<[ScheduledNotification], Error>) -> ()) {
        let context = container.viewContext
        
        let fetchRequest = NSFetchRequest<CDScheduledNotification>(entityName: Constants.typeIdentifier)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let cdShifts = try context.fetch(fetchRequest)
            let shifts = cdShifts.map {self.CDScheduledNotificationsToScheudledNotifications(cdSchedulednotification: $0)}
            
            DispatchQueue.main.async {
                completionHandler(.success(shifts))
            }
        } catch {
            DispatchQueue.main.async {
                completionHandler(.failure(error))
            }
        }
    }
    
    func delete(scheduledNotification: ScheduledNotification) -> Result<Bool, Error> {
        let context = container.viewContext
        
        let fetchRequest = self.configFetchRequestFor(scheduledNotification: scheduledNotification)
        
        do {
            let cdFixedScales = try context.fetch(fetchRequest)
            if let shiftToBeDeleted = cdFixedScales.first {
                context.delete(shiftToBeDeleted)
                try context.save()
            }
        } catch let fetchError {
            return .failure(fetchError)
        }
        
        return .success(true)
    }
    
    func update(scheduledNotification: ScheduledNotification) -> Result<Bool, Error> {
        let context = container.viewContext
        
        let fetchRequest = self.configFetchRequestFor(scheduledNotification: scheduledNotification)
        
        do {
            let cdShifts = try context.fetch(fetchRequest)
            if let newScheduledNotification = cdShifts.first {
                newScheduledNotification.uid = scheduledNotification.uid
                newScheduledNotification.scaleUid = scheduledNotification.scaleUid
                newScheduledNotification.title = scheduledNotification.title
                newScheduledNotification.descriptions = scheduledNotification.description
                newScheduledNotification.date = scheduledNotification.date
                newScheduledNotification.colorHex = scheduledNotification.colorHex
                
                try context.save()
            }
        } catch let fetchError {
            return .failure(fetchError)
        }
        
        return .success(true)
    }

    
//    func update(whereScaleId scaleUid: String) -> Result<Bool, Error> {
//        let context = container.viewContext
//        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.typeIdentifier)
//        fetchRequest.predicate = NSPredicate(format: "scaleUid = %@", scaleUid)
//        
//        do {
//            let cdShifts = try context.fetch(fetchRequest)
//            if let newScheduledNotification = cdShifts.first {
//                newScheduledNotification.uid = scheduledNotification.uid
//                newScheduledNotification.scaleUid = scheduledNotification.scaleUid
//                newScheduledNotification.title = scheduledNotification.title
//                newScheduledNotification.descriptions = scheduledNotification.description
//                newScheduledNotification.date = scheduledNotification.date
//                newScheduledNotification.colorHex = scheduledNotification.colorHex
//                
//                try context.save()
//            }
//        } catch let fetchError {
//            return .failure(fetchError)
//        }
//        
//        return .success(true)
//    }
    
    func deleteAllScheduledNotifications() -> Result<Bool, Error> {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.typeIdentifier)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch  {
            return .failure(error)
        }
        
        return .success(true)
    }
    
    func deleteAllScheduledNotificationsWhere(scaleUid: String) -> Result<Bool, Error> {
        let context = container.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.typeIdentifier)
        fetchRequest.predicate = NSPredicate(format: "scaleUid = %@", scaleUid)
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch  {
            return .failure(error)
        }
        
        return .success(true)
    }
    
    private func configFetchRequestFor(scheduledNotification: ScheduledNotification) -> NSFetchRequest<CDScheduledNotification> {
        let fetchRequest = NSFetchRequest<CDScheduledNotification>(entityName: Constants.typeIdentifier)
        
        fetchRequest.predicate = NSPredicate(format:"date = %@ AND uid = %@", scheduledNotification.date as NSDate, scheduledNotification.uid)
        
        return fetchRequest
    }
    
    private func CDScheduledNotificationsToScheudledNotifications(cdSchedulednotification: CDScheduledNotification) -> ScheduledNotification {
        ScheduledNotification(
            uid: cdSchedulednotification.uid!,
            title: cdSchedulednotification.title!,
            description: cdSchedulednotification.descriptions!,
            date: cdSchedulednotification.date!,
            scaleUid: cdSchedulednotification.scaleUid!,
            colorHex: cdSchedulednotification.colorHex!)
    }
}
