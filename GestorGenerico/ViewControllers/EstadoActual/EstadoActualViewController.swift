//
//  EstadoActualViewController.swift
//  GestorGenerico
//
//  Created by jon mikel on 21/09/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class EstadoActualViewController: UIViewController {
    @IBOutlet weak var drenajeField: UILabel!
    @IBOutlet weak var drenajeLabel: UILabel!
    @IBOutlet weak var drenajeArrow: UIImageView!
    @IBOutlet weak var digestionField: UILabel!
    @IBOutlet weak var digestionLabel: UILabel!
    @IBOutlet weak var digestionArrow: UIImageView!
    @IBOutlet weak var descansoField: UILabel!
    @IBOutlet weak var descansoLabel: UILabel!
    @IBOutlet weak var descansoArrow: UIImageView!
    @IBOutlet weak var reglasField: UILabel!
    @IBOutlet weak var reglasLabel: UILabel!
    @IBOutlet weak var reglasArrow: UIImageView!
    @IBOutlet weak var background: UIView!
    
    var cliente: ClientModel!
    var delegate: EstadoActualProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Estado Actual"
        customizeLabels()
        customizeFields()
        customizeArrows()
        setFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate.estadoActualUpdated(client: cliente)
    }

    func customizeFields() {
        digestionField.textColor = AppStyle.getPrimaryTextColor()
        drenajeField.textColor = AppStyle.getPrimaryTextColor()
        descansoField.textColor = AppStyle.getPrimaryTextColor()
        reglasField.textColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeLabels() {
        digestionLabel.textColor = AppStyle.getSecondaryTextColor()
        drenajeLabel.textColor = AppStyle.getSecondaryTextColor()
        descansoLabel.textColor = AppStyle.getSecondaryTextColor()
        reglasLabel.textColor = AppStyle.getSecondaryTextColor()
    }
    
    func customizeArrows() {
        if #available(iOS 13.0, *) {
            digestionArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        } else {
            digestionArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
        }
        if #available(iOS 13.0, *) {
            drenajeArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        } else {
            drenajeArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
        }
        if #available(iOS 13.0, *) {
            descansoArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        } else {
            descansoArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
        }
        if #available(iOS 13.0, *) {
            reglasArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        } else {
            reglasArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
        }
        digestionArrow.tintColor = AppStyle.getSecondaryColor()
        drenajeArrow.tintColor = AppStyle.getSecondaryColor()
        descansoArrow.tintColor = AppStyle.getSecondaryColor()
        reglasArrow.tintColor = AppStyle.getSecondaryColor()
        background.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func setFields() {
        drenajeLabel.text = cliente.deposicion
        digestionLabel.text = cliente.digestion
        descansoLabel.text = cliente.descanso
        reglasLabel.text = cliente.reglas
    }
    
    func getInputTextForField(inputReference: Int) -> String {
        switch inputReference {
        case 1:
            return drenajeLabel.text!
        case 2:
            return digestionLabel.text!
        case 3:
            return descansoLabel.text!
        default:
            return reglasLabel.text!
        }
    }
    
    func getControllerTitleForField(inputReference: Int) -> String {
        switch inputReference {
        case 1:
            return "Drenaje"
        case 2:
            return "Digestión"
        case 3:
            return "Descanso"
        default:
            return "Reglas"
        }
    }
}

extension EstadoActualViewController {
    @IBAction func didClickDrenaje(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 1)
    }
    
    @IBAction func didClickDigestion(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 2)
    }
    
    @IBAction func didClickDescanso(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 3)
    }
    
    @IBAction func didClickReglas(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 4)
    }
}

extension EstadoActualViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FieldIdentifier" {
            let controller: FieldViewController = segue.destination as! FieldViewController
            controller.inputReference = (sender as! Int)
            controller.delegate = self
            controller.keyboardType = .default
            controller.inputText = getInputTextForField(inputReference: (sender as! Int))
            controller.title = getControllerTitleForField(inputReference: (sender as! Int))
        }
    }
}

extension EstadoActualViewController: AddClientInputFieldProtocol {
    func textSaved(text: String, inputReference: Int) {
        switch inputReference {
        case 1:
            cliente.deposicion = text
            drenajeLabel.text = text
            break
        case 2:
            cliente.digestion = text
            digestionLabel.text = text
            break
        case 3:
            cliente.descanso = text
            descansoLabel.text = text
            break
        default:
            cliente.reglas = text
            reglasLabel.text = text
            break
        }
    }
}
