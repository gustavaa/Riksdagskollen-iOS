//
//  PartyInfoController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-15.
//

import UIKit

class PartyInfoController: UIViewController {
    
    var party: Party!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
