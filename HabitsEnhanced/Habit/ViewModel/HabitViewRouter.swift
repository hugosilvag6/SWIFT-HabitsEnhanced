//
//  HabitViewRouter.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 22/08/22.
//

import Foundation
import Combine
import SwiftUI

enum HabitViewRouter {
  static func makeHabitCreateView (habitPublisher: PassthroughSubject<Bool, Never>) -> some View {
    let viewModel = HabitCreateViewModel(interactor: HabitCreateInteractor())
    viewModel.habitPublisher = habitPublisher
    return HabitCreateView(viewModel: viewModel)
  }
}
