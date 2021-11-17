//
//  UIColor+.swift
//  TXVideo
//
//  Created by lansoft on 2021/9/9.
//

import Foundation
import UIKit

extension UIColor{
    
    static func randomColor() -> UIColor{
        return UIColor.init(red: CGFloat.random(in: Range<CGFloat>.init(uncheckedBounds: (lower: 0, upper: 1.0))), green: CGFloat.random(in: Range<CGFloat>.init(uncheckedBounds: (lower: 0, upper: 1.0))), blue: CGFloat.random(in: Range<CGFloat>.init(uncheckedBounds: (lower: 0, upper: 1.0))), alpha: 1)
    }
    
    static func initWith(hex: Int) -> UIColor{
        let components = (R:CGFloat((hex >> 16) & 0xff) / 255,G:CGFloat((hex >> 8) & 0xff) / 255,B:CGFloat((hex >> 0) & 0xff) / 255)
        return UIColor.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    static func initWith(hex:Int, alpha: CGFloat = 1) -> UIColor{
        let components = (R:CGFloat((hex >> 16) & 0xff) / 255,G:CGFloat((hex >> 8) & 0xff) / 255,B:CGFloat((hex >> 0) & 0xff) / 255)
        return UIColor.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
    }
    
    static var globOrange: UIColor{
        return UIColor.init(red: 1, green: 0.3, blue: 0.1, alpha: 1)
    }

    static var globBlack: UIColor{
        return initWith(hex: 0x333333)
    }

    static var globGrey:UIColor{
        return initWith(hex: 0x999999)
    }
    
    static var transformGreyColor: UIColor{
        return UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.9)
    }
}
