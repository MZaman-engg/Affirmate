

import SwiftUI

struct CategoryCard: View {
  var isSelected: Bool
  var name: String
    var body: some View {
      RoundedRectangle(cornerRadius: 10)
        .fill(
          LinearGradient(colors: [Color(hex: "E4D0D0"),Color(hex: "AAC8A7")], startPoint: .leading, endPoint: .bottomTrailing)
        )
        .frame(width: 170, height: 170)
        .overlay {
          ZStack {
            Text(name)
              .multilineTextAlignment(.center)
              .font(.title3)
              .fontDesign(.monospaced)
            VStack {
              Spacer()
              HStack {
                Spacer()
                if isSelected {
                  Image(systemName: "checkmark.rectangle.fill")
                    .font(.title2)
                    .padding()
                }
              }
            }
          }
        }
    }
}

struct CategoryCard_Previews: PreviewProvider {
    static var previews: some View {
      CategoryCard(isSelected: true, name: "Category")
    }
}
