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
        
        clipsToBounds = false
        
        iconImageView.image = #imageLiteral(resourceName: "IconWeatherSun")
        iconImageView.contentMode = UIViewContentMode.scaleAspectFill
        
        textLabel.textAlignment = NSTextAlignment.center
        textLabel.text = "32/80"
        textLabel.font = Appearance.Font.IconSubtitleFont
        
        
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
            
            let iconDefaultPadding = CGFloat(5)
            let iconTopPadding = CGFloat(3)
            let iconInsets = UIEdgeInsets(top: iconTopPadding, left: iconDefaultPadding, bottom: iconDefaultPadding, right: iconDefaultPadding)
            iconImageView.autoPinEdgesToSuperviewEdges(with: iconInsets, excludingEdge: ALEdge.bottom)
            iconImageView.autoPinEdge(ALEdge.bottom, to: ALEdge.top, of: textLabel, withOffset: 0)
            
            
            let textLabelInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
            textLabel.autoPinEdgesToSuperviewEdges(with: textLabelInsets, excludingEdge: ALEdge.top)
            textLabel.autoSetDimension(ALDimension.height, toSize: textLabel.intrinsicContentSize.height)
        }

        super.updateConstraints()
    }
    
    override var intrinsicContentSize: CGSize {
        let size = 63
        return CGSize(width: size, height: size)
    }
}
