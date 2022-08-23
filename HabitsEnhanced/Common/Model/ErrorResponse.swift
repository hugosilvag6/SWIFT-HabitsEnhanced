//
//  ErrorResponse.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 28/07/22.
//

import Foundation

struct ErrorResponse: Decodable {
  let detail: String
  
  
  enum CodingKeys: String, CodingKey {
    case detail
  }
}
