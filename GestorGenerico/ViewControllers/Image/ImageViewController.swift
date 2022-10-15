//
//  ImageViewController.swift
//  GestorGenerico
//
//  Created by jon mikel on 21/09/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var imageString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Imagen"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setImage()
    }
    
    func setImage() {
        let dataDecoded : Data = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters)!
        let image = UIImage(data: dataDecoded)!
        imageView.image = image
    }
}
