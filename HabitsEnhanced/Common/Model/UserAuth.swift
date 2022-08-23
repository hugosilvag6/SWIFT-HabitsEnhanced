//
//  UserAuth.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 05/08/22.
//

import Foundation

// aqui iniciamos o processo de armazenamento no LocalStorage, armazenando, por exemplo, o token de acesso, que deve durar aproximadamente 1h


// usamos o protocolo Codable, que encapsula Encodable e Decodable. Precisamos de Encodable para transformar os dados em json e salvar no storage, e do Decodable pra ler esses dados. Logo, usamos o Codable.
struct UserAuth: Codable {
  var idToken: String
  var refreshToken: String
  var expires: Double = 0.0
  var tokenType: String
  
  // CodingKey => fala pro swift tratar os cases do enum como chave de objeto JSON
  enum CodingKeys: String, CodingKey {
    case idToken = "access_token"
    case refreshToken = "refresh_token"
    case expires
    case tokenType = "token_type"
  }
}
