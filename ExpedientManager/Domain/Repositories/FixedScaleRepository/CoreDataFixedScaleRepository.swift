//
//  CDShiftRepository.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 21/01/24.
//

import Foundation
import CoreData

class CoreDataFixedScaleRepository: FixedScaleRepository {
    private let container: NSPersistentContainer
    
    struct Constants {
        static let storage = "RotinaApp"
        static let typeIdentifier = "CDFixedScale"
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
    
    func save(fixedScale: FixedScale, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let context = container.viewContext
        
        let newFixedScale = NSEntityDescription.insertNewObject(forEntityName: Constants.typeIdentifier, into: context) as! CDFixedScale
        
        newFixedScale.id = fixedScale.id
        newFixedScale.scale =  try! JSONEncoder().encode(fixedScale.scale)
        newFixedScale.initialDate = fixedScale.initialDate
        newFixedScale.finalDate = fixedScale.finalDate
        newFixedScale.title = fixedScale.title
        newFixedScale.annotation = fixedScale.annotation
        newFixedScale.colorHex = fixedScale.colorHex
        
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
    
    func getAllFixedScales(completionHandler: @escaping (Result<[FixedScale], Error>) -> ()) {
        let context = container.viewContext
        
        let fetchRequest = NSFetchRequest<CDFixedScale>(entityName: Constants.typeIdentifier)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "initialDate", ascending: false)]
        
        do {
            let cdShifts = try context.fetch(fetchRequest)
            let shifts = cdShifts.map {self.CDFixedScaleToAppFixedScale(cdFixedScale: $0)}
            
            DispatchQueue.main.async {
                completionHandler(.success(shifts))
            }
        } catch {
            DispatchQueue.main.async {
                completionHandler(.failure(error))
            }
        }
    }
    
    func delete(fixedScale: FixedScale) -> Result<Bool, Error> {
        let context = container.viewContext
        
        let fetchRequest = self.configFetchRequestFor(fixedScale: fixedScale)
        
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
    
    func update(fixedScale: FixedScale) -> Result<Bool, Error> {
        let context = container.viewContext
        
        let fetchRequest = self.configFetchRequestFor(fixedScale: fixedScale)
        
        do {
            let cdShifts = try context.fetch(fetchRequest)
            if let shiftToBeUpdated = cdShifts.first {
                shiftToBeUpdated.id = fixedScale.id
                shiftToBeUpdated.title = fixedScale.title
                shiftToBeUpdated.scale = try! JSONEncoder().encode(fixedScale.scale)
                shiftToBeUpdated.initialDate = fixedScale.initialDate
                shiftToBeUpdated.finalDate = shiftToBeUpdated.finalDate
                shiftToBeUpdated.annotation = fixedScale.annotation
                shiftToBeUpdated.colorHex = fixedScale.colorHex
                
                try context.save()
            }
        } catch let fetchError {
            return .failure(fetchError)
        }
        
        return .success(true)
    }
    
    func deleteAllShifts() -> Result<Bool, Error> {
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
    
    private func configFetchRequestFor(fixedScale: FixedScale) -> NSFetchRequest<CDFixedScale> {
        let fetchRequest = NSFetchRequest<CDFixedScale>(entityName: Constants.typeIdentifier)
        
        fetchRequest.predicate = NSPredicate(format:"initialDate = %@ AND id = %@", fixedScale.initialDate! as NSDate, fixedScale.id)
        
        return fetchRequest
    }
    
    private func CDFixedScaleToAppFixedScale(cdFixedScale: CDFixedScale) -> FixedScale {
        FixedScale(
            id: cdFixedScale.id!,
            title: cdFixedScale.title!,
            scale: try! JSONDecoder().decode(Scale.self, from: cdFixedScale.scale!),
            initialDate: cdFixedScale.initialDate!,
            finalDate: cdFixedScale.finalDate!,
            annotation: cdFixedScale.annotation!,
            colorHex: cdFixedScale.colorHex!
        )
    }
}
