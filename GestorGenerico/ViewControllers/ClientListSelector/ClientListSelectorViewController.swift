//
//  ClientListSelectorViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 08/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class ClientListSelectorViewController: UIViewController {
    @IBOutlet weak var clientTextField: UITextField!
    @IBOutlet weak var clientsTableView: UITableView!
    @IBOutlet weak var fieldContentView: UIView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var tableSeparator: UIView!
    
    var filteredClients: [[ClientModel]] = []
    var arrayIndexSection: [String]!
    var filteredArrayIndexSection: [String] = []
    var delegate: ClientListSelectorProtocol!
    var emptyStateLabel: UILabel!
    var tableRefreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Clientes"
        customizeTableView()
        customizeFilterView()
        customizeClearButton()
        arrayIndexSection = CommonFunctions.getClientsTableIndexValues()
        setTextFieldProperties()
        addRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getClients()
    }
    
    func customizeTableView() {
        clientsTableView.backgroundColor = AppStyle.getBackgroundColor()
        clientsTableView.sectionIndexColor = AppStyle.getPrimaryColor()
        tableSeparator.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func customizeClearButton() {
        if #available(iOS 13.0, *) {
            clearButton.imageView?.image = UIImage(systemName: "delete.left")?.withRenderingMode(.alwaysTemplate)
        } else {
            clearButton.imageView?.image = UIImage(named: "delete_left")?.withRenderingMode(.alwaysTemplate)
        }
        clearButton.tintColor = AppStyle.getPrimaryColor()
    }
    
    func customizeFilterView() {
        fieldContentView.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func setTextFieldProperties() {
        clientTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        clientTextField.returnKeyType = .done
        clientTextField.delegate = self
        clientTextField.layer.borderColor = AppStyle.getSecondaryColor().cgColor
        clientTextField.textColor = AppStyle.getPrimaryTextColor()
        clientTextField.attributedPlaceholder = NSAttributedString(string: "Nombre", attributes: [NSAttributedString.Key.foregroundColor: AppStyle.getSecondaryColor()])
    }
    
    func getClients() {
        if emptyStateLabel != nil {
            emptyStateLabel.removeFromSuperview()
            emptyStateLabel = nil
        }
        
        var allClientes: [ClientModel] = Constants.databaseManager.clientsManager.getAllClientsFromDatabase()
        
        if clientTextField.text!.count != 0 {
            let telf = Float(clientTextField.text!) ?? nil
            
            if telf == nil {
                allClientes = Constants.databaseManager.clientsManager.getClientsFilteredByText(text: clientTextField.text!)
            } else {
                allClientes = Constants.databaseManager.clientsManager.getClientsFilteredByPhone(phone: clientTextField.text!)
            }
        }
        
        if allClientes.count > 0 {
            indexClients(arrayClients: allClientes)
        } else {
            emptyStateLabel = CommonFunctions.createEmptyState(emptyText: "No dispone de clientes, por favor añade al menos 1", parentView: self.view)
        }
        
        clientsTableView.reloadData()
    }
    
    func indexClients(arrayClients: [ClientModel]) {
        var indexedArray: [[ClientModel]] = []
        filteredArrayIndexSection = []
        for index: String in arrayIndexSection {
            var indexArray: [ClientModel] = []
            for client in arrayClients {
                if index == "Vacio" {
                    if client.apellidos == "" {
                        indexArray.append(client)
                    }
                } else {
                    if client.apellidos.lowercased().starts(with: index.lowercased()) {
                        indexArray.append(client)
                    }
                }
            }

            if indexArray.count > 0 {
                indexArray.sort(by: { $0.nombre < $1.nombre })
                indexedArray.append(indexArray)
                filteredArrayIndexSection.append(index)
            }
        }
        
        filteredClients = indexedArray
    }
    
    func addRefreshControl() {
        tableRefreshControl.addTarget(self, action: #selector(refreshClients), for: .valueChanged)
        clientsTableView.refreshControl = tableRefreshControl
    }
}

extension ClientListSelectorViewController {
    @IBAction func didClickCleanTextfield(_ sender: Any) {
        clientTextField.text = ""
        getClients()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.count == 0 {
            getClients()
            return
        }
        
        let telf = Float(textField.text!) ?? nil
        var clients: [ClientModel] = []
        
        if telf == nil {
            clients = Constants.databaseManager.clientsManager.getClientsFilteredByText(text: textField.text!)
        } else {
            clients = Constants.databaseManager.clientsManager.getClientsFilteredByPhone(phone: textField.text!)
        }
        
        indexClients(arrayClients: clients)
        clientsTableView.reloadData()
    }
    
    @objc func refreshClients() {
        WebServices.getClientes(delegate: self)
    }
}

extension ClientListSelectorViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        filteredClients.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredClients[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredArrayIndexSection[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ClientCell = tableView.dequeueReusableCell(withIdentifier: "ClientCell") as! ClientCell
        cell.setupCell(client: filteredClients[indexPath.section][indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.clientSelected(client: filteredClients[indexPath.section][indexPath.row])
        self.navigationController!.popViewController(animated: true)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return filteredArrayIndexSection
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let view: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        view.tintColor = AppStyle.getBackgroundColor()
        view.textLabel!.textColor = AppStyle.getPrimaryTextColor()
    }
}


extension ClientListSelectorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension ClientListSelectorViewController: ListaClientesProtocol {
    func successGettingClients() {
        DispatchQueue.main.async {
            self.tableRefreshControl.endRefreshing()
            self.getClients()
        }
    }
    
    func errorGettingClients() {
        DispatchQueue.main.async {
            self.tableRefreshControl.endRefreshing()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error sincronizando clientes", viewController: self)
        }
    }
}
