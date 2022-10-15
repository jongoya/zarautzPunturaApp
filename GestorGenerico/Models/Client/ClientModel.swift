//
//  ClientModel.swift
//  GestorHeme
//
//  Created by jon mikel on 01/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class ClientModel: Codable {
    var id: Int64 = 0
    var numeroHistoria: Int64 = 0
    var nombre: String = ""
    var apellidos: String = ""
    var fecha: Int64 = 0
    var telefono: String = ""
    var email: String = ""
    var direccion: String = ""
    var profesion: String = ""
    var observaciones: String = ""
    var imagen: String = ""
    var dni: String = ""
    var motivoConsulta: String = ""
    var antecedentes: String = ""
    var alergias: String = ""
    var cirugias: String = ""
    var enfermedades: String = ""
    var estadoActual: String = ""
    var digestion: String = ""
    var deposicion: String = ""
    var descanso: String = ""
    var tratamiento: String = ""
    var alimentacion: String = ""
    var otros: String = ""
    var firma: String = ""
    var reglas: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case numeroHistoria = "numeroHistoria"
        case nombre = "nombre"
        case apellidos = "apellidos"
        case fecha = "fecha"
        case telefono = "telefono"
        case email = "email"
        case direccion = "direccion"
        case profesion = "profesion"
        case observaciones = "observaciones"
        case imagen = "imagen"
        case dni = "dni"
        case motivoConsulta = "motivoConsulta"
        case antecedentes = "antecedentes"
        case alergias = "alergias"
        case cirugias = "cirugias"
        case enfermedades = "enfermedades"
        case estadoActual = "estadoActual"
        case digestion = "digestion"
        case deposicion = "deposicion"
        case descanso = "descanso"
        case tratamiento = "tratamiento"
        case alimentacion = "alimentacion"
        case otros = "otros"
        case firma = "firma"
        case reglas = "reglas"
    }
}

extension ClientModel {
    func createClientJson() -> [String : Any]{
        return ["id" : id, "numeroHistoria" : numeroHistoria, "nombre" : nombre, "apellidos" : apellidos, "fecha" : fecha, "telefono" : telefono, "email" : email, "direccion" : direccion, "profesion" : profesion, "observaciones" : observaciones, "dni" :  dni, "imagen" : imagen, "motivoConsulta" : motivoConsulta,
                "antecedentes" : antecedentes, "alergias" : alergias, "cirugias" : cirugias, "enfermedades" : enfermedades, "estadoActual" : estadoActual, "digestion" : digestion, "deposicion" : deposicion, "descanso" : descanso, "tratamiento" : tratamiento, "alimentacion" : alimentacion, "otros" : otros, "firma" : firma, "reglas" : reglas]
    }
}
