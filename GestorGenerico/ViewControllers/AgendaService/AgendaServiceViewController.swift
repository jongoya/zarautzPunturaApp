//
//  AgendaServiceViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 08/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class AgendaServiceViewController: UIViewController {
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var servicioLabel: UILabel!
    @IBOutlet weak var observacionesLabel: UILabel!
    @IBOutlet weak var efectivoSwicth: UISwitch!
    
    @IBOutlet weak var informacionField: UILabel!
    @IBOutlet weak var nombreField: UILabel!
    @IBOutlet weak var fechaField: UILabel!
    @IBOutlet weak var servicioField: UILabel!
    @IBOutlet weak var efectiovField: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgPlantilla: UIImageView!
    @IBOutlet weak var titulo4: UILabel!
    
    @IBOutlet weak var nombreArrow: UIImageView!
    @IBOutlet weak var fechaArrow: UIImageView!
    @IBOutlet weak var servicioArrow: UIImageView!
    @IBOutlet weak var selectorField: UILabel!
    @IBOutlet weak var selectorArrow: UIImageView!
    @IBOutlet weak var selectorLabel: UILabel!
    @IBOutlet weak var titulo2: UILabel!
    @IBOutlet weak var sistemasTableView: UITableView!
    @IBOutlet weak var meridianosField: UILabel!
    @IBOutlet weak var meridianosArrow: UIImageView!
    @IBOutlet weak var meridianosLabel: UILabel!
    @IBOutlet weak var equilibriosField: UILabel!
    @IBOutlet weak var equilibriosArrow: UIImageView!
    @IBOutlet weak var equilibriosLabel: UILabel!
    @IBOutlet weak var titulo3: UILabel!
    @IBOutlet weak var imgPlantilla2: UIImageView!
    
    var newService: ServiceModel = ServiceModel()
    var clientSeleced: ClientModel!
    var newDate: Date!
    var modificacionHecha: Bool = false
    var delegate: AgendaServiceProtocol!
    var sistemas: [SistemaModel] = []
    var numCabinasDisponibles: Int = 0
    var empleadosDisponibles: [EmpleadoModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tratamiento"
        customizeLabels()
        customizeFields()
        customizeArrows()
        customizeSwitch()
        customizeBackground()
        efectivoSwicth.addTarget(self, action: #selector(switchClicked), for: UIControl.Event.valueChanged)
        addBackButton()
        setInitialDate()
        setSistemasTable()
    }
    
    func customizeLabels() {
        nombreLabel.textColor = AppStyle.getSecondaryTextColor()
        fechaLabel.textColor = AppStyle.getSecondaryTextColor()
        servicioLabel.textColor = AppStyle.getSecondaryTextColor()
        selectorLabel.textColor = AppStyle.getSecondaryTextColor()
        meridianosLabel.textColor = AppStyle.getSecondaryTextColor()
        equilibriosLabel.textColor = AppStyle.getSecondaryTextColor()
    }
    
    func customizeFields() {
        nombreField.textColor = AppStyle.getPrimaryTextColor()
        informacionField.textColor = AppStyle.getPrimaryTextColor()
        fechaField.textColor = AppStyle.getPrimaryTextColor()
        servicioField.textColor = AppStyle.getPrimaryTextColor()
        efectiovField.textColor = AppStyle.getPrimaryTextColor()
        observacionesLabel.textColor = AppStyle.getPrimaryTextColor()
        selectorField.textColor = AppStyle.getPrimaryTextColor()
        meridianosField.textColor = AppStyle.getPrimaryTextColor()
        equilibriosField.textColor = AppStyle.getPrimaryTextColor()
        titulo2.textColor = AppStyle.getPrimaryTextColor()
        titulo3.textColor = AppStyle.getPrimaryTextColor()
        titulo4.textColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeArrows() {
        if #available(iOS 13.0, *) {
            nombreArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            fechaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            servicioArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            selectorArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            meridianosArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            equilibriosArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        } else {
            nombreArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            fechaArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            servicioArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            selectorArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            meridianosArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            equilibriosArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
        }
        nombreArrow.tintColor = AppStyle.getSecondaryColor()
        fechaArrow.tintColor = AppStyle.getSecondaryColor()
        servicioArrow.tintColor = AppStyle.getSecondaryColor()
        selectorArrow.tintColor = AppStyle.getSecondaryColor()
        meridianosArrow.tintColor = AppStyle.getSecondaryColor()
        equilibriosArrow.tintColor = AppStyle.getSecondaryColor()
    }
    
    func customizeBackground() {
        scrollView.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func customizeSwitch() {
        efectivoSwicth.onTintColor = AppStyle.getPrimaryColor()
    }
    
    func setInitialDate() {
        newService.fecha = Int64(newDate.timeIntervalSince1970)
        fechaLabel.text = CommonFunctions.getDateAndTimeTypeStringFromDate(date: newDate)
    }
    
    func setSistemasTable() {
        sistemasTableView.backgroundColor = .white
        sistemasTableView.allowsMultipleSelection = true
        sistemas = Constants.databaseManager.sistemaManager.getAllSistemas()
        sistemasTableView.reloadData()
    }
    
    func getServiceArray() -> [Any] {
        if numCabinasDisponibles == 0 {
            return CommonFunctions.getServiceList()
        } else {
            return CommonFunctions.getServiciosDisponibles(numCabinasDisponibles: numCabinasDisponibles, empleados: empleadosDisponibles, empleadoSeleccionado: newService.empleadoId)
        }
    }
    
    func checkFields() {
        if nombreLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe seleccionar un paciente", viewController: self)
            return
        }
        
        if fechaLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir una fecha", viewController: self)
            return
        }
        
        if servicioLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe seleccionar un tratamiento", viewController: self)
            return
        }

        saveService()
    }
    
    func saveService() {
        newService.clientId = clientSeleced.id
        CommonFunctions.showLoadingStateView(descriptionText: "Guardando tratamiento")
        WebServices.addService(service: newService, delegate: self)
    }
    
    func addBackButton() {
        if #available(iOS 13.0, *) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(didClickBackButton))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron_left"), style: .done, target: self, action: #selector(didClickBackButton))
        }
    }
    
    func showChangesAlertMessage() {
        let alertController = UIAlertController(title: "Aviso", message: "Varios datos han sido modificados, ¿desea volver sin guardar?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Aceptar", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in }

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getTitleForInputReference(inputReference: Int) -> String {
        switch inputReference {
        case 1:
            return "Observaciones"
        case 2:
            return "Meridianos"
        case 3:
            return "Otro"
        default:
            return "Equilibrios"
        }
    }
    
    func getValueForInputReference(inputReference: Int) -> String {
        switch inputReference {
        case 1:
            return newService.observaciones
        case 2:
            return newService.meridianos
        case 3:
            if newService.selector != "Global Balance" && newService.selector != "Local Balance" {
                return newService.selector
            }
            
            return ""
        default:
            return newService.equilibrio
        }
    }
}

