//
//  RefreshRequest.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 08/08/22.
//

import Foundation

struct RefreshRequest: Encodable {

  let token: String
  
  // aqui basicamente dizemos que, quando for mandar pro servidor, o nome da chave referente a fullName deve ser "trocada" por "name"
  enum CodingKeys: String, CodingKey {
    case token = "refresh_token"
  }
}
