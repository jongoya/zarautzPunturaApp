//
//  AddClientViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 01/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class AddClientViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var numeroHistoriaView: UIView!
    @IBOutlet weak var nombreView: UIView!
    @IBOutlet weak var apellidosView: UIView!
    @IBOutlet weak var fechaView: UIView!
    @IBOutlet weak var telefonoView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var direccionView: UIView!
    @IBOutlet weak var profesionView: UIView!
    @IBOutlet weak var dniView: UIView!
    @IBOutlet weak var observacionesView: UIView!
    @IBOutlet weak var addServicioView: UIView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var motivosConsultaView: UIView!
    @IBOutlet weak var antecendentesView: UIView!
    @IBOutlet weak var estadoActualView: UIView!
    @IBOutlet weak var tratamientoView: UIView!
    @IBOutlet weak var alimentacionView: UIView!
    @IBOutlet weak var otrosView: UIView!
    @IBOutlet weak var fichaMedicaView: UIView!
    @IBOutlet weak var firmaView: UIView!
    @IBOutlet weak var edadField: UILabel!
    @IBOutlet weak var edadLabel: UILabel!
    
    @IBOutlet weak var profesionLabel: UILabel!
    @IBOutlet weak var numeroHistoriaLabel: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var apellidosLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var telefonoLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var direccionLabel: UILabel!
    @IBOutlet weak var dniLabel: UILabel!
    @IBOutlet weak var observacionesLabel: UILabel!
    @IBOutlet weak var motivoConsultaLabel: UILabel!
    @IBOutlet weak var tratamientoLabel: UILabel!
    @IBOutlet weak var alimentacionLabel: UILabel!
    @IBOutlet weak var otrosLabel: UILabel!
    @IBOutlet weak var firmaLabel: UILabel!
    
    @IBOutlet weak var profesionField: UILabel!
    @IBOutlet weak var numeroHistoriaField: UILabel!
    @IBOutlet weak var nombreField: UILabel!
    @IBOutlet weak var apellidosField: UILabel!
    @IBOutlet weak var fechaField: UILabel!
    @IBOutlet weak var telefonoField: UILabel!
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var direccionField: UILabel!
    @IBOutlet weak var dniField: UILabel!
    @IBOutlet weak var informacionField: UILabel!
    @IBOutlet weak var plusButtonField: UILabel!
    @IBOutlet weak var fichaMedicaField: UILabel!
    @IBOutlet weak var motivosConsultaField: UILabel!
    @IBOutlet weak var antecedentesField: UILabel!
    @IBOutlet weak var estadoActualField: UILabel!
    @IBOutlet weak var tratamientoField: UILabel!
    @IBOutlet weak var alimentacionField: UILabel!
    @IBOutlet weak var otrosField: UILabel!
    
    @IBOutlet weak var profesionArrow: UIImageView!
    @IBOutlet weak var numeroHistoriaArrow: UIImageView!
    @IBOutlet weak var nombreArrow: UIImageView!
    @IBOutlet weak var apellidosArrow: UIImageView!
    @IBOutlet weak var fechaArrow: UIImageView!
    @IBOutlet weak var telefonoArrow: UIImageView!
    @IBOutlet weak var emailArrow: UIImageView!
    @IBOutlet weak var dirrecionArrow: UIImageView!
    @IBOutlet weak var dniArrow: UIImageView!
    @IBOutlet weak var plusButtonImage: UIImageView!
    @IBOutlet weak var motivosConsultaArrow: UIImageView!
    @IBOutlet weak var antecedentesArrow: UIImageView!
    @IBOutlet weak var estadoActualArrow: UIImageView!
    
    @IBOutlet weak var addServicioTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var clientImageView: UIImageView!
    @IBOutlet weak var clientImageContainer: UIView!
    @IBOutlet weak var tratamientoArrow: UIImageView!
    @IBOutlet weak var alimentacionArrow: UIImageView!
    @IBOutlet weak var otrosArrow: UIImageView!
    @IBOutlet weak var firmaArrow: UIImageView!
    @IBOutlet weak var firmaCheck: UIImageView!
    
    var newClient: ClientModel = ClientModel()
    var servicios: [ServiceModel] = []
    var addServicioPreviousView: UIView!
    var delegate: AddClientProtocol!
    var isTakingClientPhoto: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonFunctions.customizeButton(button: addServicioView)
        customizeScrollView()
        customizePlaceholder()
        customizeLabels()
        customizeFields()
        customizeArrows()
        customizePlusButton()
        title = "Añadir Paciente"
        addServicioPreviousView = firmaView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if delegate != nil {
            addServicioView.isHidden = true
        }
    }
    
    func customizePlaceholder() {
        clientImageView.image = UIImage(named: "add_image")?.withRenderingMode(.alwaysTemplate)
        clientImageView.tintColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeImageView() {
        clientImageView.layer.cornerRadius = 75
    }
    
    func customizeScrollView() {
        scrollView.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func customizeLabels() {
        numeroHistoriaLabel.textColor = AppStyle.getSecondaryTextColor()
        profesionLabel.textColor = AppStyle.getSecondaryTextColor()
        nombreLabel.textColor = AppStyle.getSecondaryTextColor()
        apellidosLabel.textColor = AppStyle.getSecondaryTextColor()
        fechaLabel.textColor = AppStyle.getSecondaryTextColor()
        telefonoLabel.textColor = AppStyle.getSecondaryTextColor()
        emailLabel.textColor = AppStyle.getSecondaryTextColor()
        direccionLabel.textColor = AppStyle.getSecondaryTextColor()
        dniLabel.textColor = AppStyle.getSecondaryTextColor()
        observacionesLabel.textColor = AppStyle.getPrimaryTextColor()
        motivoConsultaLabel.textColor = AppStyle.getSecondaryTextColor()
        tratamientoLabel.textColor = AppStyle.getSecondaryTextColor()
        alimentacionLabel.textColor = AppStyle.getSecondaryTextColor()
        otrosLabel.textColor = AppStyle.getSecondaryTextColor()
        edadLabel.textColor = AppStyle.getSecondaryTextColor()
    }
    
    func customizeFields() {
        informacionField.textColor = AppStyle.getPrimaryTextColor()
        nombreField.textColor = AppStyle.getPrimaryTextColor()
        apellidosField.textColor = AppStyle.getPrimaryTextColor()
        fechaField.textColor = AppStyle.getPrimaryTextColor()
        telefonoField.textColor = AppStyle.getPrimaryTextColor()
        emailField.textColor = AppStyle.getPrimaryTextColor()
        direccionField.textColor = AppStyle.getPrimaryTextColor()
        dniField.textColor = AppStyle.getPrimaryTextColor()
        numeroHistoriaField.textColor = AppStyle.getPrimaryTextColor()
        profesionField.textColor = AppStyle.getPrimaryTextColor()
        fichaMedicaField.textColor = AppStyle.getPrimaryTextColor()
        motivosConsultaField.textColor = AppStyle.getPrimaryTextColor()
        antecedentesField.textColor = AppStyle.getPrimaryTextColor()
        estadoActualField.textColor = AppStyle.getPrimaryTextColor()
        tratamientoField.textColor = AppStyle.getPrimaryTextColor()
        alimentacionField.textColor = AppStyle.getPrimaryTextColor()
        otrosField.textColor = AppStyle.getPrimaryTextColor()
        firmaLabel.textColor = AppStyle.getPrimaryTextColor()
        edadField.textColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeArrows() {
        if #available(iOS 13.0, *) {
            nombreArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            apellidosArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            fechaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            telefonoArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            emailArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            dirrecionArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            dniArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            profesionArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            numeroHistoriaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            firmaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            motivosConsultaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            antecedentesArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            estadoActualArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            tratamientoArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            alimentacionArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            otrosArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        } else {
            nombreArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            apellidosArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            fechaArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            telefonoArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            emailArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            dirrecionArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            dniArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            profesionArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            numeroHistoriaArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            firmaArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            motivosConsultaArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            antecedentesArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            estadoActualArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            tratamientoArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            alimentacionArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            otrosArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
        }
        nombreArrow.tintColor = AppStyle.getSecondaryColor()
        apellidosArrow.tintColor = AppStyle.getSecondaryColor()
        fechaArrow.tintColor = AppStyle.getSecondaryColor()
        telefonoArrow.tintColor = AppStyle.getSecondaryColor()
        emailArrow.tintColor = AppStyle.getSecondaryColor()
        dirrecionArrow.tintColor = AppStyle.getSecondaryColor()
        dniArrow.tintColor = AppStyle.getSecondaryColor()
        numeroHistoriaArrow.tintColor = AppStyle.getSecondaryColor()
        profesionArrow.tintColor = AppStyle.getSecondaryColor()
        motivosConsultaArrow.tintColor = AppStyle.getSecondaryColor()
        antecedentesArrow.tintColor = AppStyle.getSecondaryColor()
        estadoActualArrow.tintColor = AppStyle.getSecondaryColor()
        tratamientoArrow.tintColor = AppStyle.getSecondaryColor()
        alimentacionArrow.tintColor = AppStyle.getSecondaryColor()
        otrosArrow.tintColor = AppStyle.getSecondaryColor()
        firmaArrow.tintColor = AppStyle.getSecondaryColor()
    }
    
    func customizePlusButton() {
        if #available(iOS 13.0, *) {
            plusButtonImage.image = UIImage(systemName: "plus")!.withRenderingMode(.alwaysTemplate)
        } else {
            plusButtonImage.image = UIImage(named: "plus")!.withRenderingMode(.alwaysTemplate)
        }
        plusButtonImage.tintColor = AppStyle.getPrimaryColor()
        plusButtonField.textColor = AppStyle.getPrimaryColor()
    }
    
    func showServicio(servicio: ServiceModel) {
        let view: ServicioView = ServicioView(service: servicio, client: newClient, cesta: nil)
        scrollContentView.addSubview(view)
        view.topAnchor.constraint(equalTo: addServicioPreviousView.bottomAnchor, constant: 30).isActive = true
        view.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 15).isActive = true
        view.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -15).isActive = true
        addServicioPreviousView = view
        
        addServicioTopConstraint = addServicioView.topAnchor.constraint(equalTo: addServicioPreviousView.bottomAnchor, constant: 30)
        addServicioTopConstraint.isActive = true
        addServicioView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -20).isActive = true
    }
    
    func checkFields() {
        if nombreLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir el nombre del paciente", viewController: self)
            return
        }
        
        if apellidosLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir por lo menos un apellido del paciente", viewController: self)
            return
        }
        
        if telefonoLabel.text!.count < 9 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir un número de contacto válido", viewController: self)
            return
        }
        
        saveClient()
    }
    
    func saveClient() {
        CommonFunctions.showLoadingStateView(descriptionText: "Guardando paciente")
        WebServices.addClient(model: ClientMasServicios(cliente: newClient, servicios: servicios), delegate: self)
    }
    
    func openAntecedentesViewController() {
        let showItemStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: AntecedentesViewController = showItemStoryboard.instantiateViewController(withIdentifier: "antecedentes") as! AntecedentesViewController
        controller.delegate = self
        controller.cliente = newClient
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func openEstadoActualViewController() {
        let showItemStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: EstadoActualViewController = showItemStoryboard.instantiateViewController(withIdentifier: "estadoActual") as! EstadoActualViewController
        controller.delegate = self
        controller.cliente = newClient
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func showFirmaAlertMessage() {
        let alert = UIAlertController(title: "Aviso", message: "Ya existe una firma ¿Que desea hacer?", preferredStyle: UIAlertController.Style.alert)
    
        alert.addAction(UIAlertAction(title: "Visualizar", style: UIAlertAction.Style.default, handler: { action in
            self.openFirmaViewController()
        }))
        alert.addAction(UIAlertAction(title: "Reemplazar", style: UIAlertAction.Style.cancel, handler: { action in
            self.openCameraViewController()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openFirmaViewController() {
        let showItemStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: ImageViewController = showItemStoryboard.instantiateViewController(withIdentifier: "Image") as! ImageViewController
        controller.imageString = newClient.firma
        self.navigationController!.pushViewController(controller, animated: true)
    }
}

extension AddClientViewController {
    @IBAction func didClickAñadirServicioButton(_ sender: Any) {
        if newClient.nombre.count == 0 || newClient.apellidos.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir al menos el nombre y apellidos del paciente", viewController: self)
            return
        }
        
        performSegue(withIdentifier: "AddServicioIdentifier", sender: nil)
    }
    
    @IBAction func didClickNumeroHistoria(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 1)
    }
    
    @IBAction func didClickNombreField(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 2)
    }
    
    @IBAction func didClickApellidosField(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 3)
    }
    
    @IBAction func didClickFechaField(_ sender: Any) {
        performSegue(withIdentifier: "DatePickerSelectorIdentifier", sender: nil)
    }
    
    @IBAction func didClickDireccionField(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 4)
    }
    
    @IBAction func didClickProfesionField(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 5)
    }
    
    @IBAction func didClickTelefonoField(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 6)
    }
    
    @IBAction func didClickEmailField(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 7)
    }
    
    @IBAction func didClickDni(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 8)
    }
    
    @IBAction func didClickObservacionesField(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 9)
    }
    
    @IBAction func didClickMotivosConsulta(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 10)
    }
    
    @IBAction func didClickAntecedentes(_ sender: Any) {
        openAntecedentesViewController()
    }
    
    @IBAction func didClickEstadoActual(_ sender: Any) {
        openEstadoActualViewController()
    }
    
    @IBAction func didClickTratamiento(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 11)
    }
    
    @IBAction func didClickAlimentacion(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 12)
    }
    
    @IBAction func didClickOtros(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 13)
    }
    
    @IBAction func didClickSaveClient(_ sender: Any) {
        checkFields()
    }
    
    @IBAction func didClickClientImage(_ sender: Any) {
        isTakingClientPhoto = true
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func didClickFirma(_ sender: Any) {
        if newClient.firma.count == 0 {
            openCameraViewController()
        } else {
            showFirmaAlertMessage()
        }
    }
    
    func openCameraViewController() {
        isTakingClientPhoto = false
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
}

extension AddClientViewController: AddClientInputFieldProtocol {
    func textSaved(text: String, inputReference: Int) {
        switch inputReference {
        case 1:
            newClient.numeroHistoria = Int64(text) ?? 0
            numeroHistoriaLabel.text = text
            break
        case 2:
            newClient.nombre = text
            nombreLabel.text = text
            break
        case 3:
            newClient.apellidos = text
            apellidosLabel.text = text
            break
        case 4:
            newClient.direccion = text
            direccionLabel.text = text
            break
        case 5:
            newClient.profesion = text
            profesionLabel.text = text
            break
        case 6:
            newClient.telefono = text
            telefonoLabel.text = text
            break
        case 7:
            newClient.email = text
            emailLabel.text = text
            break
        case 8:
            newClient.dni = text
            dniLabel.text = text
            break
        case 9:
            newClient.observaciones = text
            observacionesLabel.text = text
            observacionesLabel.textColor = .red
            if newClient.alergias.contains("ª") {
                let fullNameArr = newClient.alergias.split{$0 == "ª"}.map(String.init)
                if fullNameArr.count > 0 && newClient.alergias.firstIndex(of: "ª")?.encodedOffset != 0 {
                    var textAlergias = text + "ª"
                    if fullNameArr.count > 1 {
                        textAlergias.append(fullNameArr[1])
                    }
                    
                    newClient.alergias = textAlergias
                }
            } else {
                newClient.alergias = text + "ª"
            }
            break
        case 10:
            newClient.motivoConsulta = text
            motivoConsultaLabel.text = text
            break
        case 11:
            newClient.tratamiento = text
            tratamientoLabel.text = text
            break
        case 12:
            newClient.alimentacion = text
            alimentacionLabel.text = text
            break
        case 13:
            newClient.otros = text
            otrosLabel.text = text
            break
        default:
            break
        }
    }
}

extension AddClientViewController: DatePickerSelectorProtocol {
    func dateSelected(date: Date) {
        newClient.fecha = Int64(date.timeIntervalSince1970)
        fechaLabel.text = CommonFunctions.getTimeTypeStringFromDate(date: date)
        edadLabel.text = String(CommonFunctions.getYearsFromToday(fromDate: Int64(date.timeIntervalSince1970)))
    }
}

extension AddClientViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FieldIdentifier" {
            let controller: FieldViewController = segue.destination as! FieldViewController
            controller.inputReference = (sender as! Int)
            controller.delegate = self
            controller.keyboardType = getKeyboardTypeForField(inputReference: (sender as! Int))
            controller.inputText = getInputTextForField(inputReference: (sender as! Int))
            controller.title = getControllerTitleForField(inputReference: (sender as! Int))
        } else if segue.identifier == "DatePickerSelectorIdentifier" {
            let controller: DatePickerSelectorViewController = segue.destination as! DatePickerSelectorViewController
            controller.delegate = self
            controller.datePickerMode = .date
            controller.initialDate = newClient.fecha
        } else if segue.identifier == "AddServicioIdentifier" {
            let controller: AddServicioViewController = segue.destination as! AddServicioViewController
            controller.client = newClient
            controller.delegate = self
        }
    }
    
    func getKeyboardTypeForField(inputReference: Int) -> UIKeyboardType {
        switch inputReference {
        case 1:
            return .decimalPad
        case 6:
            return .phonePad
        case 7:
            return .emailAddress
        default:
            return .default
        }
    }
    
    func getInputTextForField(inputReference: Int) -> String {
        switch inputReference {
        case 1:
            return numeroHistoriaLabel.text!
        case 2:
            return nombreLabel.text!
        case 3:
            return apellidosLabel.text!
        case 4:
            return direccionLabel.text!
        case 5:
            return profesionLabel.text!
        case 6:
            return telefonoLabel.text!
        case 7:
            return emailLabel.text!
        case 8:
            return dniLabel.text!
        case 9:
            return newClient.observaciones
        case 10:
            return motivoConsultaLabel.text!
        case 11:
            return tratamientoLabel.text!
        case 12:
            return alimentacionLabel.text!
        case 13:
            return otrosLabel.text!
        default:
            return ""
        }
    }
    
    func getControllerTitleForField(inputReference: Int) -> String {
        switch inputReference {
        case 1:
            return "Numero historia"
        case 2:
            return "Nombre"
        case 3:
            return "Apellidos"
        case 4:
            return "Dirección"
        case 5:
            return "Profesión"
        case 6:
            return "Teléfono"
        case 7:
            return "Email"
        case 8:
            return "Dni"
        case 9:
            return "Observaciones"
        case 10:
            return "Motivo Consulta"
        case 11:
            return "Tratamiento actual"
        case 12:
            return "Alimentación"
        case 13:
            return "Otros"
        default:
            return ""
        }
    }
}

