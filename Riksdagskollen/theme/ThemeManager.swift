//
//  ThemeManager.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-02.
//

import UIKit
import Foundation
import SideMenu


let SELECTED_THEME_KEY = "SELECTED_THEME_KEY"

class ThemeManager {
    
    var theme: Theme?
    static let dark = DarkTheme()
    static let standard = StandardTheme()
    static let light = LightTheme()
    
    static var themes: [Theme] = [standard, dark, light]
    
    static var shared: ThemeManager = {
        let themesManager = ThemeManager()
        return themesManager
    }()
    
    func setTheme(theme : Theme){
        self.theme = theme
        UserDefaults.standard.setValue(theme.name, forKey: SELECTED_THEME_KEY)
        UserDefaults.standard.synchronize()
        
        UIApplication.shared.statusBarView!.backgroundColor = theme.primaryColor

        UINavigationBar.appearance().barStyle = theme.navigationBarStyle
        UINavigationBar.appearance().barTintColor = theme.primaryColor
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = theme.statusBarTitleTextColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.statusBarTitleTextColor]

        UITableView.appearance().backgroundColor = theme.mainBackgroundColor
        UITableViewCell.appearance().backgroundColor = UIColor.clear
        
        UISegmentedControl.appearance().tintColor = theme.colorAccent
        UISegmentedControl.appearance().backgroundColor = theme.mainBackgroundColor
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: theme.segmentedControlSelectedColor], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: theme.mainBodyTextColor], for: .normal)
        
        DrawerHeaderView.appearance().backgroundColor = theme.primaryColor
        ThemedView.appearance().backgroundColor = theme.mainBackgroundColor
        TitleLabel.appearance().textColor = theme.mainTitleTextColor
        BodyLabel.appearance().textColor = theme.mainBodyTextColor
        SubtitleLabel.appearance().textColor = theme.secondaryDarkColor
        AccentIcon.appearance().fillColor = theme.colorAccent
        CardView.appearance().backgroundColor = theme.cellBackgroundColor
        ShadowView.appearance().backgroundColor = theme.mainBackgroundColor
        
        
        
        refreshAllView()
    }
    
    func refreshAllView(){
        for window in UIApplication.shared.windows {
            if !window.isKind(of: NSClassFromString("UITextEffectsWindow") ?? NSString.classForCoder()) {
                window.subviews.forEach {
                    $0.removeFromSuperview()
                    window.addSubview($0)
                }
            }
        }
    }
    
    static func getStoredTheme() -> Theme {
        if let storedTheme = UserDefaults.standard.string(forKey: SELECTED_THEME_KEY) {
            for theme in themes {
                if theme.name == storedTheme {
                    return theme
                }
            }
        }
        return themes[0]
    }
    
}
