//
//  UserManager.swift
//  LeanData
//
//  Created by xu on 2020/7/1.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit
import LeanCloud

struct UserManager {
    
    static var currentUser: LCUser? {
        return LCApplication.default.currentUser
    }
    
    /// 性别
    ///
    /// - secrecy: 保密
    /// - male: 男
    /// - female: 女
    public enum Gender: String {
        case secrecy = "Secrecy"
        case male = "Male"
        case female = "Female"
        
        public init(_ rawValue: String){
            switch rawValue {
            case "Male":
                self = .male
            case "Female":
                self = .female
            default:
                self = .secrecy
            }
        }
        
        public init(_ intValue: Int){
            switch intValue {
            case 1:
                self = .male
            case 2:
                self = .female
            default:
                self = .secrecy
            }
        }
        
        public var index: Int {
            switch self {
            case .male:
                return 1
            case .female:
                return 2
            default:
                return 0
            }
        }
        
    }
    
    /// 公英制单位
    ///
    /// - metric: 公制单位，单位为m,kg
    /// - imperial: 英制单位，单位为ft,lb
    public enum Unit: String {
        case metric = "Metric"
        case imperial = "Imperial"
        
        public init(_ rawValue: String){
            switch rawValue {
            case "Imperial":
                self = .imperial
            default:
                self = .metric
            }
        }
        
        public init(_ intValue: Int){
            switch intValue {
            case 1:
                self = .imperial
            default:
                self = .metric
            }
        }
        
        
        public var index: Int {
            switch self {
            case .imperial:
                return 1
            default:
                return 0
            }
        }
        
        public static func metricFromImperial(height: Double) -> Double {
            return height/3.2808
        }
        
        public static func metricFromImperial(weight: Double) -> Double {
            return weight*0.4536
        }
        
        public static func imperialFromMetric(height: Double) -> Double {
            return height*3.2808
        }
        
        public static func imperialFromMetric(weight: Double) -> Double {
            return weight/0.4536
        }
    }
}


// MARK: - 扩展属性
extension LCUser {
    
    @objc dynamic var nickname: String? {
        set{
            do {
                try set("nickname", value: newValue)
            } catch {
                debugPrint(error)
            }
        }
        get{
            return get("nickname")?.stringValue ?? ""
        }
    }
    @objc dynamic var avatar: UIImage? {
        set{
            do {
                if let img = newValue, let dt = img.pngData() {
                    try set("avatar", value: dt)
                }
            } catch {
                debugPrint(error)
            }
        }
        get{
            if let dt = get("avatar") as? Data {
                return UIImage(data: dt)
            } else {
                return nil
            }
        }
    }
    
    @objc dynamic var gender: UserManager.Gender.RawValue {
        set{
            do {
                try set("gender", value: newValue)
            } catch {
                debugPrint(error)
            }
        }
        get{
            return get("gender")?.stringValue ?? ""
        }
    }
    
    @objc dynamic var birth: Date? {
        set{
            do {
                try set("birth", value: newValue)
            } catch {
                debugPrint(error)
            }
        }
        get{
            return get("birth")?.dateValue
        }
    }
    
    @objc dynamic var height: Double {
        set{
            do {
                try set("height", value: newValue)
            } catch {
                debugPrint(error)
            }
        }
        get{
            return get("height")?.doubleValue ?? 1.8
        }
    }
    @objc dynamic var weight: Double {
        set{
            do {
                try set("weight", value: newValue)
            } catch {
                debugPrint(error)
            }
        }
        get{
            return get("weight")?.doubleValue ?? 60
        }
    }
    
    @objc dynamic var unit: UserManager.Unit.RawValue {
        set{
            do {
                try set("unit", value: newValue)
            } catch {
                debugPrint(error)
            }
        }
        get{
            return get("unit")?.stringValue ?? ""
        }
    }
    
    
}

// MARK: - 扩展方法
extension LCUser {
    func getBMI() -> Double {
        return weight / pow(height, 2)
    }
    func getAge() -> Int? {
        if let b = birth {
            let interval = Date().timeIntervalSince(b)
            let year = interval / 60 / 60 / 24 / 365
            return Int(year)
        } else {
            return nil
        }
    }
    func getHeightDesc() -> String {
        if unit == UserManager.Unit.imperial.rawValue {
            let h = height*3.2808
            return String.init(format: "%.2f ft", h)
        } else {
            return String.init(format: "%.0f cm", height * 100)
        }
    }
    func getWeightDesc() -> String {
        if unit == UserManager.Unit.imperial.rawValue {
            return String.init(format: "%.2f lb", weight/0.4536)
        } else {
            return String.init(format: "%.1f kg", weight)
        }
    }
}
