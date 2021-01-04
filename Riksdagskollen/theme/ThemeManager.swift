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
        UIBarButtonItem.appearance().tintColor = theme.statusBarTitleTextColor
        // To remove separtor line between navigation controller and view
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()

        UITableView.appearance().backgroundColor = theme.mainBackgroundColor
        UITableViewCell.appearance().backgroundColor = UIColor.clear
        
        UISegmentedControl.appearance().tintColor = theme.colorAccent
        UISegmentedControl.appearance().backgroundColor = theme.mainBackgroundColor
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: theme.segmentedControlSelectedColor], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: theme.mainBodyTextColor], for: .normal)
        
        UILabel.appearance().substituteFontName = "Cabin-Regular"
        UILabel.appearance().substituteFontNameBold = "Cabin-Regular_Bold"

        
        UIActivityIndicatorView.appearance().color = theme.debateTextColor
        UIActivityIndicatorView.appearance().style = .large

        DrawerHeaderView.appearance().backgroundColor = theme.primaryColor
        ThemedView.appearance().backgroundColor = theme.mainBackgroundColor
        AccentLabel.appearance().textColor = theme.statusBarTitleTextColor
        TitleLabel.appearance().textColor = theme.mainTitleTextColor
        BodyLabel.appearance().textColor = theme.mainBodyTextColor
        SubtitleLabel.appearance().textColor = theme.secondaryDarkColor
        AccentIcon.appearance().fillColor = theme.colorAccent
        SeparatorView.appearance().backgroundColor = theme.secondaryDarkColor
        CardView.appearance().backgroundColor = theme.cellBackgroundColor
        ShadowView.appearance().backgroundColor = theme.mainBackgroundColor
        SpeechBubble.appearance().fillColor = theme.debateSpeechBubbleColor
        SpeechBubble.appearance().speechTextColor = theme.debateTextColor
        SpeechBubble.appearance().backgroundColor = theme.mainBackgroundColor
        LoadingAnimation.appearance().fillColor = theme.loadingViewAccentColor
        TabBarCollectionView.appearance().backgroundColor = theme.primaryColor
        TabBarCollectionViewCell.appearance().backgroundColor = theme.primaryColor
        CurrentTabIndicatorView.appearance().backgroundColor = theme.statusBarTitleTextColor
        NavBarExtensionView.appearance().backgroundColor = theme.primaryColor
        
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
