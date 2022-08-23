//
//  SignInViewModel.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 11/07/22.
//

import SwiftUI
import Combine

class SignInViewModel: ObservableObject {
  
  @Published var email = ""
  @Published var password = ""
  
  private var cancellable: AnyCancellable?
  private var cancellableRequest: AnyCancellable?
  
  // aqui o publisher é criado. Ainda aqui nessa viewmodel está a sink (uma pia), que é o "recebedor". Essa sink serve basicamente para receber uma "mensagem", para que, quando receber, possa mudar o uiState para .goToHomeScreen.
  // O publisher daqui é passado para o Router, que o passa para o viewModel da signup logo após instanciá-la. Lá na signup, quando clicamos no botão de cadastro, esse publisher usa o método "send", que envia a "mensagem". Essa mensagem é recebida aqui, o q significa que o cadastro na signup foi realizado e finalizado, e que, por tanto, podemos enviar o usuário para a homeScreen.
  private let publisher = PassthroughSubject<Bool, Never>()
  private let interactor: SignInInteractor
  
  @Published var uiState: SignInUIState = .none
  
  init (interactor: SignInInteractor) {
    // aqui definimos que o self.interactor vai receber o interactor que veio do parametro (init) quando a classe SignInViewModel for instanciada
    self.interactor = interactor
    // ainda na tela de login, aqui define-se um "observador", que vai ser disparado no futuro. É uma pia que receberá um valor enviado pelo método send lá na tela signup
    // para fixar: o sink é o observador, que devolve o valor passado pelo observado (send)
    // esse publisher é como uma instituição. Em um canto ela terá um observador q recebe (sink) e em outro canto ele tem um observado que envia (send)
    cancellable = publisher.sink { value in
      print("usuário criado! goToHome: \(value)")
      if value {
        // quando a "pia" recebe, significa que deu certo la na signup, entao manda para a home
        self.uiState = .goToHomeScreen
      }
    }
  }
  // o deinit acontece em uma instancia optional que tem seu valor setado como nil
  deinit {
    cancellable?.cancel()
    cancellableRequest?.cancel()
  }
  
  func login() {
    self.uiState = .loading
    // chamamos o interactor
    cancellableRequest = interactor.login(loginRequest: SignInRequest(email: email, password: password))
      .receive(on: DispatchQueue.main)
      .sink { completion in
        // aqui acontece o error ou finished
        switch completion {
        case .failure(let appError):
          self.uiState = .error(appError.message)
          break
        case .finished:
          break
        }
      } receiveValue: { success in
        // aqui acontece o sucesso
        self.interactor.insertAuth(userAuth: UserAuth(idToken: success.accessToken,
                                                      refreshToken: success.refreshToken,
                                                      expires: Date().timeIntervalSince1970 + Double(success.expires),
                                                      tokenType: success.tokenType))
        self.uiState = .goToHomeScreen
      }
  }
}

extension SignInViewModel {
  func homeView () -> some View {
    return SignInViewRouter.makeHomeView()
  }
}

extension SignInViewModel {
  // metodo responsavel por enviar para a tela signup, terceirizando para o router
  func signUpView () -> some View {
    return SignInViewRouter.makeSignUpView(publisher: publisher)
  }
}
