//
//  SistemaManager.swift
//  GestorGenerico
//
//  Created by jon mikel on 22/09/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import CoreData

class SistemaManager: NSObject {
    let TABLE_ENTITY_NAME: String = "Sistema"
    
    var backgroundContext: NSManagedObjectContext!//para escritura
    var mainContext: NSManagedObjectContext!//para lectura
    
    override init() {
        super.init()
        let app = UIApplication.shared.delegate as! AppDelegate
        backgroundContext = app.persistentContainer.newBackgroundContext()
        mainContext = app.persistentContainer.viewContext
    }
    
    func getAllSistemas() -> [SistemaModel] {
        var sistemas: [SistemaModel] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
        fetchRequest.returnsObjectsAsFaults = false
        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                for data in results {
                    sistemas.append(parseSistemaCoreObjectToSistemaModel(coreObject: data))
                }
            } catch {
            }
        }
    
        return sistemas
    }
    
    func syncronizeSistemasAsync(sistemas: [SistemaModel]) {
        backgroundContext.perform {
             for sistema: SistemaModel in sistemas {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.TABLE_ENTITY_NAME)
                fetchRequest.predicate = NSPredicate(format: "sistemaId = %f", argumentArray: [sistema.sistemaId])
                let result: NSManagedObject? = try! self.backgroundContext.fetch(fetchRequest).first
                 
                if result != nil {
                    self.setCoreDataObjectDataFromSistema(coreDataObject: result!, sistema: sistema)
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: self.TABLE_ENTITY_NAME, in: self.backgroundContext)
                    let coreSistema = NSManagedObject(entity: entity!, insertInto: self.backgroundContext)
                    self.setCoreDataObjectDataFromSistema(coreDataObject: coreSistema, sistema: sistema)
                }
             }
             
             try! self.backgroundContext.save()
         }
    }
    
    func deleteAllSistemas() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
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
    
    func parseSistemaCoreObjectToSistemaModel(coreObject: NSManagedObject) -> SistemaModel {
        let sistema: SistemaModel = SistemaModel()
        sistema.sistemaId = coreObject.value(forKey: "sistemaId") as! Int64
        sistema.nombre = coreObject.value(forKey: "nombre") as! String
        sistema.subtitulo = coreObject.value(forKey: "subtitulo") as! String
        sistema.sis1 = coreObject.value(forKey: "sis1") as! String
        sistema.sis2 = coreObject.value(forKey: "sis2") as! String
        sistema.sis3 = coreObject.value(forKey: "sis3") as! String
        sistema.sis4 = coreObject.value(forKey: "sis4") as! String
        sistema.sis5 = coreObject.value(forKey: "sis5") as! String
        sistema.sis6 = coreObject.value(forKey: "sis6") as! String
        
        return sistema
    }
    
    func setCoreDataObjectDataFromSistema(coreDataObject: NSManagedObject, sistema: SistemaModel) {
        coreDataObject.setValue(sistema.sistemaId, forKey: "sistemaId")
        coreDataObject.setValue(sistema.nombre, forKey: "nombre")
        coreDataObject.setValue(sistema.subtitulo, forKey: "subtitulo")
        coreDataObject.setValue(sistema.sis1, forKey: "sis1")
        coreDataObject.setValue(sistema.sis2, forKey: "sis2")
        coreDataObject.setValue(sistema.sis3, forKey: "sis3")
        coreDataObject.setValue(sistema.sis4, forKey: "sis4")
        coreDataObject.setValue(sistema.sis5, forKey: "sis5")
        coreDataObject.setValue(sistema.sis6, forKey: "sis6")
    }
}
