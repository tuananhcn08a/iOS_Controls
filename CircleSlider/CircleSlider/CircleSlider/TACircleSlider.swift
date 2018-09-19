//
//  TACircleSlider.swift
//  CircleSlider
//
//  Created by The New Macbook on 9/19/18.
//  Copyright © 2018 FPT. All rights reserved.
//

import UIKit

// Ultilities functions
private func degreeToRadian(degree: Double) -> Double {
    return Double(degree * (Double.pi / 180))
}

private func radianToDegree(radian: Double) -> Double {
    return Double(radian * (180 / Double.pi))
}

// Delegate
protocol TACircleSliderDelegate: class {
    func circularSeeker(_ seeker: TACircleSlider, didChangeValue value: Float)
}

// Class
class TACircleSlider: UIControl {

    // MARK: Propertise
    weak var delegate: TACircleSliderDelegate?
    lazy var seekerBarLayer = CAShapeLayer()
    lazy var thumbButton = UIButton(type: .custom)
    
    // Start Angle
    var startAngle: Float = 90.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // End Angle
    var endAngle: Float = 180.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var currentAngle: Float = 180 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var seekBarColor: UIColor = .gray {
        didSet {
            seekerBarLayer.strokeColor = seekBarColor.cgColor
            self.setNeedsLayout()
        }
    }
    
    var thumbColor: UIColor = .red {
        didSet {
            thumbButton.backgroundColor = thumbColor
            self.setNeedsLayout()
        }
    }
    
    
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        
        let sAngle = degreeToRadian(degree: Double(startAngle))
        let eAngle = degreeToRadian(degree: Double(endAngle))
        
        let path = UIBezierPath(arcCenter: center, radius: (self.bounds.size.width - 18)/2, startAngle: CGFloat(sAngle), endAngle: CGFloat(eAngle), clockwise: true)
        seekerBarLayer.path = path.cgPath
    }
    
    // MARK: Methods
    private func initSubViews() {
        addSeekerBar()
    }

    private func addSeekerBar() {
        let center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        
        let sAngle = degreeToRadian(degree: Double(startAngle))
        let eAngle = degreeToRadian(degree: Double(endAngle))
        
        // TODO: TRuyền vào radius
        let path = UIBezierPath(arcCenter: center, radius: self.bounds.size.width / 2, startAngle: CGFloat(sAngle), endAngle: CGFloat(eAngle), clockwise: true)
        
        seekerBarLayer.path = path.cgPath
        seekerBarLayer.lineWidth = 8.0
        seekerBarLayer.lineCap = kCALineCapRound
        seekerBarLayer.strokeColor = seekBarColor.cgColor
        seekerBarLayer.fillColor = UIColor.clear.cgColor
        let one : NSNumber = 1
        let two : NSNumber = 20
        seekerBarLayer.lineDashPattern = [one,two]
        
        if seekerBarLayer.superlayer == nil {
            self.layer.addSublayer(seekerBarLayer)
        }
    }
    
    private func degreeForLocation(location: CGPoint) -> Double {
        let dx = location.x - (self.frame.size.width * 0.5)
        let dy = location.y - (self.frame.size.height * 0.5)
        
        let angle = Double(atan2(Double(dy), Double(dx)))
        
        var degree = radianToDegree(radian: angle)
        if degree < 0 {
            degree = 360 + degree
        }
        
        return degree
    }
    
    private func moveToPoint(point: CGPoint) -> Bool {
        var degree = degreeForLocation(location: point)
        
        func moveToClosestEdge(degree: Double) {
            let startDistance = fabs(Float(degree) - startAngle)
            let endDistance = fabs(Float(degree) - endAngle)
            
            if startDistance < endDistance {
                currentAngle = startAngle
            } else {
                currentAngle = endDistance
            }
        }
        
        if startAngle > endAngle {
            if degree < Double(startAngle) && degree > Double(endAngle) {
                moveToClosestEdge(degree: degree)
                return false
            }
        } else {
            if degree > Double(endAngle) || degree < Double(startAngle) {
                moveToClosestEdge(degree: degree)
                return false
            }
        }
        
        currentAngle = Float(degree)
        return true
    }
    
    // MARK: Public methods
    func moveToAngle(angle: Float, duration: CFTimeInterval) {
        
        let center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        
        let sAngle = degreeToRadian(degree: Double(startAngle))
        let eAngle = degreeToRadian(degree: Double(angle))
        
        // TODO: TRuyền vào radius
        let path = UIBezierPath(arcCenter: center, radius: self.bounds.size.width / 2, startAngle: CGFloat(sAngle), endAngle: CGFloat(eAngle), clockwise: true)
        
        CATransaction.begin()
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = duration
        animation.path = path.cgPath
        CATransaction.setCompletionBlock { [weak self] in
            self?.currentAngle = angle
        }
        CATransaction.commit()
    }
}
