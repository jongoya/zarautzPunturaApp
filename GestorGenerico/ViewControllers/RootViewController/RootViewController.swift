//
//  ViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 31/03/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import MessageUI

class RootViewController: UITabBarController {
    @IBOutlet weak var rigthNavigationButton: UIBarButtonItem!
    @IBOutlet weak var secondRightNavigationButton: UIBarButtonItem!
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pacientes"
        self.delegate = self
        customizeTabBar()
        customizeNavBar()
        Constants.rootController = self
    }
    
    func customizeTabBar() {
        if #available(iOS 13.0, *) {
        } else {
            tabBar.items![0].image = UIImage(named: "person_fill")
            tabBar.items![1].image = UIImage(named: "calendar_icon")
            tabBar.items![2].image = UIImage(named: "bag")
            tabBar.items![3].image = UIImage(named: "heart_fill")
            tabBar.items![1].selectedImage = UIImage(named: "calendar_icon")
        }
        tabBar.tintColor =  AppStyle.getPrimaryColor()
        tabBar.layer.borderColor =  AppStyle.getSecondaryColor().cgColor
        tabBar.unselectedItemTintColor = AppStyle.getPrimaryTextColor()
        tabBar.items![3].title = AppStyle.getAppName()
        tabBar.barTintColor = AppStyle.getNavigationColor()
        //TODO
        //tabBar.items![0].image == Modificar la imagen
        

    }
    
    func customizeNavBar() {
        navigationController!.navigationBar.barTintColor = AppStyle.getNavigationColor()
        navigationController!.navigationBar.tintColor = AppStyle.getPrimaryColor()
        navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: AppStyle.getPrimaryTextColor()]
    }
    
    func openSettingsViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Settings", bundle:nil)
        let controller: SettingsViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func fillSecondRightNavigationButtonImage() {
        if #available(iOS 13.0, *) {
            secondRightNavigationButton.image = UIImage(systemName: "person.fill")
        } else {
            secondRightNavigationButton.image = UIImage(named: "person_fill")
        }
    }
    
    func unfillSecondRightNavigationButtonImage() {
        if #available(iOS 13.0, *) {
            secondRightNavigationButton.image = UIImage(systemName: "person")
        } else {
            secondRightNavigationButton.image = UIImage(named: "person_fill")
        }
    }
    
    private func openProductScanner() {
        let scannerViewController: ScannerViewController = ScannerViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: true, completion: nil)
    }
    
    private func showEditTextDialog() {
        let alertController = UIAlertController(title: "Introduce el nombre del producto", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = ""
        }
        let saveAction = UIAlertAction(title: "Aceptar", style: .default, handler: { alert -> Void in
            let nombreProducto = alertController.textFields![0] as UITextField
            self.codigoBarrasDetected(codigoBarras: nombreProducto.text!)
        })
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: { (action : UIAlertAction!) -> Void in })

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openVentaProductoViewController(producto: ProductoModel) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Productos", bundle:nil)
        let controller: VentaProductoViewController = storyBoard.instantiateViewController(withIdentifier: "ventaProducto") as! VentaProductoViewController
        controller.ventas.append(VentaModel(productoId: producto.productoId))
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func manageAgendaScanner(producto: ProductoModel?) {
        if producto == nil {
            CommonFunctions.showGenericAlertMessage(mensaje: "El producto no se encuentra en stock", viewController: selectedViewController!)
            return
        }
        
        if producto!.numProductos == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Este producto está agotado", viewController: selectedViewController!)
            return
        }
        
        openVentaProductoViewController(producto: producto!)
    }
    
    func manageStockScanner(producto: ProductoModel?, codigoBarras: String) {
        if producto == nil {
            openProductDetailViewController(producto: ProductoModel(codigoBarras: codigoBarras))
            return
        }

        openProductDetailViewController(producto: producto!)
    }
    
    func openProductDetailViewController(producto: ProductoModel) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller: ProductoDetailViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetail") as! ProductoDetailViewController
        controller.producto = producto
        self.navigationController!.pushViewController(controller, animated: true)
    }
}


