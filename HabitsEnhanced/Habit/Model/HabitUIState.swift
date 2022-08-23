//
//  HabitUIState.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 08/08/22.
//

import Foundation

enum HabitUIState: Equatable {
  case loading
  // sucesso
  case emptyList
  case fullList([HabitCardViewModel])
  // erro
  case error(String)
}
