//
//  DatabaseManager.swift
//  GestorHeme
//
//  Created by jon mikel on 01/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import CoreData

class DatabaseManager: NSObject {
    
    var clientsManager: ClientesManager!
    var servicesManager: ServicesManager!
    var empleadosManager: EmpleadosManager!
    var tipoServiciosManager: TipoServiciosManager!
    var cierreCajaManager: CierreCajaManager!
    var productosManager: ProductoManager!
    var cestaManager: CestaManager!
    var ventaManager: VentaManager!
    var sistemaManager: SistemaManager!
    
    override init() {
        super.init()
        clientsManager = ClientesManager()
        servicesManager = ServicesManager()
        empleadosManager = EmpleadosManager()
        tipoServiciosManager = TipoServiciosManager()
        cierreCajaManager = CierreCajaManager()
        productosManager = ProductoManager()
        cestaManager = CestaManager()
        ventaManager = VentaManager()
        sistemaManager = SistemaManager()
    }
    
    func clearAllDatabase() {
        clientsManager.deleteAllClients()
        servicesManager.deleteAllServices()
        empleadosManager.deleteAllEmpleados()
        tipoServiciosManager.deleteAllTipoServicios()
        cierreCajaManager.deleteAllCierreCajas()
        productosManager.deleteAllProductos()
        cestaManager.deleteAllCestas()
        ventaManager.deleteAllVentas()
        sistemaManager.deleteAllSistemas()
    }
}
