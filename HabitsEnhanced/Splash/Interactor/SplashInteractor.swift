//
//  SplashInteractor.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 08/08/22.
//

import Foundation
import Combine

class SplashInteractor {
  private let remote: SplashRemoteDataSource = .shared
  private let local: LocalDataSource = .shared
}

extension SplashInteractor {
  func fetchAuth () -> Future<UserAuth?, Never> {
    return local.getUserAuth()
  }
  func insertAuth(userAuth: UserAuth) {
    local.insertUserAuth(userAuth: userAuth)
  }
  func refreshToken(refreshRequest request: RefreshRequest) -> Future<SignInResponse, AppError> {
    return remote.refreshToken(request: request)
  }
}
