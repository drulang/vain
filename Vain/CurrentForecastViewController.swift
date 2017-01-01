//
//  CurrentForecastViewController.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit
import PureLayout

protocol CurrentForecastViewDelegate {
    func currentForecastChanged(forecast:Forecast?)
}

class CurrentForecastViewController: UIViewController {
    fileprivate let tempLabel = UILabel(forAutoLayout: ())
    fileprivate let locationLabel = UILabel(forAutoLayout: ())
    fileprivate let weatherConditionImageView = UIImageView(forAutoLayout: ())
    
    fileprivate let dayOverviewLabel = UILabel(forAutoLayout: ())
    fileprivate var constraintsAdded = false
    fileprivate let formatter = ForecastMeasurementFormatter()

    fileprivate var forecast:Forecast? {
        didSet {
            refreshInterface()
            delegate?.currentForecastChanged(forecast: forecast)
        }
    }

    internal var location:Location? {
        didSet {
            refreshData()
        }
    }
    internal var delegate:CurrentForecastViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tempLabel)
        view.addSubview(locationLabel)
        view.addSubview(dayOverviewLabel)
        view.addSubview(weatherConditionImageView)
        
        weatherConditionImageView.contentMode = UIViewContentMode.scaleAspectFit
        weatherConditionImageView.tintColor = Appearance.Palette.Text.Primary

        tempLabel.font = Appearance.Font.HeroFont
        tempLabel.textColor = Appearance.Palette.Text.Primary

        locationLabel.textColor = Appearance.Palette.Text.Primary
        locationLabel.font = Appearance.Font.SubtitleFontMedium
        
        dayOverviewLabel.textColor = Appearance.Palette.Text.Primary
        dayOverviewLabel.font = Appearance.Font.TitleFontMedium
        
        view.setNeedsUpdateConstraints()
        refreshInterface()
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
            
            tempLabel.autoAlignAxis(ALAxis.vertical, toSameAxisOf: view, withOffset: 20)
            tempLabel.autoConstrainAttribute(ALAttribute.horizontal, to: ALAttribute.horizontal, of: self.view, withOffset: -10)
            
            dayOverviewLabel.autoPinEdge(ALEdge.top, to: ALEdge.bottom, of: tempLabel, withOffset: 30)
            dayOverviewLabel.autoAlignAxis(toSuperviewAxis: ALAxis.vertical)
        }
        super.updateViewConstraints()
    }
    
}


//MARK: Refresh
extension CurrentForecastViewController : Refresh {
    
    func refreshInterface() {
        locationLabel.text = location?.displayName

        guard let forecast = forecast else {
            log.warning("Attempting to refresh interface with nil forecast")
            return
        }

        dayOverviewLabel.text = formatter.hiAndLo(forecast: forecast)
        weatherConditionImageView.image = UIImage.imageTemplate(named: forecast.condition.imageName())

        if let currentTemp = forecast.current {
            self.tempLabel.text = "\(formatter.string(from: currentTemp))"
        } else {
            self.tempLabel.text = "-"
        }
    }
    
    func refreshData() {
        guard let location = location else {
            log.warning("Attempting to fetch current forecast with nil location")
            return
        }
        
        CommandCenter.shared.currentForecast(atLocation: location, completion: {(forecast:Forecast?, error:WeatherServiceError?) in
            log.debug("Forecast:  \(forecast)")
            self.forecast = forecast
        })
    }
}


