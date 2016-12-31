//
//  UIImage.swift
//  Vain
//
//  Created by Dru Lang on 12/30/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit


extension UIImage {
    
    class func imageTemplate(named name: String) -> UIImage? {
        return UIImage(named: name)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    }
    
}
