//
//  AppStyle.swift
//  GestorGenerico
//
//  Created by jon mikel on 11/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation
import UIKit


class AppStyle {
    static let defaultCornerRadius: CGFloat = 10
    static let defaultBorderWidth: CGFloat = 1
    
    
    static func getLoginPrimaryTextColor() -> String {
        return "#000000"
    }
    
    static func getLoginSecondaryTextColor() -> String {
        return "#D1D1D6"
    }
    
    static func getLoginPrimaryColor() -> String {
        return "#000000"
    }
    
    static func getPrimaryTextColor() -> UIColor {
        return CommonFunctions.hexStringToUIColor(hex: "#000000")
    }
    
    static func getSecondaryTextColor() -> UIColor {
        return CommonFunctions.hexStringToUIColor(hex: "#8E8E93")
    }
    
    static func getBackgroundColor() -> UIColor {
        return CommonFunctions.hexStringToUIColor(hex: "#f9ec69")
    }
    
    static func getPrimaryColor() -> UIColor {
        return CommonFunctions.hexStringToUIColor(hex: "#e9bd15")
    }
    
    static func getSecondaryColor() -> UIColor {
        return CommonFunctions.hexStringToUIColor(hex: "#e9bd15")
    }
    
    static func getAppName() -> String {
        return "ZarautzPuntura"
    }
    
    static func getAppSmallIcon() -> String {
        return ""
    }
    
    static func getNavigationColor() -> UIColor {
        return CommonFunctions.hexStringToUIColor(hex: "#f9ec69")
    }
}
