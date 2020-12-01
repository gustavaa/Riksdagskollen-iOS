//
//  VotingDetailsViewController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-26.
//

import UIKit
import Foundation
import SwiftSoup

class VotingDetailsViewController: UIViewController {
    
    var votingDocument: VotingDocument!
    private var motions = [MotionDetails]()
    private let parseStart = "<section class=\"component-case-content"

    @IBOutlet weak var mainTitleLabel: TitleLabel!
    @IBOutlet weak var pointTitleLabel: TitleLabel!
    @IBOutlet weak var propositionLabel: BodyLabel!
    @IBOutlet weak var decisionHeacerLabel: TitleLabel!
    @IBOutlet weak var decisionLabel: BodyLabel!
    @IBOutlet weak var abstractHeaderLabel: TitleLabel!
    @IBOutlet weak var abstractLabel: BodyLabel!
    
    @IBOutlet weak var docExpandableHeader: UIStackView!
    @IBOutlet weak var docExpandableContainer: UIStackView!
    @IBOutlet weak var docExpandableIcon: AccentIcon!
    
    @IBOutlet weak var votesExpandableHeader: UIStackView!
    @IBOutlet weak var votesExpandableContainer: UIStackView!
    @IBOutlet weak var votesExpandableIcon: AccentIcon!
    //var docHeightConstraint: NSLayoutConstraint?
    
    var votesIsExpanded = false
    var docsIsExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        docExpandableContainer.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    
    func setUpViews(){
        mainTitleLabel.text = votingDocument.titel
        let pattern = "förslagspunkt ([0-9]+)"
        let regexResults = self.votingDocument?.titel.groups(for: pattern)
 
        VotesService.fetchBetForVotingDocment(votingDocument: votingDocument, success: { response in
            let htmlPart = response[response.index(of: self.parseStart)!..<response.endIndex]
            let document = try? SwiftSoup.parseBodyFragment(String(htmlPart))
            let pointTitleElement = try? document?.select("#step4 > div > div > h4.medium:contains(\(regexResults![0][1]).)").first()
            let pointTitle = (try? pointTitleElement?.text().split(separator: Character("."))[1].trimmingCharacters(in: .whitespaces)) ?? "\(self.votingDocument.undertitel)"
            
            let abstractContainer = try? document?.select("section.component-case-content.component-case-section--plate > div.row.component-case-content > div").first();
            let abstractParagraphsOrNil = try? abstractContainer?.select("p,li");
            
            do {
                var abstract = ""
                if let paragraphs = abstractParagraphsOrNil {
                    for element in paragraphs {
                        if try element.iS("li") && !element.text().contains("Teckenspråk") && !element.text().contains("Lättläst") {
                            abstract.append(" • ")
                        }
                        if try !element.text().trimmingCharacters(in: .whitespaces).isEmpty && !element.text().contains("Teckenspråk") && !element.text().contains("Lättläst") {
                            try abstract.append(element.text().appending("\n\n"))
                        }
                    }
                    self.abstractLabel.text = abstract
                }
            } catch {
                self.abstractHeaderLabel.isHidden = true
                self.abstractLabel.isHidden = true
            }
           

            
            if let titleStart = regexResults?[0][0] {
                self.pointTitleLabel.text = titleStart.capitalized + ": " + pointTitle
            } else {
                self.pointTitleLabel.text = pointTitle
            }
            
            let resultSpan = try? pointTitleElement?.nextElementSibling()
            let propositionInfo = try? resultSpan?.nextElementSibling()
            
            do {
                let resultTextSplitArray = try resultSpan!.text().split(usingRegex: "Beslut:")
                if resultTextSplitArray.count > 1 {
                    let resultText = resultTextSplitArray[1].trimmingCharacters(in: .whitespaces)
                    self.decisionLabel.text = resultText
                }
            } catch {
                self.decisionLabel.isHidden = true
                self.decisionHeacerLabel.isHidden = true
            }

            let proposition = try? propositionInfo!.text().split(usingRegex: "förslag:")[1].trimmingCharacters(in: .whitespaces)
            if let propositionText = proposition {
                let motionIds = VotingUtil.getMotionsIds(propositionText: propositionText)
                let result = VotingUtil.createMotionItemsAndCleanup(text: propositionText, motionIds: motionIds)
                self.motions = result.1
                self.displayMotions()

                let attributedPropositionText = VotingUtil.boldKeywordsWithHTML(text: result.0)
                self.propositionLabel.setHTMLFromString(htmlText: attributedPropositionText)
            }
           
        }, failure: {error in
            
        })
        let docTapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDocContainerExpanded))
        docExpandableHeader.addGestureRecognizer(docTapGesture)
        let votesTapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleVotesContainerExpanded))
        votesExpandableHeader.addGestureRecognizer(votesTapGesture)
    }
    
    @objc func toggleDocContainerExpanded() {
        docsIsExpanded.toggle()
        let expanded = docsIsExpanded
        let rotationAngle = expanded ? CGFloat(Double.pi) : 0
 
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0.5,
                           animations: {
                            self.docExpandableContainer.alpha = expanded ? 1 : 0
                            self.docExpandableContainer.isHidden = !expanded
                            self.docExpandableIcon.transform = CGAffineTransform(rotationAngle: rotationAngle)
                            },
                           completion: nil)
    }
    
    @objc func toggleVotesContainerExpanded() {
        votesIsExpanded.toggle()
        let expanded = votesIsExpanded
        let rotationAngle = expanded ? CGFloat(Double.pi) : 0
 
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0.5,
                           animations: {
                            self.votesExpandableContainer.alpha = expanded ? 1 : 0
                            self.votesExpandableContainer.isHidden = !expanded
                            self.votesExpandableIcon.transform = CGAffineTransform(rotationAngle: rotationAngle)
                            },
                           completion: nil)
    }
    
    
    private func displayMotions() {
        for motion in self.motions {
            let titleLabel = TitleLabel()
            titleLabel.font = titleLabel.font.withSize(16)
            titleLabel.numberOfLines = 0
            let lowerTitle = BodyLabel()
            lowerTitle.font = lowerTitle.font.withSize(16)
            
            docExpandableContainer.addArrangedSubview(titleLabel)
            docExpandableContainer.addArrangedSubview(lowerTitle)
            VotesService.fetchMotionById(id: motion.id, success: { partyDocuments in
                guard let partyDoc = partyDocuments?.first else { return }
                
                if partyDoc.doktyp == "prop" {
                    self.docExpandableContainer.removeArrangedSubview(lowerTitle)
                }
                titleLabel.text = "[\(motion.listPosition)] \(motion.id) \(partyDoc.titel) \(motion.proposalPoint)"
                lowerTitle.text = partyDoc.undertitel
            }, failure: { error in
                
            })
        }
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
   

}
