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
    
    func save(fixedScale: FixedScale, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let fixedScaleModel = fixedScale.toData()
        let mapperClosure: (CDFixedScale) -> Void = { newFixedScale in
            newFixedScale.id = fixedScaleModel.id
            newFixedScale.scale =  try? JSONEncoder().encode(fixedScaleModel.scale)
            newFixedScale.initialDate = fixedScaleModel.initialDate
            newFixedScale.finalDate = fixedScaleModel.finalDate
            newFixedScale.title = fixedScaleModel.title
            newFixedScale.annotation = fixedScaleModel.annotation
            newFixedScale.colorHex = fixedScaleModel.colorHex
        }
        
        save(mapperClosure: mapperClosure, completionHandler: completionHandler)
    }
    
    func getAllFixedScales(completionHandler: @escaping (Result<[FixedScale], Error>) -> ()) {
        let mapperClosure: (CDFixedScale) -> FixedScale = { cdFixedScale in
            return FixedScaleModel(
                id: cdFixedScale.id!,
                title: cdFixedScale.title!,
                scale: try! JSONDecoder().decode(ScaleModel.self, from: cdFixedScale.scale!),
                initialDate: cdFixedScale.initialDate!,
                finalDate: cdFixedScale.finalDate!,
                annotation: cdFixedScale.annotation!,
                colorHex: cdFixedScale.colorHex!
            ).toDomain()
        }
        
        getAllModels(mapperClosure: mapperClosure, completionHandler: completionHandler)
    }
    
    func update(fixedScale: FixedScale,
                completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let fixedScaleModel = fixedScale.toData()
        let fetchRequest = makeFetchRequestFor(fixedScale: fixedScaleModel)
        
        let mapperClosure: (CDFixedScale) -> Void = { shiftToBeUpdated in
            shiftToBeUpdated.id = fixedScaleModel.id
            shiftToBeUpdated.title = fixedScaleModel.title
            shiftToBeUpdated.scale = try! JSONEncoder().encode(fixedScaleModel.scale)
            shiftToBeUpdated.initialDate = fixedScaleModel.initialDate
            shiftToBeUpdated.finalDate = shiftToBeUpdated.finalDate
            shiftToBeUpdated.annotation = fixedScaleModel.annotation
            shiftToBeUpdated.colorHex = fixedScaleModel.colorHex
        }
        
        update(withFetchRequest: fetchRequest,
               mapperClosure: mapperClosure,
               completionHandler: completionHandler)
    }
    
    func delete(fixedScale: FixedScale,
                completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        let fixedScaleModel = fixedScale.toData()
        let fetchRequest = makeFetchRequestFor(fixedScale: fixedScaleModel)
                
        delete(withFetchRequest: fetchRequest, completionHandler: completionHandler)
    }
    
    // MARK: - Private Functions
    
    private func makeFetchRequestFor(fixedScale: FixedScaleModel) -> NSFetchRequest<CDFixedScale> {
        let fetchRequest = NSFetchRequest<CDFixedScale>(entityName: typeIdentifier)
        fetchRequest.predicate = NSPredicate(format:"initialDate = %@ AND id = %@", fixedScale.initialDate! as NSDate, fixedScale.id)
        
        return fetchRequest
    }
}
