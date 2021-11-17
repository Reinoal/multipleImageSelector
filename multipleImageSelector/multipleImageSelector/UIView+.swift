//
//  UIView+.swift
//  TXVideo
//
//  Created by lansoft on 2021/9/9.
//

import Foundation
import UIKit



extension UIView{
    var x: CGFloat{
        set{
            var re = frame
            re.origin.x = newValue
            frame = re
        }
        get{
            return frame.origin.x
        }
    }
    
    var y: CGFloat{
        set{
            var re = frame
            re.origin.y = newValue
            frame = re
        }
        get{
            return frame.origin.x
        }
    }
    
    var width: CGFloat{
        set{
            var re = frame
            re.size.width = newValue
            frame = re
        }
        get{
            return frame.size.width
        }
    }
    
    var height: CGFloat{
        set{
            var re = frame
            re.size.height = newValue
            frame = re
        }
        get{
            return frame.size.height
        }
    }
    
    var centerX: CGFloat{
        set{
            var cen = center
            cen.x = newValue
            center = cen
        }
        get{
            return center.x
        }
    }
    
    var centerY: CGFloat{
        set{
            var cen = center
            cen.y = newValue
            center = cen
        }
        get{
            return center.y
        }
    }
    
    var size: CGSize{
        set{
            var re = frame
            re.size = newValue
            frame = re
        }
        
        get{
            return frame.size
        }
    }
    
    var topSaveArea: CGFloat{
        get{
            return UIApplication.shared.windows.first?.subviews.first?.safeAreaInsets.top ?? 0
        }
    }
    
    var topSaveAreaAndNavHeight: CGFloat{
        get{
            return (UIApplication.shared.windows.first?.subviews.first?.safeAreaInsets.top ?? 0) + 44
        }
    }
    
    var bottomSafeArea: CGFloat{
        get{
            return UIApplication.shared.windows.first?.subviews.first?.safeAreaInsets.bottom ?? 0
        }
    }
    
    func cornerRadius(_ radius: CGFloat){
        clipsToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
    
    func cornerRadiusTop(_ raduis: CGSize){
        clipsToBounds = true
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: UIRectCorner.init([.topLeft, .topRight]), cornerRadii: raduis)
        let lay = CAShapeLayer.init()
        lay.frame = bounds
        lay.path = maskPath.cgPath
        layer.mask = lay
    }
    
    func cornerRadiusBottom(_ raduis: CGSize){
        clipsToBounds = true
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: UIRectCorner.init([.bottomLeft, .bottomRight]), cornerRadii: raduis)
        let lay = CAShapeLayer.init()
        lay.frame = bounds
        lay.path = maskPath.cgPath
        layer.mask = lay
    }
    
    func cornerRadiusLeft(_ raduis: CGSize){
        clipsToBounds = true
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: UIRectCorner.init([.topLeft, .bottomLeft]), cornerRadii: raduis)
        let lay = CAShapeLayer.init()
        lay.frame = bounds
        lay.path = maskPath.cgPath
        layer.mask = lay
    }
    
    func cornerRadiusRight(_ raduis: CGSize){
        clipsToBounds = true
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: UIRectCorner.init([.topRight, .bottomRight]), cornerRadii: raduis)
        let lay = CAShapeLayer.init()
        lay.frame = bounds
        lay.path = maskPath.cgPath
        layer.mask = lay
    }

    func gradientColorLeftToRight(color1: UIColor, color2: UIColor){
        let grad = CAGradientLayer.init()
        grad.colors = [color1.cgColor, color2.cgColor]
        grad.frame = bounds
        grad.locations = [0.0,1.0]
        grad.startPoint = CGPoint.init(x: 0, y: 0.5)
        grad.endPoint = CGPoint.init(x: 1, y: 0.5)
        layer.addSublayer(grad)
    }
    
    func gradientColorTopToBottom(color1: UIColor, color2: UIColor){
        let grad = CAGradientLayer.init()
        grad.colors = [color1.cgColor, color2.cgColor]
        grad.frame = bounds
        grad.locations = [0.0,1.0]
        grad.startPoint = CGPoint.init(x: 0.5, y: 0)
        grad.endPoint = CGPoint.init(x: 0.5, y: 1)
        layer.addSublayer(grad)
    }
    
    func gradientColorLeftTopToRightBottom(color1: UIColor, color2: UIColor){
        let grad = CAGradientLayer.init()
        grad.colors = [color1.cgColor, color2.cgColor]
        grad.frame = bounds
        grad.locations = [0.0,1.0]
        grad.startPoint = CGPoint.init(x: 0, y: 0)
        grad.endPoint = CGPoint.init(x: 1, y: 1)
        layer.addSublayer(grad)
    }
    
    func gradientColorRightTopToLeftBottom(color1: UIColor, color2: UIColor){
        let grad = CAGradientLayer.init()
        grad.colors = [color1.cgColor, color2.cgColor]
        grad.frame = bounds
        grad.locations = [0.0,1.0]
        grad.startPoint = CGPoint.init(x: 1, y: 0)
        grad.endPoint = CGPoint.init(x: 0, y: 1)
        layer.addSublayer(grad)
    }
    
    func gradientColorCenterToSide(color1: UIColor, color2: UIColor){
        let grad = CAGradientLayer.init()
        grad.colors = [color1.cgColor, color2.cgColor]
        grad.frame = bounds
        grad.locations = [0.0,1.5, 0.0]
        grad.startPoint = CGPoint.init(x: 0.5, y: 0.5)
        grad.endPoint = CGPoint.init(x: 1, y: 1)
        grad.type = .radial
        layer.addSublayer(grad)
    }
    
    func effectViewWithAlpha(_ alpha: CGFloat){
        let eff = UIBlurEffect.init(style: .light)
        let effV = UIVisualEffectView.init(effect: eff)
        effV.frame = bounds
        effV.alpha = alpha
        addSubview(effV)
    }
}
