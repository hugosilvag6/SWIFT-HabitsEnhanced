//
//  SignInUIState.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 11/07/22.
//

import Foundation


// usamos o equatable para "permitir" a equiparação com os casos do enum.
// Na signInView, mostrar a "progressão" no botão (carregamento) depende de SignInUIState ser igual a .loading
// Para fazer SignInUIState == .loading precisamos colocar o protocolo Equatable abaixo
enum SignInUIState: Equatable {
  case none
  case loading
  case goToHomeScreen
  case error(String)
}
