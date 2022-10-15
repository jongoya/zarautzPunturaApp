//
//  SistemaModel.swift
//  GestorGenerico
//
//  Created by jon mikel on 22/09/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class SistemaModel: Codable {
    var sistemaId: Int64 = 0
    var nombre: String = ""
    var subtitulo: String = ""
    var sis1: String = ""
    var sis2: String = ""
    var sis3: String = ""
    var sis4: String = ""
    var sis5: String = ""
    var sis6: String = ""
    
    init() {
    }
    
    private enum CodingKeys: String, CodingKey {
        case sistemaId = "sistemaId"
        case nombre = "nombre"
        case subtitulo = "subtitulo"
        case sis1 = "sis1"
        case sis2 = "sis2"
        case sis3 = "sis3"
        case sis4 = "sis4"
        case sis5 = "sis5"
        case sis6 = "sis6"
    }
}

extension SistemaModel {
    func createJson() -> [String: Any] {
        return ["sistemaId" : sistemaId, "nombre" : nombre, "subtitulo" : subtitulo, "sis1" : sis1, "sis2" : sis2, "sis3" : sis3, "sis4" : sis4, "sis5" : sis5, "sis6" : sis6]
    }
}
