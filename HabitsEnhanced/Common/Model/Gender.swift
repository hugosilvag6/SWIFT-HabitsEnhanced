//
//  Gender.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 12/07/22.
//

import Foundation

// o iterable é pra poder fazer foreach, e o identifiable é pro foreach conseguir identificar cada um
enum Gender: String, CaseIterable, Identifiable {
  case male = "Masculino"
  case female = "Feminino"
  
  // retorna o valor puro, tipo "Masculino". O rawValue no swift é como o value de um input no js
  var id: String {
    self.rawValue
  }
  
  // retorna o index do case do enum
  var index: Self.AllCases.Index {
    // o método firstIndex itera os casos e retorna o primeiro index em que um elemento da coleção satisfaz o requerimento. No caso abaixo, se criamos uma variável "sexo" que tem male "armazenado", sexo.index é 0. Temos o nil coalescing para, caso não encontre, retorna 0
    return Self.allCases.firstIndex { self == $0 } ?? 0
  }
  
}
