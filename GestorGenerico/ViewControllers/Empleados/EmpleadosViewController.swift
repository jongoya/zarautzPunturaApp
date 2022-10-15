//
//  EmpleadosViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 12/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class EmpleadosViewController: UIViewController {
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var empleados: [EmpleadoModel] = []
    var empleadosViews: [UIView] = []
    var showColorView: Bool = false
    var emptyStateLabel: UILabel!
    var scrollRefreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Empleados"
        customizeScrollView()
        if !showColorView {
            addCreateEmpleadoButton()
        }
        
        addRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showEmpleados()
    }
    
    func customizeScrollView() {
        scrollView.backgroundColor = AppStyle.getBackgroundColor()
        scrollContentView.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func showEmpleados() {
        empleados = CommonFunctions.getProfessionalList()
        
        removeScrollViewContent()
        
        if empleados.count > 0 {
            addEmpleadosViews()
            
            setConstraints()
        } else {
            emptyStateLabel = CommonFunctions.createEmptyState(emptyText: "No dispone de empleados", parentView: self.view)
        }
    }
    
    func addEmpleadosViews() {
        for empleado in empleados {
            addEmpleadoView(empleado: empleado)
        }
    }
    
    func addCreateEmpleadoButton() {
        if #available(iOS 13.0, *) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didClickCreateEmpleadoButton))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .done, target: self, action: #selector(didClickCreateEmpleadoButton))
        }
    }
    
    func addEmpleadoView(empleado: EmpleadoModel) {
        let empleadoView: EmpleadoView = EmpleadoView()
        empleadoView.translatesAutoresizingMaskIntoConstraints = false
        empleadoView.backgroundColor = AppStyle.getBackgroundColor()
        empleadoView.empleado = empleado
        addEmpleadoItemGestures(empleadoView: empleadoView)
        scrollContentView.addSubview(empleadoView)
        
        let crossView: UIView = UIView()
        crossView.translatesAutoresizingMaskIntoConstraints = false
        crossView.backgroundColor = .systemRed
        crossView.layer.cornerRadius = 10
        
        let tap = EmpleadoTapGesture(target: self, action: #selector(didClickCrossView(sender:)))
        tap.empleadoView = empleadoView
        crossView.addGestureRecognizer(tap)
        empleadoView.addSubview(crossView)
        
        let crossImageView: UIImageView = UIImageView()
        crossImageView.translatesAutoresizingMaskIntoConstraints = false
        crossImageView.image = UIImage.init(named: "cross")!.withRenderingMode(.alwaysTemplate)
        crossImageView.tintColor = .white
        crossView.addSubview(crossImageView)
        
        if showColorView {
            crossView.isHidden = true
            crossImageView.isHidden = true
        }
        
        let contentView: UIView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        empleadoView.addSubview(contentView)
        
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "empleado")!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = AppStyle.getPrimaryTextColor()
        contentView.addSubview(imageView)
        
        let nombreLabel: UILabel = UILabel()
        nombreLabel.translatesAutoresizingMaskIntoConstraints = false
        nombreLabel.text = empleado.nombre + " " + empleado.apellidos
        nombreLabel.textColor = AppStyle.getPrimaryTextColor()
        nombreLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(nombreLabel)
        
        let colorView: UIView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.cornerRadius = 15
        if #available(iOS 13.0, *) {
            colorView.backgroundColor = UIColor(cgColor: CGColor(srgbRed: CGFloat(empleado.redColorValue/255), green: CGFloat(empleado.greenColorValue/255), blue: CGFloat(empleado.blueColorValue/255), alpha: 1.0))
        } else {
            colorView.backgroundColor = UIColor(red: CGFloat(empleado.redColorValue/255), green: CGFloat(empleado.greenColorValue/255), blue: CGFloat(empleado.blueColorValue/255), alpha: 1.0)
        }
        contentView.addSubview(colorView)
        
        if !showColorView {
            colorView.isHidden = true
        }
        
        empleadoView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        empleadoView.empleadoLeadingAnchor = contentView.leadingAnchor.constraint(equalTo: empleadoView.leadingAnchor, constant: 10)
        empleadoView.empleadoLeadingAnchor.isActive = true
        empleadoView.empleadoTrailingAnchor = contentView.trailingAnchor.constraint(equalTo: empleadoView.trailingAnchor, constant: -10)
        empleadoView.empleadoTrailingAnchor.isActive = true
        contentView.topAnchor.constraint(equalTo: empleadoView.topAnchor, constant: 5).isActive = true
        contentView.bottomAnchor.constraint(equalTo: empleadoView.bottomAnchor, constant: -5).isActive = true
        
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        
        colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        colorView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        nombreLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        nombreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        nombreLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        nombreLabel.trailingAnchor.constraint(equalTo: colorView.isHidden ? contentView.trailingAnchor : colorView.leadingAnchor, constant: -10).isActive = true
        
        crossView.topAnchor.constraint(equalTo: empleadoView.topAnchor, constant: 5).isActive = true
        crossView.bottomAnchor.constraint(equalTo: empleadoView.bottomAnchor, constant: -5).isActive = true
        crossView.leadingAnchor.constraint(equalTo: empleadoView.leadingAnchor, constant: 10).isActive = true
        crossView.trailingAnchor.constraint(equalTo: empleadoView.trailingAnchor, constant: -10).isActive = true
        
        crossImageView.trailingAnchor.constraint(equalTo: crossView.trailingAnchor, constant: -20).isActive = true
        crossImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        crossImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        crossImageView.centerYAnchor.constraint(equalTo: crossView.centerYAnchor).isActive = true
        
        empleadosViews.append(empleadoView)
    }
    
    func addEmpleadoItemGestures(empleadoView: EmpleadoView) {
        let tap = EmpleadoTapGesture(target: self, action: #selector(didClickEmpleadoView(sender:)))
        tap.empleadoView = empleadoView
        empleadoView.addGestureRecognizer(tap)
        if !showColorView {
            let swipeLeft = EmpleadoSwipeGesture(target: self, action: #selector(serviceSwipedLeft))
            swipeLeft.direction = .left
            swipeLeft.empleadoView = empleadoView
            empleadoView.addGestureRecognizer(swipeLeft)
            let swipeRight = EmpleadoSwipeGesture(target: self, action: #selector(serviceSwipedRight))
            swipeRight.direction = .right
            swipeRight.empleadoView = empleadoView
            empleadoView.addGestureRecognizer(swipeRight)
        }
    }
    
    func setConstraints() {
        var previousView: UIView!
        for empleadoView: UIView in empleadosViews {
            empleadoView.topAnchor.constraint(equalTo: previousView != nil ? previousView.bottomAnchor : scrollContentView.topAnchor, constant: 5).isActive = true
            
            empleadoView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
            empleadoView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
            
            previousView = empleadoView
        }
        
        if previousView != nil {
            previousView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -5).isActive = true
        }
    }
    
    func removeScrollViewContent() {
        for view in scrollContentView.subviews {
            view.removeFromSuperview()
        }
        
        if emptyStateLabel != nil {
            emptyStateLabel.removeFromSuperview()
            emptyStateLabel = nil
        }
        
        empleadosViews.removeAll()
    }
    
    func leftAnimation(view: EmpleadoView) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            view.empleadoLeadingAnchor.constant = -80
            view.empleadoTrailingAnchor.constant = -80
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func rightAnimation(view: EmpleadoView) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            view.empleadoLeadingAnchor.constant = 10
            view.empleadoTrailingAnchor.constant = -10
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func addRefreshControl() {
        scrollRefreshControl.addTarget(self, action: #selector(refreshEmpleados), for: .valueChanged)
        scrollView.refreshControl = scrollRefreshControl
    }
}

extension EmpleadosViewController {
    @objc func didClickCreateEmpleadoButton(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddEmpleadoIdentifier", sender: nil)
    }
    
    @objc func didClickEmpleadoView(sender: EmpleadoTapGesture) {
        let empleado: EmpleadoModel = sender.empleadoView.empleado
        if showColorView {
            performSegue(withIdentifier: "ColorPickerIdentifier", sender: empleado)
        } else {
            performSegue(withIdentifier: "AddEmpleadoIdentifier", sender: empleado)
        }
    }
    
    @objc func didClickCrossView(sender: EmpleadoTapGesture) {
        let empleado: EmpleadoModel = sender.empleadoView.empleado
        if empleado.is_empleado_jefe {
            CommonFunctions.showGenericAlertMessage(mensaje: "No puede eliminar un empleado que es jefe", viewController: self)
            return
        }
        
        CommonFunctions.showLoadingStateView(descriptionText: "Eliminando empleado")
        WebServices.deleteEmpleado(empleado: empleado, delegate: self)
    }
    
    @objc func serviceSwipedLeft(sender: EmpleadoSwipeGesture) {
        let empleadoView: EmpleadoView = sender.empleadoView
        leftAnimation(view: empleadoView)
    }
    
    @objc func serviceSwipedRight(sender: EmpleadoSwipeGesture) {
        let empleadoView: EmpleadoView = sender.empleadoView
        rightAnimation(view: empleadoView)
    }
    
    @objc func refreshEmpleados() {
        WebServices.getEmpleados(delegate: self)
    }
}

extension EmpleadosViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEmpleadoIdentifier" {
            let controller: AddEmpleadoViewController = segue.destination as! AddEmpleadoViewController
            if sender != nil {
                controller.empleado = (sender as! EmpleadoModel)
                controller.updateMode = true
            }
        }
    }
}

