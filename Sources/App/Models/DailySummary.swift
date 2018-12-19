//
//  DailySummary.swift
//  App
//
//  Created by Norman Sutorius on 19.12.18.
//

import Vapor

struct DailySummary: Content {
    var listOfFoodStuff:[FoodStuff]
    var timestamp: Double?
}
