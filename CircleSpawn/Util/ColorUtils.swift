//
//  ColorUtils.swift
//  CircleSpawn
//
//  Created by Tomasz Bogusz on 20.03.2018.
//  Copyright © 2018 Tomasz Bogusz. All rights reserved.
//

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return random(min: 0.0, max: 1.0)
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(max > min)
        return min + ((max - min) * CGFloat(arc4random()) / CGFloat(UInt32.max))
    }
}

extension UIColor {
    static func randomBrightColor() -> UIColor {
        return UIColor(hue: .random(),
                       saturation: .random(min: 0.5, max: 1.0),
                       brightness: .random(min: 0.7, max: 1.0),
                       alpha: 1.0)
    }
}
