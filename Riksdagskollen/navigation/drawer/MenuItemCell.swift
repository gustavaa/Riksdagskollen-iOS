//
//  HeaderView.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-06.
//

import Foundation
import UIKit

class MenuItemCell: UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = ThemeManager.currentTheme().mainBackgroundColor
        title.textColor = ThemeManager.currentTheme().mainBodyTextColor
    }
    
}
