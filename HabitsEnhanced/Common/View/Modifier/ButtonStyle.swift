//
//  ButtonStyle.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 08/08/22.
//

import Foundation
import SwiftUI

// estamos extendendo a ViewModifier, um modifier que serve pra produzir uma versão diferente do original
// podemos fazer um modifier pra qualquer coisa que seja some View, e isso acaba componentizando nossos aplicativos e diminuindo a quantidade de código
struct ButtonStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity)
      .padding(.vertical, 14)
      .padding(.horizontal, 16)
      .font(.title3.bold())
      .background(Color.orange)
      .foregroundColor(.white)
      .cornerRadius(4.0)
  }
}
