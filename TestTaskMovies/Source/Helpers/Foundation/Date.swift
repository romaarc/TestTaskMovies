//
//  Date.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 17.11.2021.
//

import Foundation
extension Date {
    func getGMTTimeDate() -> Date {
       var comp: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
       comp.calendar = Calendar.current
       comp.timeZone = TimeZone(abbreviation: "GMT")!
       return Calendar.current.date(from: comp)!
    }
}