class EmpleadoTapGesture: UITapGestureRecognizer {
    var empleadoView: EmpleadoView!
}

class EmpleadoSwipeGesture: UISwipeGestureRecognizer {
    var empleadoView: EmpleadoView!
}

class EmpleadoView: UIView {
    var empleadoLeadingAnchor: NSLayoutConstraint!
    var empleadoTrailingAnchor: NSLayoutConstraint!
    var empleado: EmpleadoModel!
}

extension EmpleadosViewController: GetEmpleadosProtocol {
    func succesGettingEmpleados(empleados: [EmpleadoModel]) {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            self.scrollRefreshControl.endRefreshing()
            self.showEmpleados()
        }
    }
    
    func errorGettingEmpleados() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            self.scrollRefreshControl.endRefreshing()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error cargando los empleados", viewController: self)
        }
    }
}

extension EmpleadosViewController: DeleteEmpleadoProtocol {
    func logoutResponse() {
        CommonFunctions.showLogoutAlert(viewController: self)
    }
    
    func successDeletingEmpleado(empleadoMasServicios: EmpleadoMasServicios) {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            Constants.databaseManager.empleadosManager.eliminarEmpleado(empleadoId: empleadoMasServicios.empleado.empleadoId)
            for servicio: ServiceModel in empleadoMasServicios.servicios {
                Constants.databaseManager.servicesManager.updateServiceInDatabase(service: servicio)
            }
            
            self.updateEmpleadoInTipoServicios(empleadoEliminado: empleadoMasServicios.empleado)
            
            self.showEmpleados()
        }
    }
    
    func errorDeletingEmpleado() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error eliminando el empleado", viewController: self)
        }
    }
    
    func updateEmpleadoInTipoServicios(empleadoEliminado: EmpleadoModel) {
        let empleados: [EmpleadoModel] = Constants.databaseManager.empleadosManager.getAllEmpleadosFromDatabase()
        if empleados.count == 0 {
            return
        }
        
        var empleadoJefe: EmpleadoModel = empleados.first!
        for empleado: EmpleadoModel in empleados {
            if empleado.is_empleado_jefe {
                empleadoJefe = empleado
            }
        }
        
        let servicios: [TipoServicioModel] = Constants.databaseManager.tipoServiciosManager.getAllServiciosFromDatabase()
        
        for servicio: TipoServicioModel in servicios {
            if servicio.terapeuta == empleadoEliminado.empleadoId {
                servicio.terapeuta = empleadoJefe.empleadoId
                Constants.databaseManager.tipoServiciosManager.updateServiceInDatabase(service: servicio)
            }
        }
    }
}

