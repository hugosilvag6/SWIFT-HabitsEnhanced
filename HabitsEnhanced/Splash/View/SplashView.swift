//
//  SplashView.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 11/07/22.
//

import SwiftUI

struct SplashView: View {
    
    // aqui definimos que a viewmodel é observada, para que a view mude quando a VM mudar
    @ObservedObject var viewModel: SplashViewModel
    
    var body: some View {
        // colocamos o switch em uma view (Group) para poder ligar um modifier (onAppear) nela
        Group {
            // o switch depende da variável uiState, que está no viewModel, e a lógica não fica aqui. É tudo separado para organizar, aqui só definimos o que acontecerá com a view em cada caso
            switch viewModel.uiState {
            case .loading:
                loadingView()
            case .goToSignInScreen:
                // navegamos para a próxima tela através da função do viewModel que instancia o Router
                viewModel.signInView()
            case .goToHomeScreen:
              viewModel.homeView()
            case .error(let msg):
                loadingView(error: msg)
            }
        }.onAppear(perform: viewModel.onAppear)
    }
}

// componentizamos uma view (no caso a tela de loading)
extension SplashView {
    // usamos uma função em extensão pois precisamos receber parâmetro para lidar com eventuais erros. Poderíamos criar uma nova struct (para também receber parâmetros), mas como essa view só será usada aqui, é melhor usar extension. Uma nova struct seria vista globalmente
    func loadingView (error: String? = nil) -> some View {
        ZStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(20)
                .ignoresSafeArea()
            if let error = error {
                Text("")
                    .alert(isPresented: .constant(true)) {
                        Alert(title: Text("HabitPlus"), message: Text(error), dismissButton: .default(Text("Ok")) {
                            // faz algo quando some o alerta
                        })
                    }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        // bindamos a preview com a viewmodel, para que dependa dela.
      ForEach(ColorScheme.allCases, id: \.self) {
        SplashView(viewModel: SplashViewModel(interactor: SplashInteractor()))
          .preferredColorScheme($0)
      }
    }
}
