//
//  EditTextView.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 14/07/22.
//

import SwiftUI

struct EditTextView: View {
  
  // esse @Binding conecta uma variável de two way binding passada como parametro. Sempre que formos utilizar esse componente, precisaremos passar uma variável de binding, e esse @Binding aqui mantém a variável conectada com o "elemento pai". É uma forma de conectar a State de um objeto com algo fora dele.
  @Binding var text: String
  var placeholder: String = ""
  var mask: String? = nil
  var keyboard: UIKeyboardType = .default
  var error: String? = nil
  var failure: Bool? = nil
  var isSecure: Bool = false
  var autoCapitalization: UITextAutocapitalizationType = .none
  
  var body: some View {
    VStack {
      if isSecure {
        SecureField(placeholder, text: $text)
          .foregroundColor(Color("textColor"))
          .keyboardType(keyboard)
          .textFieldStyle(CustomTextFieldStyle())
      } else {
        TextField(placeholder, text: $text)
        // essa cor textColor é uma variável definida no xcassets
          .foregroundColor(Color("textColor"))
          .keyboardType(keyboard)
          .autocapitalization(autoCapitalization)
        // esse textfieldstyle é como um modifier específico para textfields que nós mesmos criamos. Definimos vários parametros como padding, bordas, etc, e quando queremos um componente assim, botamos esse textfieldstyle
          .textFieldStyle(CustomTextFieldStyle())
        // sempre que o usuario mudar/teclar, essa onchange é acionada, para trabalharmos com o valor inputado
          .onChange(of: text) { value in
            if let mask = mask {
              // esse & não passa uma cópia da variável, passa exatamente ela. Então se mudar na função, muda aqui
              Mask.mask(mask: mask, value: value, text: &text)
            }
          }
      }
      
      if let error = error, failure == true, !text.isEmpty {
        Text(error).foregroundColor(.red)
      }
      
    }
    .padding(.bottom, 10)
  }
}

struct EditTextView_Previews: PreviewProvider {
  static var previews: some View {
    ForEach(ColorScheme.allCases, id: \.self) {
      VStack {
        // usamos a constante abaixo como exemplo, mas será dinâmico
        EditTextView(text: .constant(""),
                     placeholder: "Email",
                     error: "Campo inválido",
                     failure: "a@a.com".count < 5)
          .padding()
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .preferredColorScheme($0)
    }
  }
}
