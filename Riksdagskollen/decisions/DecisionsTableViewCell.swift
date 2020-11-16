//
//  DecisionsTableViewCell.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-13.
//

import UIKit

class DecisionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var decisionLabel: BodyLabel!
    @IBOutlet weak var detailsLabel: BodyLabel!
    @IBOutlet weak var adjustmentDateLabel: BodyLabel!
    @IBOutlet weak var debateDateLabel: BodyLabel!
    @IBOutlet weak var decisionDateLabel: BodyLabel!
    @IBOutlet weak var toggleIcon: AccentIcon!
    @IBOutlet weak var bodyStackView: UIStackView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var categoryBanner: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    static let identifier = "DecisionsTableViewCell"
    var heightConstraint: NSLayoutConstraint?
    
    static func nib() -> UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: identifier, bundle: bundle)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

        
        if heightConstraint == nil {
            heightConstraint = bodyStackView.heightAnchor.constraint(equalToConstant: 0)
        }
    }
    
    func configure(decisionDocument: DecisionDocument){
        titleLabel.text = decisionDocument.titel
        titleLabel.sizeToFit()
        decisionLabel.text = "Betänkande: \(decisionDocument.rm):\(decisionDocument.beteckning)"
        
        adjustmentDateLabel.text = decisionDocument.justeringsdag
        debateDateLabel.text = decisionDocument.debattdag
        decisionDateLabel.text = decisionDocument.beslutsdag
        detailsLabel.text = decisionDocument.notis.htmlToString

        heightConstraint?.isActive = !decisionDocument.isExpanded
        let rotationAngle = decisionDocument.isExpanded ? CGFloat(Double.pi) : 0
        self.toggleIcon.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        let decisionCategory = DecisionCategories.getCategoryFromBet(bet: decisionDocument.beteckning)
        categoryBanner.backgroundColor = decisionCategory?.categoryColor
        categoryLabel.text = decisionCategory?.categoryName
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    

    func setExpanded(expanded: Bool) {
        self.layoutIfNeeded()
        let rotationAngle = expanded ? CGFloat(Double.pi) : 0
 
        UIView.animate(withDuration: 0.2,
                       delay: 0.1,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0.5,
                           animations: {
                            self.bodyStackView.alpha = expanded ? 1 : 0
                            //self.bodyStackView.isHidden = !expanded
                            self.heightConstraint?.isActive = !expanded
                            self.toggleIcon.transform = CGAffineTransform(rotationAngle: rotationAngle)
                            self.layoutIfNeeded()
//                            self.superview?.layoutIfNeeded()
                            },
                           completion: nil)
    }
    
    override func prepareForReuse() {
        self.toggleIcon.transform = CGAffineTransform(rotationAngle: 0)
    }
    

}
