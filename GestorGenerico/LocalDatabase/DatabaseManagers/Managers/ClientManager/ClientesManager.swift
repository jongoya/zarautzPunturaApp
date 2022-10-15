//
//  ClientesManager.swift
//  GestorHeme
//
//  Created by jon mikel on 31/03/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import  CoreData

class ClientesManager: NSObject {
    let CLIENTES_ENTITY_NAME: String = "Cliente"
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

    func getAllClientsFromDatabase() -> [ClientModel] {
        var clientes: [ClientModel] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CLIENTES_ENTITY_NAME)
        fetchRequest.returnsObjectsAsFaults = false
        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                for data in results {
                    clientes.append(databaseHelper.parseClientCoreObjectToClientModel(coreObject: data))
                }
            } catch {
            }
        }
    
        return clientes
    }
    
    func getClientsFilteredByText(text: String) -> [ClientModel] {
        var filteredArray: [ClientModel] = []
        let clients: [ClientModel] = getAllClientsFromDatabase()
        for client: ClientModel in clients {
            let completeName: String = client.nombre.lowercased() + " " + client.apellidos.lowercased()
            if completeName.contains(text.lowercased()) {
                filteredArray.append(client)
            }
        }
        
        return filteredArray
    }
    
    func getClientsFilteredByPhone(phone: String) -> [ClientModel] {
        var filteredArray: [ClientModel] = []
        let clients: [ClientModel] = getAllClientsFromDatabase()
        for client: ClientModel in clients {
            let completPhone: String = client.telefono.trimmingCharacters(in: .whitespaces)
            if completPhone.contains(phone) {
                filteredArray.append(client)
            }
        }
        
        return filteredArray
    }
    
    func addClientToDatabase(newClient: ClientModel) {
        let entity = NSEntityDescription.entity(forEntityName: CLIENTES_ENTITY_NAME, in: backgroundContext)
        
        if getCoreClientFromDatabase(clientId: newClient.id).count == 0 {
            let client = NSManagedObject(entity: entity!, insertInto: backgroundContext)
            databaseHelper.setCoreDataObjectDataFromClient(coreDataObject: client, newClient: newClient)
            backgroundContext.performAndWait {
                do {
                    try backgroundContext.save()
                } catch {
                }
            }
        }
    }
    
    func getCoreClientFromDatabase(clientId: Int64) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CLIENTES_ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "idCliente = %f", argumentArray: [clientId])
        var results: [NSManagedObject] = []
        mainContext.performAndWait {
            do {
                results = try mainContext.fetch(fetchRequest)
            } catch {
            }
        }
        
        return results
    }
    
    func getClientFromDatabase(clientId: Int64) -> ClientModel? {
        let coreClients: [NSManagedObject] =  getCoreClientFromDatabase(clientId: clientId)
        if coreClients.count == 0 {
            return nil
        }
        
        return databaseHelper.parseClientCoreObjectToClientModel(coreObject: coreClients.first!)
    }
    
    func updateClientInDatabase(client: ClientModel) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CLIENTES_ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "idCliente = %f", argumentArray: [client.id])
        var results: [NSManagedObject] = []
        
        backgroundContext.performAndWait {
            do {
                results = try backgroundContext.fetch(fetchRequest)
                
                if results.count != 0 {
                    let coreClient: NSManagedObject = results.first!
                    databaseHelper.updateClientObject(coreClient: coreClient, client: client)
                    try backgroundContext.save()
                }
            } catch {
            }
        }
    }
    
    func deleteAllClients() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CLIENTES_ENTITY_NAME)
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
    
    func syncronizeClientsAsync(clientes: [ClientModel]) {
        backgroundContext.perform {
            for cliente: ClientModel in clientes {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.CLIENTES_ENTITY_NAME)
                fetchRequest.predicate = NSPredicate(format: "idCliente = %f", argumentArray: [cliente.id])
                let result: NSManagedObject? = try! self.backgroundContext.fetch(fetchRequest).first
                
                if result != nil {
                    self.databaseHelper.updateClientObject(coreClient: result!, client: cliente)
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: self.CLIENTES_ENTITY_NAME, in: self.backgroundContext)
                    let client = NSManagedObject(entity: entity!, insertInto: self.backgroundContext)
                    self.databaseHelper.setCoreDataObjectDataFromClient(coreDataObject: client, newClient: cliente)
                }
            }
            
            try! self.backgroundContext.save()
        }
    }
    
    func syncronizeClientsSync(clientes: [ClientModel]) {
        backgroundContext.performAndWait {
            for cliente: ClientModel in clientes {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CLIENTES_ENTITY_NAME)
                fetchRequest.predicate = NSPredicate(format: "idCliente = %f", argumentArray: [cliente.id])
                let result: NSManagedObject? = try! backgroundContext.fetch(fetchRequest).first
                
                if result != nil {
                    databaseHelper.updateClientObject(coreClient: result!, client: cliente)
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: CLIENTES_ENTITY_NAME, in: backgroundContext)
                    let client = NSManagedObject(entity: entity!, insertInto: backgroundContext)
                    databaseHelper.setCoreDataObjectDataFromClient(coreDataObject: client, newClient: cliente)
                }
            }
            
            try! self.backgroundContext.save()
        }
    }
}
