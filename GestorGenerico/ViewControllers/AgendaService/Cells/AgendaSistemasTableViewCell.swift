//
//  AgendaSistemasTableViewCell.swift
//  GestorGenerico
//
//  Created by jon mikel on 23/09/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class AgendaSistemasTableViewCell: UITableViewCell {
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var subtitulo: UILabel!
    @IBOutlet weak var sis1: UILabel!
    @IBOutlet weak var sis2: UILabel!
    @IBOutlet weak var sis3: UILabel!
    @IBOutlet weak var sis4: UILabel!
    @IBOutlet weak var sis5: UILabel!
    @IBOutlet weak var sis6: UILabel!
    
    func setupCell(sistema: SistemaModel, sistemasSeleccionados: [Int64]) {
        nombre.text = sistema.nombre
        subtitulo.text = sistema.subtitulo
        sis1.text = sistema.sis1
        sis2.text = sistema.sis2
        sis3.text = sistema.sis3
        sis4.text = sistema.sis4
        sis5.text = sistema.sis5
        sis6.text = sistema.sis6
    }
}
