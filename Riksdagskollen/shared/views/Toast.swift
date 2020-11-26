//
//  Toast.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-26.
//

import Foundation
//
//  Crumpet.swift
//  Crumpet
//
//  Created by Chris Barker on 24/07/2020.
//  Copyright © 2020 Cocoa-Cabana Code Ltd. All rights reserved.
//

import UIKit

class Toast {

    static let shared = Toast()
    
    var speed = 0.4
    var wait = 1.8
    var backgroundColor = UIColor.black
    var textColor = UIColor.white
    var lineCount = 0
    var font = UIFont.systemFont(ofSize: 17.0)
    var textAlignment = NSTextAlignment.center
    var bottomConstraint: CGFloat = -46.0
    
    private var baking = false
    private var messages = [Messaage]()
    
    // MARK: Public functions
    
    func pop(message: String, _ view: UIView? = Toast.shared.keyWindow) {
        messages.append(Messaage(message: message, view: view))
        sendMessage()
    }
    
    // MARK: Fileprivate functions
    
    fileprivate func makeCrumpet(_ message: String, _ view: UIView?, completion: @escaping () -> Void) {
        
        baking = true
        
        // Setup UIView 🧇 (it looked like a Crumpet...)
        let crumpetView = UIView()
        crumpetView.backgroundColor = backgroundColor.withAlphaComponent(0.6)
        crumpetView.alpha = 0.0
        crumpetView.layer.cornerRadius = 15
        crumpetView.clipsToBounds  =  true
        
        // Setup UILabel 🏷
        let textLabel = UILabel()
        textLabel.textColor = textColor
        textLabel.textAlignment = textAlignment
        textLabel.text = message
        textLabel.numberOfLines = lineCount
        textLabel.font = font
        textLabel.clipsToBounds  =  true
        
        crumpetView.addSubview(textLabel)
        view?.addSubview(crumpetView)
        
        // Set Constaints 🏗
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        crumpetView.translatesAutoresizingMaskIntoConstraints = false
        
        crumpetView.addConstraints(item: textLabel, leading: 16, trailing: -16, top: 16, bottom: -16)
        view?.addConstraints(item: crumpetView, leading: 66, trailing: -66, top: nil, bottom: bottomConstraint)
        
        // Animate our UIView 🎥
        UIView.animate(withDuration: self.speed, delay: 0.0, options: .curveEaseIn, animations: {
            crumpetView.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: self.speed, delay: self.wait, options: .curveEaseOut, animations: {
                crumpetView.alpha = 0.0
            }, completion: { _ in
                crumpetView.removeFromSuperview()
                self.baking = false
                completion()
            })
        })
        
    }
        
    fileprivate func sendMessage() {
        
        guard !baking,
            let nextMessage = messages.first,
            let nextMessageText = nextMessage.message,
            let toView = nextMessage.view,
            messages.hasItems else {
                return
        }
        
        makeCrumpet(nextMessageText, toView) {
            self.messages.removeFirst()
            self.sendMessage()
        }
        
    }
    
    fileprivate var keyWindow: UIWindow? {
        return UIApplication.shared.windows.first
    }
        
}

fileprivate extension UIView {
    
    func addConstraints(item view: UIView, leading: CGFloat?, trailing: CGFloat?, top: CGFloat?, bottom: CGFloat?) {
                
        if let leading = leading {
            let constraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: leading)
            addConstraint(constraint)
        }
        if let trailing = trailing {
            let constraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: trailing)
            addConstraint(constraint)
        }
        if let top = top {
            let constraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: top)
            addConstraint(constraint)
        }
        if let bottom = bottom {
            let constraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: bottom)
            addConstraint(constraint)
        }
    }
    
}

fileprivate struct Messaage {
    var message: String?
    var view: UIView?
}

fileprivate extension String {
    var hasValue: Bool {
        return self != ""
    }
}

fileprivate extension Array {
    var hasItems: Bool {
        return self.count > 0
    }
}
