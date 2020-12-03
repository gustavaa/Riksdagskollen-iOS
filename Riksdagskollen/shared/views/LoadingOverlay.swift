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
    
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay() {
        
        guard let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first else { return }
        
        if var topController = window.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            overlayView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            overlayView.center = window.center
            overlayView.backgroundColor = ThemeManager.shared.theme?.primaryColor
            overlayView.addSubview(loadingView)
            overlayView.layer.cornerRadius = 10
            loadingView.frame = CGRect(x: 0, y: height/2-45/2, width: width, height: 45)
            loadingView.startAnimating()
            print(loadingView.frame)
            topController.view.addSubview(overlayView)
        }
        
       
    }
    
    public func hideOverlayView() {
        loadingView.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
