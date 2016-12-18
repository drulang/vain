//
//  CurrentForecastViewController.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit
import PureLayout

class CurrentForecastViewController: UIViewController {
    
    fileprivate let tempLabel = UILabel(forAutoLayout: ())
    fileprivate let locationLabel = UILabel(forAutoLayout: ())
    fileprivate let dayOverviewLabel = UILabel(forAutoLayout: ())
    fileprivate let weatherConditionImageView = UIImageView(forAutoLayout: ())
    fileprivate var constraintsAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tempLabel)
        view.addSubview(locationLabel)
        view.addSubview(dayOverviewLabel)
        view.addSubview(weatherConditionImageView)
        
        weatherConditionImageView.image = #imageLiteral(resourceName: "IconWeatherSun")
        weatherConditionImageView.contentMode = UIViewContentMode.scaleAspectFill

        tempLabel.font = Appearance.Font.HeroFont
 
        view.setNeedsUpdateConstraints()
        refresh()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            locationLabel.autoPinEdge(toSuperviewEdge: ALEdge.top, withInset: Appearance.Layout.Margin)
            locationLabel.autoPinEdge(toSuperviewMargin: ALEdge.left)
            locationLabel.autoPinEdge(ALEdge.right, to: ALEdge.left, of: weatherConditionImageView, withOffset: Appearance.Layout.Margin)
            
            weatherConditionImageView.autoPinEdge(toSuperviewEdge: ALEdge.top)
            weatherConditionImageView.autoPinEdge(toSuperviewMargin: ALEdge.right)
            weatherConditionImageView.autoSetDimensions(to: CGSize(width: 100, height: 100))
            
            tempLabel.autoAlignAxis(toSuperviewAxis: ALAxis.vertical)
            tempLabel.autoConstrainAttribute(ALAttribute.bottom, to: ALAttribute.horizontal, of: self.view, withOffset: -15)
            
            dayOverviewLabel.autoPinEdge(ALEdge.top, to: ALEdge.bottom, of: tempLabel, withOffset: 30)
            dayOverviewLabel.autoAlignAxis(toSuperviewAxis: ALAxis.vertical)
        }
        super.updateViewConstraints()
    }
    
}


//MARK: Refresh
extension CurrentForecastViewController : Refresh {
    
    func refresh() {
        locationLabel.text = "test"
        tempLabel.text = "32"
        dayOverviewLabel.text = "32/54 Monday"
    }
}


