//
//  UIAlertController+.swift
//  Discover
//
//  Created by lansoft on 2021/9/23.
//

import Foundation
import UIKit

extension UIAlertController {
    
    convenience init(title: String, closeTitle: String){
        self.init(title: title, message: nil, preferredStyle: .alert)
        self.addAction(UIAlertAction.init(title: closeTitle, style: .cancel, handler: nil))
    }
}
