//
//  ProtocolTabelViewCell.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-14.
//

import UIKit

class ProtocolTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var dateLabel: BodyLabel!
    
    static let identifier = "ProtocolTableViewCell"
    
    static func nib() -> UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: identifier, bundle: bundle)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with document: PartyDocument){
        titleLabel.text = trimTitle(title: document.titel)
        dateLabel.text = "Publicerad \(document.publicerad)"
    }

    func trimTitle(title: String) -> String {
        return title.split(usingRegex: ":\\d+")[1].trimmingCharacters(in: .whitespaces)
    }
    
}
