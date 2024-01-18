//
//  CoreDataOnDutyRepository.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 22/01/24.
//

import Foundation
import CoreData

class CoreDataOnDutyRepository: OnDutyRepositoryProtocol {
    
    // MARK: - Private Properties
    
    private let container: NSPersistentContainer
    
    struct Constants {
        static let storage = "RotinaApp"
        static let typeIdentifier = "CDOnDuty"
    }
    
    // MARK: - Init
    
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
    
    // MARK: - Exposed Functions
    
    func save(onDuty: OnDuty, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let context = container.viewContext
        
        let newOnDuty = NSEntityDescription.insertNewObject(forEntityName: Constants.typeIdentifier, into: context) as! CDOnDuty
        
        newOnDuty.id = onDuty.id
        newOnDuty.title = onDuty.titlo
        newOnDuty.initialDate = onDuty.initialDate
        newOnDuty.hoursDuration = Int32(onDuty.hoursDuration)
        newOnDuty.annotation = onDuty.annotation
        newOnDuty.colorHex = onDuty.colorHex
        
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
    
    func getAllOnDuty(completionHandler: @escaping (Result<[OnDuty], Error>) -> ()) {
        let context = container.viewContext
        
        let fetchRequest = NSFetchRequest<CDOnDuty>(entityName: Constants.typeIdentifier)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "initialDate", ascending: false)]
        
        do {
            let cdShifts = try context.fetch(fetchRequest)
            let shifts = cdShifts.map {self.CDOnDutyToAppOnDuty(cdOnDuty: $0)}
            
            DispatchQueue.main.async {
                completionHandler(.success(shifts))
            }
        } catch {
            DispatchQueue.main.async {
                completionHandler(.failure(error))
            }
        }
    }
    
    func delete(onDuty: OnDuty,
                completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let context = container.viewContext
        
        let fetchRequest = self.configFetchRequestFor(onDuty: onDuty)
        
        do {
            let cdOnDutys = try context.fetch(fetchRequest)
            if let onDutyToBeDeleted = cdOnDutys.first {
                context.delete(onDutyToBeDeleted)
                try context.save()
            }
        } catch {
            DispatchQueue.main.async {
                completionHandler(.failure(error))
            }
            return
        }
        
        DispatchQueue.main.async {
            completionHandler(.success(true))
        }
    }
    
    func update(onDuty: OnDuty,
                completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let context = container.viewContext
        
        let fetchRequest = self.configFetchRequestFor(onDuty: onDuty)
        
        do {
            let cdOnDutys = try context.fetch(fetchRequest)
            if let onDutyToBeUpdated = cdOnDutys.first {
                onDutyToBeUpdated.id = onDuty.id
                onDutyToBeUpdated.title = onDuty.titlo
                onDutyToBeUpdated.annotation = onDuty.annotation
                onDutyToBeUpdated.initialDate = onDuty.initialDate
                onDutyToBeUpdated.hoursDuration = Int32(onDuty.hoursDuration)
                onDutyToBeUpdated.colorHex = onDuty.colorHex
                
                try context.save()
            }
        } catch {
            DispatchQueue.main.async {
                completionHandler(.failure(error))
            }
            return
        }
        
        DispatchQueue.main.async {
            completionHandler(.success(true))
        }
    }
    
    // MARK: - Private Functions
    
    private func configFetchRequestFor(onDuty: OnDuty) -> NSFetchRequest<CDOnDuty> {
        let fetchRequest = NSFetchRequest<CDOnDuty>(entityName: Constants.typeIdentifier)
        
        fetchRequest.predicate = NSPredicate(format: "initialDate = %@ AND id = %@", onDuty.initialDate as NSDate, onDuty.id)
        
        return fetchRequest
    }
    
    private func CDOnDutyToAppOnDuty(cdOnDuty: CDOnDuty) -> OnDuty {
        OnDuty(
            id: cdOnDuty.id!,
            title: cdOnDuty.title!,
            initialDate: cdOnDuty.initialDate!,
            hoursDuration: Int(cdOnDuty.hoursDuration),
            annotation: cdOnDuty.annotation!,
            colorHex: cdOnDuty.colorHex
        )
    }
}
