//
//  AgendaViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 03/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import RMPickerViewController
import FSCalendar
import iCarousel

class AgendaViewController: UIViewController {
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var filterProfessionalButton: UIButton!
    @IBOutlet weak var monthCalendar: FSCalendar!
    @IBOutlet weak var topMonthCalendarConstrain: NSLayoutConstraint!
    @IBOutlet weak var dayCarousel: iCarousel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var datePickerButton: UIView!
    @IBOutlet weak var datePickerImage: UIImageView!
    
    var servicesViewArray: [UIView] = []
    var profesionalsArray: [EmpleadoModel] = []
    var presentDate: Date = Date()
    var initialDate: Date!
    var selectedProfesional: Int64 = 0
    var showingClientes: Bool = false
    let animationDuration: CGFloat = 0.5
    var calendarVisible: Bool = false
    var calendarHeigth: CGFloat = 400
    var daysInCarousel: [Date] = []
    var scrollRefreshControl: UIRefreshControl = UIRefreshControl()
    var empleadosDisponibles: [EmpleadoModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        addRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeScrollView()
        customizeMonthCalendar()
        customizeButtons()
        customizeCarousel()
        customizeMonthCalendar()
        
        setDayCarousel()
        setProfesionalArray()
        
        if !showingClientes {
            addAgenda(profesional: selectedProfesional)
        } else {
            Constants.rootController.fillSecondRightNavigationButtonImage()
            showClients()
        }
    }
    
    func customizeScrollView() {
        scrollView.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func setDayCarousel() {
        dayCarousel.isPagingEnabled = true
        daysInCarousel.removeAll()
        initialDate = Calendar.current.date(byAdding: .year, value: -2, to: presentDate)!
        let finalDate: Date = Calendar.current.date(byAdding: .year, value: 2, to: presentDate)!
        
        for index in 0...AgendaFunctions.getNumberOfDaysBetweenDates(date1: initialDate, date2: finalDate) {
            daysInCarousel.append(Calendar.current.date(byAdding: .day, value: index, to: initialDate)!)
        }
        
        dayCarousel.reloadData()
        
        dayCarousel.scrollToItem(at: AgendaFunctions.getNumberOfDaysBetweenDates(date1: initialDate, date2: presentDate) , animated: false)
    }
    
    func customizeMonthCalendar() {
        monthCalendar.locale = Locale(identifier: "es_ES")
        monthCalendar.appearance.headerTitleColor = AppStyle.getPrimaryColor()
        monthCalendar.appearance.weekdayTextColor = AppStyle.getPrimaryColor()
        monthCalendar.appearance.todayColor = AppStyle.getPrimaryColor()
        
        if #available(iOS 13.0, *) {
        } else {
            datePickerImage.image = UIImage(named: "calendar_badge_plus")
        }
        datePickerImage.tintColor = AppStyle.getPrimaryColor()
    }
    
    func customizeCarousel() {
        dayCarousel.backgroundColor = AppStyle.getBackgroundColor()
        dayCarousel.type = .rotary
    }
    
    func setProfesionalArray() {
        let empleado: EmpleadoModel = EmpleadoModel()
        empleado.nombre = "Todos"
        profesionalsArray.append(empleado)
        profesionalsArray.append(contentsOf: CommonFunctions.getProfessionalList())
    }
    
    func customizeButtons() {
        CommonFunctions.customizeButton(button: filterProfessionalButton)
        CommonFunctions.customizeButton(button: datePickerButton)
    }
    
    func addAgenda(profesional: Int64) {
        Constants.rootController.unfillSecondRightNavigationButtonImage()
        showingClientes = false
        removeAgenda()
        
        addAgendaItems(profesional: profesional)
        
        setAgendaItemsConstraints()
    }
    
    func addAgendaItems(profesional: Int64) {
        var serviceDate: Date = AgendaFunctions.getBeginningOfDayFromDate(date: presentDate)
        
        for _ in 1...26 {
            let agendaItemView: AgendaItemView = AgendaItemView.init(date: serviceDate, profesional: profesional, delegate: self)
            scrollContentView.addSubview(agendaItemView)
            
            servicesViewArray.append(agendaItemView)
            
            serviceDate = AgendaFunctions.add30MinutesToDate(date: serviceDate)
        }
    }
    
