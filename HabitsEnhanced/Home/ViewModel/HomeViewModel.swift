//
//  HomeViewModel.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 12/07/22.
//

import SwiftUI

class HomeViewModel: ObservableObject {
  let habitViewModel = HabitViewModel(isCharts: false, interactor: HabitInteractor())
  let habitForChartsViewModel = HabitViewModel(isCharts: true, interactor: HabitInteractor())
  let profileViewModel = ProfileViewModel(interactor: ProfileInteractor())
}

extension HomeViewModel {
  func habitView() -> some View {
    HomeViewRouter.makeHabitView(viewModel: habitViewModel)
  }
  func habitForChartView() -> some View {
    HomeViewRouter.makeHabitView(viewModel: habitForChartsViewModel)
  }
  func profileView() -> some View {
    HomeViewRouter.makeProfileView(viewModel: profileViewModel)
  }
}
