

import SwiftUI

struct ThemeCardView: View {
  var isSelected: Bool
  var imageData: Data
  var textColor, fontDesign: String
  var body: some View {
    VStack {
      Spacer()
      Text("I AM")
        .font(Font.font(fontDesign, style: .title2))
        .fontWeight(.bold)
        .foregroundColor(Color(hex: textColor))
      Spacer()
      HStack {
        Spacer()
        if isSelected {
          Image(systemName: "checkmark.rectangle.fill")
            .foregroundColor(Color.primaryColor)
            .font(.title2)
        }
      }
      .padding(6)
    }
    .background(
      Image(uiImage: UIImage(data: imageData) ?? UIImage())
        .resizable()
    )
    .frame(width: 100, height: 170)
    .cornerRadius(10)
  }
}

struct ThemeCardView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeCardView(isSelected: true, imageData: UIImage(named:  "bg4")?.pngData() ?? Data(), textColor: "#FFFFFF", fontDesign: "monospaced")
    }
}
