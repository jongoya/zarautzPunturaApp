//
//  jsonExporter.swift
//  GestorGenerico
//
//  Created by jon mikel on 28/09/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation
import Alamofire

class jsonExporter {
    static func parseClientesHeme() {
        do {
            if let path = Bundle.main.path(forResource: "pacientes", ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
                let jsonPacientes = jsonArray[2] as! [String: Any]
                let arrayPacientes: [Any] = jsonPacientes["data"] as! [Any]
                parsePacientes(pacientes: arrayPacientes)
            }
        } catch {
           print("Error parsing json")
        }
    }
    
    private static func parsePacientes(pacientes: [Any]) {
        var clientes: [ClientMasServicios] = []
        for paciente in pacientes {
            let cliente: ClientModel = ClientModel()
            let pacienteDict: [String : Any] = paciente as! [String : Any]
            cliente.nombre = pacienteDict["firstname"] as! String
            cliente.apellidos = pacienteDict["lastname"] as! String
            cliente.email = pacienteDict["email"] as! String
            cliente.telefono = (pacienteDict["prefix_mobile"] as! String) + (pacienteDict["mobile"] as! String)
            cliente.fecha = parseStringDate(stringDate: pacienteDict["birthdate"] as! String)
            clientes.append(ClientMasServicios(cliente: cliente, servicios: []))
        }
        
        saveClientesInServer(clientes: clientes)
    }
    
    private static func parseStringDate(stringDate: String) -> Int64 {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if stringDate != "0000-00-00" {
            let date: Date = dateFormatter.date(from: stringDate)!
            return Int64(date.timeIntervalSince1970)
        }
        
        return 0
    }
    
    private static func saveClientesInServer(clientes: [ClientMasServicios]) {
        let urlString: String = WebServices.baseUrl + "save_clientes"
        var json: [[String: Any]] = []
        for cliente: ClientMasServicios in clientes {
            json.append(cliente.createJson())
        }
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.headers = WebServices.createHeaders()
        request.method = .post
        request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        AF.request(request).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let clientesResult: [ClientMasServicios] = try! JSONDecoder().decode([ClientMasServicios].self, from: response.data!)
                    var arrayClientes: [ClientModel] = []
                    for clienteMasServicios: ClientMasServicios in clientesResult {
                        arrayClientes.append(clienteMasServicios.cliente)
                    }
                    
                    Constants.databaseManager.clientsManager.syncronizeClientsAsync(clientes: arrayClientes)
                }
            }
        }
    }
}