extension AddClientViewController: AddServicioProtocol {
    func serviceContentFilled(service: ServiceModel, serviceUpdated: Bool) {
        service.serviceId = Int64(Date().timeIntervalSince1970)
        servicios.append(service)
        addServicioTopConstraint.isActive = false
        showServicio(servicio: service)
    }
}

extension AddClientViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if isTakingClientPhoto {
            customizeImageView()
            let image = info[.originalImage] as! UIImage
            let resizedImage = CommonFunctions.resizeImage(image: image, targetSize: CGSize(width: 150, height: 150))
            self.clientImageView.image = resizedImage
            let imageData: Data = resizedImage.pngData()!
            let imageString: String = imageData.base64EncodedString()
            newClient.imagen = imageString
        } else {
            let image = info[.originalImage] as! UIImage
            let resizedImage = CommonFunctions.resizeImage(image: image, targetSize: CGSize(width: 500, height: 500))
            let imageData: Data = resizedImage.pngData()!
            let imageString: String = imageData.base64EncodedString()
            newClient.firma = imageString
            firmaCheck.isHidden = false
        }
    }
}

extension AddClientViewController: AddClientAndServicesProtocol {
    func logoutResponse() {
        CommonFunctions.showLogoutAlert(viewController: self)
    }
    
    func succesSavingClient(model: ClientMasServicios) {
        Constants.databaseManager.clientsManager.addClientToDatabase(newClient: model.cliente)
        for servicio: ServiceModel in model.servicios {
            Constants.databaseManager.servicesManager.addServiceInDatabase(newService: servicio)
        }
        
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            if self.delegate != nil {//Add paciente en la agenda
                self.delegate.clientAdded(client: model.cliente)
            }
            
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    func errorSavignClient() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error guardando paciente", viewController: self)
        }
    }
}

extension AddClientViewController: AntecedentesProtocol {
    func antecedentesUpdated(client: ClientModel) {
        newClient = client
    }
}

extension AddClientViewController: EstadoActualProtocol {
    func estadoActualUpdated(client: ClientModel) {
        newClient = client
    }
}
