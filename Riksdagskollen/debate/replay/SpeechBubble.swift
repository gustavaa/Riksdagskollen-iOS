//
//  SpeechBubble.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-18.
//

import Foundation
import UIKit

class SpeechBubble: UIView {
    
    private let rectangleCornerRadius: CGFloat = 19
    private var speechLabel = UILabel()
    private var headerLabel = UILabel()
    
    @objc dynamic var fillColor: UIColor?
    @objc dynamic var speechTextColor: UIColor?
    @IBInspectable var isOutgoing: Bool = false {
        didSet {
            initialize()
        }
    }

    func showIncomingSpeech(speech: Speech) {
        showSpeech(speech: speech)
    }
    
    func showOutgoingMessage(speech: Speech) {
        showSpeech(speech: speech)
    }
    
    private func initialize(){
        
        let leftPadding: CGFloat = isOutgoing ? 0 : 21
        let rightPadding: CGFloat = isOutgoing ? 21 : 0
        
        headerLabel.numberOfLines = 2
        headerLabel.font = UIFont.systemFont(ofSize: 15)
        headerLabel.font = headerLabel.font.bold()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerLabel)
        
        headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16 + leftPadding).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16 - rightPadding).isActive = true

        speechLabel.numberOfLines = 0
        speechLabel.font = UIFont.systemFont(ofSize: 14)
        speechLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(speechLabel)
        speechLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8).isActive = true
        speechLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16 + leftPadding).isActive = true
        speechLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16 - rightPadding).isActive = true
        speechLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
    }
    
    private func showSpeech(speech: Speech){
        speechLabel.text = speech.anforandetext.htmlToString
        headerLabel.text = speech.talare
        self.setNeedsDisplay()
    }
    
    
    
    override func draw(_ rect: CGRect) {
        speechLabel.textColor = self.speechTextColor
        headerLabel.textColor = self.speechTextColor

        if isOutgoing {
            drawOutgoing(rect)
        } else {
            drawIncoming(rect)
        }
    }
    
    
    private func drawOutgoing(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width-21, height: height), byRoundingCorners: [.topLeft, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: rectangleCornerRadius, height: rectangleCornerRadius))
        rectanglePath.close()
        fillColor?.setFill()
        rectanglePath.fill()
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: width-40, y: 24))
        bezierPath.addLine(to: CGPoint(x: width, y: 0))
        bezierPath.addLine(to: CGPoint(x: width-40, y: 0))
        bezierPath.addLine(to: CGPoint(x: width-40, y: 24))
        bezierPath.close()
        fillColor?.setFill()
        bezierPath.fill()
    }
    
    private func drawIncoming(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 21, y: 0, width: width-21, height: height), byRoundingCorners: [.topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: rectangleCornerRadius, height: rectangleCornerRadius))
        rectanglePath.close()
        fillColor?.setFill()
        rectanglePath.fill()

        // Triangle
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 40, y: 24))
        bezierPath.addLine(to: CGPoint(x: 0, y: -0))
        bezierPath.addLine(to: CGPoint(x: 40, y: -0))
        bezierPath.addLine(to: CGPoint(x: 40, y: 24))
        bezierPath.close()
        fillColor?.setFill()
        bezierPath.fill()
    }
}
