//
//  RepresentativeAboutViewController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-14.
//

import UIKit
import SafariServices

class RepresentativeAboutViewController: UIViewController {
    
    
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?
    private var oldContentOffset = CGPoint.zero
    private var dragDirection: DragDirection = .Up

    @IBOutlet weak var bioContainer: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    var representative: Representative!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBiographyViews()

        // Do any additional setup after loading the view.
    }
    

    private func createBiographyViews() {
        
        for bio in representative.biography {
            let bioView = BiographyItemView()
            bioView.setup(withTitel: bio[0], withBody: bio[1])
            bioContainer.addArrangedSubview(bioView)
        }
        
        if let website = representative.website {
            let bioView = BiographyItemView()
            bioView.setup(withTitel: "Webbsida", withBody: website)
            let textRange = NSMakeRange(0, website.count)
            let attributedText = NSMutableAttributedString(string: website)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
            bioView.infoLabel.attributedText = attributedText
            let tap = UITapGestureRecognizer(target: self, action: #selector(openRepWebsite))
            bioView.infoLabel.isUserInteractionEnabled = true
            bioView.infoLabel.addGestureRecognizer(tap)
            bioContainer.addArrangedSubview(bioView)
        }
        
        if representative.biography.isEmpty, representative.website == nil {
            let noContentLabel = TitleLabel()
            noContentLabel.textAlignment = .center
            noContentLabel.font = noContentLabel.font.bold()
            noContentLabel.text = "Det verkar inte finnas något här."
            bioContainer.addArrangedSubview(noContentLabel)
        }

    }

    
    @objc
    func openRepWebsite(sender: UITapGestureRecognizer) {
        let url = URL(string: representative.website!)
        let vc = SFSafariViewController(url: url!)
        vc.preferredBarTintColor = ThemeManager.shared.theme?.primaryColor
        vc.preferredControlTintColor = UIColor.white
        vc.modalPresentationCapturesStatusBarAppearance = false
        navigationController?.present(vc, animated: true)
        
    }

}

extension RepresentativeAboutViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let delta = scrollView.contentOffset.y - oldContentOffset.y
        
        let topViewCurrentHeightConst = innerTableViewScrollDelegate?.currentHeaderHeight
        
        if let topViewUnwrappedHeight = topViewCurrentHeightConst {
            
            if delta > 0, topViewUnwrappedHeight > headerViewRange.lowerBound, scrollView.contentOffset.y > 0 {
                
                dragDirection = .Up
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
            
            if delta < 0,
               topViewUnwrappedHeight < headerViewRange.upperBound, scrollView.contentOffset.y < 0 {
                
                dragDirection = .Down
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
        }
        
        
        oldContentOffset = scrollView.contentOffset
    }
    
}
