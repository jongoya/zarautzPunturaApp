//
//  AgendaItemView.swift
//  GestorHeme
//
//  Created by jon mikel on 07/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class AgendaItemView: UIView {
    var date: Date!
    
    var services: [ServiceModel] = []
    var cestas: [CestaModel] = []
    var serviceViews: [ServiceItemView] = []
    var profesional: Int64 = 0
    
    var fechaView: UIView!
    var backgroundView: UIView!
    var delegate: AgendaItemViewProtocol!
    
    let fechaViewWidth: CGFloat = 60
    let fechaViewHeight: CGFloat = 50
    var numCabinasDisponibles: Int = 3
    var empleadosOcupados: [Int64] = []

    init(date: Date, profesional: Int64, delegate: AgendaItemViewProtocol) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        self.date = date
        self.profesional = profesional
        self.delegate = delegate
        addContent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func getServices() {
        let wholeDayServices: [ServiceModel] = Constants.databaseManager.servicesManager.getServicesForDay(date: date)
        let endDate = Calendar.current.date(byAdding: .minute, value: 30, to: date)!
        
        for service in wholeDayServices {
            if service.fecha >= Int64(date.timeIntervalSince1970) && service.fecha < Int64(endDate.timeIntervalSince1970) {
                if profesional != 0 {
                    if profesional == service.empleadoId {
                        services.append(service)
                    }
                } else {
                    services.append(service)
                }
            }
        }
        
        actualizarReglasMediaHora(wholeServiceForDay: wholeDayServices, beginingOfViewDate: Int64(date.timeIntervalSince1970), endOfViewDate: Int64(endDate.timeIntervalSince1970))
        
        if numCabinasDisponibles == 0 || empleadosOcupados.count == CommonFunctions.getProfessionalList().count {
            backgroundView.backgroundColor = .red
        }
    }
    
    func actualizarReglasMediaHora(wholeServiceForDay: [ServiceModel], beginingOfViewDate: Int64, endOfViewDate: Int64) {
        for service in wholeServiceForDay {
            let beginingOfService: Int64 = service.fecha
            let tipoServicio: TipoServicioModel = Constants.databaseManager.tipoServiciosManager.getTipoServicioFromDatabase(servicioId: service.servicios[0])
            let endOfService: Int64 = Int64(Calendar.current.date(byAdding: .minute, value: Int(tipoServicio.duracion), to:  Date(timeIntervalSince1970: TimeInterval(service.fecha)))!.timeIntervalSince1970)
            
            if beginingOfService >= beginingOfViewDate && endOfService <= endOfViewDate {//Caso1
                actualizarReglas(tipoServicio: tipoServicio)
            } else if beginingOfService >= beginingOfViewDate && beginingOfService < endOfViewDate && endOfService > endOfViewDate {//Caso2
                actualizarReglas(tipoServicio: tipoServicio)
            } else if beginingOfService < beginingOfViewDate && endOfService <= endOfViewDate  && endOfService > beginingOfViewDate {//Caso3
                actualizarReglas(tipoServicio: tipoServicio)
            } else if beginingOfService < beginingOfViewDate && endOfService > endOfViewDate {//Caso4
                actualizarReglas(tipoServicio: tipoServicio)
            }
        }
    }
    
    private func actualizarReglas(tipoServicio: TipoServicioModel) {
        numCabinasDisponibles = numCabinasDisponibles - Int(tipoServicio.numCabinas)
        if tipoServicio.bloqueaTerapeuta && !empleadosOcupados.contains(tipoServicio.terapeuta) {
            empleadosOcupados.append(tipoServicio.terapeuta)
        }
    }
    
    func getCestas() {
        let wholeDayCestas: [CestaModel] = Constants.databaseManager.cestaManager.getCestasForDay(date: date)
        let endDate = Calendar.current.date(byAdding: .minute, value: 15, to: date)!
        for cesta: CestaModel in wholeDayCestas {
            if cesta.fecha >= Int64(date.timeIntervalSince1970) && cesta.fecha < Int64(endDate.timeIntervalSince1970) {
                cestas.append(cesta)
            }
        }
    }
    
    func addContent() {
        addBackground()
        addFecha()
        addServices()
        addBottomDivisoryLine()
    }
    
    func addBackground() {
        backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.alpha = 0.5
        addSubview(backgroundView)
        
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func addFecha() {
        fechaView = UIView()
        fechaView.translatesAutoresizingMaskIntoConstraints = false
        let tap = AgendaItemTypeGesture(target: self, action: #selector(dayClicked(_:)))
        tap.date = date
        fechaView.addGestureRecognizer(tap)
        addSubview(fechaView)
        
        let timeLabel: UILabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.text = AgendaFunctions.getHoursAndMinutesFromDate(date: date)
        timeLabel.textColor = AppStyle.getPrimaryTextColor()
        timeLabel.font = UIFont.systemFont(ofSize: 20)
        fechaView.addSubview(timeLabel)
        
        fechaView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        fechaView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        fechaView.widthAnchor.constraint(equalToConstant: fechaViewWidth).isActive = true
        fechaView.heightAnchor.constraint(equalToConstant: fechaViewHeight).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: fechaView.topAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: fechaView.leadingAnchor).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: fechaView.trailingAnchor).isActive = true
    }
    
    func addServices() {
        getServices()
        getCestas()
        
        if services.count == 0  && cestas.count == 0 {
            fechaView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        }
        
        for service: ServiceModel in services {
            addViewWithModel(service: service, cesta: nil)
        }
        
        for cesta: CestaModel in cestas {
            addViewWithModel(service: nil, cesta: cesta)
        }
        
        var previousView: ServiceItemView!
        for serviceView: ServiceItemView in serviceViews {
            setConstraintsToServiceView(serviceView: serviceView, previousView: previousView)
    
            previousView = serviceView
        }
        
        if previousView != nil {
            bottomAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 10).isActive = true
        }
    }
    
    func setConstraintsToServiceView(serviceView: ServiceItemView, previousView: ServiceItemView?) {
        serviceView.topAnchor.constraint(equalTo: previousView != nil ? previousView!.bottomAnchor : topAnchor, constant: 5).isActive = true
        let leading: NSLayoutConstraint = serviceView.leadingAnchor.constraint(equalTo: fechaView.trailingAnchor, constant: 10)
        serviceView.serviceLeadingAnchor = leading
        leading.isActive = true
        let trailing: NSLayoutConstraint = serviceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        serviceView.serviceTrailingAnchor = trailing
        trailing.isActive = true
    }
    
    func addViewWithModel(service: ServiceModel?, cesta: CestaModel?) {
        let redView: UIView = UIView()
        redView.translatesAutoresizingMaskIntoConstraints = false
        redView.backgroundColor = .systemRed
        redView.layer.cornerRadius = 10
        addRedViewTapGesture(redView: redView, service: service, cesta: cesta)
        addSubview(redView)
        
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "cross")!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        redView.addSubview(imageView)
        
        let serviceView: ServiceItemView = ServiceItemView()
        serviceView.service = service
        serviceView.cesta = cesta
        serviceView.translatesAutoresizingMaskIntoConstraints = false
        customizeServiceView(serviceView: serviceView)
        addServiceItemGestures(serviceView: serviceView)
        addSubview(serviceView)
        
        var client: ClientModel?
        if service != nil {
            client = Constants.databaseManager.clientsManager.getClientFromDatabase(clientId: service!.clientId)
        } else {
            client = Constants.databaseManager.clientsManager.getClientFromDatabase(clientId: cesta!.clientId)
        }
        
        let clientNameLabel: UILabel = UILabel()
        clientNameLabel.translatesAutoresizingMaskIntoConstraints = false
        clientNameLabel.textColor = AppStyle.getPrimaryTextColor()
        clientNameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        if client != nil && service != nil {
            clientNameLabel.text = client!.nombre + " " + client!.apellidos
        } else {
            if cesta != nil {
                clientNameLabel.text = "Venta Producto"
            } else {
                clientNameLabel.text = "Actualizando..."
            }
        }
        serviceView.addSubview(clientNameLabel)
        
        let serviceName: UILabel = UILabel()
        serviceName.translatesAutoresizingMaskIntoConstraints = false
        serviceName.textColor = AppStyle.getPrimaryTextColor()
        serviceName.font = .systemFont(ofSize: 15)
        
        if service != nil {
            serviceName.text = CommonFunctions.getServiciosString(servicios: getServiciosFromServiciosId(servicios: service!.servicios))
        } else {
            serviceName.text = client!.nombre + " " + client!.apellidos
        }
        serviceView.addSubview(serviceName)
        
        let profesionalNameLabel: UILabel = UILabel()
        profesionalNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if service != nil {
           profesionalNameLabel.text = Constants.databaseManager.empleadosManager.getEmpleadoFromDatabase(empleadoId: service!.empleadoId)?.nombre
        } else {
            let ventas: [VentaModel] = Constants.databaseManager.ventaManager.getVentas(cestaId: cesta!.cestaId)
            profesionalNameLabel.text = "Precio: " + String(format: "%.2f", calcularVentaTotal(ventas: ventas)) + " €"
        }
        
        profesionalNameLabel.textColor = AppStyle.getPrimaryTextColor()
        profesionalNameLabel.font = UIFont.systemFont(ofSize: 15)
        serviceView.addSubview(profesionalNameLabel)
        
        clientNameLabel.topAnchor.constraint(equalTo: serviceView.topAnchor, constant: 10).isActive = true
        clientNameLabel.leadingAnchor.constraint(equalTo: serviceView.leadingAnchor, constant: 10).isActive = true
        clientNameLabel.trailingAnchor.constraint(equalTo: serviceView.trailingAnchor, constant: -10).isActive = true
        
        serviceName.topAnchor.constraint(equalTo: clientNameLabel.bottomAnchor, constant: 2).isActive = true
        serviceName.leadingAnchor.constraint(equalTo: serviceView.leadingAnchor, constant: 10).isActive = true
        serviceName.trailingAnchor.constraint(equalTo: serviceView.trailingAnchor, constant: -10).isActive = true
        
        profesionalNameLabel.topAnchor.constraint(equalTo: serviceName.bottomAnchor, constant: 2).isActive = true
        profesionalNameLabel.leadingAnchor.constraint(equalTo: serviceView.leadingAnchor, constant: 10).isActive = true
        profesionalNameLabel.trailingAnchor.constraint(equalTo: serviceView.trailingAnchor, constant: -10).isActive = true
        profesionalNameLabel.bottomAnchor.constraint(equalTo: serviceView.bottomAnchor, constant: -10).isActive = true
        
        redView.topAnchor.constraint(equalTo: serviceView.topAnchor).isActive = true
        redView.bottomAnchor.constraint(equalTo: serviceView.bottomAnchor).isActive = true
        redView.leadingAnchor.constraint(equalTo: fechaView.trailingAnchor, constant: 10).isActive = true
        redView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.trailingAnchor.constraint(equalTo: redView.trailingAnchor, constant: -20).isActive = true
        imageView.centerYAnchor.constraint(equalTo: redView.centerYAnchor).isActive = true
        
        serviceViews.append(serviceView)
    }
    
    func customizeServiceView(serviceView: ServiceItemView) {
        if serviceView.service != nil {
            serviceView.backgroundColor = AgendaFunctions.getColorForTipoServicio(tipoServicioId: serviceView.service!.servicios[0])
            serviceView.layer.borderColor = AgendaFunctions.getColorForTipoServicio(tipoServicioId: serviceView.service!.servicios[0]).cgColor
        } else {
            serviceView.backgroundColor = AppStyle.getPrimaryColor()
            serviceView.layer.borderColor = AppStyle.getPrimaryColor().cgColor
        }
        
        serviceView.layer.cornerRadius = 10
        serviceView.layer.borderWidth = 1
    }
    
    func addServiceItemGestures(serviceView: ServiceItemView) {
        let tap = AgendaItemTypeGesture(target: self, action: #selector(serviceClicked(_:)))
        tap.service = serviceView.service
        tap.cesta = serviceView.cesta
        serviceView.addGestureRecognizer(tap)
        
        if serviceView.service != nil {
            let swipeLeft = AgendaItemSwipeGesture(target: self, action: #selector(serviceSwipedLeft))
            swipeLeft.direction = .left
            swipeLeft.serviceView = serviceView
            serviceView.addGestureRecognizer(swipeLeft)
            let swipeRight = AgendaItemSwipeGesture(target: self, action: #selector(serviceSwipedRight))
            swipeRight.direction = .right
            swipeRight.serviceView = serviceView
            serviceView.addGestureRecognizer(swipeRight)
        }
    }
    
    func addRedViewTapGesture(redView: UIView, service: ServiceModel?, cesta: CestaModel?) {
        let tap = AgendaItemTypeGesture(target: self, action: #selector(crossViewClicked(_:)))
        tap.service = service
        tap.cesta = cesta
        redView.addGestureRecognizer(tap)
    }
    
    func addBottomDivisoryLine() {
        let divisory: UIView = UIView()
        divisory.translatesAutoresizingMaskIntoConstraints = false
        divisory.backgroundColor = AppStyle.getSecondaryColor()
        addSubview(divisory)
        
        divisory.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        divisory.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        divisory.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divisory.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func leftAnimation(view: ServiceItemView) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            view.serviceLeadingAnchor.constant = -80
            view.serviceTrailingAnchor.constant = -80
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func rightAnimation(view: ServiceItemView) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            view.serviceLeadingAnchor.constant = 10
            view.serviceTrailingAnchor.constant = -10
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func getServiciosFromServiciosId(servicios: [Int64]) -> [TipoServicioModel] {
        var arrayServicios: [TipoServicioModel] = []
        for servicioId in servicios {
            arrayServicios.append(Constants.databaseManager.tipoServiciosManager.getTipoServicioFromDatabase(servicioId: servicioId))
        }
        
        return arrayServicios
    }
    
    func calcularVentaTotal(ventas: [VentaModel]) -> Double {
        var precioTotal: Double = 0.0
        for venta: VentaModel in ventas {
            let producto: ProductoModel = Constants.databaseManager.productosManager.getProductWithProductId(productId: venta.productoId)!
            precioTotal = precioTotal + (producto.precio * Double(venta.cantidad))
        }
        
        return precioTotal
    }
    
    func getEmpleadosDisponibles() -> [EmpleadoModel] {
        let empleados: [EmpleadoModel] = CommonFunctions.getProfessionalList()
        var empleadosDisponibles: [EmpleadoModel] = []
        for empleado: EmpleadoModel in empleados {
            var empleadoOcupado: Bool = false
            for empleadoId: Int64 in empleadosOcupados {
                if empleadoId == empleado.empleadoId {
                    empleadoOcupado = true
                }
            }
            
            if !empleadoOcupado {
                empleadosDisponibles.append(empleado)
            }
        }
        
        return empleadosDisponibles
    }
}

extension AgendaItemView {
    @objc func serviceClicked(_ sender: AgendaItemTypeGesture) {
        delegate.serviceClicked(service: sender.service, cesta: sender.cesta, numCabinasDisponibles: numCabinasDisponibles, empleadosDisponibles: getEmpleadosDisponibles())
    }
    
    @objc func serviceSwipedLeft(sender: AgendaItemSwipeGesture) {
        let selectedView: ServiceItemView = sender.serviceView
        leftAnimation(view: selectedView)
    }
    
    @objc func serviceSwipedRight(sender: AgendaItemSwipeGesture) {
        let selectedView: ServiceItemView = sender.serviceView
        rightAnimation(view: selectedView)
    }
    
    @objc func dayClicked(_ sender: AgendaItemTypeGesture) {
        if numCabinasDisponibles == 0 || empleadosOcupados.count == CommonFunctions.getProfessionalList().count {
            return
        }
        
        delegate.dayClicked(date: sender.date, numCabinasDisponibles: numCabinasDisponibles, empleadosDisponibles: getEmpleadosDisponibles())
    }
    
    @objc func crossViewClicked(_ sender: AgendaItemTypeGesture) {
        delegate.crossButtonClicked(service: sender.service!)
    }
}

//Custom classes
class AgendaItemTypeGesture: UITapGestureRecognizer {
    var service: ServiceModel?
    var cesta: CestaModel?
    var date: Date!
}

class AgendaItemSwipeGesture: UISwipeGestureRecognizer {
    var serviceView: ServiceItemView!
}

class ServiceItemView: UIView {
    var serviceLeadingAnchor: NSLayoutConstraint!
    var serviceTrailingAnchor: NSLayoutConstraint!
    var service: ServiceModel?
    var cesta: CestaModel?
    
}
