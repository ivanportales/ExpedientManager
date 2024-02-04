//
//  CoreDataOnDutyRepository.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 22/01/24.
//

import CoreData
import Foundation

final class CoreDataOnDutyRepository: CoreDataRepository, OnDutyRepositoryProtocol {
    
    // MARK: - Init
    
    init(inMemory: Bool = false) {
        super.init(inMemory: inMemory,
                   storage: "ExpedientManager",
                   typeIdentifier: "CDOnDuty")
    }
    
    // MARK: - Exposed Functions
    
    func save(onDuty: OnDuty, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let mapperClosure: (CDOnDuty) -> Void = { newOnDuty in
            newOnDuty.id = onDuty.id
            newOnDuty.title = onDuty.titlo
            newOnDuty.initialDate = onDuty.initialDate
            newOnDuty.hoursDuration = Int32(onDuty.hoursDuration)
            newOnDuty.annotation = onDuty.annotation
            newOnDuty.colorHex = onDuty.colorHex
        }
        
        save(mapperClosure: mapperClosure, completionHandler: completionHandler)
    }
    
    func getAllOnDuty(completionHandler: @escaping (Result<[OnDuty], Error>) -> ()) {
        let mapperClosure: (CDOnDuty) -> OnDuty = { cdOnDuty in
            return OnDuty(
                id: cdOnDuty.id!,
                title: cdOnDuty.title!,
                initialDate: cdOnDuty.initialDate!,
                hoursDuration: Int(cdOnDuty.hoursDuration),
                annotation: cdOnDuty.annotation!,
                colorHex: cdOnDuty.colorHex
            )
        }
        
        getAllModels(mapperClosure: mapperClosure, completionHandler: completionHandler)
    }
    
    func delete(onDuty: OnDuty,
                completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let fetchRequest = makeFetchRequestFor(onDuty: onDuty)
        
        delete(withFetchRequest: fetchRequest, completionHandler: completionHandler)
    }
    
    func update(onDuty: OnDuty,
                completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let fetchRequest = makeFetchRequestFor(onDuty: onDuty)
        
        let mapperClosure: (CDOnDuty) -> Void = { onDutyToBeUpdated in
            onDutyToBeUpdated.id = onDuty.id
            onDutyToBeUpdated.title = onDuty.titlo
            onDutyToBeUpdated.annotation = onDuty.annotation
            onDutyToBeUpdated.initialDate = onDuty.initialDate
            onDutyToBeUpdated.hoursDuration = Int32(onDuty.hoursDuration)
            onDutyToBeUpdated.colorHex = onDuty.colorHex
        }
        
        update(withFetchRequest: fetchRequest,
               mapperClosure: mapperClosure,
               completionHandler: completionHandler)
    }
    
    // MARK: - Private Functions
    
    private func makeFetchRequestFor(onDuty: OnDuty) -> NSFetchRequest<CDOnDuty> {
        let fetchRequest = NSFetchRequest<CDOnDuty>(entityName: typeIdentifier)
        fetchRequest.predicate = NSPredicate(format: "initialDate = %@ AND id = %@", onDuty.initialDate as NSDate, onDuty.id)
        
        return fetchRequest
    }
}
