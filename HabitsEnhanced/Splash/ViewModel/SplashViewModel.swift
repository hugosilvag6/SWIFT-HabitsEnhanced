//
//  SplashViewModel.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 11/07/22.
//

import SwiftUI
import Combine

class SplashViewModel: ObservableObject {
    
    // essa é a variável observada
    @Published var uiState: SplashUIState = .loading
  
  private var cancellableAuth: AnyCancellable?
  private var cancellableRefresh: AnyCancellable?
  
  private let interactor: SplashInteractor
  
  init (interactor: SplashInteractor) {
    self.interactor = interactor
  }
  deinit {
    cancellableAuth?.cancel()
    cancellableRefresh?.cancel()
  }
    
    func onAppear() {
      cancellableAuth = interactor.fetchAuth()
        .delay(for: .seconds(2), scheduler: RunLoop.main)
        .receive(on: DispatchQueue.main)
        .sink { userAuth in
          // se userAuth == nil       -> Login
          if userAuth == nil {
            self.uiState = .goToSignInScreen
            // se != nil && expirou               -> Refresh
          } else if (Date().timeIntervalSince1970 > Double(userAuth!.expires)) { // timeinterval = quantos segundos passaram desde 1970, basicamente a data de AGORA. se agora é maior que o momento em que o token expira, significa que ele já expirou
            
            // para forçar o usuario a logar de novo (apesar de ser cansativo pro usuario), basta fazer
            // self.uiState = .goToSignInScreen
            print("token expirou")
            self.cancellableRefresh = self.interactor.refreshToken(refreshRequest: RefreshRequest(token: userAuth!.refreshToken))
              .receive(on: DispatchQueue.main)
              .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_):
                  // caso dê erro com o refreshToken, já manda pra tela de login logo pra refazer e pgar um novo
                  self.uiState = .goToSignInScreen
                  break
                default:
                  break
                }
              }, receiveValue: { success in
                  self.interactor.insertAuth(userAuth: UserAuth(idToken: success.accessToken,
                                                                refreshToken: success.refreshToken,
                                                                expires: Date().timeIntervalSince1970 + Double(success.expires),
                                                                tokenType: success.tokenType))
                  self.uiState = .goToHomeScreen
              })
            
            
            // else                                  -> Home
          } else {
            self.uiState = .goToHomeScreen
          }
        }
    }
}

extension SplashViewModel {
    func signInView () -> some View {
        // é a função responsável por nos conectar com a próxima janela/view/viewmodel etc
        return SplashViewRouter.makeSignInView()
    }
  func homeView () -> some View {
    return SplashViewRouter.makeHomeView()
  }
}