    func setAgendaItemsConstraints() {
        var previousView: UIView!
        for agendaView in servicesViewArray {
            agendaView.topAnchor.constraint(equalTo: previousView != nil ? previousView.bottomAnchor : scrollContentView.topAnchor).isActive = true
            agendaView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
            agendaView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
            
            previousView = agendaView
        }
        
        if !Constants.databaseManager.cierreCajaManager.checkCierreCajaInDatabase(fecha: presentDate) {
            let button: UIButton =  createCierreCajaButton()
            scrollContentView.addSubview(button)
            servicesViewArray.append(button)
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 20).isActive = true
            button.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: 150).isActive = true
            previousView = button
        }
        
        scrollContentView.bottomAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 20).isActive = true
    }
    
    func removeAgenda() {
        for view: UIView in scrollContentView.subviews {
            view.removeFromSuperview()
        }
        
        servicesViewArray = []
    }
    
    func showProfessionalSelectorView() {
        let selectAction: RMAction<UIPickerView> = RMAction(title: "Seleccionar", style: .done) { (pickerView) in
            if self.calendarVisible {
                self.hideMonthCalendarView(withAnimationDuration: self.animationDuration)
                self.calendarVisible = !self.calendarVisible
            }
            
            let row: Int = pickerView.contentView.selectedRow(inComponent: 0)
            self.selectedProfesional = row == 0 ? 0 : self.profesionalsArray[row].empleadoId
            self.filterProfessionalButton.setTitle(self.profesionalsArray[row].nombre, for: .normal)
            self.filterProfessionalButton.setTitleColor(.black, for: .normal)
            self.addAgenda(profesional: self.selectedProfesional)
        }!
        let cancelAction: RMAction<UIPickerView> = RMAction(title: "Cancelar", style: .cancel, andHandler: nil)!
        let controller: RMPickerViewController = RMPickerViewController(style: .white, select: selectAction, andCancel: cancelAction)!
        controller.picker.delegate = self
        controller.picker.dataSource = self
        present(controller, animated: true, completion: nil)
    }
    
    func showClients() {
        removeAgenda()
        var clientArray: [Int64] = []
        let services: [ServiceModel] = Constants.databaseManager.servicesManager.getServicesForDay(date: presentDate)
        for service in services {
            clientArray.append(service.clientId)
        }
        
        clientArray = Array(Set(clientArray))
        
        createClientsViewsForClients(clients: clientArray)
    }
    
    func createClientsViewsForClients(clients: [Int64]) {
        var previousView: UIView!
        
        for clientId in clients {
            let client: ClientModel? = Constants.databaseManager.clientsManager.getClientFromDatabase(clientId: clientId)
            
            if client == nil {
                continue
            }
            
            let clientView: AgendaClientItemView = AgendaClientItemView(cliente: client!, presentDate: presentDate, delegate: self)
            scrollContentView.addSubview(clientView)
            
            clientView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 15).isActive = true
            clientView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -15).isActive = true
            clientView.topAnchor.constraint(equalTo: previousView != nil ? previousView.bottomAnchor : scrollContentView.topAnchor, constant: 10).isActive = true
            clientView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            previousView = clientView
        }
        
        if previousView != nil {
            scrollContentView.bottomAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 15).isActive = true
        }
    }
    
    func createCierreCajaButton() -> UIButton {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("Cerrar Caja", for: .normal)
        button.setTitleColor(AppStyle.getPrimaryTextColor(), for: .normal)
        CommonFunctions.customizeButton(button: button)
        button.addTarget(self, action: #selector(didClickCerrarCajaButton), for: .touchUpInside)
        return button
    }
    
    func addRefreshControl() {
        scrollRefreshControl.addTarget(self, action: #selector(refreshDay), for: .valueChanged)
        scrollView.refreshControl = scrollRefreshControl
    }
    
    func openVentaProductoViewController(cesta: CestaModel) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Productos", bundle:nil)
        let controller: VentaProductoViewController = storyBoard.instantiateViewController(withIdentifier: "ventaProducto") as! VentaProductoViewController
        let ventas: [VentaModel] = Constants.databaseManager.ventaManager.getVentas(cestaId: cesta.cestaId)
        controller.cesta = cesta
        controller.ventas = ventas
        self.navigationController!.pushViewController(controller, animated: true)
    }
}

extension AgendaViewController {
    @IBAction func didClickProfessionalFilterButton(_ sender: Any) {
        showProfessionalSelectorView()
    }
    
