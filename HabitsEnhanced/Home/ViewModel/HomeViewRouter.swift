//
//  HomeViewRouter.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 08/08/22.
//

import Foundation
import SwiftUI

enum HomeViewRouter {
  static func makeHabitView (viewModel: HabitViewModel) -> some View {
    return HabitView(viewModel: viewModel)
  }
  static func makeProfileView (viewModel: ProfileViewModel) -> some View {
    return ProfileView(viewModel: viewModel)
  }
}
