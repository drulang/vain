//
//  MultiDayForecastViewController.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit

class DailyForecastViewController: UIViewController {
    fileprivate let formatter = ForecastMeasurementFormatter()
    fileprivate let dateFormatter = DateFormatter()
    fileprivate let collectionView:UICollectionView
    fileprivate let collectionViewLayout = UICollectionViewFlowLayout()
    fileprivate var constraintsAdded = false
    internal    let forecastType = WeatherForecastType.FiveDay
    
    internal    var dailyForecast:DailyForecast? {
        didSet {
            refreshInterface()
        }
    }

    internal var location:Location? {
        didSet {
            refreshData()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        
        dateFormatter.dateFormat = "E"
        
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
    func refreshInterface() {
        self.collectionView.reloadData()
    }
    
    func refreshData() {
        guard let location = location else {
            log.warning("Attempting to fetch daily forecast with nil location")
            return
        }

        CommandCenter.shared.dailyForecast(atLocation: location, numberOfDays: WeatherForecastType.FiveDay.rawValue, completion: {(dailyForecast:DailyForecast?, error:WeatherServiceError?) in
            self.dailyForecast = dailyForecast
        })
    }
}


//MARK: UICollectionViewDataSource
extension DailyForecastViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyForecast?.days.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.Cell, for: indexPath)
        
        guard let forecastCell = cell as? ForecastDayQuickCollectionViewCell,
            let forecast = dailyForecast?.days[indexPath.row]
            else {
                log.warning("Attempting to render an invalid cell")
                return cell;
        }
        
        forecastCell.forecastView.subtitleLabel.text = formatter.hiAndLo(forecast: forecast)
        forecastCell.forecastView.forecastQuickView.iconImageView.image = UIImage.imageTemplate(named: forecast.condition.imageName())
        forecastCell.forecastView.forecastQuickView.iconImageView.tintColor = forecast.condition.color()
        
        let dateText = dateFormatter.string(from: forecast.date)
        forecastCell.forecastView.textLabel.text = dateText

        return cell
    }
}
