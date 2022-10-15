//
//  AlergiasDelegate.swift
//  GestorGenerico
//
//  Created by jon mikel on 14/12/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

protocol AlergiasDelegate {
    func alergiasTextWritten(text: String, alergias: String, noAlergias: String)
}
