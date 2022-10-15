//
//  DeleteServiceProtocol.swift
//  GestorGenerico
//
//  Created by jon mikel on 13/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

protocol DeleteServiceProtocol {
    func successDeletingService(service: ServiceModel)
    func errorDeletingService()
    func logoutResponse()
}
