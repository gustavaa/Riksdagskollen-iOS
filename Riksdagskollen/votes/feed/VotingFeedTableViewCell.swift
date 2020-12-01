//
//  VotesFeedTableViewCell.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-26.
//

import UIKit
import Alamofire
class VotingFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var cardLabelView: UIView!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var dateLabel: BodyLabel!
    @IBOutlet weak var yesPartyIconContainer: UIStackView!
    @IBOutlet weak var noPartyIconContainer: UIStackView!
    @IBOutlet weak var yesSideView: UIStackView!
    @IBOutlet weak var noSideView: UIStackView!
    
    
    static let identifier = "VotingFeedTableViewCell"
    private var resultRequst: DataRequest?
    
    static func nib() -> UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: identifier, bundle: bundle)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(with votesDocument: VotingDocument) {
        titleLabel.text = trimTitle(votesDocument.titel)
        dateLabel.text = votesDocument.datum
        
        let decisionCategory = DecisionCategories.getCategoryFromBet(bet: votesDocument.beteckning)
        cardLabelView.backgroundColor = ThemeManager.shared.theme?.name == ThemeManager.dark.name ? UIColor.black : decisionCategory?.categoryColor
        cardLabel.text = decisionCategory?.categoryName
        
        if votesDocument.voteResults != nil {
            arrangeVotes(results: votesDocument.voteResults!)
        } else {
            let urlString =  "http:\(votesDocument.dokument_url_html)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
            if let url = URL(string: urlString) {
                resultRequst = RiksdagenBaseService.makeStringRequest(url: url, success: { response in
                    votesDocument.votingHtmlContent = response
                    let results = VoteResult(response: response)
                    votesDocument.voteResults = results.voteResults
                    self.arrangeVotes(results: results.voteResults)
                }, failure: { error in
                    print(error)
                })
            }
        }
    }
    
    private func arrangeVotes(results: [String:[Int]]){
        var totalYes = 0
        var totalNo = 0
        var partyIcon: UIImageView
        for party in CurrentParties.values {
            if let partyResults = results[party.id] {
                var resultIndex = 0
                var max = 0
                
                for i in 0...2 {
                    if partyResults[i] > max {
                        resultIndex = i
                        max = partyResults[i]
                    }
                }
                if party.id == "-" { continue }
                partyIcon = UIImageView(image: party.logo)
                partyIcon.translatesAutoresizingMaskIntoConstraints = false
                partyIcon.widthAnchor.constraint(equalToConstant: 22).isActive = true
                partyIcon.contentMode = .scaleAspectFit
                
                if resultIndex == 0 {
                    yesPartyIconContainer.addArrangedSubview(partyIcon)
                    totalYes += max
                } else if resultIndex == 1 {
                    noPartyIconContainer.addArrangedSubview(partyIcon)
                    totalNo += max
                }
                
            }
        }
        if totalYes > totalNo {
            yesSideView.backgroundColor = ThemeManager.shared.theme?.yesIndicatorColor
        } else {
            noSideView.backgroundColor = ThemeManager.shared.theme?.noIndicatorColor
        }
    }
    
    override func prepareForReuse() {
        resultRequst?.cancel()
        yesSideView.backgroundColor = UIColor.clear
        noSideView.backgroundColor = UIColor.clear
        yesPartyIconContainer.removeAllArrangedSubviews()
        noPartyIconContainer.removeAllArrangedSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func trimTitle(_ title: String) -> String{
        return title.split(usingRegex: "[0-9]{4}\\/[0-9]{2}:[A-ö]{0,4}[0-9]{0,4}")[1].trimmingCharacters(in: .whitespaces)
    }
}
