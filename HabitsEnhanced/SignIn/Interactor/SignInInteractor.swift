//
//  SignInInteractor.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 03/08/22.
//

import Foundation
import Combine

class SignInInteractor {
  private let remote: SignInRemoteDataSource = .shared
  private let local: LocalDataSource = .shared
}

// uma forma interessante de usar extensions seria para separar o que for lógica do que for variável, e é o que fazemos nesse arquivo
extension SignInInteractor {
  // essa função é chamada pela viewModel
  func login(loginRequest request: SignInRequest) -> Future<SignInResponse, AppError> {
    // e chama o remote
    return remote.login(request: request)
  }
  
  // esse interactor toma a decisão de o que fazer com o processo de inserção do userAuth
  func insertAuth(userAuth: UserAuth) {
    local.insertUserAuth(userAuth: userAuth)
  }
}
