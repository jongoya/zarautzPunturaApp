//
//  ServicioTableViewCell.swift
//  GestorHeme
//
//  Created by jon mikel on 13/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class ServicioTableViewCell: UITableViewCell {
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var nombreServicioLabel: UILabel!
    @IBOutlet weak var bodyContentView: UIView!
    @IBOutlet weak var servicioImage: UIImageView!
    @IBOutlet weak var servicioColorView: UIView!
    
    func setupCell(servicio: TipoServicioModel, showColorView: Bool) {
        bodyContentView.backgroundColor = AppStyle.getBackgroundColor()
        nombreServicioLabel.textColor = AppStyle.getPrimaryTextColor()
        servicioImage.image = UIImage(named: "servicio")!.withRenderingMode(.alwaysTemplate)
        servicioImage.tintColor = AppStyle.getPrimaryTextColor()
        
        cellContentView.layer.cornerRadius = 10
        nombreServicioLabel.text = servicio.nombre
        
        servicioColorView.layer.cornerRadius = 15
        if #available(iOS 13.0, *) {
            servicioColorView.backgroundColor = UIColor(cgColor: CGColor(srgbRed: CGFloat(servicio.redColorValue / 255), green: CGFloat(servicio.greenColorValue / 255), blue: CGFloat(servicio.blueColorValue / 255), alpha: 1.0))
        } else {
            servicioColorView.backgroundColor = UIColor(red: CGFloat(servicio.redColorValue / 255), green: CGFloat(servicio.greenColorValue / 255), blue: CGFloat(servicio.blueColorValue / 255), alpha: 1.0)
        }
        
        servicioColorView.isHidden = !showColorView
    }
}
