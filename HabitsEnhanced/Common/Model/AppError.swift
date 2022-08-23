//
//  AppError.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 03/08/22.
//

import Foundation

enum AppError: Error {
  
  case response(message: String)
  
  public var message: String {
    switch self {
    case .response(let message):
      return message
    }
  }
  
}
