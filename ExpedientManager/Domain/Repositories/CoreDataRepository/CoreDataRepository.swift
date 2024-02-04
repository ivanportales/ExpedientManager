//
//  CoreDataRepository.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 03/02/24.
//

import CoreData
import Foundation

open class CoreDataRepository {
    
    // MARK: - Private Properties
    
    internal var container: NSPersistentContainer
    internal let storage: String
    internal let typeIdentifier: String
    
    // MARK: - Inits
    
    init(inMemory: Bool = false, storage: String, typeIdentifier: String) {
        self.storage = storage
        self.typeIdentifier = typeIdentifier
        self.container = NSPersistentCloudKitContainer(name: storage)
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description")
        }
        
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // MARK: - Exposed Functions
    
    func save<ManagedObjectType: NSManagedObject>(mapperClosure: (ManagedObjectType) -> Void,
                                                  completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let context = container.viewContext
        
        let coreDataModel = NSEntityDescription.insertNewObject(forEntityName: typeIdentifier, into: context) as! ManagedObjectType
        
        mapperClosure(coreDataModel)
        
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
    
    func getAllModels<ManagedObjectType: NSManagedObject, ReturnType>(mapperClosure: (ManagedObjectType) -> ReturnType,
                                                                      completionHandler: @escaping (Result<[ReturnType], Error>) -> ()) {
        let context = container.viewContext
        
        let fetchRequest = NSFetchRequest<ManagedObjectType>(entityName: typeIdentifier)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let coreDataModels = try context.fetch(fetchRequest)
            let models = coreDataModels.map { mapperClosure($0) }
            
            DispatchQueue.main.async {
                completionHandler(.success(models))
            }
        } catch {
            DispatchQueue.main.async {
                completionHandler(.failure(error))
            }
        }
    }
    
    func update<ManagedObjectType: NSManagedObject>(withFetchRequest fetchRequest: NSFetchRequest<ManagedObjectType>,
                                                    mapperClosure: (ManagedObjectType) -> Void,
                                                    completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let context = container.viewContext
        
        do {
            let coreDataModels = try context.fetch(fetchRequest)
            if let firstModel = coreDataModels.first {
                mapperClosure(firstModel)
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
    
    func delete<ManagedType: NSManagedObject>(withFetchRequest fetchRequest: NSFetchRequest<ManagedType>,
                                              completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let context = container.viewContext
        
        do {
            let coreDataModels = try context.fetch(fetchRequest)
            if let modelToBeDeleted = coreDataModels.first {
                context.delete(modelToBeDeleted)
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
    
    func deleteAll(withFetchRequest fetchRequest: NSFetchRequest<NSFetchRequestResult>,
                   completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let context = container.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
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
    
    // I was thinking of using this, but for someone outside the project,it may be more confusing than it should, but i think its a good "idea" of code, maybe later
    
    private func makeFetchRequest<FetchRequestResult: NSFetchRequestResult>(withArguments requestArguments: [String: Any]) -> NSFetchRequest<FetchRequestResult> {
        let argumentsStringQuery = requestArguments.keys.map { "\($0) = %@" }.joined(separator: "AND")
        let argumentArray = requestArguments.values.map { $0 }
        
        let fetchRequest = NSFetchRequest<FetchRequestResult>(entityName: typeIdentifier)
        fetchRequest.predicate = NSPredicate(format: argumentsStringQuery, argumentArray: argumentArray)
        
        return fetchRequest
    }
}