extension AgendaServiceViewController {
    @IBAction func didClickNombreField(_ sender: Any) {
        performSegue(withIdentifier: "ClientListIdentifier", sender: nil)
    }
    
    @IBAction func didClickFechaField(_ sender: Any) {
        performSegue(withIdentifier: "DatePickerSelectorIdentifier", sender: nil)
    }
    
    @IBAction func didClickServicioField(_ sender: Any) {
        performSegue(withIdentifier: "ListSelectorIdentifier", sender: nil)
    }
    
    @IBAction func didClickObservacionesField(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 1)
    }
    
    @IBAction func didClickSaveServiceButton(_ sender: Any) {
        checkFields()
    }
    
    @IBAction func didClickPlusButton(_ sender: Any) {
        performSegue(withIdentifier: "AddClienteIdentifier", sender: nil)
    }
    
    @objc func didClickBackButton(sender: UIBarButtonItem) {
        if !modificacionHecha {
            self.navigationController?.popViewController(animated: true)
        } else {
            showChangesAlertMessage()
        }
    }
    
    @objc func switchClicked(mySwitch: UISwitch) {
        newService.isEfectivo = efectivoSwicth.isOn
    }
    
    @IBAction func didClickPlantilla(_ sender: Any) {
        performSegue(withIdentifier: "plantillaSegue", sender: 1)
    }
    
    @IBAction func didClickSelector(_ sender: Any) {
        performSegue(withIdentifier: "PickerSelector", sender: nil)
    }
    
    @IBAction func didClickMeridianos(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 2)
    }
    
    @IBAction func didClickEquilibrios(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 3)
    }
    
    @IBAction func didClickImagen2(_ sender: Any) {
        performSegue(withIdentifier: "plantillaSegue", sender: 2)
    }
}

