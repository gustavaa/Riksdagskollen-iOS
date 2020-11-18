//
//  DebateListTableViewCell.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-17.
//

import UIKit
import Kingfisher

class DebateFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var debateTypeLabel: BodyLabel!
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var partyIconContainer: UIStackView!
    @IBOutlet weak var debateDateLabel: UILabel!
    @IBOutlet weak var authorLabel: BodyLabel!
    @IBOutlet weak var profileView: PartyProfileImage!
    
    static let identifier = "DebateFeedTableViewCell"
    var heightConstraint: NSLayoutConstraint?
    
    static func nib() -> UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: identifier, bundle: bundle)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configure(with partyDocument: PartyDocument) {
        self.titleLabel.text = partyDocument.titel
        self.debateDateLabel.text = "Debattdag: \(partyDocument.debattdag)"
        self.debateTypeLabel.text = partyDocument.debattnamn
        self.authorLabel.text = partyDocument.undertitel
        if partyDocument.doktyp == DocumentTypes.interpellation.docType && partyDocument.dokintressent != nil{
            RepresentativeService.fetchRepresentative(iid: partyDocument.dokintressent!.intressent[0].intressent_id, success: {rep in
                self.profileView.profileImageView.kf.setImage(with: URL(string: rep!.bild_url_80)!, completionHandler: { _ in
                    self.profileView.setParty(partyId: rep!.parti)
                    self.profileView.isHidden = false
                })
            }, failure: {_ in })
        } else {
            self.profileView.isHidden = true
        }
        
        if partyDocument.undertitel.isEmpty {
            self.authorLabel.isHidden = true
        } else {
            self.authorLabel.isHidden = false
        }
        
        for party in partyDocument.debatt.getPartiesInDebate() {
            let partyIcon = UIImageView()
            partyIcon.image = party.logo
            partyIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
            partyIcon.contentMode = .scaleAspectFit
            partyIconContainer.addArrangedSubview(partyIcon)
        }
    }
    
    override func prepareForReuse() {
        partyIconContainer.removeAllArrangedSubviews()
        profileView.profileImageView.kf.cancelDownloadTask()
        profileView.profileImageView.image = nil
        profileView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

    }
    
}
