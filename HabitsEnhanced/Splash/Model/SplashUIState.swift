//
//  SplashUIState.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 11/07/22.
//

import Foundation

enum SplashUIState {
    // aqui é um model, onde são armazenados os diferentes estados possíveis da splash screen
    case loading
    case goToSignInScreen
    case goToHomeScreen
    case error(String)
}
