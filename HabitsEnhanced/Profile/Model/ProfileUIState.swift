//
//  ProfileUIState.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 11/08/22.
//

import Foundation

enum ProfileUIState: Equatable {
  case none
  case loading
  case fetchSuccess
  case fetchError(String)
  
  case updateLoading
  case updateSuccess
  case updateError(String)
}
