//
//  TabBarCollectionViewCell.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-10.
//

import UIKit

class TabBarCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TabBarCollectionViewCell"

    @IBOutlet weak var tabNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
