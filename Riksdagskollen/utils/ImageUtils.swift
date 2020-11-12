//
//  ImageUtils.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-11.
//

import Foundation
import UIKit

extension UIImageView {
    
    public func imageFromURL(urlString: String) {

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
                self.layoutIfNeeded()
                self.needsUpdateConstraints()
            })

        }).resume()
    }
    
    public func showViewWithHeight(height: CGFloat) {
        self.isHidden = false
        heightConstraint?.constant = height
        self.needsUpdateConstraints()
        self.layoutIfNeeded()
    }
    
    public func hideView(){
        self.isHidden = true
        heightConstraint?.constant = 0
        self.needsUpdateConstraints()
        self.layoutIfNeeded()
    }
    
    var heightConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
}
