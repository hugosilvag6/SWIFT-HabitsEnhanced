//
//  Date+Extension.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 09/08/22.
//

import Foundation

extension Date {
  func toString(destPattern dest: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = dest
    return formatter.string(from: self)
  }
}
