//
//  CustomTextFieldStyle.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 14/07/22.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
  public func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .padding(.horizontal, 8)
      .padding(.vertical, 16)
      .disableAutocorrection(true)
    // o overlay é uma camada acima, então basicamente estará colocando um componente em cima desse, para efeitos visuais
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(Color.orange, lineWidth: 0.8)
      )
  }
  
  
}
