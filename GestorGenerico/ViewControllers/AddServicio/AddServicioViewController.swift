//
//  AddServicioViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 02/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class AddServicioViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var servicioLabel: UILabel!
    @IBOutlet weak var observacionLabel: UILabel!
    @IBOutlet weak var efectivoSwitch: UISwitch!
    @IBOutlet weak var sistemasTableView: UITableView!
    @IBOutlet weak var selectorField: UILabel!
    @IBOutlet weak var selectorArrow: UIImageView!
    @IBOutlet weak var selectorLabel: UILabel!
    @IBOutlet weak var titulo2: UILabel!
    @IBOutlet weak var campo1Field: UILabel!
    @IBOutlet weak var campo1Arrow: UIImageView!
    @IBOutlet weak var campo1Label: UILabel!
    @IBOutlet weak var campo2Field: UILabel!
    @IBOutlet weak var campo2Arrow: UIImageView!
    @IBOutlet weak var campo2Label: UILabel!
    @IBOutlet weak var titulo3: UILabel!
    @IBOutlet weak var plantillaImagen2: UIImageView!
    @IBOutlet weak var titulo4: UILabel!
    @IBOutlet weak var tituloField: UILabel!
    @IBOutlet weak var nombreField: UILabel!
    @IBOutlet weak var fechaField: UILabel!
    @IBOutlet weak var servicioField: UILabel!
    @IBOutlet weak var efectivoField: UILabel!
    @IBOutlet weak var plantillaImagen: UIImageView!
    @IBOutlet weak var fechaArrow: UIImageView!
    @IBOutlet weak var servicioArrow: UIImageView!
    @IBOutlet weak var chatButton: UIBarButtonItem!
    
    var client: ClientModel!
    var service: ServiceModel = ServiceModel()
    var modifyService: Bool = false
    var delegate: AddServicioProtocol!
    var modificacionHecha: Bool = false
    var sistemas: [SistemaModel] = []
    var numCabinasDisponibles: Int = 0
    var empleadosDisponibles: [EmpleadoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title =  modifyService ? "Tratamiento" : "Nuevo Tratamiento"
        efectivoSwitch.addTarget(self, action: #selector(switchClicked), for: UIControl.Event.valueChanged)
        customizeScrollView()
        customizeFields()
        customizeLabels()
        customizeArrows()
        customizeSwitch()
        addBackButton()
        setMainValues()
        setSistemasTable()
        
        if !modifyService {
            chatButton.isEnabled = false
            chatButton.tintColor = .clear
        }
    }
    
    func customizeLabels() {
        nombreLabel.textColor = AppStyle.getSecondaryTextColor()
        fechaLabel.textColor = AppStyle.getSecondaryTextColor()
        servicioLabel.textColor = AppStyle.getSecondaryTextColor()
        selectorLabel.textColor = AppStyle.getSecondaryTextColor()
        campo1Label.textColor = AppStyle.getSecondaryTextColor()
        campo2Label.textColor = AppStyle.getSecondaryTextColor()
    }
    
    func customizeFields() {
        tituloField.textColor = AppStyle.getPrimaryTextColor()
        nombreField.textColor = AppStyle.getPrimaryTextColor()
        fechaField.textColor = AppStyle.getPrimaryTextColor()
        servicioField.textColor = AppStyle.getPrimaryTextColor()
        efectivoField.textColor = AppStyle.getPrimaryTextColor()
        titulo2.textColor = AppStyle.getPrimaryTextColor()
        titulo3.textColor = AppStyle.getPrimaryTextColor()
        titulo4.textColor = AppStyle.getPrimaryTextColor()
        selectorField.textColor = AppStyle.getPrimaryTextColor()
        campo1Field.textColor = AppStyle.getPrimaryTextColor()
        campo2Field.textColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeArrows() {
        if #available(iOS 13.0, *) {
            fechaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            servicioArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            selectorArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            campo1Arrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            campo2Arrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        } else {
            fechaArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            servicioArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            selectorArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            campo1Arrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            campo2Arrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
        }
        fechaArrow.tintColor = AppStyle.getSecondaryColor()
        servicioArrow.tintColor = AppStyle.getSecondaryColor()
        selectorArrow.tintColor = AppStyle.getSecondaryColor()
        campo1Arrow.tintColor = AppStyle.getSecondaryColor()
        campo2Arrow.tintColor = AppStyle.getSecondaryColor()
    }
    
    func customizeSwitch() {
        efectivoSwitch.onTintColor = AppStyle.getPrimaryColor()
    }
    
    func customizeScrollView() {
        scrollView.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func setMainValues() {
        nombreLabel.text = client.nombre + " " + client.apellidos
        
        if modifyService {
            setAllFields()
        }
    }
    
    func setAllFields() {
        fechaLabel.text = CommonFunctions.getDateAndTimeTypeStringFromDate(date: Date(timeIntervalSince1970: TimeInterval(service.fecha)))
        servicioLabel.text = CommonFunctions.getServiciosStringFromServiciosArray(servicios: service.servicios)
        observacionLabel.text = service.observaciones
        selectorLabel.text = service.selector
        campo1Label.text = service.meridianos
        campo2Label.text = service.equilibrio
        if service.observaciones.count == 0 {
            observacionLabel.text = "Añade una observación"
        }
        
        if service.isEfectivo {
            efectivoSwitch.isOn = true
        }
        
        if service.imgPlantilla.count > 0 {
            let dataDecoded : Data = Data(base64Encoded: service.imgPlantilla, options: .ignoreUnknownCharacters)!
            plantillaImagen.image =  UIImage(data: dataDecoded)
        }
        
        if service.imgPlantilla2.count > 0 {
            let dataDecoded : Data = Data(base64Encoded: service.imgPlantilla2, options: .ignoreUnknownCharacters)!
            plantillaImagen2.image =  UIImage(data: dataDecoded)
        }
    }
    
    func getServicesArray() -> [Any] {
        if numCabinasDisponibles == 0 {
            return CommonFunctions.getServiceList()
        } else {
            return CommonFunctions.getServiciosDisponibles(numCabinasDisponibles: numCabinasDisponibles, empleados: empleadosDisponibles, empleadoSeleccionado: service.empleadoId)
        }
    }
    
    func checkFields() {
        if fechaLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir una fecha", viewController: self)
            return
        }
        
        if servicioLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe seleccionar un tipo de tratamiento", viewController: self)
            return
        }
        
        if client.id != 0 {
            if !modifyService {
                saveService()
            } else {
                updateService()
            }
        } else {
            delegate.serviceContentFilled(service: service, serviceUpdated: modifyService)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func saveService() {
        CommonFunctions.showLoadingStateView(descriptionText: "Guardando tratamiento")
        service.clientId = client.id
        WebServices.addService(service: service, delegate: self)
    }
    
    func updateService() {
        CommonFunctions.showLoadingStateView(descriptionText: "Actualizando tratameinto")
        WebServices.updateService(service: service, delegate: self)
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
    
    func addBackButton() {
        if #available(iOS 13.0, *) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(didClickBackButton))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.left"), style: .done, target: self, action: #selector(didClickBackButton))
        }
    }
    
    func getTitleForInputReference(inputReference: Int) -> String {
        switch inputReference {
        case 0:
            return "Observaciones"
        case 1:
            return "Meridianos"
        case 3:
            return "Otro"
        default:
            return "Equilibrios"
        }
    }
    
    func getValueForInputReference(inputReference: Int) -> String {
        switch inputReference {
        case 0:
            return service.observaciones
        case 1:
            return service.meridianos
        case 3:
            if service.selector != "Global Balance" && service.selector != "Local Balance" {
                return service.selector
            }
            
            return ""
        default:
            return service.equilibrio
        }
    }
    
    func returnToPreviousScreen() {
        CommonFunctions.hideLoadingStateView()
        self.delegate.serviceContentFilled(service: self.service, serviceUpdated: self.modifyService)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setSistemasTable() {
        sistemasTableView.backgroundColor = AppStyle.getBackgroundColor()
        sistemasTableView.allowsMultipleSelection = true
        sistemas = Constants.databaseManager.sistemaManager.getAllSistemas()
        sistemasTableView.reloadData()
    }
}

extension AddServicioViewController {
    @IBAction func didClickFechaButton(_ sender: Any) {
        performSegue(withIdentifier: "DatePickerSelectorIdentifier", sender: nil)
    }
    
    @IBAction func didClickServicioButton(_ sender: Any) {
        performSegue(withIdentifier: "ListSelectorIdentifier", sender: nil)
    }
    
    @IBAction func didClickObservacion(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 0)
    }
    
    @IBAction func didClickSaveButton(_ sender: Any) {
        checkFields()
    }
    
    @objc func didClickBackButton(sender: UIBarButtonItem) {
        if modifyService {
            if !modificacionHecha {
                self.navigationController?.popViewController(animated: true)
            } else {
                showChangesAlertMessage()
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func switchClicked(mySwitch: UISwitch) {
        service.isEfectivo = efectivoSwitch.isOn
    }
    
    @IBAction func didClickCuerpoHumano(_ sender: Any) {
        performSegue(withIdentifier: "plantillaSegue", sender: 1)
    }
    
    @IBAction func didClickSelector(_ sender: Any) {
        performSegue(withIdentifier: "PickerSelector", sender: nil)
    }
    
    @IBAction func didClickCampo1(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 1)
    }
    
    @IBAction func didClickCampo2(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 2)
    }
    
    @IBAction func didClickImagen2(_ sender: Any) {
        performSegue(withIdentifier: "plantillaSegue", sender: 2)
    }
    
    @IBAction func didClickChatButton(_ sender: Any) {
        let telefono: String = client.telefono.replacingOccurrences(of: " ", with: "")
        CommonFunctions.openWhatsapp(telefono: telefono)
    }
}

extension AddServicioViewController: DatePickerSelectorProtocol {
    func dateSelected(date: Date) {
        modificacionHecha = true
        service.fecha = Int64(date.timeIntervalSince1970)
        fechaLabel.text = CommonFunctions.getDateAndTimeTypeStringFromDate(date: date)
    }
}

extension AddServicioViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DatePickerSelectorIdentifier" {
            let controller: DatePickerSelectorViewController = segue.destination as! DatePickerSelectorViewController
            controller.delegate = self
            controller.datePickerMode = .dateAndTime
            controller.initialDate = service.fecha
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
            controller.listOptions = getServicesArray()
            controller.allowMultiselection = false
        } else if segue.identifier == "plantillaSegue" {
            let controller: PlantillaViewController = segue.destination as! PlantillaViewController
            let reference: Int = sender as! Int
            controller.delegate = self
            controller.screenOrientation = CommonFunctions.getDeviceOrientation()
            if reference == 1 {
                controller.imgPlantilla = service.imgPlantilla
            } else {
                controller.imgPlantilla = service.imgPlantilla2
            }
            controller.plantillaReference = reference
        } else if segue.identifier == "PickerSelector" {
            let controller: PickerSelectorViewController = segue.destination as! PickerSelectorViewController
            controller.delegate = self
            controller.options = ["Global Balance", "Local Balance", "Otro"]
        }
    }
}

