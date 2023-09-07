

import SwiftUI

struct ThemeColorPickerCardView: View {
  @ObservedObject var viewModel: ThemeViewModel
  var body: some View {
    RoundedRectangle(cornerRadius: 10)
      .fill(
        viewModel.backgroundColor
      )
      .frame(width: 100, height: 170)
      .overlay {
        ZStack {
          VStack {
            HStack {
              Spacer()
              NavigationLink {
                ThemeColorPickerView(viewModel: viewModel)
              } label: {
                Image(systemName: "slider.vertical.3")
                  .padding(.horizontal)
                  .padding(.top)
                  .font(.headline)
                  .foregroundColor(.white)
              }
            }
            Spacer()
            Text("I AM")
              .font(Font.font(viewModel.fontDesign, style: .title2))
              .fontWeight(.bold)
              .foregroundColor(viewModel.textColor)
            Spacer()
            HStack {
              Spacer()
              if viewModel.selectedTheme == AppSetting.colorBackground {
                Image(systemName: "checkmark.rectangle.fill")
                  .foregroundColor(Color.primaryColor)
                  .font(.title2)
                  .padding(6)
              }
            }
          }
        }
      }
  }
}

struct ThemeColorPickerCardView_Previews: PreviewProvider {
    static var previews: some View {
      ThemeColorPickerCardView(viewModel: .init(selectedTheme: AppSetting.colorBackground, textColor: "#9FC088", fontDesign: "monospaced", backgroundColor: "#CC704B"))
    }
}
