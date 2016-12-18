//
//  MultiDayForecastViewController.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit

class MultiDayForecastViewController: UIViewController {
    fileprivate let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    fileprivate var constraintsAdded = false

    internal    var forecast:MultiDayForecast? {
        didSet {
            refresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(ForecastDayQuickCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Identifiers.Cell)
        
        view.addSubview(collectionView)
        
        view.setNeedsUpdateConstraints()
        
        refresh()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            collectionView.autoPinEdgesToSuperviewEdges()
        }
        
        super.updateViewConstraints()
    }
}


//MARK: Refresh
extension MultiDayForecastViewController: Refresh {
    func refresh() {
        
        CommandCenter.shared.fiveDayForecast(atLocation: Location(), completion: {(forecast:MultiDayForecast?, error:WeatherServiceError?) in
                self.forecast = forecast
                self.collectionView.reloadData()
        })
    }
}


//MARK: UICollectionViewDataSource
extension MultiDayForecastViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
        return forecast?.days.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.Cell, for: indexPath)
        cell.box()
        
        return cell
    }
}
