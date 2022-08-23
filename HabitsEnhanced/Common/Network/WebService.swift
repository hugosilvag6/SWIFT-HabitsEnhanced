//
//  WebService.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 19/07/22.
//

import Foundation

enum WebService {
  
  enum Endpoint: String {
    case base = "https://habitplus-api.tiagoaguiar.co"
    case postUser = "/users"
    case fetchUser = "/users/me"
    case updateUser = "/users/%d"
    case login = "/auth/login"
    case refreshToken = "/auth/refresh-token"
    case habits = "/users/me/habits"
    case habitValues = "/users/me/habits/%d/values"
  }
  
  enum NetworkError {
    case badRequest
    case notFound
    case unauthorized
    case internalServerError
  }
  
  enum Result {
    case success(Data)
    case failure(NetworkError, Data?)
  }
  
  enum ContentType: String {
    case json = "application/json"
    case formUrl = "application/x-www-form-urlencoded"
    case multipart = "multipart/form-data"
  }
  
  enum Method: String {
    case get
    case post
    case put
    case delete
  }
  
  // criamos a url completa, que espera as informações JSON para enviar para o backend
  // usamos private, pois só usaremos aqui dentro
  // ao ser chamada, essa função receberá o path para o qual a request será enviada
  private static func completeUrl(path: String) -> URLRequest? {
    // tentamos criar a url, caso não seja possível, saímos da função. Esse objeto URL espera uma string em seu construtor
    // O rawValue é usado para acessar o valor do case de um enum, como value em um input de javascript
    guard let url = URL(string: "\(Endpoint.base.rawValue)\(path)") else { return nil }
    return URLRequest(url: url)
  }
  
  // passamos o "tipo T", que é um tipo que pode ser qualquer coisa, desde que tenha o protocolo Encodable. não podemos dizer direto algo como "body: Encodable", porque o protocolo Encodable não pode ser um type. Não usamos o tipo Any, por que não queremos aceitar qualquer coisa. Queremos aceitar apenas Encodables, e por isso usamos o T.
  // a call back é uma @escaping. A ideia de uma @escaping é: uma função é executada de cima a baixo muito rapidamente. Quando trabalhamos com uma função assíncrona dentro de uma função, o que aconteceria é: a função pai seria executada muito rapidamente, e quando recebessemos a resposta da função filho (assíncrona), a função pai já teria sido executada e "não existiria mais", então essa função filha (e sua resposta/retorno) seria "destruída" junto. O @escaping permite que essa função filha (normalmente uma callback) sobreviva a esse ciclo de vida, e complete sua execução mesmo caso a função pai já tenha sido encerrada. É como se ela "saísse do escopo" da função pai, como se fosse position: absolute (kkkk)
  
  
  // criamos um call pro json
  public static func call<T:Encodable>(path: Endpoint,
                                       method: Method = .get,
                                        body: T,
                                        completion: @escaping (Result) -> Void ) {
    // cria o json a aprtir do body, se não conseguir fazer jsonData, return
    guard let jsonData = try? JSONEncoder().encode(body) else { return }
    // chama a call passando o json
    call(path: path.rawValue, method: method, contentType: .json, data: jsonData, completion: completion)
  }
  
  public static func call<T:Encodable>(path: String,
                                       method: Method = .get,
                                        body: T,
                                        completion: @escaping (Result) -> Void ) {
    // cria o json a aprtir do body, se não conseguir fazer jsonData, return
    guard let jsonData = try? JSONEncoder().encode(body) else { return }
    // chama a call passando o json
    call(path: path, method: method, contentType: .json, data: jsonData, completion: completion)
  }
  
  // essa call é pro habitValueResponse
  public static func call(path: String,
                                       method: Method = .get,
                                        completion: @escaping (Result) -> Void ) {
    call(path: path, method: method, contentType: .json, data: nil, completion: completion)
  }
  
  // call sem body (para habitos por exemplo)
  public static func call(path: Endpoint,
                          method: Method = .get,
                          completion: @escaping (Result) -> Void ) {
    call(path: path.rawValue, method: method, contentType: .json, data: nil, completion: completion)
  }
  
  // e criamos um call pro urlEncoded. Podemos ter funções diferentes com o mesmo nome desde que: a quantidade de parametros seja diferente, ou o tipo de parametro seja diferente (pra distinguir pela chamada)
  public static func call(path: Endpoint,
                          method: Method = .post,
                          params: [URLQueryItem],
                          data: Data? = nil,
                          completion: @escaping (Result) -> Void ) {
    guard let urlRequest = completeUrl(path: path.rawValue) else { return }
    guard let absoluteURL = urlRequest.url?.absoluteString else { return }
    var components = URLComponents(string: absoluteURL)
    components?.queryItems = params
    
    let boundary = "Boundary-\(NSUUID().uuidString)" // gera um número aleatorio
    
    // chama a call passando o json
    call(path: path.rawValue,
         method: method,
         contentType: data != nil ? .multipart : .formUrl,
         data: data != nil ? createBodyWithParameters(params: params, data: data!, boundary: boundary) : components?.query?.data(using: .utf8),
         boundary: boundary,
         completion: completion)
  }
  
  private static func createBodyWithParameters(params: [URLQueryItem], data: Data, boundary: String) -> Data {
    let body = NSMutableData()
    for param in params {
      body.appendString("--\(boundary)\r\n")
      body.appendString("Content-Disposition: form-data; name=\"\(param.name)\"\r\n\r\n")
      body.appendString("\(param.value!)\r\n")
    }
    let filename = "img.jpg"
    let mimetype = "image/jpeg"
    body.appendString("--\(boundary)\r\n")
    body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
    body.appendString("Content-Type: \(mimetype)\r\n\r\n")
    body.append(data)
    body.appendString("\r\n")
    body.appendString("--\(boundary)--\r\n")
    return body as Data
  }
  
  private static func call (path: String,
                            method: Method,
                            contentType: ContentType,
                            data: Data?,
                            boundary: String = "",
                            completion: @escaping (Result) -> Void) {
    // guard var > se não conseguir fazer a urlRequest, return
    guard var urlRequest = completeUrl(path: path) else { return }
    
    _ = LocalDataSource.shared.getUserAuth()
      .sink { userAuth in
        if let userAuth = userAuth {
          urlRequest.setValue("\(userAuth.tokenType) \(userAuth.idToken)", forHTTPHeaderField: "Authorization")
        }
        if contentType == .multipart {
          urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        } else {
          urlRequest.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }
        // define os headers
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.httpBody = data
        // inicia a URLSession
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
          // a partir daqui vamos tratar data, response e error
          // caso error não seja nil, trata o error
          guard let data = data, error == nil else {
            print(error)
            // chama a callback
            completion(.failure(.internalServerError, nil))
            return
          }
          // trata a response
          if let r = response as? HTTPURLResponse {
            switch r.statusCode {
            case 400:
              completion(.failure(.badRequest, data))
            case 401:
              completion(.failure(.unauthorized, data))
            case 200:
              completion(.success(data))
            case 201:
              completion(.success(data))
            default:
              break
            }
          }
          
          print(String(data: data, encoding: .utf8))
          print("response\n")
          print(response)
          
        }
        task.resume()
      }

    
    
  }
}

extension NSMutableData {
  func appendString(_ string: String) {
    append(string.data(using: .utf8, allowLossyConversion: true)!)
  }
}
