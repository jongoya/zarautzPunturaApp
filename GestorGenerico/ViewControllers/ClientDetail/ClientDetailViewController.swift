//
//  EditClientViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 02/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import RMDateSelectionViewController

class ClientDetailViewController: UIViewController {
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var apellidosLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var telefonoLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var direccionLabel: UILabel!
    @IBOutlet weak var dniLabel: UILabel!
    @IBOutlet weak var observacionesLabel: UILabel!
    @IBOutlet weak var srollView: UIScrollView!
    @IBOutlet weak var observacionesView: UIView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var addServicioView: UIView!
    @IBOutlet weak var clientImageView: UIImageView!
    @IBOutlet weak var plusImage: UIImageView!
    @IBOutlet weak var numeroHistoriaField: UILabel!
    @IBOutlet weak var numeroHistoriaLabel: UILabel!
    @IBOutlet weak var numeroHistoriaArrow: UIImageView!
    @IBOutlet weak var profesionField: UILabel!
    @IBOutlet weak var profesionLabel: UILabel!
    @IBOutlet weak var profesionArrow: UIImageView!
    @IBOutlet weak var informacionField: UILabel!
    @IBOutlet weak var nombreField: UILabel!
    @IBOutlet weak var apellidosField: UILabel!
    @IBOutlet weak var fechaField: UILabel!
    @IBOutlet weak var telefonoField: UILabel!
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var direccionField: UILabel!
    @IBOutlet weak var dniField: UILabel!
    @IBOutlet weak var addServicioField: UILabel!
    @IBOutlet weak var nombreArrow: UIImageView!
    @IBOutlet weak var apellidosArrow: UIImageView!
    @IBOutlet weak var fechaArrow: UIImageView!
    @IBOutlet weak var telefonoArrow: UIImageView!
    @IBOutlet weak var emailArrow: UIImageView!
    @IBOutlet weak var direccionArrow: UIImageView!
    @IBOutlet weak var dniArrow: UIImageView!
    
    @IBOutlet weak var motivoConsultaField: UILabel!
    @IBOutlet weak var motivoConsultaLabel: UILabel!
    @IBOutlet weak var motivoConsultaArrow: UIImageView!
    @IBOutlet weak var antecedentesField: UILabel!
    @IBOutlet weak var antecedentesArrow: UIImageView!
    @IBOutlet weak var estadoActualField: UILabel!
    @IBOutlet weak var estadoActualArrow: UIImageView!
    @IBOutlet weak var tratamientoField: UILabel!
    @IBOutlet weak var tratamientoLabel: UILabel!
    @IBOutlet weak var tratamientoArrow: UIImageView!
    @IBOutlet weak var alimentacionField: UILabel!
    @IBOutlet weak var alimentacionLabel: UILabel!
    @IBOutlet weak var alimentacionArrow: UIImageView!
    @IBOutlet weak var otrosField: UILabel!
    @IBOutlet weak var otrosLabel: UILabel!
    @IBOutlet weak var otrosArrow: UIImageView!
    @IBOutlet weak var fichaMedicaField: UILabel!
    @IBOutlet weak var firmaField: UILabel!
    @IBOutlet weak var firmaArrow: UIImageView!
    @IBOutlet weak var firmaCheck: UIImageView!
    @IBOutlet weak var edadField: UILabel!
    @IBOutlet weak var edadLabel: UILabel!
    
    var client: ClientModel!
    var services: [ServiceModel] = []
    var cestas: [CestaModel] = []
    var serviceViewsArray: [UIView] = []
    var addServicioButtonBottomAnchor: NSLayoutConstraint!
    var scrollRefreshControl: UIRefreshControl = UIRefreshControl()
    var modificacionHecha: Bool = false
    var isTakingClientPhoto: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLabels()
        customizeFields()
        customizeScrollView()
        customizeArrows()
        customizeAddServiceButton()
        
