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
    
    var primaryColorDark: UIColor {
        switch self {
        case .standard:
            return UIColor(named: "RiksdagBlueDark")!
        case .dark:
            return UIColor.black
        case .light:
            return UIColor.white
        }
    }

    var colorAccent: UIColor {
        switch self {
        case .standard:
            return UIColor(named: "RiksdagBlue")!
        case .dark:
            return UIColor.white
        case .light:
            return UIColor.white
        }
    }
    
    var loadingViewAccentColor: UIColor {
        switch self {
        case .standard:
            return UIColor(named: "RiksdagYellow")!
        case .dark:
            return UIColor.white
        case .light:
            return UIColor.white
        }
    }
    
    var statusBarTitleTextColor: UIColor {
        switch self {
        case .standard:
            return UIColor.white
        case .dark:
            return UIColor.white
        case .light:
            return UIColor.white
        }
    }
    
    var secondaryLightColor: UIColor {
        switch self {
        case .standard:
            return UIColor.white
        case .dark:
            return UIColor.white
        case .light:
            return UIColor.white
        }
    }

    var secondaryDarkColor: UIColor {
        switch self {
        case .standard:
            return UIColor(named: "RiksdagLightGray")!
        case .dark:
            return UIColor(named: "RiksdagLightGray")!
        case .light:
            return UIColor.white
        }
    }

    var mainBackgroundColor: UIColor {
        switch self {
        case .standard:
            return UIColor.white
        case .dark:
            return UIColor.black
        case .light:
            return UIColor.white
        }
    }

    var cellBackgroundColor: UIColor {
        switch self {
        case .standard:
            return UIColor.white
        case .dark:
            return UIColor.black
        case .light:
            return UIColor.white
        }
    }

    var cellBorderColor: UIColor {
        switch self {
        case .standard:
            return UIColor.white
        case .dark:
            return UIColor.black
        case .light:
            return UIColor.white
        }
    }
    
    var mainTitleTextColor: UIColor {
        switch self {
        case .standard:
            return UIColor(named: "RiksdagBlue")!
        case .dark:
            return UIColor.white
        case .light:
            return UIColor.white
        }
    }
    
    var mainBodyTextColor: UIColor {
        switch self {
        case .standard:
            return UIColor(named: "DarkText")!
        case .dark:
            return UIColor.white
        case .light:
            return UIColor.white
        }
    }
    
    var debateTextColor: UIColor {
        switch self {
        case .standard:
            return UIColor.white
        case .dark:
            return UIColor.white
        case .light:
            return UIColor.white
        }
    }
    
    var debateTextColorTitle: UIColor {
        switch self {
        case .standard:
            return UIColor.white
        case .dark:
            return UIColor.white
        case .light:
            return UIColor.white
        }
    }
    
    var buttonColor: UIColor {
        switch self {
        case .standard:
            return UIColor(named: "RiksdagBlue")!
        case .dark:
            return UIColor.white
        case .light:
            return UIColor.white
        }
    }
    

}
