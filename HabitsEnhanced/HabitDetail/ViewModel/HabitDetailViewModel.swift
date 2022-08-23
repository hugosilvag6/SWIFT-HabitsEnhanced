//
//  HabitDetailViewModel.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 09/08/22.
//

import Foundation
import SwiftUI
import Combine

class HabitDetailViewModel: ObservableObject {
  @Published var uiState: HabitDetailUIState = .none
  @Published var value: String = ""
  let id: Int
  let name: String
  let label: String
  let interactor: HabitDetailInteractor
  private var cancellable: AnyCancellable?
  var cancellables = Set<AnyCancellable>()
  var habitPublisher: PassthroughSubject<Bool, Never>?
  
  init (id: Int, name: String, label: String, interactor: HabitDetailInteractor) {
    self.id = id
    self.name = name
    self.label = label
    self.interactor = interactor
  }
  deinit {
    cancellable?.cancel()
    for cancellable in cancellables {
      cancellable.cancel()
    }
  }
  func save () {
    self.uiState = .loading
    cancellable = interactor.save(habitId: id, habitValueRequest: HabitValueRequest(value: value))
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let appError):
          self.uiState = .error(appError.message)
        case .finished:
          break
        }
      }, receiveValue: { created in
        if created {
          self.uiState = .success
          self.habitPublisher?.send(created)
        }
      })
  }
  
}
