//
//  SignInRequest.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 31/07/22.
//

import Foundation

// não precisa ser encodable, pq não vamos encodar pra passar como json, a gente vai passar como parametro de url (tipo: grant_type=&username=usuario&password=senha&scope....)
struct SignInRequest {
  let email: String
  let password: String
}
