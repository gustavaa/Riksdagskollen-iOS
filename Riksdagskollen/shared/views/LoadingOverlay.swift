//
//  LoadingView.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-03.
//

import Foundation
import UIKit

public class LoadingOverlay {
    let height = 100
    let width = 230
    var overlayView = UIView()
    var loadingView = LoadingAnimation()
    var isSetup = false
    
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(in window: UIView) {
        if !isSetup {
            overlayView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            overlayView.center = window.center
            overlayView.backgroundColor = ThemeManager.shared.theme?.primaryColor
            overlayView.addSubview(loadingView)
            overlayView.layer.cornerRadius = 10
            loadingView.frame = CGRect(x: 0, y: height/2-45/2, width: width, height: 45)
            isSetup = true
        }
        loadingView.startAnimating()
        window.addSubview(overlayView)
    }
    
    public func hideOverlayView() {
        loadingView.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
