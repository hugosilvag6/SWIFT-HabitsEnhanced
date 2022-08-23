//
//  SignInInteractor.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 05/08/22.
//

import Foundation
import Combine

class SignUpInteractor {
  private let remoteSignUp: SignUpRemoteDataSource = .shared
  private let remoteSignIn: SignInRemoteDataSource = .shared
  private let local: LocalDataSource = .shared
}

// uma forma interessante de usar extensions seria para separar o que for lógica do que for variável, e é o que fazemos nesse arquivo
extension SignUpInteractor {
  // essa função é chamada pela viewModel
  func postUser(signUpRequest request: SignUpRequest) -> Future<Bool, AppError> {
    return remoteSignUp.postUser(request: request)
  }
  func login(signInRequest request: SignInRequest) -> Future<SignInResponse, AppError> {
    return remoteSignIn.login(request: request)
  }
  func insertAuth(userAuth: UserAuth) {
    local.insertUserAuth(userAuth: userAuth)
  }
}
