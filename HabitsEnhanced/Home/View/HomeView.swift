//
//  HomeView.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 12/07/22.
//

import SwiftUI

struct HomeView: View {
  
  @ObservedObject var viewModel: HomeViewModel
  
  @State var selection = 0
  
  var body: some View {
    // tab view é a barra inferior
    TabView(selection: $selection) {
      viewModel.habitView()
      // tabitem permite cadastrar os conteúdos na tabview
        .tabItem {
          Image(systemName: "square.grid.2x2")
          Text("Hábitos")
        }.tag(0) // a tag é tipo um id
      
      viewModel.habitForChartView()
        .tabItem {
          Image(systemName: "chart.bar")
          Text("Gráficos")
        }.tag(1)
      
      viewModel.profileView()
        .tabItem {
          Image(systemName: "person.crop.circle")
          Text("Perfil")
        }.tag(2)
    }
    .background()
    .accentColor(.orange)
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    let viewModel = HomeViewModel()
    HomeView(viewModel: viewModel)
  }
}
