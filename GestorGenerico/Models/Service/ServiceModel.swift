//
//  ServiceModel.swift
//  GestorHeme
//
//  Created by jon mikel on 02/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class ServiceModel: Codable {
    var clientId: Int64 = 0
    var serviceId: Int64 = 0
    var fecha: Int64 = 0
    var empleadoId: Int64 = 0
    var servicios: [Int64] = []
    var observaciones: String = ""
    var isEfectivo: Bool = false
    var imgPlantilla: String = ""
    var selector: String = ""
    var sistemas: [Int64] = []
    var meridianos: String = ""
    var equilibrio: String = ""
    var imgPlantilla2: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case clientId = "clientId"
        case serviceId = "serviceId"
        case fecha = "fecha"
        case empleadoId = "empleadoId"
        case servicios = "servicios"
        case observaciones = "observacion"
        case isEfectivo = "efectivo"
        case imgPlantilla = "imgPlantilla"
        case selector = "selector"
        case sistemas = "sistemas"
        case meridianos = "meridianos"
        case equilibrio = "equilibrio"
        case imgPlantilla2 = "imgPlantilla2"
    }
}

extension ServiceModel {
    func createJson() -> [String : Any] {
        return ["clientId" : clientId, "serviceId" : serviceId, "fecha" : fecha, "empleadoId" : empleadoId, "servicios" : servicios, "observacion" : observaciones, "efectivo" : isEfectivo, "imgPlantilla" : imgPlantilla, "selector": selector, "sistemas" : sistemas, "meridianos" : meridianos, "equilibrio" : equilibrio, "imgPlantilla2" : imgPlantilla2]
    }
}
