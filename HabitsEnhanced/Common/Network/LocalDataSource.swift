//
//  LocalDataSource.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 05/08/22.
//

import Foundation
import Combine

class LocalDataSource {
  
  // estrutura pra definir um singleton
  static var shared: LocalDataSource = LocalDataSource()
  private init () {}
  
  
  
  private func saveValue (value: UserAuth) {
    // UserDefaults: acessa a database do usuário, para armazenarmos pares chave-valor de forma persistente acerca dos launches do app
    // standard: serve pra começar a armazenar algumas informações
    // set: atribui valor à chave de um objeto (e depois que a gente vai ler de volta, por isso é importante o Codable, pois vamos codificar pra gravar e depois descodificar pra ler)
    // try?: retorna um optional que unwrap valores de sucesso, e retorna nil em caso de erro
    // PropertyListEncoder: um objeto que encoda/transforma instâncias de tipos de dados para uma lista de propriedades
    // encode: define o que vai salvar (o nosso objeto codificado) => value
    // forKey: um identificador único para conseguirmos "buscar de volta"
    UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: "user_key")
  }
  
  private func readValue (forkey key: String) -> UserAuth? {
    var userAuth: UserAuth?
    // value: enquanto o set atribui/salva, o value lê.
    // as?: caso o casting(conversão) dê sucesso, esse sucesso é unwrapped, e retorna nil em caso de erro
    if let data = UserDefaults.standard.value(forKey: key) as? Data {
      // se tiver conseguido ler, entra nesse bloco, daí tenta decodificar pra salvar em userAuth
      userAuth = try? PropertyListDecoder().decode(UserAuth.self, from: data)
    }
    // pode ser nil caso dê errado
    return userAuth
  }
}

extension LocalDataSource {
  func insertUserAuth(userAuth: UserAuth) {
    saveValue(value: userAuth)
  }
  // é opcional, pois pode ser que encontre, mas pode ser que não. Em casos por exemplo em que o usuário ainda não fez login, não seria encontrado, pois o usuário ainda não está autenticado
  // usamos o Never, pois "não tem erro". Não ligamos pra caso der erro, então o Never serve pra "cagar" pro erro
  func getUserAuth() -> Future<UserAuth?, Never> {
    let userAuth = readValue(forkey: "user_key")
    return Future { promise in
      promise(.success(userAuth))
    }
  }
}
