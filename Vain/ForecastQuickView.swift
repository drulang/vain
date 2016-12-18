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
    let textLabel = UILabel(forAutoLayout: ())
    fileprivate var constraintsAdded = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconImageView)
        addSubview(textLabel)
        
        iconImageView.image = #imageLiteral(resourceName: "IconWeatherSun")
        iconImageView.contentMode = UIViewContentMode.scaleAspectFit
        textLabel.text = "32/80"
        
        boxTheHellOutOfEverything()
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            iconImageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: ALEdge.bottom)
            iconImageView.autoPinEdge(ALEdge.bottom, to: ALEdge.top, of: textLabel)
            
            textLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: ALEdge.top)
            textLabel.autoSetDimension(ALDimension.height, toSize: textLabel.intrinsicContentSize.height)
        }

        super.updateConstraints()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: 50)
    }
}
