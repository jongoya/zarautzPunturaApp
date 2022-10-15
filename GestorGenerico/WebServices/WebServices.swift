//
//  WebServices.swift
//  GestorGenerico
//
//  Created by jon mikel on 09/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation
import Alamofire


public class WebServices {
    static let baseUrl: String = "https://gestor.djmrbug.com:8444/api/"
    
    static func createHeaders() -> HTTPHeaders {
        let token: String = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesTokenKey) as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer " + token, "Content-Type": "application/json"]
        return headers
    }
    
    static func login(login: LoginModel, delegate: LoginProtocol) {
        let url: String = baseUrl + "login_comercio"
        AF.request(url, method: .post, parameters: login.createJsonForLogin(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let loginResult: LoginModel = try! JSONDecoder().decode(LoginModel.self, from: response.data!)
                    delegate.succesLogingIn(login: loginResult)
                } else {
                    delegate.errorLoginIn()
                }
            }else {
                delegate.errorLoginIn()
            }
        }
    }
    
    static func getClientes(delegate: ListaClientesProtocol?) {
        let url: String = baseUrl + "get_clientes"
        AF.request(url, method: .get, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let clientes: [ClientModel] = try! JSONDecoder().decode([ClientModel].self, from: response.data!)
                    
                    if delegate == nil {
                        Constants.databaseManager.clientsManager.syncronizeClientsAsync(clientes: clientes)
                    } else {
                        Constants.databaseManager.clientsManager.syncronizeClientsSync(clientes: clientes)
                    }
                    
                    delegate?.successGettingClients()
                    return
                }
            }
            
            delegate?.errorGettingClients()
        }
    }
    
    static func addClient(model: ClientMasServicios, delegate: AddClientAndServicesProtocol) {
        let url: String = baseUrl + "save_cliente"
        AF.request(url, method: .post, parameters: model.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response?.statusCode == 200 {
                    let model :ClientMasServicios = try! JSONDecoder().decode(ClientMasServicios.self, from: response.data!)
                    delegate.succesSavingClient(model: model)
                    return
                }
            }
            
            if (response.response?.statusCode == Constants.logoutResponseValue) {
                delegate.logoutResponse()
                return
            }
            
            delegate.errorSavignClient()
        }
    }
    
    static func updateClient(cliente: ClientModel, delegate: UpdateClientProtocol) {
        let url: String = baseUrl + "update_cliente"
        AF.request(url, method: .put, parameters: cliente.createClientJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let model :ClientMasServicios = try! JSONDecoder().decode(ClientMasServicios.self, from: response.data!)
                    delegate.successUpdatingClient(cliente: model.cliente)
                    return
                }
            }
            
            if (response.response?.statusCode == Constants.logoutResponseValue) {
                delegate.logoutResponse()
                return
            }
            
            delegate.errorUpdatingClient()
        }
    }
    
    static func getServices(delegate: GetServiciosProtocol?) {
        let url: String = baseUrl + "get_servicios"
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers:  createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let servicios: [ServiceModel] = try! JSONDecoder().decode([ServiceModel].self, from: response.data!)
                    Constants.databaseManager.servicesManager.syncronizeServicesAsync(services: servicios)
                    let localServices: [ServiceModel] = Constants.databaseManager.servicesManager.getAllServicesFromDatabase()
                    deleteLocalServicesIfNeeded(serverServices: servicios, localServices: localServices)
                    
                    delegate?.successGettingServicios()
                    return
                }
            }
            
            delegate?.errorGettingServicios()
        }
    }
    
    static func getServicesForClientId(clientId: Int64, delegate: GetServiciosClientProtocol) {
        let url: String = baseUrl + "get_servicios_client/" + String(clientId)
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers:  createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let servicios: [ServiceModel] = try! JSONDecoder().decode([ServiceModel].self, from: response.data!)
                    Constants.databaseManager.servicesManager.syncronizeServicesSync(services: servicios)
                    let localServices: [ServiceModel] = Constants.databaseManager.servicesManager.getServicesForClientId(clientId: clientId)
                    deleteLocalServicesIfNeeded(serverServices: servicios, localServices: localServices)
                    
                    delegate.successGettingServicios()
                    return
                }
            }
            
            delegate.errorGettingServicios()
        }
    }
    
    static func getServicesForRange(fechaInicio: Int64, fechaFin: Int64, delegate: GetServiciosRangeProtocol) {
        let url: String = baseUrl + "get_servicios_range/" + String(fechaInicio) + "/" + String(fechaFin)
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers:  createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let servicios: [ServiceModel] = try! JSONDecoder().decode([ServiceModel].self, from: response.data!)
                    Constants.databaseManager.servicesManager.syncronizeServicesSync(services: servicios)
                    let localServices: [ServiceModel] = Constants.databaseManager.servicesManager.getAllServicesForDay(beginingOfDay: fechaInicio, endOfDay: fechaFin)
                    deleteLocalServicesIfNeeded(serverServices: servicios, localServices: localServices)
                    
                    delegate.successGettingServicios()
                    return
                }
            }
            
            delegate.errorGettingServicios()
        }
    }
    
    private static func deleteLocalServicesIfNeeded(serverServices: [ServiceModel], localServices: [ServiceModel]) {
        for localService: ServiceModel in localServices {
            var servicioExists: Bool = false
            for serverService: ServiceModel in serverServices {
                if localService.serviceId == serverService.serviceId {
                    servicioExists = true
                }
            }
            
            if !servicioExists {
                Constants.databaseManager.servicesManager.deleteService(service: localService)
            }
        }
    }
    
    static func addService(service: ServiceModel, delegate: AddNuevoServicioProtocol) {
        let url: String = baseUrl + "save_servicio"
        AF.request(url, method: .post, parameters: service.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 201 {
                    let servicio :ServiceModel = try! JSONDecoder().decode(ServiceModel.self, from: response.data!)
                    delegate.successSavingService(servicio: servicio)
                    return
                }
            }
            
            if (response.response?.statusCode == Constants.logoutResponseValue) {
                delegate.logoutResponse()
                return
            }
            
            delegate.errorSavingServicio()
        }
    }
    
    static func updateService(service: ServiceModel, delegate: UpdateServicioProtocol) {
        let url: String = baseUrl + "update_servicio"
        AF.request(url, method: .put, parameters: service.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let servicio :ServiceModel = try! JSONDecoder().decode(ServiceModel.self, from: response.data!)
                    delegate.successUpdatingService(service: servicio)
                    return
                }
            }
            
            if (response.response?.statusCode == Constants.logoutResponseValue) {
                delegate.logoutResponse()
                return
            }
            
            delegate.errorUpdatingService()
        }
    }
    
    static func deleteService(service: ServiceModel, delegate: DeleteServiceProtocol) {
        let url: String = baseUrl + "delete_servicio"
        AF.request(url, method: .post, parameters: service.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).response { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    delegate.successDeletingService(service: service)
                    return
                }
            }
            
            if (response.response?.statusCode == Constants.logoutResponseValue) {
                delegate.logoutResponse()
                return
            }
            
            delegate.errorDeletingService()
        }
    }
    
    static func getEmpleados(delegate: GetEmpleadosProtocol?) {
        let url: String = baseUrl + "get_empleados"
        AF.request(url, method: .get, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let empleados: [EmpleadoModel] = try! JSONDecoder().decode([EmpleadoModel].self, from: response.data!)
                    Constants.databaseManager.empleadosManager.syncronizeEmpleados(empleados: empleados)
                    
                    compareLocalEmpleadosWithServerEmpleados(serverEmpleados: empleados)
                    delegate?.succesGettingEmpleados(empleados: empleados)
                    return
                }
            }
            
            delegate?.errorGettingEmpleados()
        }
    }
    
    private static func compareLocalEmpleadosWithServerEmpleados(serverEmpleados: [EmpleadoModel]) {
        let localEmpleados: [EmpleadoModel] = Constants.databaseManager.empleadosManager.getAllEmpleadosFromDatabase()
        for localEmpleado: EmpleadoModel in localEmpleados {
            var empleadoExiste: Bool = false
            for serverEmpleado: EmpleadoModel in serverEmpleados {
                if serverEmpleado.empleadoId == localEmpleado.empleadoId {
                    empleadoExiste = true
                }
            }
            
            if !empleadoExiste {
                Constants.databaseManager.empleadosManager.eliminarEmpleado(empleadoId: localEmpleado.empleadoId)
            }
        }
    }
    
    static func addEmpleado(empleado: EmpleadoModel, delegate: AddEmpleadoProtocol) {
        let url: String = baseUrl + "save_empleado"
        AF.request(url, method: .post, parameters: empleado.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 201 {
                    let empleado: EmpleadoModel = try! JSONDecoder().decode(EmpleadoModel.self, from: response.data!)
                    delegate.successSavingEmpleado(empleado: empleado)
                    return
                }
            }
            
            if (response.response?.statusCode == Constants.logoutResponseValue) {
                delegate.logoutResponse()
                return
            }
            
            delegate.errorSavingEmpleado()
        }
    }
    
    static func updateEmpleado(empleado: EmpleadoModel, delegate: UpdateEmpleadoProtocol) {
        let url: String = baseUrl + "update_empleado"
        AF.request(url, method: .put, parameters: empleado.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let empleado: EmpleadoModel = try! JSONDecoder().decode(EmpleadoModel.self, from: response.data!)
                    delegate.successUpdatingEmpleado(empleado: empleado)
                    return
                }
            }
            
            if (response.response?.statusCode == Constants.logoutResponseValue) {
                delegate.logoutResponse()
                return
            }
            
            delegate.errorUpdatingEmpleado()
        }
    }
    
    static func deleteEmpleado(empleado: EmpleadoModel, delegate: DeleteEmpleadoProtocol) {
        let url: String = baseUrl + "delete_empleado"
        AF.request(url, method: .post, parameters: empleado.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let empleadoMasServicios: EmpleadoMasServicios = try! JSONDecoder().decode(EmpleadoMasServicios.self, from: response.data!)
                    delegate.successDeletingEmpleado(empleadoMasServicios: empleadoMasServicios)
                    return
                }
            }
            
            if (response.response?.statusCode == Constants.logoutResponseValue) {
                delegate.logoutResponse()
                return
            }
            
            delegate.errorDeletingEmpleado()
        }
    }
    
    static func getTipoServicios(delegate: GetTipoServiciosProtocol?) {
        let url: String = baseUrl + "get_tipo_servicios"
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let tipoServicios: [TipoServicioModel] = try! JSONDecoder().decode([TipoServicioModel].self, from: response.data!)
                    if delegate == nil {
                        Constants.databaseManager.tipoServiciosManager.syncronizeTipoDeServicios(tipoServicios: tipoServicios)
                    } else {
                        for tipoServicio: TipoServicioModel in tipoServicios {
                            if Constants.databaseManager.tipoServiciosManager.getCoreTipoServicioFromDatabase(servicioId: tipoServicio.servicioId).count == 0 {
                                Constants.databaseManager.tipoServiciosManager.addTipoServicioToDatabase(servicio: tipoServicio)
                            } else {
                                Constants.databaseManager.tipoServiciosManager.updateServiceInDatabase(service: tipoServicio)
                            }
                        }
                    }
                    
                    delegate?.successGettingServicios()
                    return
                }
            }
            
            delegate?.errorGettingServicios()
        }
    }
    
    static func addTipoServicio(tipoServicio: TipoServicioModel, delegate: AddTipoServicioProtocol) {
        let url: String = baseUrl + "save_tipo_servicio"
        AF.request(url, method: .post, parameters: tipoServicio.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 201 {
                    let tipoServicio: TipoServicioModel = try! JSONDecoder().decode(TipoServicioModel.self, from: response.data!)
                    delegate.successSavingServicio(tipoServicio: tipoServicio)
                    return
                }
            }
            
            if (response.response?.statusCode == Constants.logoutResponseValue) {
                delegate.logoutResponse()
                return
            }
            
            delegate.errorSavingServicio()
        }
    }
    
    static func updateTipoServicio(tipoServicio: TipoServicioModel, delegate: UpdateTipoServicioProtocol) {
        let url: String = baseUrl + "update_tipo_servicio"
        AF.request(url, method: .put, parameters: tipoServicio.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let tipoServicio: TipoServicioModel = try! JSONDecoder().decode(TipoServicioModel.self, from: response.data!)
                    delegate.servicioUpdated(servicio: tipoServicio)
                    return
                }
            }
            
            delegate.errorUpdatingServicio()
        }
    }
    
    static func getCierreCajas() {
        let url: String = baseUrl + "get_cierre_cajas"
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let cierreCajas: [CierreCajaModel] = try! JSONDecoder().decode([CierreCajaModel].self, from: response.data!)
                    Constants.databaseManager.cierreCajaManager.syncronizeCierreCajas(cierreCajas: cierreCajas)
                }
            }
        }
    }
    
    static func saveCierreCaja(caja: CierreCajaModel, delegate: AddCierreCajaProtocol) {
        let url: String = baseUrl + "save_cierre_caja"
        AF.request(url, method: .post, parameters: caja.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 201 {
                    let cierreCaja: CierreCajaModel = try! JSONDecoder().decode(CierreCajaModel.self, from: response.data!)
                    delegate.successAddingCierreCaja(caja: cierreCaja)
                    return
                }
            }
            
            if (response.response?.statusCode == Constants.logoutResponseValue) {
                delegate.logoutResponse()
                return
            }
            
            delegate.errorAddingCierreCaja()
        }
    }
    
    static func addProducto(producto: ProductoModel, delegate: AddProductoProtocol) {
        let url: String = baseUrl + "save_producto"
        AF.request(url, method: .post, parameters: producto.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 201 {
                    let respuesta: ProductoModel = try! JSONDecoder().decode(ProductoModel.self, from: response.data!)
                    delegate.successAddingProduct(producto: respuesta)
                    return
                }
            }
            
            if (response.response?.statusCode == Constants.logoutResponseValue) {
                delegate.logoutResponse()
                return
            }
            
            delegate.errorAddingProduct()
        }
    }
    
    static func updateProducto(producto: ProductoModel, delegate: UpdateProductoProtocol) {
        let url: String = baseUrl + "update_producto"
        AF.request(url, method: .put, parameters: producto.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let respuesta: ProductoModel = try! JSONDecoder().decode(ProductoModel.self, from: response.data!)
                    delegate.successUpdatingProduct(producto: respuesta)
                    return
                }
            }
            
            if (response.response?.statusCode == Constants.logoutResponseValue) {
                delegate.logoutResponse()
                return
            }
            
            delegate.errorUpdatingProduct()
        }
    }
    
    static func getProductos(delegate: GetProductosProtocol?) {
        let url: String = baseUrl + "get_productos"
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let productos: [ProductoModel] = try! JSONDecoder().decode([ProductoModel].self, from: response.data!)
                    
                    if delegate != nil {
                        Constants.databaseManager.productosManager.syncronizeProductosSync(productos: productos)
                    } else {
                        Constants.databaseManager.productosManager.syncronizeProductosAsync(productos: productos)
                    }
                    
                    let localProductos: [ProductoModel] = Constants.databaseManager.productosManager.getAllProductos()
                    deleteLocalProductosIfNeeded(serverProductos: productos, localProductos: localProductos)
                    
                    delegate?.successGettingProductos()
                    return
                }
            }
            
            delegate?.errorGettingProductos()
        }
    }
    
    private static func deleteLocalProductosIfNeeded(serverProductos: [ProductoModel], localProductos: [ProductoModel]) {
        for localProducto: ProductoModel in localProductos {
            var productoExists: Bool = false
            for serverProducto: ProductoModel in serverProductos {
                if localProducto.productoId == serverProducto.productoId {
                    productoExists = true
                }
            }
            
            if !productoExists {
                Constants.databaseManager.productosManager.deleteProducto(producto: localProducto)
            }
        }
    }
    
    static func saveCesta(cesta: CestaModel, ventas: [VentaModel], delegate: SaveCestaProtocol) {
        let url: String = baseUrl + "save_cesta"
        let model: CestaMasVentas = CestaMasVentas(cesta: cesta, ventas: ventas)
        AF.request(url, method: .post, parameters: model.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 201 {
                    let respuesta: CestaMasVentas = try! JSONDecoder().decode(CestaMasVentas.self, from: response.data!)
                    delegate.successSavingCesta(model: respuesta)
                    return
                }
            }
            
            if (response.response?.statusCode == Constants.logoutResponseValue) {
                delegate.logoutResponse()
                return
            }
            
            delegate.errorSavingCesta()
        }
    }
    
    static func updateCesta(cesta: CestaModel, ventas: [VentaModel], delegate: UpdateCestaProtocol) {
        let url: String = baseUrl + "update_cesta"
        for venta: VentaModel in ventas {
            venta.cestaId = cesta.cestaId
        }
        let model: CestaMasVentas = CestaMasVentas(cesta: cesta, ventas: ventas)
        AF.request(url, method: .put, parameters: model.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let respuesta: CestaMasVentas = try! JSONDecoder().decode(CestaMasVentas.self, from: response.data!)
                    delegate.successUpdatingCesta(model: respuesta)
                    return
                }
            }
            
            if (response.response?.statusCode == Constants.logoutResponseValue) {
                delegate.logoutResponse()
                return
            }
            
            delegate.errorUpdatingCesta()
        }
    }
    
    static func getCestas() {
        let url: String = baseUrl + "get_cestas"
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let cestas: [CestaModel] = try! JSONDecoder().decode([CestaModel].self, from: response.data!)
                    Constants.databaseManager.cestaManager.syncronizeCestasAsync(cestas: cestas)
                    let localCestas: [CestaModel] = Constants.databaseManager.cestaManager.getAllCestas()
                    deleteLocalCestasIfNeeded(serverCestas: cestas, localCestas: localCestas)
                }
            }
        }
    }
    
    static func getVentas() {
        let url: String = baseUrl + "get_ventas"
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let ventas: [VentaModel] = try! JSONDecoder().decode([VentaModel].self, from: response.data!)
                    Constants.databaseManager.ventaManager.syncronizeVentasAsync(ventas: ventas)
                    let localVentas: [VentaModel] = Constants.databaseManager.ventaManager.getAllVentas()
                    deleteLocalVentasIfNeeded(serverVentas: ventas, localVentas: localVentas)
                }
            }
        }
    }
    
    private static func deleteLocalCestasIfNeeded(serverCestas: [CestaModel], localCestas: [CestaModel]) {
        for localCesta: CestaModel in localCestas {
            var cestaExists: Bool = false
            for serverCesta: CestaModel in serverCestas {
                if localCesta.cestaId == serverCesta.cestaId {
                    cestaExists = true
                }
            }
            
            if !cestaExists {
                Constants.databaseManager.cestaManager.deleteCesta(cesta: localCesta)
            }
        }
    }
    
    private static func deleteLocalVentasIfNeeded(serverVentas: [VentaModel], localVentas: [VentaModel]) {
        for localVenta: VentaModel in localVentas {
            var ventaExists: Bool = false
            for serverVenta: VentaModel in serverVentas {
                if localVenta.ventaId == serverVenta.ventaId {
                    ventaExists = true
                }
            }
            
            if !ventaExists {
                Constants.databaseManager.ventaManager.deleteVenta(venta: localVenta)
            }
        }
    }
    
    static func getSistemas() {
        let url: String = baseUrl + "get_sistemas"
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let sistemas: [SistemaModel] = try! JSONDecoder().decode([SistemaModel].self, from: response.data!)
                    Constants.databaseManager.sistemaManager.syncronizeSistemasAsync(sistemas: sistemas)
                }
            }
        }
    }
}
