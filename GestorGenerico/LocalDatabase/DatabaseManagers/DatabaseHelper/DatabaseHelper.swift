//
//  DatabaseHelper.swift
//  GestorHeme
//
//  Created by jon mikel on 01/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import CoreData

class DatabaseHelper: NSObject {
    
    func parseClientCoreObjectToClientModel(coreObject: NSManagedObject) -> ClientModel {
        let client: ClientModel = ClientModel()
        client.id = coreObject.value(forKey: "idCliente") as! Int64
        client.nombre = coreObject.value(forKey: "nombre") as! String
        client.apellidos = coreObject.value(forKey: "apellidos") as! String
        client.fecha = coreObject.value(forKey: "fecha") as! Int64
        client.email = coreObject.value(forKey: "email") as! String
        client.telefono = coreObject.value(forKey: "telefono") as! String
        client.direccion = coreObject.value(forKey: "direccion") as! String
        client.profesion = coreObject.value(forKey: "profesion") as! String
        client.observaciones = coreObject.value(forKey: "observaciones") as! String
        client.imagen = coreObject.value(forKey: "imagen") as! String
        client.numeroHistoria = coreObject.value(forKey: "numeroHistoria") as! Int64
        client.dni = coreObject.value(forKey: "dni") as! String
        client.motivoConsulta = coreObject.value(forKey: "motivoConsulta") as! String
        client.antecedentes = coreObject.value(forKey: "antecedentes") as! String
        client.alergias = coreObject.value(forKey: "alergias") as! String
        client.cirugias = coreObject.value(forKey: "cirugias") as! String
        client.enfermedades = coreObject.value(forKey: "enfermedades") as! String
        client.estadoActual = coreObject.value(forKey: "estadoActual") as! String
        client.digestion = coreObject.value(forKey: "digestion") as! String
        client.deposicion = coreObject.value(forKey: "deposicion") as! String
        client.descanso = coreObject.value(forKey: "descanso") as! String
        client.tratamiento = coreObject.value(forKey: "tratamiento") as! String
        client.alimentacion = coreObject.value(forKey: "alimentacion") as! String
        client.otros = coreObject.value(forKey: "otros") as! String
        client.firma = coreObject.value(forKey: "firma") as! String
        client.reglas = coreObject.value(forKey: "reglas") as! String
        
        return client
    }
    
    func setCoreDataObjectDataFromClient(coreDataObject: NSManagedObject, newClient: ClientModel) {
        coreDataObject.setValue(newClient.id, forKey: "idCliente")
        coreDataObject.setValue(newClient.nombre, forKey: "nombre")
        coreDataObject.setValue(newClient.apellidos, forKey: "apellidos")
        coreDataObject.setValue(newClient.fecha, forKey: "fecha")
        coreDataObject.setValue(newClient.email, forKey: "email")
        coreDataObject.setValue(newClient.telefono, forKey: "telefono")
        coreDataObject.setValue(newClient.direccion, forKey: "direccion")
        coreDataObject.setValue(newClient.profesion, forKey: "profesion")
        coreDataObject.setValue(newClient.observaciones, forKey: "observaciones")
        coreDataObject.setValue(newClient.imagen, forKey: "imagen")
        coreDataObject.setValue(newClient.dni, forKey: "dni")
        coreDataObject.setValue(newClient.numeroHistoria, forKey: "numeroHistoria")
        coreDataObject.setValue(newClient.motivoConsulta, forKey: "motivoConsulta")
        coreDataObject.setValue(newClient.antecedentes, forKey: "antecedentes")
        coreDataObject.setValue(newClient.alergias, forKey: "alergias")
        coreDataObject.setValue(newClient.cirugias, forKey: "cirugias")
        coreDataObject.setValue(newClient.enfermedades, forKey: "enfermedades")
        coreDataObject.setValue(newClient.estadoActual, forKey: "estadoActual")
        coreDataObject.setValue(newClient.digestion, forKey: "digestion")
        coreDataObject.setValue(newClient.deposicion, forKey: "deposicion")
        coreDataObject.setValue(newClient.descanso, forKey: "descanso")
        coreDataObject.setValue(newClient.tratamiento, forKey: "tratamiento")
        coreDataObject.setValue(newClient.alimentacion, forKey: "alimentacion")
        coreDataObject.setValue(newClient.otros, forKey: "otros")
        coreDataObject.setValue(newClient.firma, forKey: "firma")
        coreDataObject.setValue(newClient.reglas, forKey: "reglas")
    }
    
