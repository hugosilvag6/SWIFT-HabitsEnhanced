//
//  ProfileInteractor.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 11/08/22.
//

import Foundation
import Combine

class ProfileInteractor {
  private let remote: ProfileRemoteDataSource = .shared
}

extension ProfileInteractor {
  // essa função é chamada pela viewModel
  func fetchUser () -> Future<ProfileResponse, AppError> {
    return remote.fetchUser()
  }
  func updateUser (userId: Int, profileRequest: ProfileRequest) -> Future<ProfileResponse, AppError> {
    return remote.updateUser(userId: userId, request: profileRequest)
  }
}