extension AgendaServiceViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DatePickerSelectorIdentifier" {
            let controller: DatePickerSelectorViewController = segue.destination as! DatePickerSelectorViewController
            controller.delegate = self
            controller.datePickerMode = .dateAndTime
        } else if segue.identifier == "FieldIdentifier" {
            let controller: FieldViewController = segue.destination as! FieldViewController
            controller.inputReference = (sender as! Int)
            controller.delegate = self
            controller.keyboardType = .default
            controller.inputText = getValueForInputReference(inputReference: (sender as! Int))
            controller.title = getTitleForInputReference(inputReference: (sender as! Int))
        } else if segue.identifier == "ListSelectorIdentifier" {
            let controller: ListSelectorViewController = segue.destination as! ListSelectorViewController
            controller.delegate = self
            controller.listOptions = getServiceArray()
            controller.allowMultiselection = false
        } else if segue.identifier == "ClientListIdentifier" {
            let controller: ClientListSelectorViewController = segue.destination as! ClientListSelectorViewController
            controller.delegate = self
        } else if segue.identifier == "AddClienteIdentifier" {
            let controller: AddClientViewController = segue.destination as! AddClientViewController
            controller.delegate = self
        } else if segue.identifier == "plantillaSegue" {
            let reference: Int = sender as! Int
            let controller: PlantillaViewController = segue.destination as! PlantillaViewController
            controller.delegate = self
            controller.screenOrientation = CommonFunctions.getDeviceOrientation()
            if reference == 1 {
               controller.imgPlantilla = newService.imgPlantilla
            } else {
               controller.imgPlantilla = newService.imgPlantilla2
            }
            controller.plantillaReference = reference
        } else if segue.identifier == "PickerSelector" {
            let controller: PickerSelectorViewController = segue.destination as! PickerSelectorViewController
            controller.delegate = self
            controller.options = ["Global Balance", "Local Balance", "Otro"]
        }
    }
}

extension AgendaServiceViewController: DatePickerSelectorProtocol {
    func dateSelected(date: Date) {
        newService.fecha = Int64(date.timeIntervalSince1970)
        fechaLabel.text = CommonFunctions.getDateAndTimeTypeStringFromDate(date: date)
    }
}

extension AgendaServiceViewController: ListSelectorProtocol {
    func multiSelectionOptionsSelected(options: [Any], inputReference: Int) {
        //no es necesario implementar
    }
    
    func optionSelected(option: Any, inputReference: Int) {
        modificacionHecha = true
        let servicio: TipoServicioModel = (option as! TipoServicioModel)
        newService.servicios = [servicio.servicioId]
        servicioLabel.text = servicio.nombre
        newService.empleadoId = servicio.terapeuta
    }
}

extension AgendaServiceViewController: AddClientInputFieldProtocol {
    func textSaved(text: String, inputReference: Int) {
        modificacionHecha = true
        switch inputReference {
        case 1:
            newService.observaciones = text
            observacionesLabel.text = text
            break
        case 2:
            newService.meridianos = text
            meridianosLabel.text = text
            break
        case 3:
            newService.selector = text
            selectorLabel.text = text
            return
        default:
            newService.equilibrio = text
            equilibriosLabel.text = text
        }
    }
}

extension AgendaServiceViewController: ClientListSelectorProtocol {
    func clientSelected(client: ClientModel) {
        clientSeleced = client
        nombreLabel.text = client.nombre + " " + client.apellidos
        modificacionHecha = true
    }
}

extension AgendaServiceViewController: AddClientProtocol {
    func clientAdded(client: ClientModel) {
        clientSeleced = client
        nombreLabel.text = client.nombre + " " + client.apellidos
        modificacionHecha = true
    }
}

extension AgendaServiceViewController: AddNuevoServicioProtocol {
    func logoutResponse() {
        CommonFunctions.showLogoutAlert(viewController: self)
    }
    
    func successSavingService(servicio: ServiceModel) {
        Constants.databaseManager.servicesManager.addServiceInDatabase(newService: servicio)
        
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            self.delegate.serviceAdded()
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    func errorSavingServicio() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error guardando el tratamiento", viewController: self)
        }
    }
}

extension AgendaServiceViewController: PlantillaProtocol {
    func imageDrawed(imageString: String, reference: Int) {
        let dataDecoded : Data = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters)!
        if reference == 1 {
            imgPlantilla.image =  UIImage(data: dataDecoded)
            newService.imgPlantilla = imageString
        } else {
            imgPlantilla2.image =  UIImage(data: dataDecoded)
            newService.imgPlantilla2 = imageString
        }
    }
}

extension AgendaServiceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sistemas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AgendaSistemasTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AgendaSistemasTableViewCell") as! AgendaSistemasTableViewCell
        cell.setupCell(sistema: sistemas[indexPath.row], sistemasSeleccionados: newService.sistemas)
        if newService.sistemas.contains(sistemas[indexPath.row].sistemaId) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newService.sistemas.append(sistemas[indexPath.row].sistemaId)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let identifier = sistemas[indexPath.row].sistemaId
        var position: Int = -1
        for index in 0...newService.sistemas.count - 1 {
            if newService.sistemas[index] == identifier {
               position = index
            }
        }
        
        if position != -1 {
            newService.sistemas.remove(at: position)
        }
    }
}

extension AgendaServiceViewController: PickerSelectorProtocol {
    func optionSelected(option: String) {
        if option == "Otro" {
            performSegue(withIdentifier: "FieldIdentifier", sender: 3)
        } else {
            selectorLabel.text = option
            newService.selector = option
        }
    }
}

