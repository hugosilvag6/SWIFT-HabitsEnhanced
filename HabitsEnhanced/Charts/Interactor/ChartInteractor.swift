//
//  ChartInteractor.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 16/08/22.
//

import Foundation
import Combine

class ChartInteractor {
  private let remote: ChartRemoteDataSource = .shared
}

extension ChartInteractor {
  // essa função é chamada pela viewModel
  func fetchHabitValues (habitId: Int) -> Future<[HabitValueResponse], AppError> {
    return remote.fetchHabitValues(habitId: habitId)
  }
}
