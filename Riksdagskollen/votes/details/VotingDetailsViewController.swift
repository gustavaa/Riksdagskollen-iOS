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
    @IBOutlet weak var documentsExpandableContainer: UIStackView!
    @IBOutlet weak var votesExpandableContainer: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
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
            print("Text", try? propositionInfo?.text() ?? "nil")
            let proposition = try? propositionInfo!.text().split(usingRegex: "förslag:")[1].trimmingCharacters(in: .whitespaces)
            if let propositionText = proposition {
                let motionIds = VotingUtil.getMotionsIds(propositionText: propositionText)
                (self.decisionLabel.text, self.motions) = VotingUtil.createMotionItemsAndCleanup(text: propositionText, motionIds: motionIds)
            }
           
        }, failure: {error in
            
        })
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
