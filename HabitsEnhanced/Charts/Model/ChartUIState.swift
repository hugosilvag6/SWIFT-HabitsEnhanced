//
//  ChartUIState.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 16/08/22.
//

import Foundation

enum ChartUIState: Equatable {
  case loading
  case emptyChart
  case fullChart
  case error(String)
}
