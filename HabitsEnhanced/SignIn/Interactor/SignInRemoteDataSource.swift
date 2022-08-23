//
//  RemoteDataSource.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 03/08/22.
//

import Foundation
import Combine

// padrao singleton
// temos apenas 1 objeto vivo dentro da aplicação. É usado pra evitar múltiplas instancias de um objeto que não tem necessidade
class SignInRemoteDataSource {
  // essa variável é a única forma de criarmos um objeto vivo dessa classe. É compartilhada globalmente. A primeira vez que é instanciada, ela cria uma nova instancia de RemoteDataSource(), e se por acaso for instanciada de novo, ela pega a referencia do objeto anterior.
  static var shared: SignInRemoteDataSource = SignInRemoteDataSource()
  // o construtor é privado, pra evitar que seja feito algo como RemoteDataSource() para instanciar um novo objeto dessa classe (lembrar que é singleton)
  private init () {}
  
  // o future é do combine. Produz um único valor, e então finaliza ou falha.
  func login(request: SignInRequest) -> Future<SignInResponse, AppError> {
    return Future<SignInResponse, AppError> { promise in
      WebService.call(path: .login, params: [
        URLQueryItem(name: "username", value: request.email),
        URLQueryItem(name: "password", value: request.password)
      ], completion: { result in
        switch result {
        case .failure(let error, let data):
          if let data = data {
            if error == .unauthorized {
              // agora vamos decodificar a resposta
              let decoder = JSONDecoder()
              // agora temos que passar o tipo de dado para qual vai converter (SignUpResponse)
              // e o que queremos converter (data)
              let response = try? decoder.decode(SignInErrorResponse.self, from: data)
              // completion(nil, response)
              promise(.failure(AppError.response(message: response?.detail.message ?? "Erro desconhecido no servidor.")))
            }
          }
          break
        case .success(let data):
          let decoder = JSONDecoder()
          let response = try? decoder.decode(SignInResponse.self, from: data)
            // completion(response, nil)
          guard let response = response else {
            print("Log: Error parser \(String(data: data, encoding: .utf8))")
            return
          }
          promise(.success(response))
          break
        }
      })
    }
  }
}
