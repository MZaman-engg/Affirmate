

import SwiftUI

struct ReminderCategoryListView: View {
  @ObservedObject var viewModel: ReminderViewModel
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    ZStack() {
      Color(hex: "E4D0D0").opacity(0.6).ignoresSafeArea()
      List {
        ForEach(viewModel.categories) { category in
          Section("\(category.section)") {
            ForEach(category.categories, id: \.self) { name in
              HStack {
                Text(name)
                Spacer()
                if viewModel.getSelectedCategory() == name {
                  Image(systemName: "checkmark")
                    .padding(.trailing, 5)
                }
              }
              .contentShape(Rectangle())
              .onTapGesture {
                viewModel.setSelectedCategory(category: name)
              }
            }
          }
        }
      }
      .scrollContentBackground(.hidden)
      .navigationBarBackButtonHidden(true)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            self.presentationMode.wrappedValue.dismiss()
          } label: {
            HStack {
              Image(systemName: "arrow.left")
              Text("Back")
            }
            .foregroundColor(Color.black)
            .font(.headline)
          }
        }
      }
    }
  }
}

struct ReminderCategoryListView_Previews: PreviewProvider {
    static var previews: some View {
      ReminderCategoryListView(viewModel: .init())
    }
}
