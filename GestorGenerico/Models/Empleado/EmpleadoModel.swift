//
//  EmpleadoModel.swift
//  GestorHeme
//
//  Created by jon mikel on 12/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class EmpleadoModel: Codable {
    var nombre: String = ""
    var apellidos: String = ""
    var fecha: Int64 = 0
    var telefono: String = ""
    var email: String = ""
    var empleadoId: Int64 = 0
    var redColorValue: Float = 0
    var greenColorValue: Float = 0
    var blueColorValue: Float = 0
    var is_empleado_jefe: Bool = false
}

extension EmpleadoModel {
    func createJson() -> [String : Any] {
        return ["nombre" : nombre, "apellidos" : apellidos, "fecha" : fecha, "telefono" : telefono, "email" : email, "empleadoId" : empleadoId, "redColorValue" : redColorValue, "greenColorValue" : greenColorValue, "blueColorValue" : blueColorValue, "is_empleado_jefe" : is_empleado_jefe]
    }
}
