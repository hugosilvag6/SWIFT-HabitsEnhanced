//
//  HabitCardViewModel.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 08/08/22.
//

import Foundation
import SwiftUI
import Combine

struct HabitCardViewModel: Identifiable, Equatable {
  
  var id: Int = 0
  var icon: String = ""
  var date: String = ""
  var name: String = ""
  var label: String = ""
  var value: String = ""
  var state: Color = .green
  var habitPublisher: PassthroughSubject<Bool, Never>
  
  static func == (lhs: HabitCardViewModel, rhs: HabitCardViewModel) -> Bool {
    return lhs.id == rhs.id
  }
  
}

extension HabitCardViewModel {
  func habitDetailView () -> some View {
    HabitCardViewRouter.makeHabitDetailView(id: id, name: name, label: label, habitPublisher: habitPublisher)
  }
  func chartView () -> some View {
    HabitCardViewRouter.makeChartView(id: id)
  }
}
