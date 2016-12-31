//
//  MeasurementFormatter.swift
//  Vain
//
//  Created by Dru Lang on 12/28/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation

class ForecastMeasurementFormatter : MeasurementFormatter {

    override init() {
        super.init()

        let formatter = NumberFormatter()
        formatter.numberStyle = .none

        self.unitStyle = .short
        self.numberFormatter = formatter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Helpers
extension ForecastMeasurementFormatter {
    
    func hiAndLo(forecast:Forecast) -> String {
        return "\(string(from: forecast.lo)) \(string(from: forecast.hi))"
    }
}
