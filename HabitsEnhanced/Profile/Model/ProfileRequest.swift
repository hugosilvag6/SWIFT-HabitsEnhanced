//
//  ProfileRequest.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 11/08/22.
//

import Foundation

struct ProfileRequest: Encodable {

  let fullName: String
  let phone: String
  let birthday: String
  let gender: Int
  
  enum CodingKeys: String, CodingKey {
    case fullName = "name"
    case phone
    case birthday
    case gender
  }
}
