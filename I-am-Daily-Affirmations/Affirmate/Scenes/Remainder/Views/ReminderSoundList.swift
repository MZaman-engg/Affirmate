

import SwiftUI

struct ReminderSoundList: View {
  @ObservedObject var viewModel: ReminderViewModel
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    ZStack() {
      Color(hex: "E4D0D0").opacity(0.6).ignoresSafeArea()
      List(content: {
        ForEach(viewModel.availableSounds) { sound in
          HStack {
            Text(sound.name)
            Spacer()
            if viewModel.getSelectedSound() == sound.fileName {
              Image(systemName: "checkmark")
                .padding(.trailing, 5)
            }
          }
          .contentShape(Rectangle())
          .onTapGesture {
            viewModel.setSelectedSound(name: sound.fileName)
            viewModel.playSound(name: sound.fileName)
          }
        }
      })
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

struct ReminderSoundList_Previews: PreviewProvider {
    static var previews: some View {
      ReminderSoundList(viewModel: .init())
    }
}
