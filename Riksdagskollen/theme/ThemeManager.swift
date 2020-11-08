//
//  ThemeManager.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-02.
//

import UIKit
import Foundation

let SELECTED_THEME_KEY = "SELECTED_THEME_KEY"

class ThemeManager {
    
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SELECTED_THEME_KEY) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return Theme.standard
        }
    }
    
    static func applyTheme(theme: Theme){
        UserDefaults.standard.setValue(theme.rawValue, forKey: SELECTED_THEME_KEY)
        UserDefaults.standard.synchronize()

        let sharedApplication = UIApplication.shared
                sharedApplication.delegate?.window??.tintColor = theme.primaryColor
        
    }
}
