//
//  TACircleSlider.swift
//  TACircleSlider
//
//  Created by Ragnar on 9/22/18.
//  Copyright © 2018 Ragnar. All rights reserved.
//

import UIKit

// MARK: Define default value
let tDefaultStartAngle: CGFloat = CGFloat(Float.pi * 3 / 4)
let tDefaultEndAngle: CGFloat = CGFloat(Float.pi * 9 / 4)
let tDefaultNumberOfDots = 16
let tDefaultRadiusOfDots: CGFloat = 5.0
let tDefaultColorOfDot = UIColor.green
let tDefaultMinValue: CGFloat = 0.0
let tDefaultMaxValue: CGFloat = 100.0

// MARK: Delegate
protocol TACircleSliderDelegate: class {
    func sliderDidChangeValue(value: CGFloat)
}

@IBDesignable
class TACircleSlider: UIControl {
    
    // MARK: Properties
    weak var delegate: TACircleSliderDelegate?
    
    var currentValue: CGFloat = tDefaultMaxValue / 2 {
        didSet {
            self.setNeedsLayout()
            self.delegate?.sliderDidChangeValue(value: self.currentValue)
        }
    }
    
    var minValue: CGFloat = tDefaultMinValue
    var maxValue: CGFloat = tDefaultMaxValue
    
    var startAngle: CGFloat = tDefaultStartAngle {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var endAngle: CGFloat = tDefaultEndAngle {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    var numberDots: Int = tDefaultNumberOfDots
    
    @IBInspectable
    var dotRadius: CGFloat = tDefaultRadiusOfDots
    
    var dotColor: UIColor = tDefaultColorOfDot
    var isGradient: Bool = true
    
    var lstDots: [CAShapeLayer] = []
    
    // Thumb
    lazy var thumbButton = UIButton(type: .custom)
    var thumbColor: UIColor = .red {
        didSet {
            thumbButton.backgroundColor = thumbColor
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var thumImage: UIImage? = nil {
        didSet {
            if let image = self.thumImage {
                self.thumbColor = .clear
                self.thumbButton.setImage(image, for: .normal)
            }
        }
    }
    
    @IBInspectable
    var thumbRadius: CGFloat = 20
    
    
    // MARK: Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        initSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        initSubViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateThumbPosition()
    }
    
    // MARK: Method
    private func initSubViews() {
        addSeekerBar()
        addThumb()
    }
    
    private func addSeekerBar() {
        let divisionUnitValue = (self.maxValue - self.minValue)/CGFloat(self.numberDots)
        let divisionUnitAngle = abs(self.endAngle - self.startAngle)/CGFloat(self.numberDots)
        
        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        let circleRadius: CGFloat = min(self.bounds.width/2, self.bounds.height/2)
        
        // Draw dots
        for i in 0..<self.numberDots+1 {
            let value = CGFloat(i) * divisionUnitValue + self.minValue
            let angle = self.angleFromValue(value: value, devisionUnitValue: divisionUnitValue, devisionUnitAngle: divisionUnitAngle)
            
            let dotCenter = CGPoint(x: circleRadius * cos(angle) + center.x, y: circleRadius * sin(angle) + center.y)
            
            self.drawDot(center: dotCenter, radius: self.dotRadius, fillColor: self.dotColor.withAlphaComponent((CGFloat(i)/CGFloat(self.numberDots))).cgColor)
        }
    }
    
    private func addThumb() {
        thumbButton.frame = CGRect(x: 0, y: 0, width: thumbRadius, height: thumbRadius)
        thumbButton.backgroundColor = thumbColor
        thumbButton.layer.cornerRadius = thumbButton.frame.size.width/2
        thumbButton.layer.masksToBounds = true
        thumbButton.isUserInteractionEnabled = false
        
        self.addSubview(thumbButton)
    }
    
    private func updateThumbPosition() {
        let angle: CGFloat = abs(self.currentValue * (self.startAngle - endAngle) / (minValue - maxValue)) + self.startAngle
        
        //        print("-------\(angle)")
        var rect = thumbButton.frame
        
        let circleRadius: CGFloat = min(self.bounds.width/2, self.bounds.height/2)
        
        let thumbCenter: CGFloat = thumbRadius / 2
        
        let finalX = cos(angle) * circleRadius
        let finalY = sin(angle) * circleRadius
        
        rect.origin.x = finalX - thumbCenter + self.bounds.width/2
        rect.origin.y = finalY - thumbCenter + self.bounds.height/2
        
        thumbButton.frame = rect
        
        // update color for list dot
        let progress = (self.currentValue - self.minValue)/(self.maxValue - self.minValue)
        let currentIndex = Int(ceil(CGFloat(progress * CGFloat(tDefaultNumberOfDots))))
        
        if self.lstDots.count > 0 {
            
            for i in 0..<self.lstDots.count {
                self.lstDots[i].fillColor = i >= currentIndex ? UIColor.lightGray.withAlphaComponent(0.5).cgColor : self.dotColor.withAlphaComponent(CGFloat(i)/CGFloat(self.lstDots.count)).cgColor
                
                self.lstDots[i].lineWidth = i >= currentIndex ? 0 : 0.1
                
            }
        }
    }
    
    // Convert angle to value
    private func angleFromValue(value: CGFloat, devisionUnitValue: CGFloat, devisionUnitAngle: CGFloat) -> CGFloat {
        
        let level = (value - minValue)/devisionUnitValue
        let angle: CGFloat = level * devisionUnitAngle + self.startAngle
        return angle
    }
    
    //
    private func drawDot(center: CGPoint, radius: CGFloat, fillColor: CGColor) {
        
        let dotLayer = CAShapeLayer()
        dotLayer.fillColor = fillColor
        dotLayer.strokeColor = self.dotColor.cgColor
        dotLayer.lineWidth = 0.1
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0.0, endAngle: 360.0, clockwise: true)
        
        dotLayer.path = path.cgPath
        
        self.layer.addSublayer(dotLayer)
        self.lstDots.append(dotLayer)
    }
    
    // ...
    private func angleForLocation(location: CGPoint) -> CGFloat {
        let dx = location.x - self.frame.width / 2
        let dy = location.y - self.frame.height / 2
        
        let angle = CGFloat(atan2(dy, dx))
        
        return angle
    }
    
    // MARK: Touch event
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let point = touch.location(in: self)
        
        let rect = self.thumbButton.frame.insetBy(dx: -thumbRadius, dy: -thumbRadius)
        
        let canBegin = rect.contains(point)
        
        if canBegin {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseIn, .beginFromCurrentState], animations: {
                self.thumbButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: nil)
        }
        
        return canBegin
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        var angle = angleForLocation(location: point)
        angle = angle >= self.startAngle ? angle : (CGFloat((2 * Float.pi)) + angle)
        if angle > self.endAngle || angle < self.startAngle {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [ .curveEaseOut, .beginFromCurrentState ], animations: { () -> Void in
                self.thumbButton.transform = .identity
            }, completion: nil)
            return false
        }
        
        //        print(angle)
        let newValue = abs(angle - self.startAngle) / (self.endAngle - self.startAngle) * (self.maxValue - self.minValue)
        self.currentValue = round(newValue)
        //        print(self.currentValue)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [ .curveEaseOut, .beginFromCurrentState ], animations: { () -> Void in
            self.thumbButton.transform = .identity
        }, completion: nil)
    }
}
