//
//  SignUpUIState.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 12/07/22.
//

import Foundation

enum SignUpUIState: Equatable {
  case none
  case loading
  case success
  case error(String)
}
