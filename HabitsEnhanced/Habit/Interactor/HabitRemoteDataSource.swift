//
//  HabitRemoteDataSource.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 09/08/22.
//

import Foundation
import Combine


class HabitRemoteDataSource {
  static var shared: HabitRemoteDataSource = HabitRemoteDataSource()
  private init () {}
  
  func fetchHabits() -> Future<[HabitResponse], AppError> {
    return Future<[HabitResponse], AppError> { promise in
      WebService.call(path: .habits, method: .get) { result in
        switch result {
        case .failure(_, let data):
          if let data = data {
            // agora vamos decodificar a resposta
            let decoder = JSONDecoder()
            // agora temos que passar o tipo de dado para qual vai converter (SignUpResponse)
            // e o que queremos converter (data)
            let response = try? decoder.decode(SignInErrorResponse.self, from: data)
            promise(.failure(AppError.response(message: response?.detail.message ?? "Erro desconhecido no servidor.")))
          }
//          break
        case .success(let data):
          let decoder = JSONDecoder()
          let response = try? decoder.decode([HabitResponse].self, from: data)
            // completion(response, nil)
          guard let res = response else {
            print("Log: Error parser \(String(data: data, encoding: .utf8)!)")
            return
          }
          promise(.success(res))
          break
        }
      }
    }
  }
}
