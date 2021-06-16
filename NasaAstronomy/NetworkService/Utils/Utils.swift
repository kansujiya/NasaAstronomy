//
//  Utils.swift
//  NetworkService
//
//  Created by suresh kansujiya on 15/06/21.
//

import Foundation
import UIKit

let dateFormat = "ddMMyyyy"

func shortStringValueInYYYYMMDDAsDate(_ date: Date?) -> String? {
    guard let dateValue = date else { return nil }
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = dateFormat
    return formatter.string(from: dateValue)
}

func shortStringValueInYYYYMMDDAsDayBeforeDate(_ date: Date?) -> String? {
    guard let dateValue = date else { return nil }
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = dateFormat
    let lastTime: TimeInterval = -(24*60*60)
    let lastDate = dateValue.addingTimeInterval(lastTime)
    return formatter.string(from: lastDate)
}
