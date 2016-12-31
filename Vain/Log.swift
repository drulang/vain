//
//  Log.swift
//  Vain
//
//  Created by Dru Lang on 12/29/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation

import SwiftyBeaver


let log = SwiftyBeaver.self

func initializeLogging() {
    print("Initializing logging")
    log.addDestination(ConsoleDestination())
    log.info("Logging initialized")
}
    
