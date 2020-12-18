//
//  Theme.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-02.
//

import UIKit


protocol Theme {
    var name: String { get }
    var navigationBarStyle : UIBarStyle{ get }
    
    var primaryColor : UIColor { get }
    var primaryColorDark : UIColor {get}
    var colorAccent : UIColor {get}
    var loadingViewAccentColor : UIColor {get}
    var statusBarTitleTextColor : UIColor { get }
    var secondaryLightColor : UIColor { get }
    var secondaryDarkColor : UIColor { get }
    var mainBackgroundColor : UIColor { get }
    var cellBackgroundColor : UIColor { get }
    var cellBorderColor : UIColor { get }
    var mainTitleTextColor : UIColor { get }
    var mainBodyTextColor : UIColor { get }
    var debateTextColor : UIColor { get }
    var debateSpeechBubbleColor : UIColor { get }
    var buttonColor : UIColor { get }
    var segmentedControlSelectedColor : UIColor { get }
    
    var yesIndicatorColor: UIColor { get }
    var noIndicatorColor: UIColor { get }
    var absentColor: UIColor { get }
    var refrainColor: UIColor { get }
    
    var cssFileName: String { get }
}

protocol Themable {
    func applyTheme()
}

struct StandardTheme: Theme {
    var name: String = "Standard"
    var navigationBarStyle : UIBarStyle = .black
    
    var primaryColor: UIColor = UIColor(named: "RiksdagBlue")!
    var primaryColorDark: UIColor = UIColor(named: "RiksdagBlueDark")!
    var colorAccent: UIColor = UIColor(named: "RiksdagBlue")!
    var loadingViewAccentColor: UIColor = UIColor(named: "RiksdagYellow")!
    var statusBarTitleTextColor: UIColor = UIColor.white
    var secondaryLightColor: UIColor = UIColor.white
    var secondaryDarkColor: UIColor = UIColor(named: "RiksdagLightGray")!
    var mainBackgroundColor: UIColor = UIColor.white
    var cellBackgroundColor: UIColor = UIColor.white
    var cellBorderColor: UIColor = UIColor.white
    var mainTitleTextColor: UIColor = UIColor(named: "RiksdagBlue")!
    var mainBodyTextColor: UIColor = UIColor(named: "DarkText")!
    var debateTextColor: UIColor = UIColor.white
    var debateSpeechBubbleColor : UIColor = UIColor(named: "RiksdagBlue")!
    var buttonColor: UIColor = UIColor(named: "RiksdagBlue")!
    var segmentedControlSelectedColor: UIColor = UIColor(named: "RiksdagBlue")!
    
    var yesIndicatorColor: UIColor = UIColor(named: "YesVoteColorLight")!
    var noIndicatorColor: UIColor = UIColor(named: "NoVoteColorLight")!
    var absentColor: UIColor = UIColor.black
    var refrainColor: UIColor = UIColor(named: "RefrainVoteColor")!
    
    var cssFileName: String = "motion_style"
}



struct DarkTheme: Theme {
    var name: String = "Mörkt"
    var navigationBarStyle : UIBarStyle = .black
    
    var primaryColor: UIColor = UIColor.black
    var primaryColorDark: UIColor = UIColor.black
    var colorAccent: UIColor = UIColor.white
    var loadingViewAccentColor: UIColor =  UIColor.white
    var statusBarTitleTextColor: UIColor = UIColor.white
    var secondaryLightColor: UIColor = UIColor.white
    var secondaryDarkColor: UIColor = UIColor(named: "RiksdagLightGray")!
    var mainBackgroundColor: UIColor = UIColor.black
    var cellBackgroundColor: UIColor = UIColor.black
    var cellBorderColor: UIColor = UIColor.black
    var mainTitleTextColor: UIColor =  UIColor.white
    var mainBodyTextColor: UIColor =  UIColor.white
    var debateTextColor: UIColor = UIColor.white
    var debateSpeechBubbleColor : UIColor = UIColor(named: "RiksdagDarkGray")!
    var buttonColor: UIColor = UIColor.white
    var segmentedControlSelectedColor: UIColor = UIColor.black
    
    var yesIndicatorColor: UIColor = UIColor(named: "DarkResultIndicator")!
    var noIndicatorColor: UIColor = UIColor(named: "DarkResultIndicator")!
    var absentColor: UIColor = UIColor(named: "RefrainVoteColor")!
    var refrainColor: UIColor = UIColor.white
    
    var cssFileName: String = "motion_style_black"
}


struct LightTheme: Theme {
    var name: String = "Ljust"
    var navigationBarStyle : UIBarStyle = .default
    
    var primaryColor: UIColor = UIColor.white
    var primaryColorDark: UIColor = UIColor.white
    var colorAccent: UIColor = UIColor(named: "RiksdagBlueLight")!
    var loadingViewAccentColor: UIColor = UIColor(named: "RiksdagBlueLight")!
    var statusBarTitleTextColor: UIColor = UIColor(named: "RiksdagBlueLight")!
    var secondaryLightColor: UIColor = UIColor(named: "RiksdagBlueLight")!
    var secondaryDarkColor: UIColor = UIColor(named: "RiksdagLightGray")!
    var mainBackgroundColor: UIColor = UIColor.white
    var cellBackgroundColor: UIColor = UIColor.white
    var cellBorderColor: UIColor = UIColor.black
    var mainTitleTextColor: UIColor = UIColor(named: "RiksdagBlueLight")!
    var mainBodyTextColor: UIColor =  UIColor(named: "DarkText")!
    var debateTextColor: UIColor = UIColor(named: "RiksdagBlueLight")!
    var debateSpeechBubbleColor : UIColor = UIColor(named: "RiksdagBlueLightest")!
    var buttonColor: UIColor = UIColor(named: "RiksdagBlueLight")!
    var segmentedControlSelectedColor: UIColor = UIColor(named: "RiksdagBlueLight")!
    
    var yesIndicatorColor: UIColor = UIColor(named: "RiksdagBlueLightest")!
    var noIndicatorColor: UIColor = UIColor(named: "RiksdagBlueLightest")!
    var absentColor: UIColor = UIColor.black
    var refrainColor: UIColor = UIColor(named: "RefrainVoteColor")!
    
    var cssFileName: String = "motion_style_white"
}


