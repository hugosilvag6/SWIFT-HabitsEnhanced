//
//  HabitCreateInteractor.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 23/08/22.
//

import Foundation
import Combine

class HabitCreateInteractor {
  private let remote: HabitCreateRemoteDataSource = .shared
}

extension HabitCreateInteractor {
  func save(habitCreateRequest request: HabitCreateRequest) -> Future<Void, AppError> {
    return remote.save(request: request)
  }
}

