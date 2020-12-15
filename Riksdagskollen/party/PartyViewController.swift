//
//  PartyViewController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-15.
//

import UIKit

class PartyViewController: UIViewController {
    
    var party: Party!
    init(party: Party) {
        self.party = party
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
