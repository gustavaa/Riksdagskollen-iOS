//
//  RepresentativeTableViewCell.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-07.
//

import UIKit
import Kingfisher

class RepresentativeTableViewCell: UITableViewCell {
    
    static let identifier = "RepresentativeTableViewCell"
    @IBOutlet weak var professionLabel: BodyLabel!
    @IBOutlet weak var professionRow: UIStackView!
    @IBOutlet weak var districtLabel: BodyLabel!
    @IBOutlet weak var ageLabel: BodyLabel!
    @IBOutlet weak var nameLabel: TitleLabel!
    @IBOutlet weak var profileView: PartyProfileImage!
    
    static func nib() -> UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: identifier, bundle: bundle)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with representative: Representative){
        
        nameLabel.text = "\(representative.tilltalsnamn) \(representative.efternamn)"
        ageLabel.text = String(representative.age ?? 0)
        districtLabel.text = representative.valkrets
        profileView.setRepresentative(representative: representative, imageSize: .medium)
        
        guard let repTitel = representative.title else { professionRow.isHidden = true; return }
        professionLabel.text = repTitel
    }

    override func prepareForReuse() {
        professionRow.isHidden = false
        profileView.profileImageView.kf.cancelDownloadTask()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
