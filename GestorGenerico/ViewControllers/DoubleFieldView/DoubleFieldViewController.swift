//
//  DoubleFieldViewController.swift
//  GestorGenerico
//
//  Created by jon mikel on 14/12/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class DoubleFieldViewController: UIViewController {
    @IBOutlet weak var alergiasField: UITextView!
    @IBOutlet weak var noAlergiasField: UITextView!
    
    var delegate: AlergiasDelegate!
    var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
        
        
        if text.count != 0 {
            if text.contains("ª") {
                let fullNameArr = text.split{$0 == "ª"}.map(String.init)
                if fullNameArr.count > 0 && text.firstIndex(of: "ª")?.encodedOffset != 0 {
                    alergiasField.text = fullNameArr[0]
                }
                
                if fullNameArr.count > 0 && text.firstIndex(of: "ª")?.encodedOffset == 0 {
                    noAlergiasField.text = fullNameArr[0]
                }
                
                if fullNameArr.count > 1 {
                    noAlergiasField.text = fullNameArr[1]
                }
            } else {
                alergiasField.text = text
            }
        }
        
        
        alergiasField.backgroundColor = .white
        noAlergiasField.backgroundColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if alergiasField.text.count == 0 && noAlergiasField.text.count == 0 {
            self.delegate.alergiasTextWritten(text: "", alergias: "", noAlergias: "")
            return
        }
        
        if alergiasField.text == "Alergias" && noAlergiasField.text == "No Alergias" {
            self.delegate.alergiasTextWritten(text: "", alergias: "", noAlergias: "")
            return
        }
        
        var text: String = ""
        if alergiasField.text != "Alergias" {
            text.append(alergiasField.text)
        }
        
        text.append("ª")
        
        if noAlergiasField.text != "No Alergias" {
            text.append(noAlergiasField.text)
        }
        
        self.delegate.alergiasTextWritten(text: text, alergias: alergiasField.text == "Alergias" ? "" : alergiasField.text, noAlergias: noAlergiasField.text == "No Alergias" ? "" : noAlergiasField.text)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
