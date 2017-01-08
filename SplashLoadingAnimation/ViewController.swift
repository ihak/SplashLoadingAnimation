//
//  ViewController.swift
//  StopwatchAnimation
//
//  Created by Hassan Ahmed Khan on 12/24/16.
//  Copyright © 2016 Hassan Ahmed Khan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {

    /*
     @property (weak, nonatomic) IBOutlet UIView *stopWatchView;
     @property (weak, nonatomic) IBOutlet UIImageView *stopWatchImage;
     @property (weak, nonatomic) IBOutlet UIView *stopWatchCircle;
     @property (strong, nonatomic) CABasicAnimation *fillWatchAnimation;
     
     @property (strong, nonatomic) CAShapeLayer *pieShape;
     @property (assign, nonatomic) BOOL reverseAnimation;
     */
    
    let kFillAnimation = "FillAnimation"
    let kClearAnimation = "ClearAnimation"
    
    @IBOutlet var stopwatchView: UIView!
    @IBOutlet var stopwatchImageView: UIImageView!
    @IBOutlet var stopwatchCircle: UIView!
    
    var fillWatchAnimation: CASpringAnimation!
    var pieShape: CAShapeLayer?
    
    var reverseAnimation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startWatchAnimation()
        
        self.view.layoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Stopwatch Animation
    func startWatchAnimation() {
        print("Watch animation started.")
        self.fillWatchDial()
    }

    func stopWatchAnimation() {
        print("Watch animation stopped.")
        pieShape?.removeAllAnimations()
        pieShape?.removeFromSuperlayer()
        self.stopwatchView.isHidden = true
    }
    
    func fillWatchDial() {
        if pieShape == nil {
            let rect = self.view.convert(self.stopwatchCircle.bounds, from: nil)
            
            let startAngle = M_PI * 1.5
            let endAngle = startAngle + (M_PI * 2)
            
            pieShape = CAShapeLayer()
            pieShape?.fillColor   = UIColor.clear.cgColor
            pieShape?.strokeColor = UIColor(colorLiteralRed: 18.0/256.0, green: 76.0/256.0, blue: 155.0/256.0, alpha: 1.0).cgColor
            pieShape?.lineWidth   = rect.size.width
            pieShape?.borderColor = UIColor.clear.cgColor

            let innerbezierPath = UIBezierPath()
            innerbezierPath.addArc(withCenter: CGPoint(x: rect.size.width/2, y: rect.size.height / 2), radius: rect.size.width/2, startAngle: CGFloat(startAngle), endAngle: CGFloat((endAngle - startAngle) * 1 + startAngle), clockwise: true)
            pieShape?.path = innerbezierPath.cgPath

            self.stopwatchCircle.layer.addSublayer(pieShape!)
            
            fillWatchAnimation = CASpringAnimation(keyPath: "strokeEnd")
            
            fillWatchAnimation.initialVelocity = -5.0
            
            fillWatchAnimation.damping = 10.0
            fillWatchAnimation.stiffness = 50.0
            fillWatchAnimation.duration = 1.3
            fillWatchAnimation.delegate = self
            fillWatchAnimation.fromValue = NSNumber(floatLiteral: 0.0)
            fillWatchAnimation.toValue = NSNumber(floatLiteral: 1.0)
            fillWatchAnimation.isRemovedOnCompletion = false
            fillWatchAnimation.fillMode = kCAFillModeForwards

            pieShape?.add(fillWatchAnimation, forKey: kFillAnimation)
            reverseAnimation = true
        }
        else {
            let fromValue = reverseAnimation ? 1.0 : 0.0
            let toValue = reverseAnimation ? 0.0 : 1.0
            
            let bezierPath = UIBezierPath(cgPath: pieShape!.path!)
            
            pieShape!.path = bezierPath.reversing().cgPath
            self.stopwatchCircle.layer.addSublayer(pieShape!)

            fillWatchAnimation = CASpringAnimation(keyPath: "strokeEnd")
            fillWatchAnimation.initialVelocity = -5.0
            
            
            fillWatchAnimation.damping = 10.0
            fillWatchAnimation.stiffness = 50.0
            fillWatchAnimation.duration = 1.3
            fillWatchAnimation.delegate = self
            fillWatchAnimation.fromValue = NSNumber(value: fromValue)
            fillWatchAnimation.toValue = NSNumber(value: toValue)
            fillWatchAnimation.isRemovedOnCompletion = false
            fillWatchAnimation.fillMode = kCAFillModeForwards
            
            pieShape!.add(fillWatchAnimation, forKey: kFillAnimation)
            reverseAnimation = !reverseAnimation
        }
    }
    
    //MARK: CAAnimationDelegate
    func animationDidStart(_ anim: CAAnimation) {
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == self.pieShape!.animation(forKey: kFillAnimation) {
            fillWatchDial()
        }
    }
}