extension AddServicioViewController: AddClientInputFieldProtocol {
    func textSaved(text: String, inputReference: Int) {
        modificacionHecha = true
        switch inputReference {
        case 0:
            service.observaciones = text
            observacionLabel.text = text
            break
        case 1:
            service.meridianos = text
            campo1Label.text = text
            break
        case 3:
            service.selector = text
            selectorLabel.text = text
            return
        default:
            service.equilibrio = text
            campo2Label.text = text
            break
        }
    }
}

extension AddServicioViewController: ListSelectorProtocol {
    func multiSelectionOptionsSelected(options: [Any], inputReference: Int) {
        //este metodo no es necesario
    }
    
    func optionSelected(option: Any, inputReference: Int) {
        modificacionHecha = true
        let servicio: TipoServicioModel = (option as! TipoServicioModel)
        service.servicios = [servicio.servicioId]
        servicioLabel.text = servicio.nombre
        service.empleadoId = servicio.terapeuta
    }
}

extension AddServicioViewController: AddNuevoServicioProtocol {
    func logoutResponse() {
        CommonFunctions.showLogoutAlert(viewController: self)
    }
    
    func successSavingService(servicio: ServiceModel) {
        Constants.databaseManager.servicesManager.addServiceInDatabase(newService: servicio)
        
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            self.returnToPreviousScreen()
        }
    }
    
    func errorSavingServicio() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error Guardando el tratamiento", viewController: self)
        }
    }
}

