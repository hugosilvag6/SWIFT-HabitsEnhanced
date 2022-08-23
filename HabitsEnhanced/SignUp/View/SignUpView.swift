//
//  SignUpView.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 12/07/22.
//

import SwiftUI

struct SignUpView: View {
  
  @ObservedObject var viewModel: SignUpViewModel
  
  var body: some View {
    ZStack {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .center) {
          VStack(alignment: .leading, spacing: 8) {
            Text("Cadastro")
              .foregroundColor(Color("textColor"))
              .font(.title.bold())
              .padding(.bottom, 8)
            fullNameField
            emailField
            passwordField
            documentField
            phoneField
            birthdayField
            genderField
            saveButton
          }
          Spacer()
        }
        .padding(.horizontal, 8)
      }
      .padding()
      if case SignUpUIState.error(let value) = viewModel.uiState {
        Text("")
            .alert(isPresented: .constant(true)) {
                Alert(title: Text("HabitPlus"), message: Text(value), dismissButton: .default(Text("Ok")) {
                    // faz algo quando some o alerta
                })
            }
      }
    }
  }
}

extension SignUpView {
  var fullNameField: some View {
    EditTextView(text: $viewModel.fullName,
                 placeholder: "Nome completo",
                 keyboard: .alphabet,
                 error: "O nome deve ter pelo menos 3 caracteres",
                 failure: viewModel.fullName.count < 3,
                 autoCapitalization: .words)
  }
}
extension SignUpView {
  var emailField: some View {
    EditTextView(text: $viewModel.email,
                 placeholder: "Email",
                 keyboard: .emailAddress,
                 error: "Email inválido",
                 // esse método isEmail() não existe, nós o criamos como uma extensão das Strings. Está no arquivo Common/Lang/String+Extension
                 failure: !viewModel.email.isEmail())
  }
}
extension SignUpView {
  var passwordField: some View {
    EditTextView(text: $viewModel.password,
                 placeholder: "Senha",
                 keyboard: .emailAddress,
                 error: "A senha deve ter pelo menos 8 caracteres",
                 failure: viewModel.password.count < 8,
                 isSecure: true)
  }
}
extension SignUpView {
  var documentField: some View {
    EditTextView(text: $viewModel.document,
                 placeholder: "CPF",
                 mask: "###.###.###-##",
                 keyboard: .numberPad,
                 error: "CPF inválido",
                 failure: viewModel.document.count != 14)
    // TODO: mask (concatenando numeros com pontos e caracteres especiais)
  }
}
extension SignUpView {
  var phoneField: some View {
    EditTextView(text: $viewModel.phone,
                 placeholder: "Celular",
                 mask: "(##) ####-####",
                 keyboard: .numberPad,
                 error: "Informe DDD + 8 ou 9 dígitos",
                 failure: viewModel.phone.count < 14 || viewModel.phone.count > 15)
    // TODO: mask (concatenando numeros com pontos e caracteres especiais)
  }
}
extension SignUpView {
  var birthdayField: some View {
    EditTextView(text: $viewModel.birthday,
                 placeholder: "Data de nascimento",
                 mask: "##/##/####",
                 keyboard: .numberPad,
                 error: "Informe DD/MM/AAAA",
                 failure: viewModel.birthday.count != 10)
    // TODO: mask (concatenando numeros com pontos e caracteres especiais)
  }
}
extension SignUpView {
  var genderField: some View {
    Picker("Gender", selection: $viewModel.gender) {
      ForEach(Gender.allCases, id: \.self) { value in
        Text(value.rawValue)
          .tag(value)
      }
    }
    .pickerStyle(.segmented)
    .padding(.bottom, 32)
  }
}
extension SignUpView {
  var saveButton: some View {
    LoadingButtonView(
      action: { viewModel.signUp() },
      text: "Cadastrar",
      showProgress: self.viewModel.uiState == SignUpUIState.loading,
      disabled: viewModel.fullName.count < 3 ||
      !viewModel.email.isEmail() ||
      viewModel.password.count < 8 ||
      viewModel.document.count != 14 ||
      viewModel.phone.count < 14 || viewModel.phone.count > 15 ||
      viewModel.birthday.count != 10)
  }
}

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    // bindamos a preview com a viewmodel, para que dependa dela (em caso de loading, erro, etc)
    ForEach(ColorScheme.allCases, id: \.self) {
      SignUpView(viewModel: SignUpViewModel(interactor: SignUpInteractor()))
        .preferredColorScheme($0)
    }
  }
}
