//
//  HabitDetailUIState.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 09/08/22.
//

import Foundation

enum HabitDetailUIState: Equatable {
  case none
  case loading
  case success
  case error(String)
}
