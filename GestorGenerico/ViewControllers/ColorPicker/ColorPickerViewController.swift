//
//  ColorPickerViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 12/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import ChromaColorPicker

class ColorPickerViewController: UIViewController {
    @IBOutlet weak var colorPicker: ChromaColorPicker!
    @IBOutlet weak var colorSlider: ChromaBrightnessSlider!
    
    var selectedColor: UIColor!
    var servicio: TipoServicioModel!
    var delegate: ColorPickerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Color"
        colorSlider.connect(to: colorPicker)
        
        addColorHandler()
        addColorChangedHandler()
        
        if delegate == nil {
            addSaveColorButton()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if delegate != nil  && selectedColor != nil {
            delegate.colorSelected(color: selectedColor)
        }
    }
    
    func addColorHandler() {
        let customHandle = ChromaColorHandle()
        if servicio != nil {
            if #available(iOS 13.0, *) {
                customHandle.color = UIColor(cgColor: CGColor(srgbRed: CGFloat(servicio.redColorValue/255), green: CGFloat(servicio.greenColorValue/255), blue: CGFloat(servicio.blueColorValue/255), alpha: 1.0))
            } else {
                customHandle.color = UIColor(red: CGFloat(servicio.redColorValue/255), green: CGFloat(servicio.greenColorValue/255), blue: CGFloat(servicio.blueColorValue/255), alpha: 1.0)
            }
        } else {
            customHandle.color = .systemBlue
        }
        
        colorPicker.addHandle(customHandle)
    }
    
    func addSaveColorButton() {
        if #available(iOS 13.0, *) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(didClickSaveButton))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "checkmark"), style: .done, target: self, action: #selector(didClickSaveButton))
        }
    }
    
    func addColorChangedHandler() {
        colorSlider.addTarget(self, action: #selector(sliderDidValueChange(_:)), for: .valueChanged)
        colorPicker.delegate = self
    }
}

extension ColorPickerViewController {
    @objc func sliderDidValueChange(_ slider: ChromaBrightnessSlider) {
        selectedColor = slider.currentColor
    }
    
    @objc func didClickSaveButton(sender: UIBarButtonItem) {
        if selectedColor == nil {
            navigationController!.popViewController(animated: true)
            return
        }
        
        let components = selectedColor.cgColor.components
        servicio.redColorValue = Float(components![0] * 255)
        servicio.greenColorValue = Float(components![1] * 255)
        servicio.blueColorValue = Float(components![2] * 255)

        CommonFunctions.showLoadingStateView(descriptionText: "Guardando color")
        WebServices.updateTipoServicio(tipoServicio: servicio, delegate: self)
    }
}

extension ColorPickerViewController: ChromaColorPickerDelegate {
    func colorPickerHandleDidChange(_ colorPicker: ChromaColorPicker, handle: ChromaColorHandle, to color: UIColor) {
        selectedColor = color
    }
}

extension ColorPickerViewController: UpdateTipoServicioProtocol {
    func servicioUpdated(servicio: TipoServicioModel) {
        Constants.databaseManager.tipoServiciosManager.updateServiceInDatabase(service: servicio)
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    func errorUpdatingServicio() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error actualizando servicio", viewController: self)
        }
    }
}
