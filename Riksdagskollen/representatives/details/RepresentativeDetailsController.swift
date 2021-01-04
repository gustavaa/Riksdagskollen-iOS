//
//  RepresentativeDetailsController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-09.
//

import UIKit
import Kingfisher

let headerViewMaxHeight: CGFloat = 300
let headerViewMinHeight: CGFloat = 44 //+  UIApplication.shared.statusBarFrame.height
let headerViewRange = headerViewMinHeight..<headerViewMaxHeight

class RepresentativeDetailsController: TabbedViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var outerHeaderView: UIView!
    
    private var currentpageIndex = 0
    
    @IBOutlet weak var nameLabel: AccentLabel!
    @IBOutlet weak var roleLabel: AccentLabel!
    @IBOutlet weak var partyProfileView: PartyProfileImage!
    @IBOutlet weak var docCountLabel: AccentLabel!
    @IBOutlet weak var voteLabel: AccentLabel!
    @IBOutlet weak var ageLabel: AccentLabel!
    
    var representative: Representative!
    var initialNavBarAttributes: [NSAttributedString.Key : Any]!
    
    init(representative: Representative) {
        super.init(nibName: nil, bundle: nil)
        self.representative = representative
        orderedViewControllers.append(RepresentativeFeedController(representative: representative, innerTableViewScrollDelegate: self))
        orderedViewControllers.append(RepresentativeAboutViewController(representative: representative, innerTableViewScrollDelegate: self))
        tabLabels.append("Ledamotsflöde")
        tabLabels.append("Om \(representative.tilltalsnamn)")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRepresentativeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialNavBarAttributes = navigationController?.navigationBar.titleTextAttributes
        let navigationTitleAlpha = normalize(val: headerViewHeightConstraint.constant, min: headerViewMinHeight, max: headerViewMaxHeight, from: 1, to: 0)
        setNavBarTitleAlpha(navigationTitleAlpha)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = initialNavBarAttributes
    }
    
    func setupRepresentativeView() {
        self.title = "\(representative.tilltalsnamn) \(representative.efternamn)"
        nameLabel.text = "\(representative.tilltalsnamn) \(representative.efternamn)"
        roleLabel.text = representative.descriptiveRole
        self.partyProfileView.setRepresentative(representative: representative, imageSize: .large)
        
        if let age = representative.age {
            ageLabel.text = String(age)
        }
        
        RepresentativeService.fetchDocumentsForRepresentative(iid: representative.intressent_id, page: 1, success: { documents, hits in
            self.docCountLabel.text = hits
        }, failure: { _ in
        
        })
        
        RepresentativeService.fetchVoteStatisticsForRepresentative(iid: representative.intressent_id, success: { statistics in
            self.voteLabel.text = statistics?.attendancePercentage
        }, failure: { _ in
        
        })
        
    }
    
    func setNavBarTitleAlpha(_ alpha: CGFloat){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navigationController?.navigationBar.tintColor.withAlphaComponent(alpha) as Any]
    }
    
    
    func normalize(val: CGFloat, min: CGFloat, max: CGFloat, from a: CGFloat = 0, to b: CGFloat = 1) -> CGFloat {
        return (b - a) * ((val - min) / (max - min)) + a
    }

}

protocol InnerTableViewScrollDelegate: class {
    var currentHeaderHeight: CGFloat { get }
    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat)
}

//MARK:- Handle headerview height when inner scrollable view controller scrolls
extension RepresentativeDetailsController: InnerTableViewScrollDelegate {
    
    var currentHeaderHeight: CGFloat {
        return headerViewHeightConstraint.constant
    }
    
    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat) {
        headerViewHeightConstraint.constant -= scrollDistance

        if headerViewHeightConstraint.constant > headerViewMaxHeight {
            headerViewHeightConstraint.constant = headerViewMaxHeight
        }
         
        if headerViewHeightConstraint.constant < headerViewMinHeight {
            headerViewHeightConstraint.constant = headerViewMinHeight
        }

        let headerViewAlpha = normalize(val: headerViewHeightConstraint.constant, min: 180, max: headerViewMaxHeight, from: 0, to: 1)
        let navigationTitleAlpha = normalize(val: headerViewHeightConstraint.constant, min: headerViewMinHeight, max: headerViewMaxHeight, from: 1, to: 0)
        headerView.alpha = headerViewAlpha
        setNavBarTitleAlpha(navigationTitleAlpha)
    }
    
}
