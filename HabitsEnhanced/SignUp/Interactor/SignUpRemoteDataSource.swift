//
//  SignUpRemoteDataSource.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 05/08/22.
//

import Foundation
import Combine

// padrao singleton
// temos apenas 1 objeto vivo dentro da aplicação. É usado pra evitar múltiplas instancias de um objeto que não tem necessidade
class SignUpRemoteDataSource {
  // essa variável é a única forma de criarmos um objeto vivo dessa classe. É compartilhada globalmente. A primeira vez que é instanciada, ela cria uma nova instancia de RemoteDataSource(), e se por acaso for instanciada de novo, ela pega a referencia do objeto anterior.
  static var shared: SignUpRemoteDataSource = SignUpRemoteDataSource()
  // o construtor é privado, pra evitar que seja feito algo como RemoteDataSource() para instanciar um novo objeto dessa classe (lembrar que é singleton)
  private init () {}
  
  // Esta é a função que cria um novo usuário (que é um objeto)
  func postUser(request: SignUpRequest) -> Future<Bool, AppError> {
    return Future { promise in
      WebService.call(path: .postUser, method: .post, body: request, completion: { result in
        switch result {
        case .failure(let error, let data):
          if let data = data {
            if error == .badRequest {
              // agora vamos decodificar a resposta
              let decoder = JSONDecoder()
              // agora temos que passar o tipo de dado para qual vai converter (SignUpResponse)
              // e o que queremos converter (data)
              let response = try? decoder.decode(ErrorResponse.self, from: data)
              promise(.failure(AppError.response(message: response?.detail ?? "Erro interno no servidor")))
            }
          }
          break
        case .success(_):
          promise(.success(true))
          break
        }
      })
    }
  }
  
}
