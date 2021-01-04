//
//  PartyInfoController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-15.
//

import UIKit

class PartyInfoController: UIViewController {
    
    var party: Party!
    
    @IBOutlet weak var partyImage: UIImageView!
    @IBOutlet weak var partyNameLabel: TitleLabel!
    @IBOutlet weak var websiteLabel: BodyLabel!
    @IBOutlet weak var ideologyLabel: BodyLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        partyImage.image = party.logo
        partyNameLabel.text = party.name
        websiteLabel.text = party.website
        ideologyLabel.text = party.ideology
     
    }
    
    init(party: Party) {
        super.init(nibName: nil, bundle: nil)
        self.party = party
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