    func parseServiceCoreObjectToServiceModel(coreObject: NSManagedObject) -> ServiceModel {
        let service: ServiceModel = ServiceModel()
        service.clientId = coreObject.value(forKey: "idCliente") as! Int64
        service.serviceId = coreObject.value(forKey: "idServicio") as! Int64
        service.fecha = coreObject.value(forKey: "fecha") as! Int64
        service.empleadoId = coreObject.value(forKey: "empleadoId") as! Int64
        service.servicios = coreObject.value(forKey: "servicios") as! [Int64]
        service.observaciones = coreObject.value(forKey: "observaciones") as! String
        service.isEfectivo = coreObject.value(forKey: "isEfectivo") as! Bool
        service.imgPlantilla = coreObject.value(forKey: "imgPlantilla") as! String
        service.selector = coreObject.value(forKey: "selector") as! String
        service.sistemas = coreObject.value(forKey: "sistemas") as! [Int64]
        service.meridianos = coreObject.value(forKey: "meridianos") as! String
        service.equilibrio = coreObject.value(forKey: "equilibrio") as! String
        service.imgPlantilla2 = coreObject.value(forKey: "imgPlantilla2") as! String
        
        return service
    }
    
    func setCoreDataObjectDataFromService(coreDataObject: NSManagedObject, newService: ServiceModel) {
        coreDataObject.setValue(newService.serviceId, forKey: "idServicio")
        coreDataObject.setValue(newService.clientId, forKey: "idCliente")
        coreDataObject.setValue(newService.fecha, forKey: "fecha")
        coreDataObject.setValue(newService.empleadoId, forKey: "empleadoId")
        coreDataObject.setValue(newService.servicios, forKey: "servicios")
        coreDataObject.setValue(newService.observaciones, forKey: "observaciones")
        coreDataObject.setValue(newService.isEfectivo, forKey: "isEfectivo")
        coreDataObject.setValue(newService.imgPlantilla, forKey: "imgPlantilla")
        coreDataObject.setValue(newService.selector, forKey: "selector")
        coreDataObject.setValue(newService.sistemas, forKey: "sistemas")
        coreDataObject.setValue(newService.meridianos, forKey: "meridianos")
        coreDataObject.setValue(newService.equilibrio, forKey: "equilibrio")
        coreDataObject.setValue(newService.imgPlantilla2, forKey: "imgPlantilla2")

    }
    
