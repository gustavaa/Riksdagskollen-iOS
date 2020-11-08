//
//  Theme.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-02.
//

import UIKit

enum Theme: Int {
    case standard, dark, light
    
    var primaryColor: UIColor {
        switch self {
        case .standard:
            return UIColor(named: "RiksdagBlue")!
        case .dark:
            return UIColor.black
        case .light:
            return UIColor.white
        }
    }

}
