//
//  SignUpViewModel.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 12/07/22.
//

import SwiftUI
import Combine

class SignUpViewModel: ObservableObject {
  
  @Published var email = ""
  @Published var password = ""
  @Published var fullName = ""
  @Published var document = ""
  @Published var phone = ""
  @Published var birthday = ""
  @Published var gender = Gender.male
  
  var publisher: PassthroughSubject<Bool, Never>!
  
  private var cancellableSignUp: AnyCancellable?
  private var cancellableSignIn: AnyCancellable?
  
  @Published var uiState: SignUpUIState = .none
  
  private let interactor: SignUpInteractor
  
  init (interactor: SignUpInteractor) {
    self.interactor = interactor
  }
  deinit {
    cancellableSignUp?.cancel()
    cancellableSignIn?.cancel()
  }
}

extension SignUpViewModel {
  func homeView() -> some View {
    return SignUpViewRouter.makeHomeView()
  }
}

extension SignUpViewModel {
  func signUp() {
    self.uiState = .loading
    
    // Dateformatter converte entre datas e suas representações textuais
    let formatter = DateFormatter()
    // especificamos o padrão que deve ser usado para a conversão, e usamos o padrão universal en_US
    formatter.locale = Locale(identifier: "en_US_POSIX")
    // agora especificamos o formato que queremos trabalhar
    formatter.dateFormat = "dd/MM/yyyy"
    
    // agora criamos um objeto do tipo data
    guard let dateFormatted = formatter.date(from: birthday) else {
      self.uiState = .error("Data inválida \(birthday)")
      return
    }
    
    // agora trocamos o formato do dateFormat
    formatter.dateFormat = "yyyy-MM-dd"
    // agora criamos um birthday com o novo formato
    let birthday = formatter.string(from: dateFormatted)
    
    
    let signUpRequest = SignUpRequest(fullName: fullName,
                                      email: email,
                                      password: password,
                                      document: document,
                                      phone: phone,
                                      birthday: birthday,
                                      gender: gender.index)
    
    cancellableSignUp = interactor.postUser(signUpRequest: signUpRequest)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        //error
        switch completion {
        case .failure(let appError):
          self.uiState = .error(appError.message)
          break
        case .finished:
          break
        }
      } receiveValue: { created in
        if created {
          // se tiver criado => login
          self.cancellableSignIn = self.interactor.login(signInRequest: SignInRequest(email: self.email, password: self.password))
            .receive(on: DispatchQueue.main)
            .sink { completion in
              switch completion {
              case .failure(let appError):
                self.uiState = .error(appError.message)
                break
              case .finished:
                break
              }
            } receiveValue: { success in
              print(created)
              self.interactor.insertAuth(userAuth: UserAuth(idToken: success.accessToken,
                                                            refreshToken: success.refreshToken,
                                                            expires: Date().timeIntervalSince1970 + Double(success.expires),
                                                            tokenType: success.tokenType))
              self.publisher.send(created)
              self.uiState = .success
            }
        }
      }
  }
}
