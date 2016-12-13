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
            
            forecastQuickView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: ALEdge.bottom)
            
            textLabel.autoPinEdge(ALEdge.top, to: ALEdge.bottom, of: forecastQuickView)
            textLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: ALEdge.top)
        }
        
        super.updateConstraints()
    }
}