//Click actions
extension RootViewController {
    @IBAction func didClickRightNavigationButton(_ sender: Any) {
        if selectedIndex == 0 {//Clients tab
            performSegue(withIdentifier: "AddClientIdentifier", sender: nil)
        } else if selectedIndex == 3 {
            openSettingsViewController()
        } else if selectedIndex == 1 {
            let controller: AgendaViewController =  selectedViewController as! AgendaViewController
            controller.didClickCalendarButton()
        } else if selectedIndex == 2 {
            showEditTextDialog()
        }
    }
    
    @IBAction func didClickSecondRightButton(_ sender: Any) {
        if selectedIndex == 1 {
            let controller: AgendaViewController =  selectedViewController as! AgendaViewController
            controller.didClickListarClientes()
        }
    }
    
    @IBAction func didClickLeftBarButton(_ sender: Any) {
        showEditTextDialog()
    }
}

extension RootViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch tabBarController.selectedIndex {
        case 0:
            title = "Pacientes"
            leftBarButtonItem.image = UIImage(named: "")
            if #available(iOS 13.0, *) {
                rigthNavigationButton.image = UIImage(systemName: "plus")
            } else {
                rigthNavigationButton.image = UIImage(named: "plus")
            }
            secondRightNavigationButton.image = UIImage(named: "")
        case 1:
            title = "Agenda"
            if #available(iOS 13.0, *) {
                leftBarButtonItem.image = UIImage(systemName: "plus")
                rigthNavigationButton.image = UIImage(systemName: "calendar")
                secondRightNavigationButton.image = UIImage(systemName: "person")
            } else {
                leftBarButtonItem.image = UIImage(named: "plus")
                rigthNavigationButton.image = UIImage(named: "calendar_icon")
                secondRightNavigationButton.image = UIImage(named: "person")
            }
        case 2:
            title = "Productos"
            if #available(iOS 13.0, *) {
                leftBarButtonItem.image = UIImage(systemName: "")
                rigthNavigationButton.image = UIImage(systemName: "plus")
                secondRightNavigationButton.image = UIImage(systemName: "")
            } else {
                leftBarButtonItem.image = UIImage(named: "")
                rigthNavigationButton.image = UIImage(named: "plus")
                secondRightNavigationButton.image = UIImage(named: "")
            }
        default:
            title = "ZarautzPuntura"
            leftBarButtonItem.image = UIImage(named: "")
            if #available(iOS 13.0, *) {
                rigthNavigationButton.image = UIImage(systemName: "wrench.fill")
            } else {
                rigthNavigationButton.image = UIImage(named: "wrench_fill")
            }
            secondRightNavigationButton.image = UIImage(named: "")
        }
    }
}

extension RootViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        if error == nil  && result == .sent {
            UserPreferences.saveValueInUserDefaults(value: Int64(Date().timeIntervalSince1970), key: Constants.backupKey)
        }
    }
}

extension RootViewController: ProductoScannerProtocol {
    func codigoBarrasDetected(codigoBarras: String) {
        let producto: ProductoModel? = Constants.databaseManager.productosManager.getProductWithBarcode(barcode: codigoBarras)
        if selectedIndex == 1 {
            manageAgendaScanner(producto: producto)
        } else if selectedIndex == 2 {
            manageStockScanner(producto: producto, codigoBarras: codigoBarras)
        }
    }
    
    func errorDetectingCodigoBarras() {
        CommonFunctions.showGenericAlertMessage(mensaje: "No se ha podido leer el codigo de barras", viewController: selectedViewController!)
    }
}

extension RootViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productDetailSegue" {
            let controller: ProductoDetailViewController = segue.destination as! ProductoDetailViewController
            controller.producto = sender as? ProductoModel
        }
    }
}
