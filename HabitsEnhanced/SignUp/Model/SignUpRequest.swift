//
//  SignUpRequest.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 25/07/22.
//

import Foundation

// usamos o encodable para permitir que esse objeto seja "encodado"/transformado no tipo JSON. Se fosse o contrário, usaríamos Decodable
struct SignUpRequest: Encodable {

  let fullName: String
  let email: String
  let password: String
  let document: String
  let phone: String
  let birthday: String
  let gender: Int
  
  // esse enum são as chaves das variáveis que a gente quer trabalhar
  // o protocolo CodingKey basicamente diz para o swift que vamos tratar todos os cases desse enum como se fosse uma chave de objeto JSON
  enum CodingKeys: String, CodingKey {
    // aqui basicamente dizemos que, quando for mandar pro servidor, o nome da chave referente a fullName deve ser "trocada" por "name"
    case fullName = "name"
    case email
    case password
    case document
    case phone
    case birthday
    case gender
  }
}
