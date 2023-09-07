

import SwiftUI

struct WeekDaysSelectionView: View {
  @ObservedObject var viewModel: ReminderViewModel
  var body: some View {
    HStack {
      let days = viewModel.getRemaindersDays()
      ForEach(days) { day in
        let letter = String(day.name[day.name.startIndex])
        Circle()
          .foregroundColor(day.isSelected ? Color.primaryColor : Color.white)
          .overlay {
            Text(letter)
          }
          .frame(width: 50)
          .overlay(
            Circle()
              .stroke(Color.primaryColor, lineWidth: 2)
          )
          .padding(3)
          .onTapGesture {
            viewModel.setDaySelection(day: day.number)
          }
        
      }
    }
  }
}

struct WeekDaysSelectionView_Previews: PreviewProvider {
    static var previews: some View {
      WeekDaysSelectionView(viewModel: .init())
    }
}
