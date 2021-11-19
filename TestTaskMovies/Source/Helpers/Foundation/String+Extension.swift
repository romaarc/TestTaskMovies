//
//  String+Extension.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 09.11.2021.
//

import Foundation

extension String {
    func getYear(withDate date: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy'-'MM'-'dd"
        guard let backendDate = dateformatter.date(from: date) else { return "" }
        
        let formatDate = DateFormatter()
        formatDate.locale = .init(identifier: "ru_RU")
        formatDate.dateFormat = "yyyy"
        let date = formatDate.string(from: backendDate)
        
        return date
    }    
}
