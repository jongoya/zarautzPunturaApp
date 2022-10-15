//
//  AddTipoServicioViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 13/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class AddTipoServicioViewController: UIViewController {
    @IBOutlet weak var nombreServicioLabel: UILabel!
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var informcaionField: UILabel!
    @IBOutlet weak var nombreField: UILabel!
    @IBOutlet weak var nombreArrow: UIImageView!
    @IBOutlet weak var numCabinasField: UILabel!
    @IBOutlet weak var numCabinasArrow: UIImageView!
    @IBOutlet weak var numCabinasLabel: UILabel!
    @IBOutlet weak var ocupaTerapeutaField: UILabel!
    @IBOutlet weak var ocupaSwitch: UISwitch!
    @IBOutlet weak var duracionField: UILabel!
    @IBOutlet weak var duracionArrow: UIImageView!
    @IBOutlet weak var duracionLabel: UILabel!
    @IBOutlet weak var terapeutaField: UILabel!
    @IBOutlet weak var terapeutaArrow: UIImageView!
    @IBOutlet weak var terapeutaLabel: UILabel!
    @IBOutlet weak var precioField: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var precioArrow: UIImageView!
    
    var servicio: TipoServicioModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nuevo Servicio"
        if servicio == nil {
            servicio = TipoServicioModel()
        }
        customizeBackground()
        customizeFields()
        customizeArrow()
        customizeLabels()
        customizeSwitch()
        setFields()
        addSaveServicioButton()
        ocupaSwitch.addTarget(self, action: #selector(switchClicked), for: UIControl.Event.valueChanged)
    }
    
    func customizeFields() {
        informcaionField.textColor = AppStyle.getPrimaryTextColor()
        nombreField.textColor = AppStyle.getPrimaryTextColor()
        numCabinasField.textColor = AppStyle.getPrimaryTextColor()
        ocupaTerapeutaField.textColor = AppStyle.getPrimaryTextColor()
        duracionField.textColor = AppStyle.getPrimaryTextColor()
        terapeutaField.textColor = AppStyle.getPrimaryTextColor()
        precioField.textColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeArrow() {
        if #available(iOS 13.0, *) {
            nombreArrow.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        } else {
            nombreArrow.image = UIImage(named: "chevron_right")?.withRenderingMode(.alwaysTemplate)
        }
        nombreArrow.tintColor = AppStyle.getSecondaryColor()
        if #available(iOS 13.0, *) {
            numCabinasArrow.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        } else {
            numCabinasArrow.image = UIImage(named: "chevron_right")?.withRenderingMode(.alwaysTemplate)
        }
        numCabinasArrow.tintColor = AppStyle.getSecondaryColor()
        if #available(iOS 13.0, *) {
            duracionArrow.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        } else {
            duracionArrow.image = UIImage(named: "chevron_right")?.withRenderingMode(.alwaysTemplate)
        }
        duracionArrow.tintColor = AppStyle.getSecondaryColor()
        if #available(iOS 13.0, *) {
            terapeutaArrow.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        } else {
            terapeutaArrow.image = UIImage(named: "chevron_right")?.withRenderingMode(.alwaysTemplate)
        }
        terapeutaArrow.tintColor = AppStyle.getSecondaryColor()
        if #available(iOS 13.0, *) {
            precioArrow.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        } else {
            precioArrow.image = UIImage(named: "chevron_right")?.withRenderingMode(.alwaysTemplate)
        }
        precioArrow.tintColor = AppStyle.getSecondaryColor()
    }
    
    func customizeLabels() {
        nombreServicioLabel.textColor = AppStyle.getSecondaryTextColor()
        numCabinasLabel.textColor = AppStyle.getSecondaryTextColor()
        duracionLabel.textColor = AppStyle.getSecondaryTextColor()
        terapeutaLabel.textColor = AppStyle.getSecondaryTextColor()
        precioLabel.textColor = AppStyle.getSecondaryTextColor()
    }
    
    func customizeBackground() {
        background.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func customizeSwitch() {
        ocupaSwitch.onTintColor = AppStyle.getPrimaryColor()
    }
    
    func setFields() {
        nombreServicioLabel.text = servicio.nombre
        numCabinasLabel.text = servicio.numCabinas == 0 ? "" : String(servicio.numCabinas)
        ocupaSwitch.isOn = servicio.bloqueaTerapeuta
        duracionLabel.text = servicio.duracion == 0 ? "" : String(servicio.duracion)
        if servicio.terapeuta != 0 {
            let empleado: EmpleadoModel = Constants.databaseManager.empleadosManager.getEmpleadoFromDatabase(empleadoId: servicio.terapeuta) ?? EmpleadoModel()
            terapeutaLabel.text = empleado.nombre
        }
        
        precioLabel.text = servicio.precio == 0 ? "" : String(format: "%.2f", servicio.precio) + " €"
    }
    
    func addSaveServicioButton() {
        if #available(iOS 13.0, *) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(didClickSaveButton))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "checkmark"), style: .done, target: self, action: #selector(didClickSaveButton))
        }
    }
    
    func showInputFieldView(inputReference: Int, keyBoardType: UIKeyboardType, text: String) {
        let showItemStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: FieldViewController = showItemStoryboard.instantiateViewController(withIdentifier: "FieldViewController") as! FieldViewController
        controller.inputReference = inputReference
        controller.delegate = self
        controller.keyboardType = keyBoardType
        controller.inputText = text
        controller.title = getTitleForInputController(reference: inputReference)
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func showListSelectorViewController(inputReference: Int) {
        let showItemStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: ListSelectorViewController = showItemStoryboard.instantiateViewController(withIdentifier: "ListSelector") as! ListSelectorViewController
        controller.delegate = self
        controller.inputReference = inputReference
        controller.listOptions = CommonFunctions.getProfessionalList()
        controller.allowMultiselection = false
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func getTitleForInputController(reference: Int) -> String {
        switch reference {
        case 0:
            return "Nombre"
        case 1:
            return "Numero Cabinas"
        case 3:
            return "Precio"
        default:
            return "Duración"
        }
    }
    
    func checkFields() {
        if nombreServicioLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe escribir un nombre para el servicio", viewController: self)
            return
        }
        
        if numCabinasLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe escribir un numerode cabinas para el servicio", viewController: self)
            return
        }
        
        if duracionLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe escribir una duración para el servicio", viewController: self)
            return
        }
        
        if terapeutaLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe seleccionar un terapeuta para el servicio", viewController: self)
            return
        }
        
        if precioLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe escribir un precio para el servicio", viewController: self)
            return
        }
        
        if servicio.servicioId  == 0 {
            CommonFunctions.showLoadingStateView(descriptionText: "Guardando servicio")
            WebServices.addTipoServicio(tipoServicio: servicio, delegate: self)
        } else {
            CommonFunctions.showLoadingStateView(descriptionText: "Actualizando servicio")
            WebServices.updateTipoServicio(tipoServicio: servicio, delegate: self)
        }
    }
}

