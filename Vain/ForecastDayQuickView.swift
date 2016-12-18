//
//  ForecastDayQuickView.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit
import PureLayout


class ForecastDayQuickView : UIView {
    let forecastQuickView = ForecastQuickView(forAutoLayout: ())
    let textLabel = UILabel(forAutoLayout: ())
    fileprivate var constraintsAdded = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(forecastQuickView)
        addSubview(textLabel)
        
        textLabel.text = "Mon"
        
        setNeedsUpdateConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if  !constraintsAdded {
            constraintsAdded = true

            forecastQuickView.autoPinEdge(toSuperviewEdge: ALEdge.top)
            forecastQuickView.autoAlignAxis(toSuperviewAxis: ALAxis.vertical)
            forecastQuickView.autoSetDimensions(to: forecastQuickView.intrinsicContentSize)
            
            textLabel.autoPinEdge(ALEdge.top, to: ALEdge.bottom, of: forecastQuickView)
            textLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: ALEdge.top)
            textLabel.autoSetDimension(ALDimension.height, toSize: textLabel.intrinsicContentSize.height)
        }
        
        super.updateConstraints()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = forecastQuickView.intrinsicContentSize.height + textLabel.intrinsicContentSize.height
        return CGSize(width: super.intrinsicContentSize.width, height: height)
    }
}
