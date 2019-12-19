//
//  CircularView.swift
//  ShARe
//
//  Created by Andrei Ostafciuc on 19/12/2019.
//  Copyright © 2019 Andrei Ostafciuc. All rights reserved.
//

import UIKit

class CiruclarProgressBar: UIView {
    
    //MARK: awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    
    //MARK: Public
    
    public var lineWidth:CGFloat = 50 {
        didSet{
            foregroundLayer.lineWidth = lineWidth
            backgroundLayer.lineWidth = lineWidth - (0.20 * lineWidth)
        }
    }
    
    public var fillBackgroundColor: UIColor = .gray
    
    private var previousProgress: Double = 0
    private var nextProgress: Double = 0
    
    private var previousColor: UIColor = .clear
    private var nextColor: UIColor = .clear
    
    enum ProgressAnimation: String {
        case strokeColorAnimation
        case strokeAnimation
    }
    
    public func setProgress(to progressConstant: Double, withAnimation: Bool, duration: CFTimeInterval = 2, color: UIColor = .gray) {
        nextProgress = max(0, min(progressConstant, 1))
        nextColor = color
        
        foregroundLayer.strokeEnd = CGFloat(nextProgress)
        foregroundLayer.strokeColor = nextColor.cgColor
        
        if withAnimation {
            let strokeColorAnimation = CABasicAnimation(keyPath: "strokeColor")
            
            strokeColorAnimation.fromValue = previousColor.cgColor
            strokeColorAnimation.toValue = nextColor.cgColor
            
            strokeColorAnimation.duration = duration
            strokeColorAnimation.delegate = self
            strokeColorAnimation.setValue(ProgressAnimation.strokeColorAnimation, forKey: "id")
            foregroundLayer.add(strokeColorAnimation, forKey: "foregroundStrokeColorAnimation")
    
            let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
            
            strokeAnimation.fromValue = previousProgress
            strokeAnimation.toValue = nextProgress
            
            strokeAnimation.duration = duration
            strokeAnimation.delegate = self
            strokeAnimation.setValue(ProgressAnimation.strokeAnimation, forKey: "id")
            foregroundLayer.add(strokeAnimation, forKey: "foregroundStrokeAnimation")
        }
    }
    
    
    //MARK: Private
    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private var radius: CGFloat {
        get{
            if self.frame.width < self.frame.height { return (self.frame.width - lineWidth)/2 }
            else { return (self.frame.height - lineWidth)/2 }
        }
    }
    
    private var pathCenter: CGPoint{ get{ return self.convert(self.center, from:self.superview) } }
    private func makeBar(){
        self.layer.sublayers = nil
        drawBackgroundLayer()
        drawForegroundLayer()
    }
    
    private func drawBackgroundLayer(){
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        self.backgroundLayer.path = path.cgPath
        self.backgroundLayer.strokeColor = fillBackgroundColor.cgColor
        self.backgroundLayer.lineWidth = lineWidth - (lineWidth * 20/100)
        self.backgroundLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(backgroundLayer)
    }
    
    private func drawForegroundLayer(){
        let startAngle = (-CGFloat.pi/2)
        let endAngle = 2 * CGFloat.pi + startAngle
        
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        foregroundLayer.lineCap = CAShapeLayerLineCap.round
        foregroundLayer.path = path.cgPath
        foregroundLayer.lineWidth = lineWidth
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.strokeColor = previousColor.cgColor
        foregroundLayer.strokeEnd = 0
        
        self.layer.addSublayer(foregroundLayer)
        
    }
    
    private func setupView() {
        makeBar()
    }
    
    //Layout Sublayers
    
    private var layoutDone = false
    override func layoutSublayers(of layer: CALayer) {
        if !layoutDone {
            setupView()
            layoutDone = true
        }
    }
}

extension CiruclarProgressBar: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let animationId = anim.value(forKey: "id") as? ProgressAnimation{
            if animationId == .strokeColorAnimation {
                previousColor = nextColor
            } else {
                previousProgress = nextProgress
            }
        }
    }
}