extension AddTipoServicioViewController {
    @IBAction func didClickNombreServicio(_ sender: Any) {
        showInputFieldView(inputReference: 0, keyBoardType: .default, text: nombreServicioLabel.text!)
    }
    
    @objc func didClickSaveButton(sender: UIBarButtonItem) {
        checkFields()
    }
    
    @IBAction func didClickNumCabinas(_ sender: Any) {
        showInputFieldView(inputReference: 1, keyBoardType: .decimalPad, text: numCabinasLabel.text!)
    }
    
    @IBAction func didClickDuracion(_ sender: Any) {
        showInputFieldView(inputReference: 2, keyBoardType: .decimalPad, text: servicio.duracion > 0 ? String(servicio.duracion) : "")
    }
    
    @IBAction func didClickTerapeuta(_ sender: Any) {
        showListSelectorViewController(inputReference: 0)
    }
    
    @objc func switchClicked(mySwitch: UISwitch) {
        servicio.bloqueaTerapeuta = ocupaSwitch.isOn
    }
    
    @IBAction func didClickPrecio(_ sender: Any) {
        showInputFieldView(inputReference: 3, keyBoardType: .decimalPad, text: servicio.precio > 0 ? String(format: "%.2f", servicio.precio) : "")
    }
}

extension AddTipoServicioViewController: AddClientInputFieldProtocol {
    func textSaved(text: String, inputReference: Int) {
        switch inputReference {
        case 0:
            servicio.nombre = text
            nombreServicioLabel.text = text
            break
        case 1:
            servicio.numCabinas = Int64(text) ?? 0
            numCabinasLabel.text = text
            break
        case 2:
            servicio.duracion = Int64(text) ?? 0
            duracionLabel.text = text + " mins"
            break
        case 3:
            let value = text.replacingOccurrences(of: ",", with: ".")
            precioLabel.text = value + " €"
            servicio.precio = (value as NSString).doubleValue
            break
        default:
            break
        }
    }
}

extension AddTipoServicioViewController: AddTipoServicioProtocol {
    func logoutResponse() {
        CommonFunctions.showLogoutAlert(viewController: self)
    }
    
    func successSavingServicio(tipoServicio: TipoServicioModel) {
        Constants.databaseManager.tipoServiciosManager.addTipoServicioToDatabase(servicio: tipoServicio)
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    func errorSavingServicio() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error guardando servicio", viewController: self)
        }
    }
}

extension AddTipoServicioViewController: ListSelectorProtocol {
    func optionSelected(option: Any, inputReference: Int) {
        let terapueta: EmpleadoModel = option as! EmpleadoModel
        servicio.terapeuta = terapueta.empleadoId
        terapeutaLabel.text = terapueta.nombre
    }
    
    func multiSelectionOptionsSelected(options: [Any], inputReference: Int) {
        //TODO no es necesario
    }
}

extension AddTipoServicioViewController: UpdateTipoServicioProtocol {
    func servicioUpdated(servicio: TipoServicioModel) {
        Constants.databaseManager.tipoServiciosManager.updateServiceInDatabase(service: servicio)
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    func errorUpdatingServicio() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error guardando servicio", viewController: self)
        }
    }
}
