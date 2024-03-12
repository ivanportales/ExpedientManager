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
        let onDutyModel = onDuty.toData()
        let mapperClosure: (CDOnDuty) -> Void = { newOnDuty in
            newOnDuty.id = onDutyModel.id
            newOnDuty.title = onDutyModel.titlo
            newOnDuty.initialDate = onDutyModel.initialDate
            newOnDuty.hoursDuration = Int32(onDutyModel.hoursDuration)
            newOnDuty.annotation = onDutyModel.annotation
            newOnDuty.colorHex = onDutyModel.colorHex
        }
        
        save(mapperClosure: mapperClosure, completionHandler: completionHandler)
    }
    
    func getAllOnDuty(completionHandler: @escaping (Result<[OnDuty], Error>) -> ()) {
        let mapperClosure: (CDOnDuty) -> OnDuty = { cdOnDuty in
            return OnDutyModel(
                id: cdOnDuty.id!,
                title: cdOnDuty.title!,
                initialDate: cdOnDuty.initialDate!,
                hoursDuration: Int(cdOnDuty.hoursDuration),
                annotation: cdOnDuty.annotation!,
                colorHex: cdOnDuty.colorHex
            ).toDomain()
        }
        
        getAllModels(mapperClosure: mapperClosure, completionHandler: completionHandler)
    }
    
    func update(onDuty: OnDuty,
                completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let onDutyModel = onDuty.toData()
        let fetchRequest = makeFetchRequestFor(onDuty: onDutyModel)
        
        let mapperClosure: (CDOnDuty) -> Void = { onDutyToBeUpdated in
            onDutyToBeUpdated.id = onDutyModel.id
            onDutyToBeUpdated.title = onDutyModel.titlo
            onDutyToBeUpdated.annotation = onDutyModel.annotation
            onDutyToBeUpdated.initialDate = onDutyModel.initialDate
            onDutyToBeUpdated.hoursDuration = Int32(onDutyModel.hoursDuration)
            onDutyToBeUpdated.colorHex = onDutyModel.colorHex
        }
        
        update(withFetchRequest: fetchRequest,
               mapperClosure: mapperClosure,
               completionHandler: completionHandler)
    }
    
    func delete(onDuty: OnDuty,
                completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let onDutyModel = onDuty.toData()
        let fetchRequest = makeFetchRequestFor(onDuty: onDutyModel)
        
        delete(withFetchRequest: fetchRequest, completionHandler: completionHandler)
    }
    
    // MARK: - Private Functions
    
    private func makeFetchRequestFor(onDuty: OnDutyModel) -> NSFetchRequest<CDOnDuty> {
        let fetchRequest = NSFetchRequest<CDOnDuty>(entityName: typeIdentifier)
        fetchRequest.predicate = NSPredicate(format: "initialDate = %@ AND id = %@", onDuty.initialDate as NSDate, onDuty.id)
        
        return fetchRequest
    }
}
