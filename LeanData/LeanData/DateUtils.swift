//
//  DateUtils.swift
//  LeanData
//
//  Created by xu on 2020/7/1.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit


fileprivate let dateFormatter = DateFormatter()

extension Date {
    
    init(year: Int, month: Int = 1, day: Int = 1) {
        dateFormatter.dateFormat = "yyyyMMdd"
        let str = String.init(format: "%04d%02d%02d", year, month, day)
        let d = dateFormatter.date(from: str)
        self = d ?? Date()
    }
    
    init(dateInt: Int) {
        dateFormatter.dateFormat = "yyyyMMdd"
        self = dateFormatter.date(from: String(dateInt)) ?? Date()
    }
    
    var fullDesc: String {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    var descForArchiveSection: String {
        dateFormatter.dateFormat = "LLLL, yyyy"
        return dateFormatter.string(from: self)
    }
    
    func add(year: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: year, to: self) ?? self
    }
    func add(month: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: month, to: self) ?? self
    }
    func add(week: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: week*7, to: self) ?? self
    }
    func add(day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: self) ?? self
    }
    func add(second: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: second, to: self) ?? self
    }
    
    var dateInt: Int {
        dateFormatter.dateFormat = "yyyyMMdd"
        let str = dateFormatter.string(from: self)
        return Int(str) ?? 0
    }
    var dateStr: String {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var week: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
}

