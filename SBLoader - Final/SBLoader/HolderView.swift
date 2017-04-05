//
//  HolderView.swift
//  SBLoader
//
//  Created by Satraj Bambra on 2015-03-17.
//  Copyright (c) 2015 Satraj Bambra. All rights reserved.
//

import UIKit

protocol HolderViewDelegate:class {
  func animateLabel()
}

class HolderView: UIView {

    var parentFrame :CGRect = CGRect.zero
    weak var delegate:HolderViewDelegate?
  
    let ovalLayer = OvalLayer()
    let triangleLayer = TriangleLayer()
    let redRectangleLayer = RectangleLayer()
    let blueRectangleLayer = RectangleLayer()
    let arcLayer  = ArcLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.clear
    }
  
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    func addOval(){
        self.layer.addSublayer(ovalLayer);
        ovalLayer.expand()
        
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
                self.wobbleOval()
            }
        } else {
            Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(wobbleOval), userInfo: nil, repeats: false)
        }
        
    }
    func wobbleOval() {
    //1
        layer.addSublayer(triangleLayer)
        ovalLayer.wobble()
        
    //2
        Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(drawAnimateTriangle), userInfo: nil, repeats: false)
        
    }
    
    func drawAnimateTriangle()  {
        triangleLayer.animate()
        Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(spinAndTransform), userInfo: nil, repeats: false)
        
    }
    func spinAndTransform()  {
        //1
        layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.6)
        //2
        let  rotationAniamtion = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAniamtion.toValue = CGFloat(M_PI*2.0)
        rotationAniamtion.duration = 0.45
        rotationAniamtion.isRemovedOnCompletion = true
        layer.add(rotationAniamtion, forKey: "rotation")
        //3
        ovalLayer.contract()
        
        //4
        Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(drawRedAnimateRectangle), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 0.65, target: self, selector: #selector(drawBlueAnimatedRectangle), userInfo: nil, repeats: false)

    }
    
    func drawRedAnimateRectangle()  {
       layer.addSublayer(redRectangleLayer)
       redRectangleLayer.animateStrokeWithColor(Colors.red)
    }
    func drawBlueAnimatedRectangle()  {
        layer.addSublayer(blueRectangleLayer)
        blueRectangleLayer.animateStrokeWithColor(Colors.blue)
        Timer.scheduledTimer(timeInterval: 0.40, target: self, selector: #selector(drawArc), userInfo: nil, repeats: false)
    }
    func drawArc()  {
        layer.addSublayer(arcLayer)
        arcLayer.animate()
        Timer.scheduledTimer(timeInterval: 0.90, target: self, selector: #selector(expandView), userInfo: nil, repeats: false)
    }
    
    func expandView()  {
        //1 
        backgroundColor = Colors.blue
        
        //2
        frame = CGRect.init(x: frame.origin.x-blueRectangleLayer.lineWidth, y: frame.origin.y-blueRectangleLayer.lineWidth, width: frame.size.width+blueRectangleLayer.lineWidth*2, height: frame.size.height+blueRectangleLayer.lineWidth*2)
        
        //3
        layer.sublayers = nil
        
        //4
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { 
            self.frame = self.parentFrame
        }) { (fineshed) in
            self.addLabel()
        }
        
    }
    func addLabel()  {
        delegate?.animateLabel()
    }
}
