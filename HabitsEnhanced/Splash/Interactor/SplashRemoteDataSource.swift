//
//  SplashRemoteDataSource.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 08/08/22.
//

import Foundation
import Combine


class SplashRemoteDataSource {
  static var shared: SplashRemoteDataSource = SplashRemoteDataSource()
  // construtor privado para proibir novas instancias
  private init () {}
  
  func refreshToken(request: RefreshRequest) -> Future<SignInResponse, AppError> {
    return Future<SignInResponse, AppError> { promise in
      WebService.call(path: .refreshToken, method: .put, body: request, completion: { result in
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
