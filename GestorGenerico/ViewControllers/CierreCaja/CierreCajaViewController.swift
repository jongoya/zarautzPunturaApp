//
//  CierreCajaViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 21/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class CierreCajaViewController: UIViewController {
    @IBOutlet weak var numeroServiciosLabel: UILabel!
    @IBOutlet weak var totalCajaLabel: UILabel!
    @IBOutlet weak var totalProductosLabel: UILabel!
    @IBOutlet weak var efectivoLabel: UILabel!
    @IBOutlet weak var tarjetaLabel: UILabel!
    
    @IBOutlet weak var numeroServiciosField: UILabel!
    @IBOutlet weak var totalCajaField: UILabel!
    @IBOutlet weak var totalProductosField: UILabel!
    @IBOutlet weak var efectivoField: UILabel!
    @IBOutlet weak var tarjetaField: UILabel!
    
    
    @IBOutlet weak var numeroServiciosArrow: UIImageView!
    @IBOutlet weak var totalCajaArrow: UIImageView!
    @IBOutlet weak var totalProductosArrow: UIImageView!
    @IBOutlet weak var efectivoArrow: UIImageView!
    @IBOutlet weak var tarjetaArrow: UIImageView!
    @IBOutlet weak var background: UIView!
    
    
    var cierreCaja: CierreCajaModel = CierreCajaModel()
    var presentDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cierre Caja"
        customizeLabels()
        customizeFields()
        customizeArrows()
        customizeBackground()
        addSaveCierreCajaButton()
        
        fillFields()
    }
    
    func customizeLabels() {
        numeroServiciosLabel.textColor = AppStyle.getSecondaryTextColor()
        totalCajaLabel.textColor = AppStyle.getSecondaryTextColor()
        totalProductosLabel.textColor = AppStyle.getSecondaryTextColor()
        efectivoLabel.textColor = AppStyle.getSecondaryTextColor()
        tarjetaLabel.textColor = AppStyle.getSecondaryTextColor()
    }
    
    func customizeFields() {
        numeroServiciosField.textColor = AppStyle.getPrimaryTextColor()
        totalCajaField.textColor = AppStyle.getPrimaryTextColor()
        totalProductosField.textColor = AppStyle.getPrimaryTextColor()
        efectivoField.textColor = AppStyle.getPrimaryTextColor()
        tarjetaField.textColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeArrows() {
        if #available(iOS 13.0, *) {
            numeroServiciosArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        } else {
            numeroServiciosArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
        }
        if #available(iOS 13.0, *) {
            totalCajaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        } else {
            totalCajaArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
        }
        if #available(iOS 13.0, *) {
            totalProductosArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        } else {
            totalProductosArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
        }
        if #available(iOS 13.0, *) {
            efectivoArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        } else {
            efectivoArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
        }
        if #available(iOS 13.0, *) {
            tarjetaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        } else {
            tarjetaArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
        }
        numeroServiciosArrow.tintColor = AppStyle.getSecondaryColor()
        totalCajaArrow.tintColor = AppStyle.getSecondaryColor()
        totalProductosArrow.tintColor = AppStyle.getSecondaryColor()
        efectivoArrow.tintColor = AppStyle.getSecondaryColor()
        tarjetaArrow.tintColor = AppStyle.getSecondaryColor()
    }
    
    func customizeBackground() {
        background.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func addSaveCierreCajaButton() {
        if #available(iOS 13.0, *) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(didClickSaveCierreCajaButton))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "checkmark"), style: .done, target: self, action: #selector(didClickSaveCierreCajaButton))
        }
    }
    
    func fillFields() {
        let services: [ServiceModel] = Constants.databaseManager.servicesManager.getServicesForDay(date: presentDate)
        let cestas: [CestaModel] = Constants.databaseManager.cestaManager.getCestasForDay(date: presentDate)
        numeroServiciosLabel.text = String(services.count)
        cierreCaja.numeroServicios = services.count
        totalCajaLabel.text = String(format: "%.2f", getTotalCajaFromServiciosYVentas(servicios: services, cestas: cestas)) + " €"
        cierreCaja.totalCaja = getTotalCajaFromServiciosYVentas(servicios: services, cestas: cestas)
        totalProductosLabel.text = String(format: "%.2f", getTotalProductosFromCestas(cestas: cestas)) + " €"
        cierreCaja.totalProductos = getTotalProductosFromCestas(cestas: cestas)
        efectivoLabel.text = String(format: "%.2f", getTotalEfectivoFromServiciosYCestas(servicios: services, cestas: cestas)) + " €"
        cierreCaja.efectivo = getTotalEfectivoFromServiciosYCestas(servicios: services, cestas: cestas)
        tarjetaLabel.text = String(format: "%.2f", getTotalTarjetaFromServiciosYCestas(servicios: services, cestas: cestas)) + " €"
        cierreCaja.tarjeta = getTotalTarjetaFromServiciosYCestas(servicios: services, cestas: cestas)
    }
    
    func getTotalCajaFromServiciosYVentas(servicios: [ServiceModel], cestas: [CestaModel]) -> Double {
        var totalCaja: Double = 0.0
        for servicio: ServiceModel in servicios {
            let tipoServicio: TipoServicioModel = Constants.databaseManager.tipoServiciosManager.getTipoServicioFromDatabase(servicioId: servicio.servicios[0])
            totalCaja = totalCaja + tipoServicio.precio
        }
        
        for cesta: CestaModel in cestas {
            let ventas: [VentaModel] = Constants.databaseManager.ventaManager.getVentas(cestaId: cesta.cestaId)
            for venta: VentaModel in ventas {
                let producto: ProductoModel = Constants.databaseManager.productosManager.getProductWithProductId(productId: venta.productoId)!
                totalCaja = totalCaja + (producto.precio * Double(venta.cantidad))
            }
        }
        
        return totalCaja
    }
    
    func getTotalProductosFromCestas(cestas: [CestaModel]) -> Double {
        var totalProductos = 0.0
        
        for cesta: CestaModel in cestas {
            let ventas: [VentaModel] = Constants.databaseManager.ventaManager.getVentas(cestaId: cesta.cestaId)
            for venta: VentaModel in ventas {
                let producto: ProductoModel = Constants.databaseManager.productosManager.getProductWithProductId(productId: venta.productoId)!
                totalProductos = totalProductos + (producto.precio * Double(venta.cantidad))
            }
        }
        
        return totalProductos
    }
    
    func getTotalEfectivoFromServiciosYCestas(servicios: [ServiceModel], cestas: [CestaModel]) -> Double {
        var totalEfectivo = 0.0
        for servicio: ServiceModel in servicios {
            if servicio.isEfectivo {
                let tipoServicio: TipoServicioModel = Constants.databaseManager.tipoServiciosManager.getTipoServicioFromDatabase(servicioId: servicio.servicios[0])
                totalEfectivo = totalEfectivo + tipoServicio.precio
            }
        }
        
        for cesta: CestaModel in cestas {
            if cesta.isEfectivo {
                let ventas: [VentaModel] = Constants.databaseManager.ventaManager.getVentas(cestaId: cesta.cestaId)
                for venta: VentaModel in ventas {
                    let producto: ProductoModel = Constants.databaseManager.productosManager.getProductWithProductId(productId: venta.productoId)!
                    totalEfectivo = totalEfectivo + (producto.precio * Double(venta.cantidad))
                }
            }
        }
        
        return totalEfectivo
    }
    
    func getTotalTarjetaFromServiciosYCestas(servicios: [ServiceModel], cestas: [CestaModel]) -> Double {
        var totalTarjeta = 0.0
        for servicio: ServiceModel in servicios {
            if !servicio.isEfectivo {
                let tipoServicio: TipoServicioModel = Constants.databaseManager.tipoServiciosManager.getTipoServicioFromDatabase(servicioId: servicio.servicios[0])
                totalTarjeta = totalTarjeta + tipoServicio.precio
            }
        }
        
        for cesta: CestaModel in cestas {
            if !cesta.isEfectivo {
                let ventas: [VentaModel] = Constants.databaseManager.ventaManager.getVentas(cestaId: cesta.cestaId)
                for venta: VentaModel in ventas {
                    let producto: ProductoModel = Constants.databaseManager.productosManager.getProductWithProductId(productId: venta.productoId)!
                    totalTarjeta = totalTarjeta + (producto.precio * Double(venta.cantidad))
                }
            }
        }
        
        return totalTarjeta
    }
    
    func getKeyboardTypeForField(inputReference: Int) -> UIKeyboardType {
        switch inputReference {
        case 1:
            return .numberPad
        default:
            return .decimalPad
        }
    }
    
    func getInputTextForField(inputReference: Int) -> String {
        switch inputReference {
        case 1:
            return numeroServiciosLabel.text!
        case 2:
            return totalCajaLabel.text!
        case 3:
            return totalProductosLabel.text!
        case 4:
            return efectivoLabel.text!
        default:
            return tarjetaLabel.text!
        }
    }
    
    func getControllerTitleForField(inputReference: Int) -> String {
        switch inputReference {
        case 1:
            return "Número servicios"
        case 2:
            return "Total caja"
        case 3:
            return "Total productos"
        case 4:
            return "Efectivo"
        default:
            return "Tarjeta"
        }
    }
    
    func checkFields() {
        if numeroServiciosLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluier un numero de servicios", viewController: self)
            return
        }
        
        if totalCajaLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir un total en la caja", viewController: self)
            return
        }
        
        if totalProductosLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir un total de productos", viewController: self)
            return
        }
        
        if efectivoLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir un total en efectivo", viewController: self)
            return
        }
        
        if tarjetaLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir un total en tarjeta", viewController: self)
            return
        }
        
        saveCierreCaja()
    }
    
    func saveCierreCaja() {
        cierreCaja.fecha = Int64(presentDate.timeIntervalSince1970)
        CommonFunctions.showLoadingStateView(descriptionText: "Guardando el cierre de caja")
        WebServices.saveCierreCaja(caja: cierreCaja, delegate: self)
    }
}

