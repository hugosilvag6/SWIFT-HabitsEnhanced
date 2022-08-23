//
//  Mask.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 23/08/22.
//

import Foundation

class Mask {
  
  static var isUpdating = false
  static var oldString = ""
  
  private static func replaceChars (full: String) -> String {
    full.replacingOccurrences(of: ".", with: "")
        .replacingOccurrences(of: "-", with: "")
        .replacingOccurrences(of: "(", with: "")
        .replacingOccurrences(of: ")", with: "")
        .replacingOccurrences(of: "/", with: "")
        .replacingOccurrences(of: "*", with: "")
        .replacingOccurrences(of: " ", with: "")
  }
  
  // o inout é como um bind, mas com variáveis normais
  static func mask (mask: String, value: String, text: inout String) {
    
    let str = Mask.replaceChars(full: value)
    var cpfMasked = ""
    var _mask = mask
    if (_mask == "(##) ####-####") {
      if(value.count >= 14 && value.characterAtIndex(index: 5) == "9") {
        _mask = "(##) #####-####"
      }
    }
    
    if (str <= oldString) { // está deletando caracteres
      isUpdating = true
      if(_mask == "(##) #####-####" && value.count == 14) {
        _mask = "(##) ####-####"
      }
    }
    
    if (isUpdating || value.count == mask.count) {
      oldString = str
      isUpdating = false
      return
    }
    
    var i = 0
    
    for char in _mask {
      if (char != "#" && str.count > oldString.count) {
        cpfMasked = cpfMasked + String(char)
        continue
      }
      let unamed = str.characterAtIndex(index: i) // characterAtIndex foi criado como extension de String
      guard let char = unamed else { break }
      
      cpfMasked = cpfMasked + String(char)
      
      i = i + 1
      
    }
    
    isUpdating = true
    
    if (cpfMasked == "(0") {
      text = ""
      return
    }
    
    text = cpfMasked
    print(text)
  }
}
