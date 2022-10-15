//
//  ContactosManager.swift
//  GestorGenerico
//
//  Created by jon mikel on 20/10/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation
import ContactsUI

class ContactosManager: NSObject {
    static func actualizarContactos(delegate: ContactosProtocol) {
        DispatchQueue.global(qos: .background).async {
            let contactStore = CNContactStore()
            var contactos: [String] = []
            let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                            CNContactPhoneNumbersKey,
                            CNContactEmailAddressesKey] as [Any]
            let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
            do {
                try contactStore.enumerateContacts(with: request){
                        (contact, stop) in
                    for phoneNumber in contact.phoneNumbers {
                        let numeroContacto: String = phoneNumber.value.stringValue.trimmingCharacters(in: .whitespaces)
                        contactos.append(numeroContacto)
                    }
                }
                
                compararContactos(contactos: contactos, delegate: delegate)
            } catch {
                print("Error cargando contactos")
            }
        }
    }
    
    private static func compararContactos(contactos: [String], delegate: ContactosProtocol) {
        let clientes: [ClientModel] = Constants.databaseManager.clientsManager.getAllClientsFromDatabase()
        
        for cliente: ClientModel in clientes {
            var clienteExiste = false
            for contacto: String in contactos {
                if cliente.telefono.trimmingCharacters(in: .whitespaces) == contacto {
                    clienteExiste = true
                }
            }
            
            if !clienteExiste {
                guardarContacto(cliente: cliente)
            }
        }
        
        DispatchQueue.main.async {
            delegate.pacientesSincronizados()
        }
    }
    
    private static func guardarContacto(cliente: ClientModel) {
        let store = CNContactStore()
        let newContact = CNMutableContact()
        newContact.givenName = cliente.nombre
        newContact.familyName = cliente.apellidos
        newContact.jobTitle = "cliente zarautzPuntura"
        
        if cliente.fecha > 0 {
            let fecha = Date(timeIntervalSince1970: TimeInterval(cliente.fecha))
            let comps = Calendar.current.dateComponents([.year, .month, .day], from: fecha)
            newContact.birthday = comps
        }

        let workEmail = CNLabeledValue(label:CNLabelWork, value:cliente.email as NSString)
        newContact.emailAddresses = [workEmail]
        newContact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue:cliente.telefono.trimmingCharacters(in: .whitespaces)))]
        
        do {
            let saveRequest = CNSaveRequest()
            saveRequest.add(newContact, toContainerWithIdentifier: nil)
            try store.execute(saveRequest)
        } catch {
        }
    }
}
