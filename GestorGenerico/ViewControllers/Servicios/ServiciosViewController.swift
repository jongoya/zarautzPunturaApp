//
//  ServiciosViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 13/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class ServiciosViewController: UIViewController {
    @IBOutlet weak var serviciosTableView: UITableView!
    
    var emptyStateLabel: UILabel!
    
    var servicios: [TipoServicioModel] = []
    var tableRefreshControl: UIRefreshControl = UIRefreshControl()
    var showServicioColor: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Servicios"
        customizeTableView()
        
        if !showServicioColor {
            addCreateServicioButton()
        }
        addRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showServicios()
    }
    
    func customizeTableView() {
        serviciosTableView.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func showServicios() {
        if emptyStateLabel != nil {
            emptyStateLabel.removeFromSuperview()
            emptyStateLabel = nil
        }
        
        servicios = Constants.databaseManager.tipoServiciosManager.getAllServiciosFromDatabase()
        
        if servicios.count > 0 {
            serviciosTableView.reloadData()
        } else {
            emptyStateLabel = CommonFunctions.createEmptyState(emptyText: "No dispone de servicios", parentView: self.view)
        }
        
    }
    
    func addCreateServicioButton() {
        if #available(iOS 13.0, *) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didClickCreateServicioButton))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .done, target: self, action: #selector(didClickCreateServicioButton))
        }
    }
    
    func addRefreshControl() {
        tableRefreshControl.addTarget(self, action: #selector(refreshServicios(_:)), for: .valueChanged)
        serviciosTableView.refreshControl = tableRefreshControl
    }
}

extension ServiciosViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ServicioTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ServicioTableViewCell", for: indexPath) as! ServicioTableViewCell
        cell.selectionStyle = .none
        cell.setupCell(servicio: servicios[indexPath.row], showColorView: showServicioColor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !showServicioColor {
            performSegue(withIdentifier: "AddServicioIdentifier", sender: servicios[indexPath.row])
        } else {
            performSegue(withIdentifier: "colorSegue", sender: servicios[indexPath.row])
        }
    }
}

extension ServiciosViewController {
    @objc func didClickCreateServicioButton(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddServicioIdentifier", sender: nil)
    }
    
    @objc func refreshServicios(_ sender: Any) {
        WebServices.getTipoServicios(delegate: self)
    }
}

extension ServiciosViewController: GetTipoServiciosProtocol {
    func successGettingServicios() {
        DispatchQueue.main.async {
            self.tableRefreshControl.endRefreshing()
            self.showServicios()
        }
    }
    
    func errorGettingServicios() {
        DispatchQueue.main.async {
            CommonFunctions.showGenericAlertMessage(mensaje: "Error cargando servicios", viewController: self)
        }
    }
}

extension ServiciosViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddServicioIdentifier" {
            let controller: AddTipoServicioViewController = segue.destination as! AddTipoServicioViewController
            if sender != nil {
                controller.servicio = (sender as! TipoServicioModel)
            }
        } else if segue.identifier == "colorSegue" {
            let servicio: TipoServicioModel = (sender as! TipoServicioModel)
            let controller: ColorPickerViewController = segue.destination as! ColorPickerViewController
            controller.servicio = servicio
        }
    }
}
