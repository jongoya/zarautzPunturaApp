//
//  AgendaItemViewProtocol.swift
//  GestorHeme
//
//  Created by jon mikel on 07/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

protocol AgendaItemViewProtocol {
    func serviceClicked(service: ServiceModel?, cesta: CestaModel?, numCabinasDisponibles: Int, empleadosDisponibles: [EmpleadoModel])
    func dayClicked(date: Date, numCabinasDisponibles: Int, empleadosDisponibles: [EmpleadoModel])
    func crossButtonClicked(service: ServiceModel)
}
