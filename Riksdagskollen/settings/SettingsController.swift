//
//  SettingsController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-12.
//

import Foundation
import UIKit
import SideMenu

class SettingsController: UIViewController {
    
    @IBOutlet weak var themeSelector: UISegmentedControl!
    @IBOutlet weak var asd: UILabel!
    
    override func viewDidLoad() {
        themeSelector.removeAllSegments()
        for (index, theme) in ThemeManager.themes.enumerated() {
            themeSelector.insertSegment(withTitle: theme.name, at: index, animated: false)
            if ThemeManager.shared.theme?.name == theme.name {
                themeSelector.selectedSegmentIndex = index
            }
        }
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        let selectedTheme = ThemeManager.themes[themeSelector.selectedSegmentIndex]
        ThemeManager.shared.setTheme(theme: selectedTheme)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.shared.theme?.statusBarTitleTextColor]
        navigationController?.navigationBar.tintColor = ThemeManager.shared.theme?.statusBarTitleTextColor
        navigationController?.navigationBar.barTintColor = ThemeManager.shared.theme?.primaryColor
    }
    
}
