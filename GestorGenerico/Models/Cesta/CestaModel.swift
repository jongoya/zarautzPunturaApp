//
//  CestaModel.swift
//  GestorGenerico
//
//  Created by jon mikel on 22/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation


class CestaModel: Codable {
    var cestaId: Int64 = 0
    var clientId: Int64 = 0
    var fecha: Int64 = 0
    var isEfectivo: Bool = true
    
    private enum CodingKeys: String, CodingKey {
        case cestaId = "cestaId"
        case clientId = "clientId"
        case fecha = "fecha"
        case isEfectivo = "efectivo"
    }
}

extension CestaModel {
    func createJson() -> [String: Any] {
        return ["cestaId" : cestaId, "clientId" : clientId, "fecha" : fecha, "efectivo" : isEfectivo]
    }
}
