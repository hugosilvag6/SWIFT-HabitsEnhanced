//
//  ProfileView.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 10/08/22.
//

import SwiftUI

struct ProfileView: View {
  
  @ObservedObject var viewModel: ProfileViewModel
  var disableDone: Bool {
    viewModel.fullNameValidation.failure
    || viewModel.phoneValidation.failure
    || viewModel.birthdayValidation.failure
  }
  
  var body: some View {
    ZStack {
      
      if case ProfileUIState.loading = viewModel.uiState {
        ProgressView()
      } else {
        NavigationView {
          VStack {
            Form {
              Section(header: Text("Dados cadastrais")) {
                HStack {
                  Text("Nome")
                  Spacer()
                  TextField("Digite o nome", text: $viewModel.fullNameValidation.value)
                    .keyboardType(.alphabet)
                    .multilineTextAlignment(.trailing)
                }
                if viewModel.fullNameValidation.failure {
                  Text("A senha deve ter pelo menos 8 caracteres")
                    .foregroundColor(.red)
                }
                HStack {
                  Text("Email")
                  Spacer()
                  TextField("", text: $viewModel.email)
                    .disabled(true) // desativa a interação com o campo, impedindo de mudar o email
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.trailing)
                }
                HStack {
                  Text("CPF")
                  Spacer()
                  TextField("", text: $viewModel.document)
                    .disabled(true) // desativa a interação com o campo, impedindo de mudar o email
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.trailing)
                }
                HStack {
                  Text("Telefone")
                  Spacer()
                  
                  ProfileEditTextView(text: $viewModel.phoneValidation.value,
                               placeholder: "Celular",
                               mask: "(##) ####-####",
                               keyboard: .numberPad)
                  
                }
                if viewModel.phoneValidation.failure {
                  Text("Informe DDD + 8 ou 9 dígitos")
                    .foregroundColor(.red)
                }
                HStack {
                  Text("Data de nascimento")
                  Spacer()
                  
                  ProfileEditTextView(text: $viewModel.birthdayValidation.value,
                               placeholder: "Data de nascimento",
                               mask: "##/##/####",
                               keyboard: .numberPad)
                  
                  // editar para o antigo depois
//                  TextField("Digite a data", text: $viewModel.birthdayValidation.value)
//                    .multilineTextAlignment(.trailing)
                }
                if viewModel.birthdayValidation.failure {
                  Text("Informe DD/MM/AAAA")
                    .foregroundColor(.red)
                }
                NavigationLink(destination: GenderSelectorView(selectedGender: $viewModel.gender, genders: Gender.allCases, title: "Escolha o gênero"),
                               label: {
                  Text("Gênero")
                  Spacer()
                  Text(viewModel.gender?.rawValue ?? "")
                })
              }
            }
          }
          .navigationBarTitle(Text("Editar Perfil"), displayMode: .automatic)
          .navigationBarItems(trailing: Button(action: {
            viewModel.updateUser()
          }, label: {
            if case ProfileUIState.updateLoading = viewModel.uiState {
              ProgressView()
            } else {
              Text("Salvar")
                .foregroundColor(.orange)
                .bold()
            }
          })
            .alert(isPresented: .constant(viewModel.uiState == .updateSuccess)) {
              Alert(title: Text("Habit"),
                    message: Text("Dados atualizados com sucesso."),
                    dismissButton: .default(Text("Ok")) {
                viewModel.uiState = .none
              })
            }
            .opacity(disableDone ? 0 : 1)
          )
        }
      }
      
      if case ProfileUIState.updateError(let value) = viewModel.uiState {
        Text("")
          .alert(isPresented: .constant(true)) {
            Alert(title: Text("Habit"),
                  message: Text(value),
                  dismissButton: .default(Text("Ok")) {
              viewModel.uiState = .none
            })
          }
      }
      
      if case ProfileUIState.fetchError(let value) = viewModel.uiState {
        Text("")
          .alert(isPresented: .constant(true)) {
            Alert(title: Text("Habit"),
                  message: Text(value),
                  dismissButton: .default(Text("Ok")) {
              // faz algo quando some o alerta
            })
          }
      }
      
    }.onAppear(perform: viewModel.fetchUser)
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView(viewModel: ProfileViewModel(interactor: ProfileInteractor()))
  }
}
