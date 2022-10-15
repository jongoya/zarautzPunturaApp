//
//  PickerSelectorViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 17/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class PickerSelectorViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    
    var options: [String]!
    var delegate: PickerSelectorProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizePickerView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate.optionSelected(option: options[pickerView.selectedRow(inComponent: 0)])
    }
    
    func customizePickerView() {
        pickerView.setValue(AppStyle.getPrimaryTextColor(), forKey: "textColor")
    }
}

extension PickerSelectorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
}
