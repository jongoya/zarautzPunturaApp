//
//  LoginViewController.swift
//  GestorGenerico
//
//  Created by jon mikel on 09/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginContentview: UIView!
    @IBOutlet weak var loginText: UILabel!
    @IBOutlet weak var loginBackground: UIImageView!
    @IBOutlet weak var iconoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:))))
        initializeTokenInSharedPreferences()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLoginStyle()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func initializeTokenInSharedPreferences() {
        if !UserPreferences.checkValueInUserDefaults(key: Constants.preferencesTokenKey) {
            UserPreferences.saveValueInUserDefaults(value: "", key: Constants.preferencesTokenKey)
        }
    }
    
    private func setLoginStyle() {
        /*if (UserPreferences.checkValueInUserDefaults(key: Constants.preferencesLoginBackgroundKey)) {
            let background: String = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesLoginBackgroundKey) as! String
            setImageWithString(stringData: background, imageView: loginBackground)
        }*/
        
        /*if (UserPreferences.checkValueInUserDefaults(key: Constants.preferencesLoginIconoKey)) {
            let icono: String = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesLoginIconoKey) as! String
            setImageWithString(stringData: icono, imageView: iconoImage)
        }*/
        
        let primaryTextColor: String = AppStyle.getLoginPrimaryTextColor()
        let secondaryTextColor: String = AppStyle.getLoginSecondaryTextColor()
        let primaryColor: String = AppStyle.getLoginPrimaryColor()
        
        customizeTextFieldWithValues(primaryColor: primaryColor, secondaryTextColor: secondaryTextColor, primaryTextColor: primaryTextColor, textField: userField, placeHolderText: "Usuario")
        customizeTextFieldWithValues(primaryColor: primaryTextColor, secondaryTextColor: secondaryTextColor, primaryTextColor: primaryTextColor, textField: passwordField, placeHolderText: "Contraseña")
        customizeLoginButton(primaryColor: primaryColor, primaryTextColor: primaryTextColor)
    }
    
    private func setImageWithString(stringData: String, imageView: UIImageView) {
        let dataDecoded : Data = Data(base64Encoded: stringData, options: .ignoreUnknownCharacters)!
        imageView.image = UIImage(data: dataDecoded)
    }
    
    private func customizeTextFieldWithValues(primaryColor: String, secondaryTextColor: String, primaryTextColor: String, textField: UITextField, placeHolderText: String) {
        textField.layer.borderColor = CommonFunctions.hexStringToUIColor(hex: primaryColor).cgColor
        textField.layer.borderWidth = AppStyle.defaultBorderWidth
        textField.backgroundColor = .white
        textField.layer.cornerRadius = AppStyle.defaultCornerRadius
        textField.textColor = CommonFunctions.hexStringToUIColor(hex: primaryTextColor)
        textField.attributedPlaceholder = NSAttributedString(string: placeHolderText,
                                                             attributes: [NSAttributedString.Key.foregroundColor: CommonFunctions.hexStringToUIColor(hex: secondaryTextColor)])
        
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftView = indentView
        textField.leftViewMode = .always
        textField.rightView = indentView
        textField.rightViewMode = .always
    }
    
    private func customizeLoginButton(primaryColor: String, primaryTextColor: String) {
        loginContentview.layer.cornerRadius = AppStyle.defaultCornerRadius
        loginContentview.layer.borderWidth = AppStyle.defaultBorderWidth
        loginContentview.layer.borderColor = CommonFunctions.hexStringToUIColor(hex: primaryColor).cgColor
        loginText.textColor = CommonFunctions.hexStringToUIColor(hex: primaryTextColor)
    }
    
    private func saveLoginDataAndChangeController(login: LoginModel) {
        UserPreferences.saveValueInUserDefaults(value: login.password, key: Constants.preferencesPasswordKey)
        UserPreferences.saveValueInUserDefaults(value: login.token, key: Constants.preferencesTokenKey)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
        if #available(iOS 13.0, *) {
            let sceneDelegate: SceneDelegate = self.view.window!.windowScene!.delegate as! SceneDelegate
            sceneDelegate.window!.rootViewController = vc
        } else {
            let appDelegate: UIApplicationDelegate =  UIApplication.shared.delegate as! AppDelegate
            appDelegate.window!?.rootViewController = vc
        }
    }
}

extension LoginViewController {
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        userField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    @IBAction func didClickLoginButton(_ sender: Any) {
        CommonFunctions.showLoadingStateView(descriptionText: "Iniciando sesión")
        let login: LoginModel = LoginModel(usuario: userField.text!, password: passwordField.text!, nombre: "ZarautzPuntura")
        WebServices.login(login: login, delegate: self)
    }
}

extension LoginViewController: LoginProtocol {
    func succesLogingIn(login: LoginModel) {
        CommonFunctions.hideLoadingStateView()
        saveLoginDataAndChangeController(login: login)
        CommonFunctions.sincronizarBaseDeDatos()
    }
    
    func errorLoginIn() {
        CommonFunctions.hideLoadingStateView()
        CommonFunctions.showGenericAlertMessage(mensaje: "Error iniciando sesion, inténtelo de nuevo", viewController: self)
    }
}
