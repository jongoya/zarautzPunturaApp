//
//  StockProductosViewController.swift
//  GestorGenerico
//
//  Created by jon mikel on 21/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class StockProductosViewController: UIViewController {
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var productosTableView: UITableView!
    @IBOutlet weak var tableSeparatorView: UIView!
    
    var tableRefreshControl: UIRefreshControl = UIRefreshControl()
    var emptyStateLabel: UILabel!
    var productos: [ProductoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefreshControl()
        customizeTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProductos()
    }
    
    func addRefreshControl() {
        tableRefreshControl.addTarget(self, action: #selector(refreshProducts), for: .valueChanged)
        productosTableView.refreshControl = tableRefreshControl
    }
    
    func customizeTableView() {
        productosTableView.backgroundColor = AppStyle.getBackgroundColor()
        productosTableView.sectionIndexColor = AppStyle.getPrimaryColor()
        tableSeparatorView.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    private func getProductos() {
        if emptyStateLabel != nil {
            emptyStateLabel.removeFromSuperview()
            emptyStateLabel = nil
        }
        
        productos = Constants.databaseManager.productosManager.getAllProductos()
        
        if productos.count == 0 {
            emptyStateLabel = CommonFunctions.createEmptyState(emptyText: "No dispone de productos, clique en el botón + para añadir un producto", parentView: self.view)
        }
        
        productosTableView.reloadData()
    }
}

extension StockProductosViewController {
    @objc func refreshProducts() {
        WebServices.getProductos(delegate: self)
    }
}

extension StockProductosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "productoCell") as! ProductoTableViewCell
        cell.setupCell(producto: productos[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "productDetailSegue", sender: productos[indexPath.row])
    }
}

extension StockProductosViewController: GetProductosProtocol {
    func successGettingProductos() {
        tableRefreshControl.endRefreshing()
        getProductos()
    }
    
    func errorGettingProductos() {
        tableRefreshControl.endRefreshing()
        CommonFunctions.showGenericAlertMessage(mensaje: "Error recogiendo los productos", viewController: self)
    }
}

extension StockProductosViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productDetailSegue" {
            let controller: ProductoDetailViewController = segue.destination as! ProductoDetailViewController
            controller.producto = sender as? ProductoModel
        }
    }
}

