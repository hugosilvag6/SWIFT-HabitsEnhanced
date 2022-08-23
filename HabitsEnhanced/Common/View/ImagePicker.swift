//
//  ImagePicker.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 22/08/22.
//

import Foundation
import SwiftUI
import UIKit

struct ImagePickerView: UIViewControllerRepresentable {
  
  @Binding var isPresented: Bool
  @Binding var image: Image?
  @Binding var imageData: Data?
  
  // será usado para diferenciar se o que estamos usando é a galeria ou a propria camera
  var sourceType: UIImagePickerController.SourceType = .photoLibrary
  
  func makeCoordinator() -> ImagePickerViewCoordinator {
    ImagePickerViewCoordinator(image: $image, imageData: $imageData, isPresented: $isPresented)
  }
  // UIImagePickerController é responsavel por abrir a camera e galeria nativas do iphone
  func makeUIViewController(context: Context) -> UIImagePickerController {
    
    let pickerController = UIImagePickerController()
    
    if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
      pickerController.sourceType = .photoLibrary
    } else {
      pickerController.sourceType = sourceType
    }
    
    // delegamos instruções para uma nova classe. Essas instruções são, por exemplo, qual foto o usuário escolheu
    pickerController.delegate = context.coordinator
    
    return pickerController
  }
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    //
  }
}

class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  @Binding var isPresented: Bool
  @Binding var image: Image?
  @Binding var imageData: Data?
  
  init(image: Binding<Image?>, imageData: Binding<Data?>, isPresented: Binding<Bool>) {
    // precisamos do _ quando um init vai atribuir a um binding
    self._isPresented = isPresented
    self._imageData = imageData
    self._image = image
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      
      // aqui estamos redimensionando a imagem pra não mandar uma muito grande pra API, já que não tem necessidade de mandar uma foto 4k se no app vai ser tão pequena
      let width: CGFloat = 420.0
      let canvas = CGSize(width: width, height: CGFloat(ceil(width/image.size.width * image.size.height)))
      let imgResized = UIGraphicsImageRenderer(size: canvas, format: image.imageRendererFormat)
        .image(actions: { _ in
          image.draw(in: CGRect(origin: .zero, size: canvas))
        })
      self.image = Image(uiImage: imgResized)
      self.imageData = imgResized.jpegData(compressionQuality: 0.2)
    }
    self.isPresented = false
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.isPresented = false
  }
}