        title = "Detalle Paciente"
        addBackButton()
        CommonFunctions.customizeButton(button: addServicioView)
        addRefreshControl()
        getClientDetails()
    }
    
    func customizeLabels() {
        nombreLabel.textColor = AppStyle.getSecondaryTextColor()
        apellidosLabel.textColor = AppStyle.getSecondaryTextColor()
        fechaLabel.textColor = AppStyle.getSecondaryTextColor()
        telefonoLabel.textColor = AppStyle.getSecondaryTextColor()
        emailLabel.textColor = AppStyle.getSecondaryTextColor()
        direccionLabel.textColor = AppStyle.getSecondaryTextColor()
        dniLabel.textColor = AppStyle.getSecondaryTextColor()
        numeroHistoriaLabel.textColor = AppStyle.getSecondaryTextColor()
        profesionLabel.textColor = AppStyle.getSecondaryTextColor()
        numeroHistoriaLabel.textColor = AppStyle.getSecondaryTextColor()
        dniLabel.textColor = AppStyle.getSecondaryTextColor()
        motivoConsultaLabel.textColor = AppStyle.getSecondaryTextColor()
        tratamientoLabel.textColor = AppStyle.getSecondaryTextColor()
        alimentacionLabel.textColor = AppStyle.getSecondaryTextColor()
        otrosLabel.textColor = AppStyle.getSecondaryTextColor()
        edadLabel.textColor = AppStyle.getSecondaryTextColor()
    }
    
    func customizeFields() {
        nombreField.textColor = AppStyle.getPrimaryTextColor()
        informacionField.textColor = AppStyle.getPrimaryTextColor()
        apellidosField.textColor = AppStyle.getPrimaryTextColor()
        fechaField.textColor = AppStyle.getPrimaryTextColor()
        telefonoField.textColor = AppStyle.getPrimaryTextColor()
        emailField.textColor = AppStyle.getPrimaryTextColor()
        direccionField.textColor = AppStyle.getPrimaryTextColor()
        dniField.textColor = AppStyle.getPrimaryTextColor()
        observacionesLabel.textColor = AppStyle.getPrimaryTextColor()
        numeroHistoriaField.textColor = AppStyle.getPrimaryTextColor()
        profesionField.textColor = AppStyle.getPrimaryTextColor()
        fichaMedicaField.textColor = AppStyle.getPrimaryTextColor()
        numeroHistoriaField.textColor = AppStyle.getPrimaryTextColor()
        dniField.textColor = AppStyle.getPrimaryTextColor()
        motivoConsultaField.textColor = AppStyle.getPrimaryTextColor()
        antecedentesField.textColor = AppStyle.getPrimaryTextColor()
        estadoActualField.textColor = AppStyle.getPrimaryTextColor()
        tratamientoField.textColor = AppStyle.getPrimaryTextColor()
        alimentacionField.textColor = AppStyle.getPrimaryTextColor()
        otrosField.textColor = AppStyle.getPrimaryTextColor()
        firmaField.textColor = AppStyle.getPrimaryTextColor()
        edadField.textColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeArrows() {
        if #available(iOS 13.0, *) {
            nombreArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            apellidosArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            fechaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            telefonoArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            emailArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            direccionArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            dniArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            numeroHistoriaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            profesionArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            numeroHistoriaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            dniArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            motivoConsultaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            antecedentesArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            estadoActualArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            tratamientoArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            otrosArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
            firmaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        } else {
            nombreArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            apellidosArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            fechaArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            telefonoArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            emailArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            direccionArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            dniArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            numeroHistoriaArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            profesionArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            numeroHistoriaArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            dniArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            motivoConsultaArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            antecedentesArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            estadoActualArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            tratamientoArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            otrosArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
            firmaArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
        }
        nombreArrow.tintColor = AppStyle.getSecondaryColor()
        apellidosArrow.tintColor = AppStyle.getSecondaryColor()
        fechaArrow.tintColor = AppStyle.getSecondaryColor()
        telefonoArrow.tintColor = AppStyle.getSecondaryColor()
        emailArrow.tintColor = AppStyle.getSecondaryColor()
        direccionArrow.tintColor = AppStyle.getSecondaryColor()
        dniArrow.tintColor = AppStyle.getSecondaryColor()
        numeroHistoriaArrow.tintColor = AppStyle.getSecondaryColor()
        profesionArrow.tintColor = AppStyle.getSecondaryColor()
        numeroHistoriaArrow.tintColor = AppStyle.getSecondaryColor()
        dniArrow.tintColor = AppStyle.getSecondaryColor()
        motivoConsultaArrow.tintColor = AppStyle.getSecondaryColor()
        antecedentesArrow.tintColor = AppStyle.getSecondaryColor()
        estadoActualArrow.tintColor = AppStyle.getSecondaryColor()
        tratamientoArrow.tintColor = AppStyle.getSecondaryColor()
        alimentacionArrow.tintColor = AppStyle.getSecondaryColor()
        otrosArrow.tintColor = AppStyle.getSecondaryColor()
        firmaArrow.tintColor = AppStyle.getSecondaryColor()
    }
    
    func customizeAddServiceButton() {
        if #available(iOS 13.0, *) {
            plusImage.image = UIImage(systemName: "plus")!.withRenderingMode(.alwaysTemplate)
        } else {
            plusImage.image = UIImage(named: "plus")!.withRenderingMode(.alwaysTemplate)
        }
        plusImage.tintColor = AppStyle.getPrimaryColor()
        addServicioField.textColor = AppStyle.getPrimaryColor()
    }
    
    func customizeScrollView() {
        srollView.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func getClientDetails() {
        services = Constants.databaseManager.servicesManager.getServicesForClientId(clientId: client.id)
        cestas = Constants.databaseManager.cestaManager.getCestasForClientId(clientId: client.id)
        sortServicesByDate()
        sortCestasByDate()
        
        setFields()
        showServices()
    }
    
    func setFields() {
        nombreLabel.text = client.nombre
        apellidosLabel.text = client.apellidos
        fechaLabel.text = CommonFunctions.getTimeTypeStringFromDate(date: Date(timeIntervalSince1970: TimeInterval(client.fecha)))
        telefonoLabel.text = client.telefono
        emailLabel.text = client.email
        direccionLabel.text = client.direccion
        dniLabel.text = client.dni
        observacionesLabel.text = client.observaciones
        numeroHistoriaLabel.text = String(client.numeroHistoria)
        profesionLabel.text = client.profesion
        motivoConsultaLabel.text = client.motivoConsulta
        tratamientoLabel.text = client.tratamiento
        alimentacionLabel.text = client.alimentacion
        otrosLabel.text = client.otros
        
        if client.observaciones.count != 0 {
            observacionesLabel.text = client.observaciones
            observacionesLabel.textColor = .red
        } else {
            observacionesLabel.text = "Añade una observación"
        }
        
        if client.imagen.count > 0 {
            let dataDecoded : Data = Data(base64Encoded: client.imagen, options: .ignoreUnknownCharacters)!
            clientImageView.image = UIImage(data: dataDecoded)
            clientImageView.layer.cornerRadius = 75
        } else {
            clientImageView.image = UIImage(named: "add_image")?.withRenderingMode(.alwaysTemplate)
            clientImageView.tintColor = AppStyle.getPrimaryTextColor()
        }
        
        if client.firma.count > 0 {
            firmaCheck.isHidden = false
        }
        
        edadLabel.text = String(CommonFunctions.getYearsFromToday(fromDate: client.fecha))
    }
    
    func showServices() {
        removeServicesViews()
        if services.count == 0  && cestas.count == 0 {
            addServicioButtonBottomAnchor = addServicioView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -20)
            addServicioButtonBottomAnchor.isActive = true
            return
        } else if addServicioButtonBottomAnchor != nil {
            addServicioButtonBottomAnchor.isActive = false
        }
        
        var serviciosFuturos: [ServiceModel] = []
        var serviciosPasados: [ServiceModel] = []
        for service: ServiceModel in services {
            let fecha: Date = Date(timeIntervalSince1970: TimeInterval(service.fecha))
            fecha < Date() ? serviciosPasados.append(service) : serviciosFuturos.append(service)
        }
        
        if serviciosFuturos.count > 0 {
            addServiceHeaderWithText(text: "PRÓXIMOS SERVICIOS")
        }
        
        for service: ServiceModel in serviciosFuturos {
            let serviceView: ServicioView = ServicioView(service: service, client: client, cesta: nil)
            serviceView.delegate = self
            scrollContentView.addSubview(serviceView)
            serviceViewsArray.append(serviceView)
        }
        
        if serviciosPasados.count > 0 {
            addServiceHeaderWithText(text: "ANTIGUOS SERVICIOS")
        }
        
        for service: ServiceModel in serviciosPasados {
            let serviceView: ServicioView = ServicioView(service: service, client: client, cesta: nil)
            serviceView.delegate = self
            scrollContentView.addSubview(serviceView)
            serviceViewsArray.append(serviceView)
        }
        
        if cestas.count > 0 {
            addServiceHeaderWithText(text: "VENTA PRODUCTOS")
        }
        
        for cesta: CestaModel in cestas {
            let serviceView: ServicioView = ServicioView(service: nil, client: client, cesta: cesta)
            serviceView.delegate = self
            scrollContentView.addSubview(serviceView)
            serviceViewsArray.append(serviceView)
        }
        
        setServicesConstraints()
    }
    
    func addServiceHeaderWithText(text: String) {
        let headerLabel: UILabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = text
        headerLabel.textColor = AppStyle.getPrimaryTextColor()
        headerLabel.font = .systemFont(ofSize: 15)
        scrollContentView.addSubview(headerLabel)
        serviceViewsArray.append(headerLabel)
    }
    
    func setServicesConstraints() {
        var previousView: UIView = addServicioView
        for serviceView: UIView in serviceViewsArray {
            serviceView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 20).isActive = true
            serviceView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -15).isActive = true
            serviceView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 15).isActive = true
            
            previousView = serviceView
        }
        
        scrollContentView.bottomAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 30).isActive = true
    }
    
    func sortServicesByDate() {
        services.sort(by: { $0.fecha > $1.fecha })
    }
    
    func sortCestasByDate() {
        cestas.sort(by: { $0.fecha > $1.fecha })
    }
    
    func removeServicesViews() {
        for view: UIView in serviceViewsArray {
            view.removeFromSuperview()
        }
        
        serviceViewsArray = []
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
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir un número de contacto", viewController: self)
            return
        }
        
        updateClient()
    }
    
    func updateClient() {
        CommonFunctions.showLoadingStateView(descriptionText: "Actualizando Paciente")
        WebServices.updateClient(cliente: client, delegate: self)
    }
    
    func addRefreshControl() {
        scrollRefreshControl.addTarget(self, action: #selector(refreshClient), for: .valueChanged)
        srollView.refreshControl = scrollRefreshControl
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
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron_left"), style: .done, target: self, action: #selector(didClickBackButton))
        }
    }
    
    func openVentaProductoViewController(cesta: CestaModel) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Productos", bundle:nil)
        let controller: VentaProductoViewController = storyBoard.instantiateViewController(withIdentifier: "ventaProducto") as! VentaProductoViewController
        let ventas: [VentaModel] = Constants.databaseManager.ventaManager.getVentas(cestaId: cesta.cestaId)
        controller.cesta = cesta
        controller.ventas = ventas
        controller.delegate = self
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func openFirmaViewController() {
        let showItemStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: ImageViewController = showItemStoryboard.instantiateViewController(withIdentifier: "Image") as! ImageViewController
        controller.imageString = client.firma
        self.navigationController!.pushViewController(controller, animated: true)
    }
}

