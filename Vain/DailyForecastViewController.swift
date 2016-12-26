//
//  MultiDayForecastViewController.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit

class DailyForecastViewController: UIViewController {
    fileprivate let collectionView:UICollectionView
    fileprivate let collectionViewLayout = UICollectionViewFlowLayout()
    fileprivate var constraintsAdded = false
    internal    let forecastType = WeatherForecastType.FiveDay
    
    internal    var dailyForecast:DailyForecast? {
        didSet {
            refresh()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()

        view.clipsToBounds = false
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


//MARK: Helpers
extension DailyForecastViewController {

    func setupCollectionView() {
        //Layout
        let width = view.frame.size.width / CGFloat(forecastType.rawValue)
        let height = ForecastDayQuickCollectionViewCell().intrinsicContentSize.height
        collectionViewLayout.itemSize = CGSize(width: width, height: height)
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        preferredContentSize = CGSize(width: view.frame.width, height: height)
        
        // View
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(ForecastDayQuickCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Identifiers.Cell)
    }
}


//MARK: Refresh
extension DailyForecastViewController: Refresh {
    func refresh() {
    
        CommandCenter.shared.dailyForecast(atLocation: Location(), numberOfDays: WeatherForecastType.FiveDay.rawValue, completion: {(dailyForecast:DailyForecast?, error:WeatherServiceError?) in
            self.dailyForecast = dailyForecast
            self.collectionView.reloadData()
        })
    }
}


//MARK: UICollectionViewDataSource
extension DailyForecastViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
        //TODO: Fix
        return dailyForecast?.days.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.Cell, for: indexPath)
        
        return cell
    }
}
