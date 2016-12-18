//
//  ForecastDayQuickCollectionViewCell.swift
//  Vain
//
//  Created by Dru Lang on 12/13/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//
import PureLayout
import UIKit

class ForecastDayQuickCollectionViewCell : UICollectionViewCell {

    internal let forecastView = ForecastDayQuickView(forAutoLayout: ())
    private  var constraintsAdded = false
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(forecastView)
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !constraintsAdded {
            forecastView.autoPinEdgesToSuperviewEdges()
        }

        super.updateConstraints()
    }
    
    override var intrinsicContentSize: CGSize {
        return forecastView.intrinsicContentSize
    }
}
