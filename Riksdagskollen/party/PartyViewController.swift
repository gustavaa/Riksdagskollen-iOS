//
//  PartyViewController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-15.
//

import UIKit

class PartyViewController: TabbedViewController {
        
    @IBOutlet weak var navbarExtensionView: NavBarExtensionView!
    
    var party: Party!
    init(party: Party) {
        super.init(nibName: nil, bundle: nil)
        self.party = party
        orderedViewControllers.append(DocumentFeedController(party: party))
        orderedViewControllers.append(PartyInfoController(party: party))
        orderedViewControllers.append(PartyRepresentativeListController(party: party))
        tabLabels.append("Flöde")
        tabLabels.append("Om partiet")
        tabLabels.append("Ledamöter")

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
 
    
    @IBAction func tabSelected() {
        //setPageTo(pageIndex: tabController.selectedSegmentIndex)
    }
    

}




