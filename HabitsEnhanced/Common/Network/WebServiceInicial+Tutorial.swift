//
//  WebService.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 19/07/22.
//

import Foundation

enum WebService2 {
  
  enum Endpoint: String {
    case base = "https://habitplus-api.tiagoaguiar.co"
    case postUser = "/users"
  }
  
  // criamos a url completa, que espera as informações JSON para enviar para o backend
  // usamos private, pois só usaremos aqui dentro
  // ao ser chamada, essa função receberá o path para o qual a request será enviada
  private static func completeUrl(path: Endpoint) -> URLRequest? {
    // tentamos criar a url, caso não seja possível, saímos da função. Esse objeto URL espera uma string em seu construtor
    // O rawValue é usado para acessar o valor do case de um enum, como value em um input de javascript
    guard let url = URL(string: "\(Endpoint.base.rawValue)\(path.rawValue)") else { return nil }
            return URLRequest(url: url)
  }
  
  
  // Esta é a função que cria um novo usuário
  static func postUser(fullName: String,
                       email: String,
                       password: String,
                       document: String,
                       phone: String,
                       birthday: String,
                       gender: Int) {
    // Criamos um objeto json usando dictionary, é assim que se faz no swift. Temos uma chave que é uma string, e um valor que pode ser de qualquer tipo
    let json: [String:Any] = [
        "name": fullName,
        "email": email,
        "document": document,
        "phone": phone,
        "gender": gender,
        "birthday": birthday,
        "password": password
    ]
    
    
    // Criamos um objeto para converter o dictionary em JSON. O JSONSerialization é responsável por isso, e é seu método "data()" que retorna JSON a partir de um objeto Swift (especificado em withJSONObject)
    // O try? basicamente retorna um optional que unwrap valores de sucesso, e retorna nil em caso de erro
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    
    // criamos a URL abaixo usando guard, para que caso dê errado, a função seja encerrada. Inicialmente passávamos apenas .postUser, mas poderíamos passar outros endpoints. Inicialmente o else era só um return, pois não queríamos tratar erros, mas poderíamos tratar de alguma forma no else.
    guard var urlRequest = completeUrl(path: .postUser) else { return }
    
    
    // definimos o tipo do método http
    urlRequest.httpMethod = "POST"
    // definimos os headers da requisição
    urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    // definimos o corpo da requisição, que é um objeto do tipo json
    urlRequest.httpBody = jsonData
    
    // Agora precisamos efetivamente fazer a chamada. Para fazer uma chamada precisamos abrir uma sessão de requisição, ou seja, uma sessão para a gente abrir um protocolo HTTP e enviar os dados através da URLRequest.
    // A requisição já está pronta, agora precisamos conectar com o servidor e ter a resposta de volta.
    // Para isso, criamos uma task, que roda de forma assíncrona em background, que tenta disparar e depois de um tempo nos devolve a resposta do servidor baseado nos dados que a gente enviar
    // Essa task é um retorno do objeto URLSession, e nos devolve data, response e error (caso tenha)
    let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
      // primeiro verificamos se teve algum erro na chamada. Se error for nil, deu sucesso, então segue adiante. Se não for nil, imprime o error no console e por ser um guard let, já encerra a função.
      guard let data = data, error == nil else {
        print(error)
        return
      }
      // se o guard let acima der certo, já temos o data, que é o tipo de resposta que vai vim no corpo do nosso response. Imprimimos ele abaixo
      print(String(data: data, encoding: .utf8))
      print("response\n")
      // Aqui imprimimos o response
      print(response)
      // esse as? é como o try?
      // basicamente retorna um optional, em que caso o casting(conversão) dê sucesso, esse sucesso é unwrapped, e retorna nil em caso de erro
      // no caso abaixo, tentamos converter o response para uma HTTPURLResponse, e depois imprimimos o status code,
      if let r = response as? HTTPURLResponse {
        print(r.statusCode)
      }
    }
    // inicializamos a task para ser disparada depois
    task.resume()
  }
}