extension AddServicioViewController: UpdateServicioProtocol {
    func successUpdatingService(service: ServiceModel) {
        Constants.databaseManager.servicesManager.updateServiceInDatabase(service: service)
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            self.returnToPreviousScreen()
        }
    }
    
    func errorUpdatingService() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error Actualizando el tratamiento", viewController: self)
        }
    }
}

extension AddServicioViewController: PlantillaProtocol {
    func imageDrawed(imageString: String, reference: Int) {
        let dataDecoded : Data = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters)!
        if reference == 1 {
            plantillaImagen.image =  UIImage(data: dataDecoded)
            service.imgPlantilla = imageString
        } else if reference == 2 {
            plantillaImagen2.image =  UIImage(data: dataDecoded)
            service.imgPlantilla2 = imageString
        }
    }
}

extension AddServicioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sistemas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SistemasTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SistemasTableViewCell") as! SistemasTableViewCell
        cell.setupCell(sistema: sistemas[indexPath.row], sistemasSeleccionados: service.sistemas)
        if service.sistemas.contains(sistemas[indexPath.row].sistemaId) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        service.sistemas.append(sistemas[indexPath.row].sistemaId)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let identifier = sistemas[indexPath.row].sistemaId
        var position: Int = -1
        for index in 0...service.sistemas.count - 1 {
            if service.sistemas[index] == identifier {
               position = index
            }
        }
        
        if position != -1 {
            service.sistemas.remove(at: position)
        }
    }
}

extension AddServicioViewController: PickerSelectorProtocol {
    func optionSelected(option: String) {
        if option == "Otro" {
            performSegue(withIdentifier: "FieldIdentifier", sender: 3)
        } else {
            selectorLabel.text = option
            service.selector = option
        }
    }
}