    @IBAction func datePickerCLicked(_ sender: Any) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        let alert = UIAlertController(title: "Elige la fecha\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        
        let ok = UIAlertAction(title: "Aceptar", style: .default) { (action) in
            self.presentDate = datePicker.date
            self.calendarVisible = false
            self.hideMonthCalendarView(withAnimationDuration: self.animationDuration)
            self.setDayCarousel()
            self.addAgenda(profesional: self.selectedProfesional)
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func didClickCalendarButton() {
        if calendarVisible {
            hideMonthCalendarView(withAnimationDuration: animationDuration)
        } else {
            showMonthCalendarView()
        }
        
        calendarVisible = !calendarVisible
    }
    
    func didClickListarClientes() {
        if calendarVisible {
            hideMonthCalendarView(withAnimationDuration: animationDuration)
            calendarVisible = !calendarVisible
        }
        
        if showingClientes {
            Constants.rootController.unfillSecondRightNavigationButtonImage()
            showingClientes = false
            addAgenda(profesional: selectedProfesional)
        } else {
            Constants.rootController.fillSecondRightNavigationButtonImage()
            showingClientes = true
            removeAgenda()
            showClients()
        }
    }
    
    @objc func refreshDay() {
        let beginningOfDay: Int64 = Int64(AgendaFunctions.getBeginningOfDayFromDate(date: presentDate).timeIntervalSince1970)
        let endOfDay: Int64 = Int64(AgendaFunctions.getEndOfDayFromDate(date: presentDate).timeIntervalSince1970)
        WebServices.getServicesForRange(fechaInicio: beginningOfDay, fechaFin: endOfDay, delegate: self)
    }
    
    @objc func didClickCerrarCajaButton() {
        performSegue(withIdentifier: "cierreCajaIdentifier", sender: nil)
    }
}

extension AgendaViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return profesionalsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return profesionalsArray[row].nombre
    }
}

extension AgendaViewController: AgendaItemViewProtocol {
    func crossButtonClicked(service: ServiceModel) {
        CommonFunctions.showLoadingStateView(descriptionText: "Eliminando servicio")
        WebServices.deleteService(service: service, delegate: self)
    }
    
    func dayClicked(date: Date, numCabinasDisponibles: Int, empleadosDisponibles: [EmpleadoModel]) {
        self.empleadosDisponibles = empleadosDisponibles
        performSegue(withIdentifier: "AgendaServiceIdentifier", sender: ["date" : date, "numCabinas" : numCabinasDisponibles])
    }
    
    func serviceClicked(service: ServiceModel?, cesta: CestaModel?, numCabinasDisponibles: Int, empleadosDisponibles: [EmpleadoModel]) {
        if service != nil {
            self.empleadosDisponibles = empleadosDisponibles
            performSegue(withIdentifier: "ServiceDetailIdentifier", sender: ["service" : service!, "numCabinas" : numCabinasDisponibles])
        } else {
            openVentaProductoViewController(cesta: cesta!)
        }
    }
}

extension AgendaViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ServiceDetailIdentifier" {
            let dictionary: [String : Any] = sender as! [String : Any]
            openServiceDetail(sender: dictionary["service"], numCabinasDisponibles: (dictionary["numCabinas"] as! Int), segue: segue)
        } else if segue.identifier == "ClientDetailIdentifier" {
            let controller: ClientDetailViewController = segue.destination as! ClientDetailViewController
            controller.client = (sender as! ClientModel)
        } else if segue.identifier == "AgendaServiceIdentifier" {
            let controller: AgendaServiceViewController = segue.destination as! AgendaServiceViewController
            let dictionary: [String : Any] = sender as! [String : Any]
            controller.newDate = (dictionary["date"] as! Date)
            controller.numCabinasDisponibles = (dictionary["numCabinas"] as! Int)
            controller.empleadosDisponibles = empleadosDisponibles
            controller.delegate = self
        } else if segue.identifier == "cierreCajaIdentifier" {
            let controller: CierreCajaViewController = segue.destination as! CierreCajaViewController
            controller.presentDate = presentDate
        }
    }
    
    func openServiceDetail(sender: Any?, numCabinasDisponibles: Int, segue: UIStoryboardSegue) {
        let service: ServiceModel = sender as! ServiceModel
        let controller: AddServicioViewController = segue.destination as! AddServicioViewController
        let client: ClientModel? = Constants.databaseManager.clientsManager.getClientFromDatabase(clientId: service.clientId)
        if client == nil {
            CommonFunctions.showGenericAlertMessage(mensaje: "Error mostrando el detalle servicio", viewController: self)
            return
        }
        
        controller.client = client
        controller.modifyService = true
        controller.service = service
        controller.numCabinasDisponibles = numCabinasDisponibles
        controller.empleadosDisponibles = empleadosDisponibles
        controller.delegate = self
    }
}

