//
//  UpdateTipoServicioProtocol.swift
//  GestorGenerico
//
//  Created by jon mikel on 05/10/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

protocol UpdateTipoServicioProtocol {
    func servicioUpdated(servicio: TipoServicioModel)
    func errorUpdatingServicio()
}
