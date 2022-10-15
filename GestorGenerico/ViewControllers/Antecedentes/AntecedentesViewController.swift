//
//  AntecedentesViewController.swift
//  GestorGenerico
//
//  Created by jon mikel on 21/09/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class AntecedentesViewController: UIViewController {
    @IBOutlet weak var alergiaField: UILabel!
    @IBOutlet weak var cirugiaField: UILabel!
    @IBOutlet weak var enfermedadesField: UILabel!
    @IBOutlet weak var alergiaLabel: UILabel!
    @IBOutlet weak var cirugiaLabel: UILabel!
    @IBOutlet weak var enfermedadesLabel: UILabel!
    @IBOutlet weak var alergiaArrow: UIImageView!
    @IBOutlet weak var cirugiaArrow: UIImageView!
    @IBOutlet weak var enfermedadesArrow: UIImageView!
    @IBOutlet weak var background: UIView!
    
    var cliente: ClientModel!
    var delegate: AntecedentesProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Antecedentes"
        customizeArrows()
        customizeFields()
        customizeLabels()
        setFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate.antecedentesUpdated(client: cliente)
    }
    
    func customizeLabels() {
        alergiaLabel.textColor = AppStyle.getSecondaryTextColor()
        cirugiaLabel.textColor = AppStyle.getSecondaryTextColor()
        enfermedadesLabel.textColor = AppStyle.getSecondaryTextColor()
    }
    
    func customizeFields() {
        cirugiaField.textColor = AppStyle.getPrimaryTextColor()
        alergiaField.textColor = AppStyle.getPrimaryTextColor()
        enfermedadesField.textColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeArrows() {
        if #available(iOS 13.0, *) {
            cirugiaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        } else {
            cirugiaArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
        }
        if #available(iOS 13.0, *) {
            alergiaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        } else {
            alergiaArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
        }
        if #available(iOS 13.0, *) {
            enfermedadesArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        } else {
            enfermedadesArrow.image = UIImage(named: "chevron_right")!.withRenderingMode(.alwaysTemplate)
        }
        cirugiaArrow.tintColor = AppStyle.getSecondaryColor()
        alergiaArrow.tintColor = AppStyle.getSecondaryColor()
        enfermedadesArrow.tintColor = AppStyle.getSecondaryColor()
        background.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func setFields() {
        cirugiaLabel.text = cliente.cirugias
        alergiaLabel.text = cliente.alergias.replacingOccurrences(of: "ª", with: " ")
        enfermedadesLabel.text = cliente.enfermedades
    }
    
    func getInputTextForField(inputReference: Int) -> String {
        switch inputReference {
        case 2:
            return cirugiaLabel.text!
        case 3:
            return enfermedadesLabel.text!
        default:
            return ""
        }
    }
    
    func getControllerTitleForField(inputReference: Int) -> String {
        switch inputReference {
        case 2:
            return "Cirugias"
        case 3:
            return "Anfermedades"
        default:
            return ""
        }
    }
}

extension AntecedentesViewController {
    @IBAction func didClickAlergia(_ sender: Any) {
        performSegue(withIdentifier: "alergiasViewSegue", sender: nil)
    }
    
    @IBAction func didClickCirugia(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 2)
    }
    
    @IBAction func didClickEnfermedades(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 3)
    }
}

extension AntecedentesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FieldIdentifier" {
            let controller: FieldViewController = segue.destination as! FieldViewController
            controller.inputReference = (sender as! Int)
            controller.delegate = self
            controller.keyboardType = .default
            controller.inputText = getInputTextForField(inputReference: (sender as! Int))
            controller.title = getControllerTitleForField(inputReference: (sender as! Int))
        } else if segue.identifier == "alergiasViewSegue" {
            let controller: DoubleFieldViewController = segue.destination as! DoubleFieldViewController
            controller.text = cliente.alergias
            controller.delegate = self
        }
    }
}

extension AntecedentesViewController: AddClientInputFieldProtocol {
    func textSaved(text: String, inputReference: Int) {
        switch inputReference {
        case 2:
            cliente.cirugias = text
            cirugiaLabel.text = text
            break
        case 3:
            cliente.enfermedades = text
            enfermedadesLabel.text = text
            break
        default:
            break
        }
    }
}

extension AntecedentesViewController: AlergiasDelegate {
    func alergiasTextWritten(text: String, alergias: String, noAlergias: String) {
        if alergias.count > 0 {
            cliente.observaciones = alergias
        }
        
        cliente.alergias = text
        alergiaLabel.text = text.replacingOccurrences(of: "ª", with: " ")
    }
}
