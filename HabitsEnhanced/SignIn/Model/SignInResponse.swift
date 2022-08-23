//
//  SignInResponse.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 01/08/22.
//

import Foundation

struct SignInResponse: Decodable {
  let accessToken: String
  let refreshToken: String
  let expires: Int
  let tokenType: String
  
  // esse enum são as chaves das variáveis que a gente quer trabalhar
  // o protocolo CodingKey basicamente diz para o swift que vamos tratar todos os cases desse enum como se fosse uma chave de objeto JSON
  enum CodingKeys: String, CodingKey {
    // aqui basicamente dizemos que, quando for mandar pro servidor, o nome da chave referente a accessToken por exemplo deve ser access_token (que é o que o servidor espera)
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
    case expires
    case tokenType = "token_type"
  }
}
