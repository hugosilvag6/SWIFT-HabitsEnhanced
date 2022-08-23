//
//  HabitView.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 08/08/22.
//

import Foundation
import SwiftUI

struct HabitView: View {
  
  @ObservedObject var viewModel: HabitViewModel
  
  var body: some View {
    ZStack {
      if case HabitUIState.loading = viewModel.uiState {
        progress
      } else {
        NavigationView {
          ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
              if !viewModel.isCharts {
                topContainer
                addButton
              }
              if case HabitUIState.emptyList = viewModel.uiState {
                Spacer(minLength: 60)
                VStack {
                  Image(systemName: "exclamationmark.octagon.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24, alignment: .center)
                  Text("Nenhum hábito encontrado :(")
                }
              } else if case HabitUIState.fullList(let rows) = viewModel.uiState {
                // o LazyVStack é como um VStack, mas otimizado para quando trabalhamos com multiplos valores de lista/de elementos de views. Ele basicamente re-renderia a view quando necessário, então vamos rolando na lista e ele vai "chamando" as views de cada item (cada card). Iríamos usar ele por causa das imagens de cada hábito, mas como as imagens são pequenas, removemos e deixamos apenas o VStack, pra não ficar sumindo as imagens. Trocar pra VStack deixa mais fluido
                VStack {
                  ForEach(rows) { row in
                    HabitCardView(isCharts: viewModel.isCharts, viewModel: row)
                  }
                }
                .padding(.horizontal, 14)
              } else if case HabitUIState.error(let msg) = viewModel.uiState {
                Text("")
                  .alert(isPresented: .constant(true)) {
                    Alert(
                      title: Text("Ops! \(msg)"),
                      message: Text("Tentar novamente?"),
                      primaryButton: .default(Text("Sim")) {
                        // aqui é a retentativa
                        viewModel.onAppear()
                      },
                      secondaryButton: .cancel()
                    )
                  }
              }
            }
          }.navigationTitle("Meus hábitos")
        }
      }
    }
    .onAppear {
      if !viewModel.opened {
        viewModel.onAppear()
      }
    }
  }
}

extension HabitView {
  var progress: some View {
    ProgressView()
  }
}

extension HabitView {
  var topContainer: some View {
    VStack(alignment: .center, spacing: 12) {
      Image(systemName: "exclamationmark.triangle")
        .resizable()
        .scaledToFit()
        .frame(width: 50, height: 50, alignment: .center)
      Text(viewModel.title)
        .font(.title.bold())
        .foregroundColor(.orange)
      Text(viewModel.headline)
        .font(.title3.bold())
        .foregroundColor(Color("textColor"))
      Text(viewModel.desc)
        .font(.subheadline)
        .foregroundColor(Color("textColor"))
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 32)
    .overlay(
      RoundedRectangle(cornerRadius: 6)
        .stroke(Color.gray, lineWidth: 1)
    )
    .padding(.horizontal, 16)
    .padding(.top, 16)
  }
}

extension HabitView {
  var addButton: some View {
    // na SignInView fizemos uma navigationLink diferente. Esta é outra forma de fazer, passando o destination direto (uma view)
    NavigationLink (destination: viewModel.habitCreateView()
      .frame(maxWidth: .infinity, maxHeight: .infinity)) {
        Label("Criar hábito", systemImage: "plus.app")
        // esse modifier é uma estilização padrão criada por nós, clique para ver
          .modifier(ButtonStyle())
      }
      .padding(.horizontal, 16)
  }
}

struct HabitView_Previews: PreviewProvider {
  static var previews: some View {
    HomeViewRouter.makeHabitView(viewModel: HabitViewModel(isCharts: false, interactor: HabitInteractor()))
  }
}
