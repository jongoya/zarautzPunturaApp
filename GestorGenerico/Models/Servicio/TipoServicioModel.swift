//
//  ServicioModel.swift
//  GestorHeme
//
//  Created by jon mikel on 12/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class TipoServicioModel: Codable {
    var nombre: String = ""
    var servicioId: Int64 = 0
    var numCabinas: Int64 = 0
    var bloqueaTerapeuta: Bool = false
    var duracion: Int64 = 0
    var terapeuta: Int64 = 0
    var precio: Double = 0.0
    var redColorValue: Float = 0
    var greenColorValue: Float = 0
    var blueColorValue: Float = 0
    
    private enum CodingKeys: String, CodingKey {
        case nombre = "nombre"
        case servicioId = "servicioId"
        case numCabinas = "numCabinas"
        case bloqueaTerapeuta = "bloqueaTerapeuta"
        case duracion = "duracion"
        case terapeuta = "terapeuta"
        case precio = "precio"
        case redColorValue = "red_color_value"
        case greenColorValue = "green_color_value"
        case blueColorValue = "blue_color_value"
    }
}

extension TipoServicioModel {
    func createJson() -> [String : Any] {
        return ["nombre" : nombre, "servicioId" : servicioId, "numCabinas" : numCabinas, "bloqueaTerapeuta" : bloqueaTerapeuta, "duracion" : duracion, "terapeuta" : terapeuta, "precio" : precio, "red_color_value" : redColorValue, "green_color_value" : greenColorValue, "blue_color_value" : blueColorValue]
    }
    
}
