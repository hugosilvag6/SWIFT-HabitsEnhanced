//
//  SwiftUIView.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 22/08/22.
//

import SwiftUI

struct HabitCreateView: View {
  
  @ObservedObject var viewModel: HabitCreateViewModel
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @State private var shouldPresentCamera = false
  
  init(viewModel: HabitCreateViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      
      VStack(alignment: .center, spacing: 12) {
        Button(action: {
          self.shouldPresentCamera = true
        }) {
          VStack {
            viewModel.image!
              .resizable()
              .scaledToFit()
              .frame(width: 100, height: 100)
              .foregroundColor(.orange)
            Text("Clique aqui para enviar")
              .foregroundColor(.orange)
          }
        }
        .padding(.bottom, 12)
        // o sheet é como o alerta, mas é uma "folha" modal
        .sheet(isPresented: $shouldPresentCamera) {
          ImagePickerView(isPresented: $shouldPresentCamera,
                          image: self.$viewModel.image,
                          imageData: self.$viewModel.imageData,
                          sourceType: .camera)
        }
      }
      
      VStack {
        TextField("Escreva aqui o nome do hábito", text: $viewModel.name)
          .multilineTextAlignment(.center)
          .textFieldStyle(PlainTextFieldStyle())
        Divider()
          .frame(height: 1)
          .background(.gray)
      }.padding(.horizontal, 32)
      
      VStack {
        TextField("Escreva aqui a unidade de medida", text: $viewModel.label)
          .multilineTextAlignment(.center)
          .textFieldStyle(PlainTextFieldStyle())
        Divider()
          .frame(height: 1)
          .background(.gray)
      }.padding(.horizontal, 32)
      
      LoadingButtonView(action: {
        self.viewModel.save()
      },text: "Salvar",
        showProgress: self.viewModel.uiState == .loading,
                        disabled: self.viewModel.name.isEmpty || self.viewModel.label.isEmpty)
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

struct HabitCreateView_Previews: PreviewProvider {
  static var previews: some View {
    ForEach(ColorScheme.allCases, id: \.self) {
      HabitCreateView(viewModel: HabitCreateViewModel(interactor: HabitCreateInteractor()))
        .preferredColorScheme($0)
    }
  }
}
