//
//  PlantillaViewController.swift
//  GestorGenerico
//
//  Created by jon mikel on 15/09/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import TouchDraw

class PlantillaViewController: UIViewController {
    @IBOutlet weak var drawView: TouchDrawView!
    @IBOutlet weak var plantillaContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var delegate: PlantillaProtocol!
    var imgPlantilla: String!
    var screenOrientation: String!
    var plantillaReference: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Plantilla"
        initializeDrawView()
        setInitialImage()
        addClearImageButton()
        CommonFunctions.setOrientation(orientation: UIInterfaceOrientation.landscapeRight.rawValue)
        
        if plantillaReference == 1 {
            imageView.image = UIImage(named: "cuerpo_paso1")!
        } else if plantillaReference == 2 {
            imageView.image = UIImage(named: "cuerpo2")!
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.landscapeRight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let imageString = getImage()
        delegate.imageDrawed(imageString: imageString, reference: plantillaReference)
        AppUtility.lockOrientation(.all)
        checkOrientation()
    }
    
    func initializeDrawView() {
        drawView.setWidth(3)
        drawView.setColor(.red)
    }
    
    func setInitialImage() {
        if imgPlantilla.count > 0 {
            let dataDecoded : Data = Data(base64Encoded: imgPlantilla, options: .ignoreUnknownCharacters)!
            imageView.image =  UIImage(data: dataDecoded)
        }
    }
    
    func addClearImageButton() {
        if #available(iOS 13.0, *) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "clear"), style: .done, target: self, action: #selector(didClickClearButton))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "clear"), style: .done, target: self, action: #selector(didClickClearButton))
        }
    }
    
    func getImage() -> String {
        UIGraphicsBeginImageContext(plantillaContainerView.frame.size)
        plantillaContainerView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imageData: Data = image!.pngData()!
        let imageString: String = imageData.base64EncodedString()
        return imageString
    }
    
    func checkOrientation() {
        switch screenOrientation {
            case "Portrait":
                CommonFunctions.setOrientation(orientation: UIInterfaceOrientation.portrait.rawValue)
                break
            case "PortraitDown":
                CommonFunctions.setOrientation(orientation: UIInterfaceOrientation.portraitUpsideDown.rawValue)
                break
            case "LandscapeLeft":
                CommonFunctions.setOrientation(orientation: UIInterfaceOrientation.landscapeLeft.rawValue)
                break
            case "LandscapeRight":
                CommonFunctions.setOrientation(orientation: UIInterfaceOrientation.landscapeLeft.rawValue)
                break
            default:
                CommonFunctions.setOrientation(orientation: UIInterfaceOrientation.portrait.rawValue)
                break
        }
    }
}

extension PlantillaViewController {
    @objc func didClickClearButton(sender: UIBarButtonItem) {
        drawView.clearDrawing()
        imageView.image = UIImage(named: "cuerpo.png")!
    }
}
