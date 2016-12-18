//
//  WeatherDashboardViewController.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit
import PureLayout

class WeatherDashboardViewController: UIViewController {

    fileprivate let currentForecastViewController = CurrentForecastViewController()
    fileprivate let weekForecastViewController = MultiDayForecastViewController()
    
    fileprivate var constraintsAdded = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Appearance.Palette.Primary

        setupSubControllers()
        
        weekForecastViewController.view.box()
        view.setNeedsUpdateConstraints()
    }
 
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            let currentForecastView = currentForecastViewController.view
            let topViewInsets = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
            currentForecastView?.autoPinEdgesToSuperviewEdges(with: topViewInsets, excludingEdge: ALEdge.bottom)
            currentForecastView?.autoConstrainAttribute(ALAttribute.height, to: ALAttribute.height, of: self.view, withMultiplier: 0.75)
            
            
            if let currentForecastView = currentForecastView {
                let weekForecastView = weekForecastViewController.view
                
                weekForecastView?.autoPinEdge(ALEdge.top, to: ALEdge.bottom, of: currentForecastView)
                weekForecastView?.autoPinEdge(toSuperviewEdge: ALEdge.left)
                weekForecastView?.autoPinEdge(toSuperviewEdge: ALEdge.right)
                weekForecastView?.autoSetDimension(ALDimension.height, toSize: weekForecastViewController.preferredContentSize.height)
            } else {
                log.warning("Attempting to layout weekForecastViewController.view with a nil currentForecastViewController.view")
            }
        }
        
        super.updateViewConstraints()
    }
}


//MARK: Helpers
extension WeatherDashboardViewController {

    fileprivate func setupSubControllers() {
        setupChildController(controller: currentForecastViewController)
        setupChildController(controller: weekForecastViewController)
    }
    
    private func setupChildController(controller:UIViewController) {
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.didMove(toParentViewController: self)
    }
}
