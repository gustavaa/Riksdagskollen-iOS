//
//  PartyDocumentTableViewCell.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-11.
//

import UIKit
import Kingfisher

class PartyDocumentTableViewCell: UITableViewCell {
    
    static let identifier = "PartyDocumentTableViewCell"
    
    static func nib() -> UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: identifier, bundle: bundle)
    }
    
    @IBOutlet weak var docTypeLabel: UILabel!
    @IBOutlet weak var docTitleLabel: UILabel!
    @IBOutlet weak var docAuthorLabel: UILabel!
    @IBOutlet weak var docDateLabel: UILabel!
    @IBOutlet weak var partyProfileImageView: PartyProfileImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with document: PartyDocument){
        docTypeLabel.text = document.dokumentnamn
        docTitleLabel.text = document.titel
        docAuthorLabel.text = document.undertitel
        docDateLabel.text = "Publicerad \(document.publicerad)"
        
        if document.getSenders().count == 1 {
            partyProfileImageView.setRepresentative(iid: document.getSenders()[0], party: nil, imageSize: .small)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        partyProfileImageView.profileImageView.kf.cancelDownloadTask()
        partyProfileImageView.isHidden = true
    }
    
}
