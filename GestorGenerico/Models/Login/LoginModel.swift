//
//  LoginModel.swift
//  GestorGenerico
//
//  Created by jon mikel on 09/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class LoginModel: Codable {
    var comercioId: Int64 = 0
    var usuario: String = ""
    var password: String = ""
    var token: String = ""
    var nombre: String = ""
    
    init(usuario: String, password: String, nombre: String) {
        self.usuario = usuario
        self.nombre = nombre
        self.password = password
    }
    
    private enum CodingKeys: String, CodingKey {
        case comercioId = "comercioId"
        case usuario = "usuario"
        case password = "password"
        case token = "token"
        case nombre = "nombre"
    }
}

extension LoginModel {
    func createJsonForLogin() -> [String: Any] {
        return ["usuario" : self.usuario, "password" : self.password, "nombre" : self.nombre]
    }
}
