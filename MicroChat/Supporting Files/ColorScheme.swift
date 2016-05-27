//
//  ColorScheme.swift
//  MicroChat
//
//  Created by Daniel Li on 5/26/16.
//  Copyright © 2016 dantheli. All rights reserved.
//

import UIKit

extension UIColor {
    static func navigationBar() -> UIColor {
        return microPurple()
    }
    
    static func microPink() -> UIColor {
        return UIColor(red:0.86, green:0.52, blue:0.64, alpha:1.00)
    }
    
    static func microPurple() -> UIColor {
        return UIColor(red:0.65, green:0.45, blue:0.58, alpha:1.00)
    }
    
    static func microDarkPurple() -> UIColor {
        return UIColor(red:0.44, green:0.27, blue:0.35, alpha:1.00)
    }
}