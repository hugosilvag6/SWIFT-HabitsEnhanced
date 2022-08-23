//
//  ImageView.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 10/08/22.
//

import SwiftUI
import Combine

struct ImageView: View {
  
  @State var image: UIImage = UIImage()
  @ObservedObject var imageLoader: ImageLoader
  
  init (url: String) {
    imageLoader = ImageLoader(url: url)
  }
  
    var body: some View {
        Image(uiImage: image)
        .resizable()
        .onReceive(imageLoader.didChange, perform: { data in
          self.image = UIImage(data: data) ?? UIImage()
        })
    }
}

class ImageLoader: ObservableObject {
  
  var didChange = PassthroughSubject<Data, Never>()
  var data = Data () {
    // did set serve para executar seu bloco sempre que a variável receber um valor (se dermos valor pra data, o didSet executa)
    didSet {
      didChange.send(data)
    }
  }
  
  init (url: String) {
    // verifica se é uma URL mesmo
    guard let url = URL(string: url) else { return }
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data else { return }
      DispatchQueue.main.async {
        self.data = data
      }
    }
    task.resume()
  }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
      ImageView(url: "http://google.com")
    }
}
