//
//  ListaClientesViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 31/03/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class ListaClientesViewController: UIViewController {
    @IBOutlet weak var clientesTextField: UITextField!
    @IBOutlet weak var clientsTableView: UITableView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var tableSeparator: UIView!
    
    var filteredClients: [[ClientModel]] = []
    var arrayIndexSection: [String]!
    var filteredArrayIndexSection: [String] = []
    var emptyStateLabel: UILabel!
    var tableRefreshControl: UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        arrayIndexSection = CommonFunctions.getClientsTableIndexValues()
        
        addRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeFilterContainer()
        setTextFieldProperties()
        customizeTableView()
        customizeClearButton()
        
        getClients()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    func customizeFilterContainer() {
        filterView.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func setTextFieldProperties() {
        clientesTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        clientesTextField.returnKeyType = .done
        clientesTextField.layer.borderColor = AppStyle.getSecondaryColor().cgColor
        clientesTextField.textColor = AppStyle.getPrimaryTextColor()
        clientesTextField.attributedPlaceholder = NSAttributedString(string: "Nombre", attributes: [NSAttributedString.Key.foregroundColor: AppStyle.getSecondaryColor()])
        clientesTextField.delegate = self
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
    
    func getClients() {
        if emptyStateLabel != nil {
            emptyStateLabel.removeFromSuperview()
            emptyStateLabel = nil
        }
        
        var allClientes: [ClientModel] = Constants.databaseManager.clientsManager.getAllClientsFromDatabase()
        
        if clientesTextField.text!.count != 0 {
            let telf = Float(clientesTextField.text!) ?? nil
            
            if telf == nil {
                allClientes = Constants.databaseManager.clientsManager.getClientsFilteredByText(text: clientesTextField.text!)
            } else {
                allClientes = Constants.databaseManager.clientsManager.getClientsFilteredByPhone(phone: clientesTextField.text!)
            }
        }
        
        if allClientes.count > 0 {
            indexClients(arrayClients: allClientes)
        } else {
            emptyStateLabel = CommonFunctions.createEmptyState(emptyText: "No dispone de pacientes, clique en el botón + para añadir un paciente", parentView: self.view)
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

extension ListaClientesViewController {
    @IBAction func didClickclearTextField(_ sender: Any) {
        clientesTextField.text = ""
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

extension ListaClientesViewController: UITableViewDelegate, UITableViewDataSource {
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
        performSegue(withIdentifier: "ClientDetailIdentifier", sender: filteredClients[indexPath.section][indexPath.row])
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

extension ListaClientesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClientDetailIdentifier" {
            let controller: ClientDetailViewController = segue.destination as! ClientDetailViewController
            controller.client = (sender as! ClientModel)
        }
    }
}

extension ListaClientesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension ListaClientesViewController: ListaClientesProtocol {
    func successGettingClients() {
        DispatchQueue.main.async {
            self.tableRefreshControl.endRefreshing()
            self.getClients()
        }
    }
    
    func errorGettingClients() {
        DispatchQueue.main.async {
            self.tableRefreshControl.endRefreshing()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error sincronizando pacientes", viewController: self)
        }
    }
}