extension ClientDetailViewController {
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
        performSegue(withIdentifier: "DateIdentifier", sender: nil)
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
    
    @IBAction func didClickMotivoConsulta(_ sender: Any) {
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
    
    @IBAction func didClickSaveInfoButton(_ sender: Any) {
        checkFields()
    }
    
    @IBAction func didClickAddServicioButton(_ sender: Any) {
        performSegue(withIdentifier: "AddServicioIdentifier", sender: nil)
    }
    
    @IBAction func didClickCallButton(_ sender: Any) {
        CommonFunctions.callPhone(telefono: client.telefono.replacingOccurrences(of: " ", with: ""))
    }
    
    @IBAction func didClickImageView(_ sender: Any) {
        isTakingClientPhoto = true
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc func refreshClient() {
        WebServices.getServicesForClientId(clientId: client.id, delegate: self)
    }
    
    @objc func didClickBackButton(sender: UIBarButtonItem) {
        if !modificacionHecha {
            self.navigationController?.popViewController(animated: true)
        } else {
            showChangesAlertMessage()
        }
    }
    
    @IBAction func didClickFirma(_ sender: Any) {
        if client.firma.count == 0 {
            self.openCameraViewController()
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

extension ClientDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FieldIdentifier" {
            let controller: FieldViewController = segue.destination as! FieldViewController
            controller.inputReference = (sender as! Int)
            controller.delegate = self
            controller.keyboardType = getKeyboardTypeForField(inputReference: (sender as! Int))
            controller.inputText = getInputTextForField(inputReference: (sender as! Int))
            controller.title = getControllerTitleForInputReference(inputReference: (sender as! Int))
        } else if segue.identifier == "DateIdentifier" {
            let controller: DatePickerSelectorViewController = segue.destination as! DatePickerSelectorViewController
            controller.delegate = self
            controller.datePickerMode = .date
            controller.initialDate = client.fecha
        } else if segue.identifier == "AddServicioIdentifier" {
            let controller: AddServicioViewController = segue.destination as! AddServicioViewController
            controller.client = client
            controller.delegate = self
            if let update: [String : Any] = sender as? [String : Any] {
                controller.modifyService = (update["update"] as! Bool)
                controller.service = update["service"] as! ServiceModel
            }
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
            return client.observaciones
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
    
    func getControllerTitleForInputReference(inputReference: Int) -> String {
        switch inputReference {
        case 1:
            return "Número de historia"
        case 2:
            return "Nombre"
        case 3:
            return "Apellidos"
        case 4:
            return "Dirección"
        case 5:
            return "Profesión"
        case 6:
            return "Telefono"
        case 7:
            return "Email"
        case 8:
            return "Dni"
        case 9:
            return "Observaciones"
        case 10:
            return "Motivo Consulta"
        case 11:
            return "Tratamiento"
        case 12:
            return "Alimentación"
        case 13:
            return "Otros"
        default:
            return ""
        }
    }
    
    func openAntecedentesViewController() {
        let showItemStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: AntecedentesViewController = showItemStoryboard.instantiateViewController(withIdentifier: "antecedentes") as! AntecedentesViewController
        controller.delegate = self
        controller.cliente = client
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func openEstadoActualViewController() {
        let showItemStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: EstadoActualViewController = showItemStoryboard.instantiateViewController(withIdentifier: "estadoActual") as! EstadoActualViewController
        controller.delegate = self
        controller.cliente = client
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
}

extension ClientDetailViewController: DatePickerSelectorProtocol {
    func dateSelected(date: Date) {
        modificacionHecha = true
        client.fecha = Int64(date.timeIntervalSince1970)
        fechaLabel.text = CommonFunctions.getTimeTypeStringFromDate(date: date)
        edadLabel.text = String(CommonFunctions.getYearsFromToday(fromDate: Int64(date.timeIntervalSince1970)))
    }
}

extension ClientDetailViewController: AddClientInputFieldProtocol {
    func textSaved(text: String, inputReference: Int) {
        modificacionHecha = true
        switch inputReference {
        case 1:
            client.numeroHistoria = Int64(text) ?? 0
            numeroHistoriaLabel.text = text
            break
        case 2:
            client.nombre = text
            nombreLabel.text = text
            break
        case 3:
            client.apellidos = text
            apellidosLabel.text = text
            break
        case 4:
            client.direccion = text
            direccionLabel.text = text
            break
        case 5:
            client.profesion = text
            profesionLabel.text = text
            break
        case 6:
            client.telefono = text
            telefonoLabel.text = text
            break
        case 7:
            client.email = text
            emailLabel.text = text
            break
        case 8:
            client.dni = text
            dniLabel.text = text
            break
        case 9:
            client.observaciones = text
            observacionesLabel.text = text
            observacionesLabel.textColor = .red
            if client.alergias.contains("ª") {
                let fullNameArr = client.alergias.split{$0 == "ª"}.map(String.init)
                if fullNameArr.count > 0 && client.alergias.firstIndex(of: "ª")?.encodedOffset != 0 {
                    var textAlergias = text + "ª"
                    if fullNameArr.count > 1 {
                        textAlergias.append(fullNameArr[1])
                    }
                    
                    client.alergias = textAlergias
                }
            } else {
                client.alergias = text + "ª"
            }
            break
        case 10:
            client.motivoConsulta = text
            motivoConsultaLabel.text = text
            break
        case 11:
            client.tratamiento = text
            tratamientoLabel.text = text
            break
        case 12:
            client.alimentacion = text
            alimentacionLabel.text = text
            break
        case 13:
            client.otros = text
            otrosLabel.text = text
            break
        default:
            break
        }
    }
}

extension ClientDetailViewController: AddServicioProtocol {
    func serviceContentFilled(service: ServiceModel, serviceUpdated: Bool) {
        if serviceUpdated {
            services = Constants.databaseManager.servicesManager.getServicesForClientId(clientId: client.id)
        } else {
            service.serviceId = Int64(Date().timeIntervalSince1970)
            services.append(service)
        }
        
        sortServicesByDate()
        showServices()
    }
}

extension ClientDetailViewController: ServicioViewProtocol {
    func cestaClicked(cesta: CestaModel) {
        openVentaProductoViewController(cesta: cesta)
    }
    
    func servicioClicked(service: ServiceModel) {
        performSegue(withIdentifier: "AddServicioIdentifier", sender: ["update" :  true, "service" : service])
    }
}

extension ClientDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if isTakingClientPhoto {
            modificacionHecha = true
            clientImageView.layer.cornerRadius = 50
            let image = info[.originalImage] as! UIImage
            let resizedImage = CommonFunctions.resizeImage(image: image, targetSize: CGSize(width: 150, height: 150))
            self.clientImageView.image = resizedImage
            let imageData: Data = resizedImage.pngData()!
            let imageString: String = imageData.base64EncodedString()
            client.imagen = imageString
        } else {
            let image = info[.originalImage] as! UIImage
            let resizedImage = CommonFunctions.resizeImage(image: image, targetSize: CGSize(width: 500, height: 500))
            let imageData: Data = resizedImage.pngData()!
            let imageString: String = imageData.base64EncodedString()
            client.firma = imageString
            firmaCheck.isHidden = false
        }
    }
}

extension ClientDetailViewController: UpdateClientProtocol {
    func logoutResponse() {
        CommonFunctions.showLogoutAlert(viewController: self)
    }
    
    func successUpdatingClient(cliente: ClientModel) {
        Constants.databaseManager.clientsManager.updateClientInDatabase(client: self.client)
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    func errorUpdatingClient() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error actualizando Paciente", viewController: self)
        }
    }
}

extension ClientDetailViewController: GetServiciosClientProtocol {
    func successGettingServicios() {
        DispatchQueue.main.async {
            self.scrollRefreshControl.endRefreshing()
            self.getClientDetails()
        }
    }
    
    func errorGettingServicios() {
        DispatchQueue.main.async {
            self.scrollRefreshControl.endRefreshing()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error actualizando Paciente", viewController: self)
        }
    }
}

extension ClientDetailViewController: ClientUpdateCestaProtocol {
    func cestaUpdated() {
        cestas = Constants.databaseManager.cestaManager.getCestasForClientId(clientId: client.id)
        sortCestasByDate()
        showServices()
    }
}

extension ClientDetailViewController: AntecedentesProtocol {
    func antecedentesUpdated(client: ClientModel) {
        self.client = client
    }
}

extension ClientDetailViewController: EstadoActualProtocol {
    func estadoActualUpdated(client: ClientModel) {
        self.client = client
    }
}


