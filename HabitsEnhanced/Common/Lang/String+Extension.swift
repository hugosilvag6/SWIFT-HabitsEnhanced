//
//  String+Extension.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 15/07/22.
//

import Foundation

// a nomenclatura String+Extension é um padrão de bons hábitos herdado do Objective C. Lá fazia-se assim, então fazemos assim aqui também

// aqui vamos criar uma extension para, literalmente, extender as funcionalidades de Strings, para criar a nossa verificação de email por exemplo


// verificação de email
extension String {
  func isEmail() -> Bool {
    let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    return NSPredicate(format:"SELF MATCHES %@", regEx).evaluate(with: self)
  }
}


// conversão de datas
extension String {
  func toDate(sourcePattern source: String, destPattern dest: String) -> String? {
    
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = source
    
    guard let dateFormatted = formatter.date(from: self) else {
      return nil
    }
    
    formatter.dateFormat = dest
    return formatter.string(from: dateFormatted)
  }
}


extension String {
  func toDate(sourcePattern source: String) -> Date? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = source
    return formatter.date(from: self)
  }
}

extension String {
  func characterAtIndex (index: Int) -> Character? {
    var cur = 0
    for char in self {
      if cur == index {
        return char
      }
      cur = cur + 1
    }
    return nil
  }
}
