//
//  RiksdagenViewController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-04.
//

import Foundation
import UIKit
import KYDrawerController

class RiksdagenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.backgroundColor = UIColor.red//UIColor(named: "RiksdagsBlue")
        navigationController?.navigationBar.tintColor = UIColor.white

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "menu"),
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(didTapOpenButton)
        )
    }
    
    @objc func didTapOpenButton(_ sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
}