extension AgendaViewController: AddServicioProtocol {
    func serviceContentFilled(service: ServiceModel, serviceUpdated: Bool) {
        //no es necesario implementar
    }
}

extension AgendaViewController: ClientItemViewProtocol {
    func clientClicked(client: ClientModel) {
        performSegue(withIdentifier: "ClientDetailIdentifier", sender: client)
    }
}

extension AgendaViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        presentDate = Calendar.current.date(byAdding: .hour, value: 12, to: date)!
        calendarVisible = false
        hideMonthCalendarView(withAnimationDuration: animationDuration)
        setDayCarousel()
        addAgenda(profesional: selectedProfesional)
    }
    
    func hideMonthCalendarView(withAnimationDuration: CGFloat) {
        UIView.animate(withDuration: TimeInterval(withAnimationDuration), delay: 0, options: .curveEaseOut, animations: {
            self.topMonthCalendarConstrain.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func showMonthCalendarView() {
        UIView.animate(withDuration: TimeInterval(animationDuration), delay: 0, options: .curveEaseOut, animations: {
            self.topMonthCalendarConstrain.constant = self.calendarHeigth
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension AgendaViewController: iCarouselDataSource, iCarouselDelegate {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return daysInCarousel.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view: CarouselItem = CarouselItem(frame: CGRect(x: 0, y: 0, width: 80, height: 70), date: daysInCarousel[index])
        if index == carousel.currentItemIndex {
            view.highlightView()
        } else {
            view.unhightlightView()
        }
        
        return view
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let oldItem: CarouselItem = carousel.itemView(at: carousel.currentItemIndex) as! CarouselItem
        let item: CarouselItem = carousel.itemView(at: index) as! CarouselItem
        item.highlightView()
        oldItem.unhightlightView()
        presentDate = item.date
        calendarVisible = false
        hideMonthCalendarView(withAnimationDuration: animationDuration)
        addAgenda(profesional: selectedProfesional)
    }
    
    func carouselDidEndDecelerating(_ carousel: iCarousel) {
        let item: CarouselItem = carousel.currentItemView as! CarouselItem
        item.highlightView()
        presentDate = item.date
        calendarVisible = false
        hideMonthCalendarView(withAnimationDuration: animationDuration)
        addAgenda(profesional: selectedProfesional)
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        //TODO mirar si es necesario
    }
    
    func carouselWillBeginDragging(_ carousel: iCarousel) {
        let oldItem: CarouselItem = carousel.itemView(at: carousel.currentItemIndex) as! CarouselItem
        oldItem.unhightlightView()
    }
}

extension AgendaViewController: AgendaServiceProtocol {
    func serviceAdded() {
        let item: CarouselItem = dayCarousel.currentItemView! as! CarouselItem
        item.checkCitasPoint()
    }
}

extension AgendaViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollContentView
    }
}

extension AgendaViewController: GetServiciosRangeProtocol {
    func successGettingServicios() {
        DispatchQueue.main.async {
            self.scrollRefreshControl.endRefreshing()
            if !self.showingClientes {
                Constants.rootController.unfillSecondRightNavigationButtonImage()
                self.addAgenda(profesional: self.selectedProfesional)
            } else {
                Constants.rootController.fillSecondRightNavigationButtonImage()
                self.showClients()
            }
        }
    }
    
    func errorGettingServicios() {
        DispatchQueue.main.async {
            self.scrollRefreshControl.endRefreshing()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error recogiendo servicios", viewController: self)
        }
    }
}

extension AgendaViewController: DeleteServiceProtocol {
    func logoutResponse() {
        CommonFunctions.showLogoutAlert(viewController: self)
    }
    
    func successDeletingService(service: ServiceModel) {
        Constants.databaseManager.servicesManager.deleteService(service: service)
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            self.addAgenda(profesional: self.selectedProfesional)
            
            let item: CarouselItem = self.dayCarousel.currentItemView! as! CarouselItem
            item.checkCitasPoint()
        }
    }
    
    func errorDeletingService() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error eliminando el servicio", viewController: self)
        }
    }
}
