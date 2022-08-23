//
//  ProfileEditTextView.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 23/08/22.
//

import Foundation
import SwiftUI

struct ProfileEditTextView: View {
  
  @Binding var text: String
  var placeholder: String = ""
  var mask: String? = nil
  var keyboard: UIKeyboardType = .default
  var autoCapitalization: UITextAutocapitalizationType = .none
  
  var body: some View {
    VStack {
      TextField(placeholder, text: $text)
        .foregroundColor(Color("textColor"))
        .keyboardType(keyboard)
        .autocapitalization(autoCapitalization)
        .multilineTextAlignment(.trailing)
        .onChange(of: text) { value in
          if let mask = mask {
            Mask.mask(mask: mask, value: value, text: &text)
          }
        }
    }
    .padding(.bottom, 10)
  }
}

struct ProfileEditTextView_Previews: PreviewProvider {
  static var previews: some View {
    ForEach(ColorScheme.allCases, id: \.self) {
      VStack {
        // usamos a constante abaixo como exemplo, mas será dinâmico
        ProfileEditTextView(text: .constant(""),
                            placeholder: "Email")
        .padding()
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .preferredColorScheme($0)
    }
  }
}