    func updateClientObject(coreClient: NSManagedObject, client: ClientModel) {
        coreClient.setValue(client.nombre, forKey: "nombre")
        coreClient.setValue(client.apellidos, forKey: "apellidos")
        coreClient.setValue(client.fecha, forKey: "fecha")
        coreClient.setValue(client.telefono, forKey: "telefono")
        coreClient.setValue(client.email, forKey: "email")
        coreClient.setValue(client.direccion, forKey: "direccion")
        coreClient.setValue(client.profesion, forKey: "profesion")
        coreClient.setValue(client.observaciones, forKey: "observaciones")
        coreClient.setValue(client.imagen, forKey: "imagen")
        coreClient.setValue(client.dni, forKey: "dni")
        coreClient.setValue(client.numeroHistoria, forKey: "numeroHistoria")
        coreClient.setValue(client.motivoConsulta, forKey: "motivoConsulta")
        coreClient.setValue(client.antecedentes, forKey: "antecedentes")
        coreClient.setValue(client.alergias, forKey: "alergias")
        coreClient.setValue(client.cirugias, forKey: "cirugias")
        coreClient.setValue(client.enfermedades, forKey: "enfermedades")
        coreClient.setValue(client.estadoActual, forKey: "estadoActual")
        coreClient.setValue(client.digestion, forKey: "digestion")
        coreClient.setValue(client.deposicion, forKey: "deposicion")
        coreClient.setValue(client.descanso, forKey: "descanso")
        coreClient.setValue(client.tratamiento, forKey: "tratamiento")
        coreClient.setValue(client.alimentacion, forKey: "alimentacion")
        coreClient.setValue(client.otros, forKey: "otros")
        coreClient.setValue(client.firma, forKey: "firma")
        coreClient.setValue(client.reglas, forKey: "reglas")
    }
    
    func updateCoreEmpleadoWithEmpleado(coreEmpleado: NSManagedObject, empleado: EmpleadoModel) {
        coreEmpleado.setValue(empleado.redColorValue, forKey: "redColorValue")
        coreEmpleado.setValue(empleado.greenColorValue, forKey: "greenColorValue")
        coreEmpleado.setValue(empleado.blueColorValue, forKey: "blueColorValue")
        coreEmpleado.setValue(empleado.nombre, forKey: "nombre")
        coreEmpleado.setValue(empleado.apellidos, forKey: "apellidos")
        coreEmpleado.setValue(empleado.fecha, forKey: "fecha")
        coreEmpleado.setValue(empleado.telefono, forKey: "telefono")
        coreEmpleado.setValue(empleado.email, forKey: "email")
        coreEmpleado.setValue(empleado.is_empleado_jefe, forKey: "is_empleado_jefe")
    }
    
    func parseEmpleadosCoreObjectToEmpleadosModel(coreObject: NSManagedObject) -> EmpleadoModel {
        let empleado: EmpleadoModel = EmpleadoModel()
        empleado.empleadoId = coreObject.value(forKey: "empleadoId") as! Int64
        empleado.nombre = coreObject.value(forKey: "nombre") as! String
        empleado.apellidos = coreObject.value(forKey: "apellidos") as! String
        empleado.fecha = coreObject.value(forKey: "fecha") as! Int64
        empleado.telefono = coreObject.value(forKey: "telefono") as! String
        empleado.email = coreObject.value(forKey: "email") as! String
        empleado.redColorValue = coreObject.value(forKey: "redColorValue") as! Float
        empleado.greenColorValue = coreObject.value(forKey: "greenColorValue") as! Float
        empleado.blueColorValue = coreObject.value(forKey: "blueColorValue") as! Float
        empleado.is_empleado_jefe = coreObject.value(forKey: "is_empleado_jefe") as! Bool
        
        return empleado
    }
    
    func setCoreDataObjectDataFromEmpleado(coreDataObject: NSManagedObject, newEmpleado: EmpleadoModel) {
        coreDataObject.setValue(newEmpleado.empleadoId, forKey: "empleadoId")
        coreDataObject.setValue(newEmpleado.nombre, forKey: "nombre")
        coreDataObject.setValue(newEmpleado.apellidos, forKey: "apellidos")
        coreDataObject.setValue(newEmpleado.fecha, forKey: "fecha")
        coreDataObject.setValue(newEmpleado.telefono, forKey: "telefono")
        coreDataObject.setValue(newEmpleado.email, forKey: "email")
        coreDataObject.setValue(newEmpleado.redColorValue, forKey: "redColorValue")
        coreDataObject.setValue(newEmpleado.greenColorValue, forKey: "greenColorValue")
        coreDataObject.setValue(newEmpleado.blueColorValue, forKey: "blueColorValue")
        coreDataObject.setValue(newEmpleado.is_empleado_jefe, forKey: "is_empleado_jefe")
    }
    
