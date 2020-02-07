//
//  SpeedCriteriaEnum.swift
//  UserTripTask
//
//  Created by Mubashshir on 2/7/20.
//  Copyright © 2020 Mubashshir. All rights reserved.
//

import Foundation
import UIKit

func ==(lhs: SpeedCriteria, rhs: SpeedCriteria) -> Bool{
    return lhs.rawValue == rhs.rawValue
}


func >(lhs: SpeedCriteria, rhs: SpeedCriteria) -> Bool{
    return lhs.rawValue > rhs.rawValue
}

enum SpeedCriteria: Int {
    case stable = 0
    case twenty = 1
    case thirty = 2
    case fifty = 3
    case eighty = 4
    case hundred = 5
    case onetwenty = 6
    case onefifty = 7
    case twohundred = 8
    
    static func intialize(with speed: Double) -> SpeedCriteria {
        switch speed {
        case 0...20:
            return .stable
        case 20...30:
            return .twenty
        case 30...50:
            return .thirty
        case 50...80:
            return .fifty
        case 80...100:
            return .eighty
        case 100...120:
            return .hundred
        case 120...150:
            return .onetwenty
        case 150...200:
            return .onefifty
        default:
            return .stable
        }
        
//        switch speed {
//        case 0...5:
//            return .stable
//        case 5...15:
//            return .twenty
//        case 15...20:
//            return .thirty
//        case 20...25:
//            return .fifty
//        case 25...30:
//            return .eighty
//        case 30...35:
//            return .hundred
//        case 35...45:
//            return .onetwenty
//        case 40...100:
//            return .onefifty
//        default:
//            return .stable
//        }
    }
    
    var timeInterval: TimeInterval?{
        switch self {
        case .stable:
            return nil
        case .twenty:
            return TimeInterval(60)
        case .thirty:
            return TimeInterval(50)
        case .fifty:
            return TimeInterval(40)
        case .eighty:
            return TimeInterval(30)
        case .hundred:
            return TimeInterval(20)
        case .onetwenty:
            return TimeInterval(10)
        case .onefifty:
            return TimeInterval(5)
        case .twohundred:
            return TimeInterval(2)
        }
    }
    
    var colorCriteria : UIColor {
        switch self {
        case .stable:
            return .black
        case .twenty:
            return .blue
        case .thirty:
            return .brown
        case .fifty:
            return .cyan
        case .eighty:
            return .darkGray
        case .hundred:
            return .green
        case .onetwenty:
            return .orange
        case .onefifty:
            return .purple
        case .twohundred:
            return .red
        }
    }
}
