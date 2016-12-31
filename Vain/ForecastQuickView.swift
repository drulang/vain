//
//  ForecastQuickView.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit
import PureLayout

class ForecastQuickView : UIView {
    
    let iconImageView = UIImageView(forAutoLayout: ())
    fileprivate var constraintsAdded = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconImageView)

        clipsToBounds = false

        iconImageView.contentMode = UIViewContentMode.scaleAspectFill

        layer.cornerRadius = 30
        backgroundColor = UIColor.orange
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            let padding = CGFloat(15)
            let iconInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            iconImageView.autoPinEdgesToSuperviewEdges(with: iconInsets)
        }

        super.updateConstraints()
    }
    
    override var intrinsicContentSize: CGSize {
        let size = 60
        return CGSize(width: size, height: size)
    }
}