extension CierreCajaViewController {
    @objc func didClickSaveCierreCajaButton(sender: UIBarButtonItem) {
        checkFields()
    }
    
    @IBAction func didClickNumeroServicios(_ sender: Any) {
        performSegue(withIdentifier: "inputFieldIdentifier", sender: 1)
    }
    
    @IBAction func didClickTotalCaja(_ sender: Any) {
        performSegue(withIdentifier: "inputFieldIdentifier", sender: 2)
    }
    
    @IBAction func didClickTotalProductos(_ sender: Any) {
        performSegue(withIdentifier: "inputFieldIdentifier", sender: 3)
    }
    
    @IBAction func didClickEfectivo(_ sender: Any) {
        performSegue(withIdentifier: "inputFieldIdentifier", sender: 4)
    }
    
    @IBAction func didClickTarjeta(_ sender: Any) {
        performSegue(withIdentifier: "inputFieldIdentifier", sender: 5)
    }
}

extension CierreCajaViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inputFieldIdentifier" {
            let controller: FieldViewController = segue.destination as! FieldViewController
            controller.inputReference = (sender as! Int)
            controller.delegate = self
            controller.keyboardType = getKeyboardTypeForField(inputReference: (sender as! Int))
            controller.inputText = getInputTextForField(inputReference: (sender as! Int))
            controller.title = getControllerTitleForField(inputReference: (sender as! Int))
        }
    }
}

extension CierreCajaViewController: AddClientInputFieldProtocol {
    func textSaved(text: String, inputReference: Int) {
        let value = text.replacingOccurrences(of: ",", with: ".")
        switch inputReference {
        case 1:
            numeroServiciosLabel.text = text
            cierreCaja.numeroServicios = (text as NSString).integerValue
        case 2:
            totalCajaLabel.text = value
            cierreCaja.totalCaja = (value as NSString).doubleValue
        case 3:
            totalProductosLabel.text = value
            cierreCaja.totalProductos = (value as NSString).doubleValue
        case 4:
            efectivoLabel.text = value
            cierreCaja.efectivo = (value as NSString).doubleValue
        default:
            tarjetaLabel.text = value
            cierreCaja.tarjeta = (value as NSString).doubleValue
        }
    }
}

extension CierreCajaViewController: AddCierreCajaProtocol {
    func logoutResponse() {
        CommonFunctions.showLogoutAlert(viewController: self)
    }
    
    func successAddingCierreCaja(caja: CierreCajaModel) {
        Constants.databaseManager.cierreCajaManager.addCierreCajaToDatabase(newCierreCaja: caja)
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    func errorAddingCierreCaja() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error guardando el cierre de caja", viewController: self)
        }
    }
}
