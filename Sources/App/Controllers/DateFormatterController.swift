//
//  DateFormatterController.swift
//  App
//
//  Created by Norman Sutorius on 20.12.18.
//

import Foundation

class DateFormatterController {
    
    func currentDayInSeconds() -> Date {
        let timestamp = Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        print(TimeZone.current.abbreviation() ?? "GMT")
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd.MM.yyyy" //Specify your format that you want
        
        let strDate = dateFormatter.string(from: date)
        print(strDate)
        return dateFormatter.date(from: strDate)!
    }
}
