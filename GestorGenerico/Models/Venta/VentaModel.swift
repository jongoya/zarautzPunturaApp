//
//  VentaModel.swift
//  GestorGenerico
//
//  Created by jon mikel on 22/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class VentaModel: Codable {
    var cestaId:Int64 = 0
    var ventaId: Int64 = 0
    var productoId: Int64 = 0
    var cantidad: Int = 1
    
    init(productoId: Int64) {
        self.productoId = productoId
    }
    
    init() {
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case cestaId = "cestaId"
        case ventaId = "ventaId"
        case productoId = "productoId"
        case cantidad = "cantidad"
    }
}

extension VentaModel {
    func createJson() -> [String: Any] {
        return ["cestaId" : cestaId, "ventaId" : ventaId, "productoId" : productoId, "cantidad" : cantidad]
    }
}
