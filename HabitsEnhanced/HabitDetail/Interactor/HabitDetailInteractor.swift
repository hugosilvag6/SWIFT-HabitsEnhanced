//
//  HabitDetailInteractor.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 09/08/22.
//

import Foundation
import Combine

class HabitDetailInteractor {
  private let remote: HabitDetailRemoteDataSource = .shared
}

extension HabitDetailInteractor {
  func save(habitId: Int, habitValueRequest request: HabitValueRequest) -> Future<Bool, AppError> {
    return remote.save(habitId: habitId, request: request)
  }
}
