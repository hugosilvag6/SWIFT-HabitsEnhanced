//
//  LoadingButtonView.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 15/07/22.
//

import SwiftUI

struct LoadingButtonView: View {
  
  var action: () -> Void
  var text: String
  var showProgress: Bool = true
  var disabled: Bool = false
  
    var body: some View {
      ZStack {
        Button {
          action()
        } label: {
          Text(showProgress ? "" : text)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .font(.title3.bold())
            .background(disabled ? Color("lightOrange") : Color.orange)
            .foregroundColor(.white)
            .cornerRadius(4.0)
        }
        .disabled(disabled || showProgress)
        
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle())
          .opacity(showProgress ? 1 : 0)
      }
    }
}

struct LoadingButtonView_Previews: PreviewProvider {
    static var previews: some View {
      ForEach(ColorScheme.allCases, id: \.self) {
      LoadingButtonView(action: {
        print("hello world")
      }, text: "Login", showProgress: true, disabled: false)
      .preferredColorScheme($0)
      }
    }
}
