//
//  TodayViewController.swift
//  VainWidget
//
//  Created by Dru Lang on 12/29/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController: UIViewController {

    fileprivate let tempLabel = UILabel()
    fileprivate let locationLabel = UILabel()
    fileprivate let weatherConditionImageView = UIImageView()
    fileprivate var constraintsAdded = false
    fileprivate let formatter = ForecastMeasurementFormatter()
    fileprivate var forecast:Forecast? {
        didSet {
            refreshInterface()
        }
    }
    
    internal var location:Location? {
        didSet {
            refreshData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherConditionImageView.translatesAutoresizingMaskIntoConstraints = false
        
        initializeLogging()
        
        view.addSubview(tempLabel)
        view.addSubview(locationLabel)
        view.addSubview(weatherConditionImageView)

        weatherConditionImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        tempLabel.font = Appearance.Font.HeroFontSmall

        view.setNeedsUpdateConstraints()
        refreshInterface()
        
    
        CommandCenter.shared.requestLocationUseAuthorization { (error:LocationServiceError?) in
                CommandCenter.shared.currentLocation { (location:Location?, error:LocationServiceError?) in
                    if error != nil {
                        log.error("There was an error retreiving user's location: \(error)")
                    }
                    self.location = location
                }
        }

    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            let heightRation = 0.7
            
            view.addConstraint(NSLayoutConstraint(item: locationLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 15))
            view.addConstraint(NSLayoutConstraint(item: locationLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: tempLabel, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 15))
            
            view.addConstraint(NSLayoutConstraint(item: tempLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: tempLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
            
            view.addConstraint(NSLayoutConstraint(item: weatherConditionImageView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -15))
            view.addConstraint(NSLayoutConstraint(item: weatherConditionImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: weatherConditionImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.height, multiplier: CGFloat(heightRation), constant: 0))
            view.addConstraint(NSLayoutConstraint(item: weatherConditionImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: weatherConditionImageView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
        }
        
        super.updateViewConstraints()
    }
}


//MARK: NCWidgetProviding

extension TodayViewController : NCWidgetProviding {
    
    public func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        refreshInterface()

        completionHandler(NCUpdateResult.newData)
    }
}


//MARK: Refresh
extension TodayViewController : Refresh {
    
    func refreshInterface() {
        locationLabel.text = location?.displayName
        
        guard let forecast = forecast else {
            log.warning("Attempting to refresh interface with nil forecast")
            return
        }

        weatherConditionImageView.image = UIImage.imageTemplate(named: forecast.condition.imageName())
        weatherConditionImageView.tintColor = forecast.condition.color()
        
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
