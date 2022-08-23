//
//  HabitInteractor.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 09/08/22.
//

import Foundation
import Combine

class HabitInteractor {
  private let remote: HabitRemoteDataSource = .shared
}

extension HabitInteractor {
  func fetchHabits() -> Future<[HabitResponse], AppError> {
    return remote.fetchHabits()
  }
}
