//
//  SignInView.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 11/07/22.
//

import SwiftUI

struct SignInView: View {
  @ObservedObject var viewModel: SignInViewModel
  
  @State var action: Int? = 0
  @State var navigationHidden = true
  
  var body: some View {
    
    ZStack {
      if case SignInUIState.goToHomeScreen = viewModel.uiState {
        viewModel.homeView()
      } else {
        // para usar uma navigationView, o filho dela precisa definir as propriedades que queremos utilizar
        NavigationView {
          ScrollView (showsIndicators: false) {
            VStack(alignment: .center, spacing: 20) {
              Spacer(minLength: 36)
              VStack(alignment: .center, spacing: 8) {
                Image("logo")
                  .resizable()
                  .scaledToFit()
                  .padding(.horizontal, 48)
                
                Text("Login")
                  .foregroundColor(.orange)
                  .font(.title.bold())
                  .padding(.bottom, 8)
                
                emailField
                passwordField
                enterButton
                registerLink
                
                Text("Copyright - Hugo Silva 2022")
                  .foregroundColor(.gray)
                  .font(.system(size: 13).bold())
                  .padding(.top, 16)
              }
            }
            if case SignInUIState.error(let value) = viewModel.uiState {
              Text("")
                  .alert(isPresented: .constant(true)) {
                      Alert(title: Text("HabitPlus"), message: Text(value), dismissButton: .default(Text("Ok")) {
                          // faz algo quando some o alerta
                      })
                  }
            }
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .padding(.horizontal, 32)
          .navigationBarTitle("Login", displayMode: .inline)
          .navigationBarHidden(navigationHidden)
        }
      }
    }
  }
}

extension SignInView {
  var emailField: some View {
    EditTextView(text: $viewModel.email,
                 placeholder: "Email",
                 keyboard: .emailAddress,
                 error: "Email inválido",
                 // esse método isEmail() não existe, nós o criamos como uma extensão das Strings. Está no arquivo Common/Lang/String+Extension
                 failure: !viewModel.email.isEmail())
  }
}
extension SignInView {
  var passwordField: some View {
    EditTextView(text: $viewModel.password,
                 placeholder: "Senha",
                 keyboard: .emailAddress,
                 error: "A senha deve ter pelo menos 8 caracteres",
                 failure: viewModel.password.count < 8,
                 isSecure: true)
  }
}
extension SignInView {
  var enterButton: some View {
    LoadingButtonView(
      action: { viewModel.login() },
      text: "Entrar",
      showProgress: self.viewModel.uiState == SignInUIState.loading,
      disabled: !viewModel.email.isEmail() || viewModel.password.count < 8)
  }
}
extension SignInView {
  var registerLink: some View {
    VStack {
      Text("Ainda não possui um login ativo?")
        .foregroundColor(.gray)
        .padding(.top, 48)
      
      ZStack {
        // a tag é um id de tela, se tivessemos mais telas usariamos 1, 2, 3, 4, etc
        // o selection é um evento que vai acontecer
        // Todo navigationlink precisa que algum de seus pais seja uma navigationview
        NavigationLink(
          destination: viewModel.signUpView(),
          tag: 1,
          selection: $action,
          label: {EmptyView()})
        // o botão muda a action pra 1, mandando pra "tela 1"
        Button("Cadastre-se") {
          self.action = 1
        }
        // Botão customizado:
//        LoadingButtonView(action: {self.action = 1}, text: "Cadastre-se", showProgress: false, disabled: false)
      }
    }
  }
}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    // bindamos a preview com a viewmodel, para que dependa dela.
    ForEach(ColorScheme.allCases, id: \.self) {
      let viewModel = SignInViewModel(interactor: SignInInteractor())
      SignInView(viewModel: viewModel)
        .preferredColorScheme($0)
    }
  }
}
