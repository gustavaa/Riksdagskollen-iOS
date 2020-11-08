//
//  PushUp.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-02.
//

import Foundation

import UIKit
class PushUp: UIStoryboardSegue {
    override func perform() {

        let firstClassView = self.source.view
        let secondClassView = self.destination.view
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        secondClassView?.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
        
        if let window = UIApplication.shared.keyWindow {
            window.insertSubview(secondClassView!, aboveSubview: firstClassView!)
            
            UIView.animate(withDuration: 0.45, animations: { () -> Void in
                firstClassView?.frame = (firstClassView?.frame.offsetBy(dx: 0, dy: -screenHeight))!
                secondClassView?.frame = (secondClassView?.frame.offsetBy(dx: 0, dy: -screenHeight))!
            }, completion: {(Finished) -> Void in
                self.source.navigationController?.pushViewController(self.destination, animated: false)
            })
            
        }
    }
}
