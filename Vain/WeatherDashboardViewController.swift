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

    fileprivate var constraintsAdded = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Appearance.Palette.Primary
        
        setupSubControllers()
        
        view.setNeedsUpdateConstraints()
    }
 
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            let currentForecastView = currentForecastViewController.view
            let topViewInsets = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
            currentForecastView?.autoPinEdgesToSuperviewEdges(with: topViewInsets, excludingEdge: ALEdge.bottom)
            currentForecastView?.autoConstrainAttribute(ALAttribute.height, to: ALAttribute.height, of: self.view, withMultiplier: 0.75)
        }

        super.updateViewConstraints()
    }
}


//MARK: Helpers
extension WeatherDashboardViewController {

    fileprivate func setupSubControllers() {
        setupCurrentForecastController()
    }
    
    fileprivate func setupCurrentForecastController() {
        addChildViewController(currentForecastViewController)
        view.addSubview(currentForecastViewController.view)
        currentForecastViewController.view.translatesAutoresizingMaskIntoConstraints = false
        currentForecastViewController.didMove(toParentViewController: self)
    }
}
