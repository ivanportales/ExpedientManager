//
//  CDShiftRepository.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 21/01/24.
//

import CoreData
import Foundation

final class CoreDataFixedScaleRepository: CoreDataRepository, FixedScaleRepositoryProtocol {
    
    // MARK: - Init
    
    init(inMemory: Bool = false) {
        super.init(inMemory: inMemory,
                   storage: "ExpedientManager",
                   typeIdentifier: "CDFixedScale")
    }
    
    // MARK: - Exposed Functions
    
    func save(fixedScale: FixedScaleModel, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let mapperClosure: (CDFixedScale) -> Void = { newFixedScale in
            newFixedScale.id = fixedScale.id
            newFixedScale.scale =  try? JSONEncoder().encode(fixedScale.scale)
            newFixedScale.initialDate = fixedScale.initialDate
            newFixedScale.finalDate = fixedScale.finalDate
            newFixedScale.title = fixedScale.title
            newFixedScale.annotation = fixedScale.annotation
            newFixedScale.colorHex = fixedScale.colorHex
        }
        
        save(mapperClosure: mapperClosure, completionHandler: completionHandler)
    }
    
    func getAllFixedScales(completionHandler: @escaping (Result<[FixedScaleModel], Error>) -> ()) {
        let mapperClosure: (CDFixedScale) -> FixedScaleModel = { cdFixedScale in
            return FixedScaleModel(
                id: cdFixedScale.id!,
                title: cdFixedScale.title!,
                scale: try! JSONDecoder().decode(ScaleModel.self, from: cdFixedScale.scale!),
                initialDate: cdFixedScale.initialDate!,
                finalDate: cdFixedScale.finalDate!,
                annotation: cdFixedScale.annotation!,
                colorHex: cdFixedScale.colorHex!
            )
        }
        
        getAllModels(mapperClosure: mapperClosure, completionHandler: completionHandler)
    }
    
    func update(fixedScale: FixedScaleModel,
                completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let fetchRequest = makeFetchRequestFor(fixedScale: fixedScale)
        
        let mapperClosure: (CDFixedScale) -> Void = { shiftToBeUpdated in
            shiftToBeUpdated.id = fixedScale.id
            shiftToBeUpdated.title = fixedScale.title
            shiftToBeUpdated.scale = try! JSONEncoder().encode(fixedScale.scale)
            shiftToBeUpdated.initialDate = fixedScale.initialDate
            shiftToBeUpdated.finalDate = shiftToBeUpdated.finalDate
            shiftToBeUpdated.annotation = fixedScale.annotation
            shiftToBeUpdated.colorHex = fixedScale.colorHex
        }
        
        update(withFetchRequest: fetchRequest,
               mapperClosure: mapperClosure,
               completionHandler: completionHandler)
    }
    
    func delete(fixedScale: FixedScaleModel,
                completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let fetchRequest = makeFetchRequestFor(fixedScale: fixedScale)
                
        delete(withFetchRequest: fetchRequest, completionHandler: completionHandler)
    }
    
    // MARK: - Private Functions
    
    private func makeFetchRequestFor(fixedScale: FixedScaleModel) -> NSFetchRequest<CDFixedScale> {
        let fetchRequest = NSFetchRequest<CDFixedScale>(entityName: typeIdentifier)
        fetchRequest.predicate = NSPredicate(format:"initialDate = %@ AND id = %@", fixedScale.initialDate! as NSDate, fixedScale.id)
        
        return fetchRequest
    }
}
