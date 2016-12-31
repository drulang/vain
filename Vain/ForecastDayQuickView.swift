//
//  ForecastDayQuickView.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit
import PureLayout

private struct ForecastDayQuickViewConfig {
    struct Layout {
        static let TextLabelTopPadding = CGFloat(5)
        static let SubtitleLabelTopPadding = CGFloat(10)
    }
}

class ForecastDayQuickView : UIView {
    let forecastQuickView = ForecastQuickView(forAutoLayout: ())
    let textLabel = UILabel(forAutoLayout: ())
    let subtitleLabel = UILabel(forAutoLayout: ())
    fileprivate var constraintsAdded = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(forecastQuickView)
        addSubview(textLabel)
        addSubview(subtitleLabel)
        
        textLabel.text = "M"
        textLabel.textAlignment = NSTextAlignment.center
        textLabel.font = Appearance.Font.IconSubtitleFont
        
        subtitleLabel.text = "45  23"
        subtitleLabel.textAlignment = NSTextAlignment.center
        subtitleLabel.font = Appearance.Font.SubtitleFont
        
        setNeedsUpdateConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if  !constraintsAdded {
            constraintsAdded = true

            textLabel.autoPinEdge(toSuperviewEdge: ALEdge.top)
            textLabel.autoAlignAxis(ALAxis.vertical, toSameAxisOf: forecastQuickView)
            textLabel.autoSetDimension(ALDimension.height, toSize: textLabel.intrinsicContentSize.height)

            forecastQuickView.autoPinEdge(ALEdge.top, to: ALEdge.bottom, of: textLabel, withOffset:ForecastDayQuickViewConfig.Layout.TextLabelTopPadding)
            forecastQuickView.autoAlignAxis(toSuperviewAxis: ALAxis.vertical)
            forecastQuickView.autoSetDimensions(to: forecastQuickView.intrinsicContentSize)

            subtitleLabel.autoPinEdge(ALEdge.top, to: ALEdge.bottom, of: forecastQuickView, withOffset:ForecastDayQuickViewConfig.Layout.SubtitleLabelTopPadding)
            subtitleLabel.autoAlignAxis(ALAxis.vertical, toSameAxisOf: textLabel)
            subtitleLabel.autoSetDimension(ALDimension.height, toSize: subtitleLabel.intrinsicContentSize.height)
            
        }
        
        super.updateConstraints()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = forecastQuickView.intrinsicContentSize.height + textLabel.intrinsicContentSize.height + ForecastDayQuickViewConfig.Layout.TextLabelTopPadding + subtitleLabel.intrinsicContentSize.height + ForecastDayQuickViewConfig.Layout.SubtitleLabelTopPadding
        return CGSize(width: super.intrinsicContentSize.width, height: height)
    }
}
