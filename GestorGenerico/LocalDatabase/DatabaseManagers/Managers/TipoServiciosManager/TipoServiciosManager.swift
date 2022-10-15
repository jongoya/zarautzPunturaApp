//
//  TipoServiciosManager.swift
//  GestorHeme
//
//  Created by jon mikel on 12/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import CoreData

class TipoServiciosManager: NSObject {
    let TIPOSERVICIOS_ENTITY_NAME: String = "TipoServicios"
    var databaseHelper: DatabaseHelper!
    
    var backgroundContext: NSManagedObjectContext!//para escritura
    var mainContext: NSManagedObjectContext!//para lectura
    
    override init() {
        super.init()
        let app = UIApplication.shared.delegate as! AppDelegate
        backgroundContext = app.persistentContainer.newBackgroundContext()
        mainContext = app.persistentContainer.viewContext
        databaseHelper = DatabaseHelper()
    }
    
    func getAllServiciosFromDatabase() -> [TipoServicioModel] {
        var servicios: [TipoServicioModel] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TIPOSERVICIOS_ENTITY_NAME)
        fetchRequest.returnsObjectsAsFaults = false
        
        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                for data in results {
                    servicios.append(databaseHelper.parseTipoServiciosCoreObjectToTipoServicioModel(coreObject: data))
                }
            } catch {
            }
        }

        return servicios
    }
    
    func addTipoServicioToDatabase(servicio: TipoServicioModel) {
        let entity = NSEntityDescription.entity(forEntityName: TIPOSERVICIOS_ENTITY_NAME, in: backgroundContext)
        
        if getCoreTipoServicioFromDatabase(servicioId: servicio.servicioId).count == 0 {
            let coreService = NSManagedObject(entity: entity!, insertInto: backgroundContext)
            databaseHelper.setCoreDataObjectDataFromTipoServicio(coreDataObject: coreService, newServicio: servicio)
            backgroundContext.performAndWait {
                do {
                    try backgroundContext.save()
                } catch {
                }
            }
        }
    }
    
    func updateServiceInDatabase(service: TipoServicioModel) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TIPOSERVICIOS_ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "servicioId = %f", argumentArray: [service.servicioId])
        var results: [NSManagedObject] = []
        
        mainContext.performAndWait {
            do {
                results = try mainContext.fetch(fetchRequest)
                if results.count != 0 {
                    let coreService: NSManagedObject = results.first!
                    databaseHelper.setCoreDataObjectDataFromTipoServicio(coreDataObject: coreService, newServicio: service)
                    try mainContext.save()
                }
            } catch {
                print("Error updating service in database")
            }
        }
    }
    
    func getCoreTipoServicioFromDatabase(servicioId: Int64) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TIPOSERVICIOS_ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "servicioId = %f", argumentArray: [servicioId])
        var results: [NSManagedObject] = []
        
        mainContext.performAndWait {
            do {
                results = try mainContext.fetch(fetchRequest)
            } catch {
            }
        }
        
        return results
    }
    
    func getTipoServicioFromDatabase(servicioId: Int64) -> TipoServicioModel {
        let coreTipoServicios: [NSManagedObject] = getCoreTipoServicioFromDatabase(servicioId: servicioId)
        
        return databaseHelper.parseTipoServiciosCoreObjectToTipoServicioModel(coreObject: coreTipoServicios.first!)
    }
    
    func deleteAllTipoServicios() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TIPOSERVICIOS_ENTITY_NAME)
                var results: [NSManagedObject] = []
        backgroundContext.performAndWait {
            do {
                results = try backgroundContext.fetch(fetchRequest)
                for object in results {
                    backgroundContext.delete(object)
                }
                
                try backgroundContext.save()
            } catch {
            }
        }
    }
    
    func syncronizeTipoDeServicios(tipoServicios: [TipoServicioModel]) {
        backgroundContext.performAndWait {
            for tipoServicio: TipoServicioModel in tipoServicios {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TIPOSERVICIOS_ENTITY_NAME)
                fetchRequest.predicate = NSPredicate(format: "servicioId = %f", argumentArray: [tipoServicio.servicioId])
                let result: NSManagedObject? = try! backgroundContext.fetch(fetchRequest).first
                
                if result == nil {
                    let entity = NSEntityDescription.entity(forEntityName: TIPOSERVICIOS_ENTITY_NAME, in: backgroundContext)
                    let coreTipoServicio = NSManagedObject(entity: entity!, insertInto: backgroundContext)
                    databaseHelper.setCoreDataObjectDataFromTipoServicio(coreDataObject: coreTipoServicio, newServicio: tipoServicio)
                } else {
                    databaseHelper.setCoreDataObjectDataFromTipoServicio(coreDataObject: result!, newServicio: tipoServicio)
                }
            }
            
            try! backgroundContext.save()
        }
    }
}
