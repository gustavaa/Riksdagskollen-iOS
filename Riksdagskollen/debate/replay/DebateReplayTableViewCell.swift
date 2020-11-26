//
//  DebateReplayTableViewCell.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-23.
//

import UIKit

class DebateReplayTableViewCell: UITableViewCell {
    
    static let outgoingIdentifier = "DebateReplayOutgoingCell"
    static let incomingIdentifier = "DebateReplayIncomingCell"

    @IBOutlet weak var speechBubbleView: SpeechBubble!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var profileView: PartyProfileImage!
    
    static func outgoingNib() -> UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: outgoingIdentifier, bundle: bundle)
    }
    
    static func incomingNib() -> UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: incomingIdentifier, bundle: bundle)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
        profileView.partyIndicatorSize = 15
    }
    
    func configure(speech: Speech, isOutgoing: Bool){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        if isOutgoing {
            speechBubbleView.showOutgoingMessage(speech: speech)
        } else {
            speechBubbleView.showIncomingSpeech(speech: speech)
        }
        
        RepresentativeService.fetchRepresentative(iid: speech.intressent_id, party: speech.parti, success: {rep in
            self.profileView.profileImageView.kf.setImage(with: URL(string: rep!.bild_url_80)!, completionHandler: { _ in
                self.profileView.setParty(partyId: rep!.parti)
                self.profileView.isHidden = false
            })
        }, failure: {_ in })
        
    }
    
    override func prepareForReuse() {
        activityIndicator.isHidden = false
        profileView.profileImageView.kf.cancelDownloadTask()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