    func parseTipoServiciosCoreObjectToTipoServicioModel(coreObject: NSManagedObject) -> TipoServicioModel {
        let servicio: TipoServicioModel = TipoServicioModel()
        servicio.servicioId = coreObject.value(forKey: "servicioId") as! Int64
        servicio.nombre = coreObject.value(forKey: "nombre") as! String
        servicio.numCabinas = coreObject.value(forKey: "numCabinas") as! Int64
        servicio.bloqueaTerapeuta = coreObject.value(forKey: "bloqueaTerapeuta") as! Bool
        servicio.duracion = coreObject.value(forKey: "duracion") as! Int64
        servicio.terapeuta = coreObject.value(forKey: "terapeuta") as! Int64
        servicio.precio = coreObject.value(forKey: "precio") as! Double
        servicio.redColorValue = coreObject.value(forKey: "redColorValue") as! Float
        servicio.greenColorValue = coreObject.value(forKey: "greenColorValue") as! Float
        servicio.blueColorValue = coreObject.value(forKey: "blueColorValue") as! Float
        
        return servicio
    }
    
    func setCoreDataObjectDataFromTipoServicio(coreDataObject: NSManagedObject, newServicio: TipoServicioModel) {
        coreDataObject.setValue(newServicio.servicioId, forKey: "servicioId")
        coreDataObject.setValue(newServicio.nombre, forKey: "nombre")
        coreDataObject.setValue(newServicio.numCabinas, forKey: "numCabinas")
        coreDataObject.setValue(newServicio.bloqueaTerapeuta, forKey: "bloqueaTerapeuta")
        coreDataObject.setValue(newServicio.duracion, forKey: "duracion")
        coreDataObject.setValue(newServicio.terapeuta, forKey: "terapeuta")
        coreDataObject.setValue(newServicio.precio, forKey: "precio")
        coreDataObject.setValue(newServicio.redColorValue, forKey: "redColorValue")
        coreDataObject.setValue(newServicio.greenColorValue, forKey: "greenColorValue")
        coreDataObject.setValue(newServicio.blueColorValue, forKey: "blueColorValue")
    }
    
    func parseCierreCajaCoreObjectToCierreCajaModel(coreObject: NSManagedObject) -> CierreCajaModel {
        let cierreCaja: CierreCajaModel = CierreCajaModel()
        cierreCaja.cajaId = coreObject.value(forKey: "cajaId") as! Int64
        cierreCaja.fecha = coreObject.value(forKey: "fecha") as! Int64
        cierreCaja.numeroServicios = coreObject.value(forKey: "numeroServicios") as! Int
        cierreCaja.totalCaja = coreObject.value(forKey: "totalCaja") as! Double
        cierreCaja.totalProductos = coreObject.value(forKey: "totalProductos") as! Double
        cierreCaja.efectivo = coreObject.value(forKey: "efectivo") as! Double
        cierreCaja.tarjeta = coreObject.value(forKey: "tarjeta") as! Double
        
        return cierreCaja
    }
    
    func setCoreDataObjectDataFromCierreCaja(coreDataObject: NSManagedObject, newCierreCaja: CierreCajaModel) {
        coreDataObject.setValue(newCierreCaja.cajaId, forKey: "cajaId")
        coreDataObject.setValue(newCierreCaja.fecha, forKey: "fecha")
        coreDataObject.setValue(newCierreCaja.numeroServicios, forKey: "numeroServicios")
        coreDataObject.setValue(newCierreCaja.totalCaja, forKey: "totalCaja")
        coreDataObject.setValue(newCierreCaja.totalProductos, forKey: "totalProductos")
        coreDataObject.setValue(newCierreCaja.efectivo, forKey: "efectivo")
        coreDataObject.setValue(newCierreCaja.tarjeta, forKey: "tarjeta")
    }
}
