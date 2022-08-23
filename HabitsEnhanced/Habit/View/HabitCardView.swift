//
//  HabitCardView.swift
//  HabitsEnhanced
//
//  Created by Hugo Silva on 08/08/22.
//

import SwiftUI
import Combine

struct HabitCardView: View {
  
  @State private var action = false
  
  let isCharts: Bool
  let viewModel: HabitCardViewModel
  
    var body: some View {
      ZStack(alignment: .trailing) {
        if isCharts {
          NavigationLink(
            destination:  viewModel.chartView(),
            isActive: self.$action,
            label: {
              EmptyView()
          })
        } else {
          NavigationLink(
            destination:  viewModel.habitDetailView(),
            isActive: self.$action,
            label: {
              EmptyView()
          })
        }
        Button {
          self.action = true
        } label: {
          HStack {
            ImageView(url: viewModel.icon)
              .aspectRatio(contentMode: .fill)
              .frame(width: 32, height: 32)
              .clipped()
            Spacer()
            HStack(alignment: .top) {
              Spacer()
              VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.name)
                  .foregroundColor(.orange)
                Text(viewModel.label)
                  .foregroundColor(Color("textColor"))
                  .bold()
                Text(viewModel.date)
                  .foregroundColor(Color("textColor"))
                  .bold()
              }
              .frame(maxWidth: 300, alignment: .leading)
              Spacer()
              VStack(alignment: .leading, spacing: 4) {
                Text("Registrado")
                  .foregroundColor(.orange)
                  .bold()
                  .multilineTextAlignment(.leading)
                Text(viewModel.value)
                  .foregroundColor(Color("textColor")).bold()
                  .bold()
                  .multilineTextAlignment(.leading)
              }
              Spacer()
            }
            Spacer()
          }
          .padding()
          .cornerRadius(4)
        }
        if !isCharts {
          Rectangle()
            .frame(width: 8)
            .foregroundColor(viewModel.state)
        }
      }
      .background(
        RoundedRectangle(cornerRadius: 4)
          .stroke(.orange, lineWidth: 1.4)
          .shadow(color: .gray, radius: 2, x: 2, y: 2)
      )
      .padding(.horizontal, 4)
      .padding(.vertical, 8)
    }
}

struct HabitCardView_Previews: PreviewProvider {
    static var previews: some View {
      ForEach(ColorScheme.allCases, id: \.self) {
        NavigationView {
          List {
            HabitCardView(isCharts: false, viewModel: HabitCardViewModel(id: 1, icon: "https://via.placeholder.com/150", date: "01/01/2022 00:00:00", name: "Tocar guitarra", label: "horas", value: "2", state: .green, habitPublisher: PassthroughSubject<Bool, Never>()))
            HabitCardView(isCharts: false, viewModel: HabitCardViewModel(id: 1,
                                                        icon: "https://via.placeholder.com/150",
                                                        date: "01/01/2022 00:00:00",
                                                        name: "Tocar guitarra",
                                                        label: "horas",
                                                        value: "2",
                                                        state: .green,
                                                        habitPublisher: PassthroughSubject<Bool, Never>()))
          }
          .frame(maxWidth: .infinity)
          .navigationTitle("Teste")
        }
        .preferredColorScheme($0)
      }
    }
}
