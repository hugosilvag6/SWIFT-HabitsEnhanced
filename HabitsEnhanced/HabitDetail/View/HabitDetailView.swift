//
//  HabitDetailView.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 09/08/22.
//

import SwiftUI

struct HabitDetailView: View {
  
  @ObservedObject var viewModel: HabitDetailViewModel
  // essa variável abaixo tem um método dismiss, que é usado pra dispensar uma view. Nessa tela dá pra clicar no card, o que abre uma nova view pra editá-lo. Nessa nova view, há um botão pra cancelar, que fecha a view e volta pra essa tela aqui. Esse processo de cancelamento/dismiss é feito usando a variável abaixo
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  init(viewModel: HabitDetailViewModel) {
    self.viewModel = viewModel
  }
  
    var body: some View {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .center, spacing: 12) {
          Text(viewModel.name)
            .foregroundColor(.orange)
            .font(.title.bold())
          Text("Unidade: \(viewModel.label)")
        }
        VStack {
          TextField("Escreva aqui o valor conquistado", text: $viewModel.value)
            .multilineTextAlignment(.center)
            .textFieldStyle(PlainTextFieldStyle())
            .keyboardType(.numberPad)
          Divider()
            .frame(height: 1)
            .background(.gray)
        }.padding(.horizontal, 32)
        Text("Os registros devem ser feitos em até 24h.\nHábitos se constroem todos os dias :)")
        LoadingButtonView(action: {
          self.viewModel.save()
        }, text: "Salvar", showProgress: self.viewModel.uiState == .loading, disabled: self.viewModel.value.isEmpty)
          .padding(.horizontal, 16)
          .padding(.vertical, 8)
        
        Button("Cancelar") {
          // tira a tela
          self.presentationMode.wrappedValue.dismiss()
        }.modifier(ButtonStyle())
        .padding(.horizontal, 16)
        Spacer()
      }
      .padding(.horizontal, 8)
      .padding(.top, 32)
      .onAppear {
        viewModel.$uiState.sink { uiState in
          if uiState == .success {
            self.presentationMode.wrappedValue.dismiss()
          }
        }.store(in: &viewModel.cancellables)
      }
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
      ForEach(ColorScheme.allCases, id: \.self) {
        HabitDetailView(viewModel: HabitDetailViewModel(id: 1, name: "Tocar guitarra", label: "horas", interactor: HabitDetailInteractor()))
          .preferredColorScheme($0)
      }
    }
}
