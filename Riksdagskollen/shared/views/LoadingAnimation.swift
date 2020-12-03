//
//  LoadingView.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-02.
//

import Foundation
import UIKit

class LoadingAnimation: UIView {
    
    private let drawingLayer = CAShapeLayer()
    private let crownPath = getCrownPath().cgPath
    private let introCircle = getCircleWith(xPos: -50).cgPath
    private let firstCirclePath = getCircleWith(xPos: 15).cgPath
    private let secondCirclePath = getCircleWith(xPos: 187.5).cgPath
    private let outroCircle = getCircleWith(xPos: 280).cgPath
    private var isAnimating = true

    @objc dynamic var fillColor: UIColor?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        clipsToBounds = true
    }
        
    init(){
        super.init(frame: .zero)
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        clipsToBounds = true
    }
    func stopAnimating(){
        isAnimating = false
    }
    func startAnimating(){
        isAnimating = true
        CATransaction.begin()
        let intro = createAnimatePathChange(for: drawingLayer, toPath: firstCirclePath, offset: 0, duration: 0.2)
        let anim1 = createAnimatePathChange(for: drawingLayer, toPath: crownPath, offset: 0.4, duration: 0.6)
        let anim2 = createAnimatePathChange(for: drawingLayer, toPath: secondCirclePath, offset: 1, duration: 0.6)
        let outro = createAnimatePathChange(for: drawingLayer, toPath: outroCircle, offset: 1.8, duration: 0.2)
        CATransaction.setCompletionBlock(){
            self.drawingLayer.path = self.introCircle
            if(self.isAnimating){ self.startAnimating() }
        }
        drawingLayer.add(intro, forKey: nil)
        drawingLayer.add(anim1, forKey: nil)
        drawingLayer.add(anim2, forKey: nil)
        drawingLayer.add(outro, forKey: nil)
        CATransaction.commit()
    }
    
    override func draw(_ rect: CGRect) {
        drawingLayer.frame = rect
        drawingLayer.path = introCircle
        drawingLayer.fillColor = fillColor?.cgColor
        layer.addSublayer(drawingLayer)
        super.draw(rect)
    }
    
    private func createAnimatePathChange(for layer: CAShapeLayer, toPath: CGPath, offset: Double, duration: Double) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        animation.repeatCount = 0
        animation.beginTime = CACurrentMediaTime() + offset
        animation.fromValue = layer.path
        animation.toValue = toPath
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = .init(controlPoints: 1, 0, 0.46, 1)
        layer.path = toPath
        return animation
    }
    
    private static func getCircleWith(xPos: CGFloat) -> UIBezierPath {
        let circlePath = UIBezierPath()
        circlePath.move(to: CGPoint(x: 17.5, y: 35.79))
        circlePath.addCurve(to: CGPoint(x: 16.17, y: 36.14), controlPoint1: CGPoint(x: 17.06, y: 35.93), controlPoint2: CGPoint(x: 16.62, y: 36.04))
        circlePath.addCurve(to: CGPoint(x: 14.79, y: 36.35), controlPoint1: CGPoint(x: 15.72, y: 36.23), controlPoint2: CGPoint(x: 15.26, y: 36.3))
        circlePath.addCurve(to: CGPoint(x: 13.37, y: 36.42), controlPoint1: CGPoint(x: 14.33, y: 36.4), controlPoint2: CGPoint(x: 13.85, y: 36.42))
        circlePath.addCurve(to: CGPoint(x: 11.96, y: 36.35), controlPoint1: CGPoint(x: 12.9, y: 36.42), controlPoint2: CGPoint(x: 12.42, y: 36.4))
        circlePath.addCurve(to: CGPoint(x: 10.58, y: 36.14), controlPoint1: CGPoint(x: 11.49, y: 36.3), controlPoint2: CGPoint(x: 11.03, y: 36.23))
        circlePath.addCurve(to: CGPoint(x: 9.25, y: 35.79), controlPoint1: CGPoint(x: 10.13, y: 36.04), controlPoint2: CGPoint(x: 9.69, y: 35.93))
        circlePath.addCurve(to: CGPoint(x: 7.98, y: 35.32), controlPoint1: CGPoint(x: 8.82, y: 35.65), controlPoint2: CGPoint(x: 8.39, y: 35.5))
        circlePath.addCurve(to: CGPoint(x: 6.77, y: 34.73), controlPoint1: CGPoint(x: 7.56, y: 35.14), controlPoint2: CGPoint(x: 7.16, y: 34.95))
        circlePath.addCurve(to: CGPoint(x: 5.62, y: 34.03), controlPoint1: CGPoint(x: 6.37, y: 34.52), controlPoint2: CGPoint(x: 5.99, y: 34.28))
        circlePath.addCurve(to: CGPoint(x: 4.56, y: 33.22), controlPoint1: CGPoint(x: 5.26, y: 33.78), controlPoint2: CGPoint(x: 4.9, y: 33.51))
        circlePath.addCurve(to: CGPoint(x: 3.57, y: 32.32), controlPoint1: CGPoint(x: 4.22, y: 32.94), controlPoint2: CGPoint(x: 3.89, y: 32.64))
        circlePath.addCurve(to: CGPoint(x: 2.68, y: 31.33), controlPoint1: CGPoint(x: 3.26, y: 32), controlPoint2: CGPoint(x: 2.96, y: 31.67))
        circlePath.addCurve(to: CGPoint(x: 1.88, y: 30.25), controlPoint1: CGPoint(x: 2.4, y: 30.98), controlPoint2: CGPoint(x: 2.13, y: 30.62))
        circlePath.addCurve(to: CGPoint(x: 1.19, y: 29.09), controlPoint1: CGPoint(x: 1.63, y: 29.88), controlPoint2: CGPoint(x: 1.4, y: 29.49))
        circlePath.addCurve(to: CGPoint(x: 0.6, y: 27.87), controlPoint1: CGPoint(x: 0.97, y: 28.7), controlPoint2: CGPoint(x: 0.78, y: 28.29))
        circlePath.addCurve(to: CGPoint(x: 0.14, y: 26.58), controlPoint1: CGPoint(x: 0.43, y: 27.45), controlPoint2: CGPoint(x: 0.27, y: 27.02))
        circlePath.addCurve(to: CGPoint(x: -0.21, y: 25.24), controlPoint1: CGPoint(x: 0, y: 26.15), controlPoint2: CGPoint(x: -0.11, y: 25.7))
        circlePath.addCurve(to: CGPoint(x: -0.42, y: 23.85), controlPoint1: CGPoint(x: -0.3, y: 24.79), controlPoint2: CGPoint(x: -0.37, y: 24.32))
        circlePath.addCurve(to: CGPoint(x: -0.49, y: 22.42), controlPoint1: CGPoint(x: -0.46, y: 23.38), controlPoint2: CGPoint(x: -0.49, y: 22.9))
        circlePath.addCurve(to: CGPoint(x: -0.42, y: 20.99), controlPoint1: CGPoint(x: -0.49, y: 21.94), controlPoint2: CGPoint(x: -0.46, y: 21.46))
        circlePath.addCurve(to: CGPoint(x: -0.21, y: 19.6), controlPoint1: CGPoint(x: -0.37, y: 20.52), controlPoint2: CGPoint(x: -0.3, y: 20.05))
        circlePath.addCurve(to: CGPoint(x: 0.14, y: 18.26), controlPoint1: CGPoint(x: -0.11, y: 19.14), controlPoint2: CGPoint(x: 0, y: 18.7))
        circlePath.addCurve(to: CGPoint(x: 0.6, y: 16.97), controlPoint1: CGPoint(x: 0.27, y: 17.82), controlPoint2: CGPoint(x: 0.43, y: 17.39))
        circlePath.addCurve(to: CGPoint(x: 1.19, y: 15.75), controlPoint1: CGPoint(x: 0.78, y: 16.55), controlPoint2: CGPoint(x: 0.97, y: 16.14))
        circlePath.addCurve(to: CGPoint(x: 1.88, y: 14.59), controlPoint1: CGPoint(x: 1.4, y: 15.35), controlPoint2: CGPoint(x: 1.63, y: 14.97))
        circlePath.addCurve(to: CGPoint(x: 2.68, y: 13.52), controlPoint1: CGPoint(x: 2.13, y: 14.22), controlPoint2: CGPoint(x: 2.4, y: 13.86))
        circlePath.addCurve(to: CGPoint(x: 3.57, y: 12.52), controlPoint1: CGPoint(x: 2.96, y: 13.17), controlPoint2: CGPoint(x: 3.26, y: 12.84))
        circlePath.addCurve(to: CGPoint(x: 4.56, y: 11.62), controlPoint1: CGPoint(x: 3.89, y: 12.2), controlPoint2: CGPoint(x: 4.21, y: 11.9))
        circlePath.addCurve(to: CGPoint(x: 5.62, y: 10.81), controlPoint1: CGPoint(x: 4.9, y: 11.33), controlPoint2: CGPoint(x: 5.26, y: 11.06))
        circlePath.addCurve(to: CGPoint(x: 6.77, y: 10.11), controlPoint1: CGPoint(x: 5.99, y: 10.56), controlPoint2: CGPoint(x: 6.37, y: 10.33))
        circlePath.addCurve(to: CGPoint(x: 7.98, y: 9.52), controlPoint1: CGPoint(x: 7.16, y: 9.89), controlPoint2: CGPoint(x: 7.56, y: 9.7))
        circlePath.addCurve(to: CGPoint(x: 9.25, y: 9.05), controlPoint1: CGPoint(x: 8.39, y: 9.34), controlPoint2: CGPoint(x: 8.82, y: 9.19))
        circlePath.addCurve(to: CGPoint(x: 10.58, y: 8.7), controlPoint1: CGPoint(x: 9.69, y: 8.91), controlPoint2: CGPoint(x: 10.13, y: 8.8))
        circlePath.addCurve(to: CGPoint(x: 11.96, y: 8.49), controlPoint1: CGPoint(x: 11.03, y: 8.61), controlPoint2: CGPoint(x: 11.49, y: 8.54))
        circlePath.addCurve(to: CGPoint(x: 13.37, y: 8.42), controlPoint1: CGPoint(x: 12.42, y: 8.44), controlPoint2: CGPoint(x: 12.9, y: 8.42))
        circlePath.addLine(to: CGPoint(x: 13.37, y: 8.42))
        circlePath.addCurve(to: CGPoint(x: 14.79, y: 8.49), controlPoint1: CGPoint(x: 13.85, y: 8.42), controlPoint2: CGPoint(x: 14.33, y: 8.44))
        circlePath.addCurve(to: CGPoint(x: 16.17, y: 8.7), controlPoint1: CGPoint(x: 15.26, y: 8.54), controlPoint2: CGPoint(x: 15.72, y: 8.61))
        circlePath.addCurve(to: CGPoint(x: 17.5, y: 9.05), controlPoint1: CGPoint(x: 16.62, y: 8.8), controlPoint2: CGPoint(x: 17.06, y: 8.91))
        circlePath.addCurve(to: CGPoint(x: 18.77, y: 9.52), controlPoint1: CGPoint(x: 17.93, y: 9.19), controlPoint2: CGPoint(x: 18.35, y: 9.34))
        circlePath.addCurve(to: CGPoint(x: 19.98, y: 10.11), controlPoint1: CGPoint(x: 19.18, y: 9.7), controlPoint2: CGPoint(x: 19.59, y: 9.89))
        circlePath.addCurve(to: CGPoint(x: 21.12, y: 10.81), controlPoint1: CGPoint(x: 20.37, y: 10.33), controlPoint2: CGPoint(x: 20.75, y: 10.56))
        circlePath.addCurve(to: CGPoint(x: 22.19, y: 11.62), controlPoint1: CGPoint(x: 21.49, y: 11.06), controlPoint2: CGPoint(x: 21.85, y: 11.33))
        circlePath.addCurve(to: CGPoint(x: 23.18, y: 12.52), controlPoint1: CGPoint(x: 22.53, y: 11.9), controlPoint2: CGPoint(x: 22.86, y: 12.2))
        circlePath.addCurve(to: CGPoint(x: 24.07, y: 13.52), controlPoint1: CGPoint(x: 23.49, y: 12.84), controlPoint2: CGPoint(x: 23.79, y: 13.17))
        circlePath.addCurve(to: CGPoint(x: 24.87, y: 14.59), controlPoint1: CGPoint(x: 24.35, y: 13.86), controlPoint2: CGPoint(x: 24.62, y: 14.22))
        circlePath.addCurve(to: CGPoint(x: 25.56, y: 15.75), controlPoint1: CGPoint(x: 25.12, y: 14.97), controlPoint2: CGPoint(x: 25.35, y: 15.35))
        circlePath.addCurve(to: CGPoint(x: 26.15, y: 16.97), controlPoint1: CGPoint(x: 25.77, y: 16.14), controlPoint2: CGPoint(x: 25.97, y: 16.55))
        circlePath.addCurve(to: CGPoint(x: 26.61, y: 18.26), controlPoint1: CGPoint(x: 26.32, y: 17.39), controlPoint2: CGPoint(x: 26.48, y: 17.82))
        circlePath.addCurve(to: CGPoint(x: 26.95, y: 19.6), controlPoint1: CGPoint(x: 26.75, y: 18.7), controlPoint2: CGPoint(x: 26.86, y: 19.14))
        circlePath.addCurve(to: CGPoint(x: 27.16, y: 20.99), controlPoint1: CGPoint(x: 27.05, y: 20.05), controlPoint2: CGPoint(x: 27.12, y: 20.52))
        circlePath.addCurve(to: CGPoint(x: 27.24, y: 22.42), controlPoint1: CGPoint(x: 27.21, y: 21.46), controlPoint2: CGPoint(x: 27.24, y: 21.94))
        circlePath.addCurve(to: CGPoint(x: 27.16, y: 23.85), controlPoint1: CGPoint(x: 27.24, y: 22.9), controlPoint2: CGPoint(x: 27.21, y: 23.38))
        circlePath.addCurve(to: CGPoint(x: 26.95, y: 25.24), controlPoint1: CGPoint(x: 27.12, y: 24.32), controlPoint2: CGPoint(x: 27.05, y: 24.79))
        circlePath.addCurve(to: CGPoint(x: 26.61, y: 26.58), controlPoint1: CGPoint(x: 26.86, y: 25.7), controlPoint2: CGPoint(x: 26.75, y: 26.15))
        circlePath.addCurve(to: CGPoint(x: 26.15, y: 27.87), controlPoint1: CGPoint(x: 26.48, y: 27.02), controlPoint2: CGPoint(x: 26.32, y: 27.45))
        circlePath.addCurve(to: CGPoint(x: 25.56, y: 29.09), controlPoint1: CGPoint(x: 25.97, y: 28.29), controlPoint2: CGPoint(x: 25.77, y: 28.7))
        circlePath.addCurve(to: CGPoint(x: 24.87, y: 30.25), controlPoint1: CGPoint(x: 25.35, y: 29.49), controlPoint2: CGPoint(x: 25.12, y: 29.88))
        circlePath.addCurve(to: CGPoint(x: 24.07, y: 31.33), controlPoint1: CGPoint(x: 24.62, y: 30.62), controlPoint2: CGPoint(x: 24.35, y: 30.98))
        circlePath.addCurve(to: CGPoint(x: 23.18, y: 32.32), controlPoint1: CGPoint(x: 23.79, y: 31.67), controlPoint2: CGPoint(x: 23.49, y: 32))
        circlePath.addCurve(to: CGPoint(x: 22.19, y: 33.22), controlPoint1: CGPoint(x: 22.86, y: 32.64), controlPoint2: CGPoint(x: 22.53, y: 32.94))
        circlePath.addCurve(to: CGPoint(x: 21.12, y: 34.03), controlPoint1: CGPoint(x: 21.85, y: 33.51), controlPoint2: CGPoint(x: 21.49, y: 33.78))
        circlePath.addCurve(to: CGPoint(x: 19.98, y: 34.73), controlPoint1: CGPoint(x: 20.76, y: 34.28), controlPoint2: CGPoint(x: 20.37, y: 34.52))
        circlePath.addCurve(to: CGPoint(x: 18.77, y: 35.32), controlPoint1: CGPoint(x: 19.59, y: 34.95), controlPoint2: CGPoint(x: 19.18, y: 35.14))
        circlePath.addCurve(to: CGPoint(x: 17.5, y: 35.79), controlPoint1: CGPoint(x: 18.35, y: 35.5), controlPoint2: CGPoint(x: 17.93, y: 35.65))
        circlePath.close()
        circlePath.apply(CGAffineTransform(translationX: xPos, y: 0))
        circlePath.move(to: CGPoint(x: 115.12, y: 36.42))
        circlePath.addLine(to: CGPoint(x: 115.12, y: 36.42))
        circlePath.addLine(to: CGPoint(x: 115.12, y: 36.42))
        circlePath.addLine(to: CGPoint(x: 115.12, y: 36.42))
        circlePath.addLine(to: CGPoint(x: 115.12, y: 36.42))
        circlePath.close()
        return circlePath
    }
    
    private static func getCrownPath() -> UIBezierPath {
        let crownPath = UIBezierPath()
        crownPath.move(to: CGPoint(x: 137.81, y: 3.6))
        crownPath.addLine(to: CGPoint(x: 137.81, y: 3.6))
        crownPath.addCurve(to: CGPoint(x: 143.91, y: 0.09), controlPoint1: CGPoint(x: 139.06, y: -0.72), controlPoint2: CGPoint(x: 143.91, y: 0.09))
        crownPath.addCurve(to: CGPoint(x: 140.27, y: 33.15), controlPoint1: CGPoint(x: 142.7, y: 11.11), controlPoint2: CGPoint(x: 141.48, y: 22.13))
        crownPath.addCurve(to: CGPoint(x: 89.29, y: 33.15), controlPoint1: CGPoint(x: 123.28, y: 33.15), controlPoint2: CGPoint(x: 106.28, y: 33.15))
        crownPath.addCurve(to: CGPoint(x: 85.65, y: 0.09), controlPoint1: CGPoint(x: 88.07, y: 22.13), controlPoint2: CGPoint(x: 86.86, y: 11.11))
        crownPath.addCurve(to: CGPoint(x: 91.75, y: 3.6), controlPoint1: CGPoint(x: 85.65, y: 0.09), controlPoint2: CGPoint(x: 90.5, y: -0.72))
        crownPath.addCurve(to: CGPoint(x: 90.96, y: 9.24), controlPoint1: CGPoint(x: 93, y: 7.93), controlPoint2: CGPoint(x: 90.71, y: 9.32))
        crownPath.addCurve(to: CGPoint(x: 99.09, y: 12.86), controlPoint1: CGPoint(x: 91.21, y: 9.17), controlPoint2: CGPoint(x: 97.99, y: 7.36))
        crownPath.addCurve(to: CGPoint(x: 91.07, y: 18.57), controlPoint1: CGPoint(x: 100.2, y: 18.36), controlPoint2: CGPoint(x: 94.87, y: 20.89))
        crownPath.addCurve(to: CGPoint(x: 91.61, y: 21.65), controlPoint1: CGPoint(x: 91.25, y: 19.6), controlPoint2: CGPoint(x: 91.43, y: 20.63))
        crownPath.addCurve(to: CGPoint(x: 97.07, y: 27.29), controlPoint1: CGPoint(x: 91.61, y: 21.65), controlPoint2: CGPoint(x: 92.52, y: 26.86))
        crownPath.addCurve(to: CGPoint(x: 108.12, y: 27.34), controlPoint1: CGPoint(x: 97.07, y: 27.29), controlPoint2: CGPoint(x: 107.08, y: 27.38))
        crownPath.addCurve(to: CGPoint(x: 112.99, y: 23.5), controlPoint1: CGPoint(x: 109.67, y: 27.27), controlPoint2: CGPoint(x: 112.45, y: 26.98))
        crownPath.addCurve(to: CGPoint(x: 113.17, y: 17.5), controlPoint1: CGPoint(x: 113.22, y: 22.02), controlPoint2: CGPoint(x: 113.17, y: 17.5))
        crownPath.addCurve(to: CGPoint(x: 108.92, y: 19.5), controlPoint1: CGPoint(x: 113.17, y: 17.5), controlPoint2: CGPoint(x: 111.09, y: 19.58))
        crownPath.addCurve(to: CGPoint(x: 105.67, y: 18.47), controlPoint1: CGPoint(x: 107.64, y: 19.45), controlPoint2: CGPoint(x: 106.83, y: 19.15))
        crownPath.addCurve(to: CGPoint(x: 103.77, y: 16), controlPoint1: CGPoint(x: 104.5, y: 17.79), controlPoint2: CGPoint(x: 103.9, y: 16.48))
        crownPath.addCurve(to: CGPoint(x: 103.97, y: 11.74), controlPoint1: CGPoint(x: 103.44, y: 14.75), controlPoint2: CGPoint(x: 103.17, y: 13.22))
        crownPath.addCurve(to: CGPoint(x: 104.84, y: 10.52), controlPoint1: CGPoint(x: 104.2, y: 11.32), controlPoint2: CGPoint(x: 104.47, y: 10.89))
        crownPath.addCurve(to: CGPoint(x: 105.37, y: 10.03), controlPoint1: CGPoint(x: 104.84, y: 10.52), controlPoint2: CGPoint(x: 105.09, y: 10.26))
        crownPath.addCurve(to: CGPoint(x: 106.01, y: 9.57), controlPoint1: CGPoint(x: 105.68, y: 9.78), controlPoint2: CGPoint(x: 106.01, y: 9.57))
        crownPath.addCurve(to: CGPoint(x: 107.16, y: 9.05), controlPoint1: CGPoint(x: 106.38, y: 9.35), controlPoint2: CGPoint(x: 106.75, y: 9.16))
        crownPath.addCurve(to: CGPoint(x: 108.43, y: 8.82), controlPoint1: CGPoint(x: 107.82, y: 8.86), controlPoint2: CGPoint(x: 108.24, y: 8.83))
        crownPath.addCurve(to: CGPoint(x: 109.58, y: 8.84), controlPoint1: CGPoint(x: 108.43, y: 8.82), controlPoint2: CGPoint(x: 109, y: 8.78))
        crownPath.addCurve(to: CGPoint(x: 111.15, y: 9.21), controlPoint1: CGPoint(x: 110.19, y: 8.91), controlPoint2: CGPoint(x: 110.91, y: 9.07))
        crownPath.addCurve(to: CGPoint(x: 110.03, y: 7.74), controlPoint1: CGPoint(x: 111.39, y: 9.34), controlPoint2: CGPoint(x: 110.57, y: 8.8))
        crownPath.addCurve(to: CGPoint(x: 109.4, y: 5.33), controlPoint1: CGPoint(x: 109.7, y: 7.07), controlPoint2: CGPoint(x: 109.44, y: 6.31))
        crownPath.addCurve(to: CGPoint(x: 109.72, y: 3.32), controlPoint1: CGPoint(x: 109.38, y: 4.75), controlPoint2: CGPoint(x: 109.47, y: 3.98))
        crownPath.addCurve(to: CGPoint(x: 114.78, y: 0.03), controlPoint1: CGPoint(x: 111.03, y: -0.13), controlPoint2: CGPoint(x: 114.25, y: 0.01))
        crownPath.addCurve(to: CGPoint(x: 119.84, y: 3.32), controlPoint1: CGPoint(x: 115.31, y: 0.01), controlPoint2: CGPoint(x: 118.53, y: -0.13))
        crownPath.addCurve(to: CGPoint(x: 120.16, y: 5.33), controlPoint1: CGPoint(x: 120.08, y: 3.98), controlPoint2: CGPoint(x: 120.18, y: 4.74))
        crownPath.addCurve(to: CGPoint(x: 119.52, y: 7.74), controlPoint1: CGPoint(x: 120.12, y: 6.31), controlPoint2: CGPoint(x: 119.86, y: 7.07))
        crownPath.addCurve(to: CGPoint(x: 118.4, y: 9.21), controlPoint1: CGPoint(x: 118.98, y: 8.8), controlPoint2: CGPoint(x: 118.17, y: 9.34))
        crownPath.addCurve(to: CGPoint(x: 119.98, y: 8.84), controlPoint1: CGPoint(x: 118.64, y: 9.07), controlPoint2: CGPoint(x: 119.37, y: 8.91))
        crownPath.addCurve(to: CGPoint(x: 121.12, y: 8.82), controlPoint1: CGPoint(x: 120.55, y: 8.78), controlPoint2: CGPoint(x: 121.13, y: 8.82))
        crownPath.addCurve(to: CGPoint(x: 122.4, y: 9.05), controlPoint1: CGPoint(x: 121.32, y: 8.83), controlPoint2: CGPoint(x: 121.73, y: 8.86))
        crownPath.addCurve(to: CGPoint(x: 123.54, y: 9.57), controlPoint1: CGPoint(x: 122.81, y: 9.16), controlPoint2: CGPoint(x: 123.18, y: 9.35))
        crownPath.addCurve(to: CGPoint(x: 124.19, y: 10.03), controlPoint1: CGPoint(x: 123.55, y: 9.57), controlPoint2: CGPoint(x: 123.88, y: 9.78))
        crownPath.addCurve(to: CGPoint(x: 124.72, y: 10.52), controlPoint1: CGPoint(x: 124.47, y: 10.26), controlPoint2: CGPoint(x: 124.71, y: 10.52))
        crownPath.addCurve(to: CGPoint(x: 124.79, y: 10.6), controlPoint1: CGPoint(x: 124.74, y: 10.54), controlPoint2: CGPoint(x: 124.77, y: 10.57))
        crownPath.addCurve(to: CGPoint(x: 124.87, y: 10.68), controlPoint1: CGPoint(x: 124.82, y: 10.63), controlPoint2: CGPoint(x: 124.84, y: 10.65))
        crownPath.addCurve(to: CGPoint(x: 124.94, y: 10.77), controlPoint1: CGPoint(x: 124.89, y: 10.71), controlPoint2: CGPoint(x: 124.92, y: 10.74))
        crownPath.addCurve(to: CGPoint(x: 125.01, y: 10.85), controlPoint1: CGPoint(x: 124.96, y: 10.79), controlPoint2: CGPoint(x: 124.99, y: 10.82))
        crownPath.addCurve(to: CGPoint(x: 125.08, y: 10.94), controlPoint1: CGPoint(x: 125.03, y: 10.88), controlPoint2: CGPoint(x: 125.05, y: 10.91))
        crownPath.addCurve(to: CGPoint(x: 125.14, y: 11.02), controlPoint1: CGPoint(x: 125.1, y: 10.97), controlPoint2: CGPoint(x: 125.12, y: 10.99))
        crownPath.addCurve(to: CGPoint(x: 125.2, y: 11.11), controlPoint1: CGPoint(x: 125.16, y: 11.05), controlPoint2: CGPoint(x: 125.18, y: 11.08))
        crownPath.addCurve(to: CGPoint(x: 125.26, y: 11.2), controlPoint1: CGPoint(x: 125.22, y: 11.14), controlPoint2: CGPoint(x: 125.24, y: 11.17))
        crownPath.addCurve(to: CGPoint(x: 125.32, y: 11.29), controlPoint1: CGPoint(x: 125.28, y: 11.23), controlPoint2: CGPoint(x: 125.3, y: 11.26))
        crownPath.addCurve(to: CGPoint(x: 125.38, y: 11.38), controlPoint1: CGPoint(x: 125.34, y: 11.32), controlPoint2: CGPoint(x: 125.36, y: 11.35))
        crownPath.addCurve(to: CGPoint(x: 125.43, y: 11.47), controlPoint1: CGPoint(x: 125.4, y: 11.41), controlPoint2: CGPoint(x: 125.41, y: 11.44))
        crownPath.addCurve(to: CGPoint(x: 125.48, y: 11.56), controlPoint1: CGPoint(x: 125.45, y: 11.5), controlPoint2: CGPoint(x: 125.47, y: 11.53))
        crownPath.addCurve(to: CGPoint(x: 125.54, y: 11.65), controlPoint1: CGPoint(x: 125.5, y: 11.59), controlPoint2: CGPoint(x: 125.52, y: 11.62))
        crownPath.addCurve(to: CGPoint(x: 125.58, y: 11.74), controlPoint1: CGPoint(x: 125.55, y: 11.68), controlPoint2: CGPoint(x: 125.57, y: 11.71))
        crownPath.addCurve(to: CGPoint(x: 125.79, y: 16), controlPoint1: CGPoint(x: 126.39, y: 13.22), controlPoint2: CGPoint(x: 126.12, y: 14.75))
        crownPath.addCurve(to: CGPoint(x: 123.89, y: 18.47), controlPoint1: CGPoint(x: 125.66, y: 16.48), controlPoint2: CGPoint(x: 125.05, y: 17.79))
        crownPath.addCurve(to: CGPoint(x: 120.64, y: 19.5), controlPoint1: CGPoint(x: 122.72, y: 19.15), controlPoint2: CGPoint(x: 121.92, y: 19.45))
        crownPath.addCurve(to: CGPoint(x: 116.38, y: 17.5), controlPoint1: CGPoint(x: 118.47, y: 19.58), controlPoint2: CGPoint(x: 116.38, y: 17.5))
        crownPath.addCurve(to: CGPoint(x: 116.57, y: 23.5), controlPoint1: CGPoint(x: 116.38, y: 17.5), controlPoint2: CGPoint(x: 116.34, y: 22.02))
        crownPath.addCurve(to: CGPoint(x: 121.44, y: 27.34), controlPoint1: CGPoint(x: 117.11, y: 26.98), controlPoint2: CGPoint(x: 119.89, y: 27.27))
        crownPath.addCurve(to: CGPoint(x: 132.49, y: 27.29), controlPoint1: CGPoint(x: 122.47, y: 27.38), controlPoint2: CGPoint(x: 132.49, y: 27.29))
        crownPath.addCurve(to: CGPoint(x: 137.94, y: 21.65), controlPoint1: CGPoint(x: 137.04, y: 26.86), controlPoint2: CGPoint(x: 137.94, y: 21.65))
        crownPath.addCurve(to: CGPoint(x: 138.49, y: 18.57), controlPoint1: CGPoint(x: 138.13, y: 20.63), controlPoint2: CGPoint(x: 138.31, y: 19.6))
        crownPath.addCurve(to: CGPoint(x: 130.46, y: 12.86), controlPoint1: CGPoint(x: 134.68, y: 20.89), controlPoint2: CGPoint(x: 129.36, y: 18.36))
        crownPath.addCurve(to: CGPoint(x: 138.59, y: 9.24), controlPoint1: CGPoint(x: 131.57, y: 7.36), controlPoint2: CGPoint(x: 138.34, y: 9.17))
        crownPath.addCurve(to: CGPoint(x: 137.81, y: 3.6), controlPoint1: CGPoint(x: 138.84, y: 9.32), controlPoint2: CGPoint(x: 136.56, y: 7.93))
        crownPath.close()
        crownPath.move(to: CGPoint(x: 90.73, y: 45))
        crownPath.addLine(to: CGPoint(x: 89.71, y: 35.42))
        crownPath.addLine(to: CGPoint(x: 139.95, y: 35.42))
        crownPath.addLine(to: CGPoint(x: 138.77, y: 45))
        crownPath.addLine(to: CGPoint(x: 90.73, y: 45))
        crownPath.close()
        return crownPath
    }
    
    
    
    
}
