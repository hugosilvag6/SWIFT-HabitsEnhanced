//
//  SplashViewRouter.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 11/07/22.
//

import SwiftUI

// este é o arquivo responsável pelas próximas rotas, que além de loading e error podem ser home ou signin
// criamos um enum pois é apenas precisamos conectar os casos de uso (proxima view, viewmodel, model)
enum SplashViewRouter {
    
    // criamos uma static pra que não seja necessário instanciar um objeto desse enum, o que seria, de certa forma, desnecessário
    static func makeSignInView () -> some View {
        let viewModel = SignInViewModel(interactor: SignInInteractor())
        return SignInView(viewModel: viewModel)
    }
  static func makeHomeView () -> some View {
      let viewModel = HomeViewModel()
      return HomeView(viewModel: viewModel)
  }
}
