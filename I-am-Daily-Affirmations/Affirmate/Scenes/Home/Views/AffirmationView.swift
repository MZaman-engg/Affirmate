

import SwiftUI

struct AffirmationView: View {
  
  // MARK: - ViewModel
  @ObservedObject var viewModel: HomeViewModel
  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
  }
  // MARK: - Stata variables
  @State var animate: Bool = false
  @State var likeAnimation: Bool = false
  
  // MARK: - Private variables
  private var duration: Double = 0.4
  
  var body: some View {
    GeometryReader { proxy in
      TabView {
        ForEach(0..<viewModel.affirmations.count, id: \.self) { index in
          VStack {
            Spacer()
            Text("\(viewModel.affirmations[index].text.capitalizingFirstLetter())")
              .multilineTextAlignment(.center)
              .foregroundColor(
                viewModel.selectedTheme == AppSetting.colorBackground
                ?
                Color(hex: viewModel.selectedColorBackground.textColor)
                :
                  Color(hex: viewModel.selectedThemeBackground.textColor)
              )
              .font(
                viewModel.selectedTheme == AppSetting.colorBackground
                ?
                Font.font(viewModel.selectedColorBackground.fontDesign, style: .title)
                :
                  Font.font(viewModel.selectedThemeBackground.fontDesign, style: .title)
              )
              .padding(.horizontal,5)
            Spacer()
            HStack {
              ShareLink(item: viewModel.affirmations[index].text) {
                Image(systemName: "square.and.arrow.up")
                  .font(.title)
                  .fontWeight(.light)
                  .foregroundColor(
                    viewModel.selectedTheme == AppSetting.colorBackground
                    ?
                    Color(hex: viewModel.selectedColorBackground.textColor)
                    :Color(hex: viewModel.selectedThemeBackground.textColor)
                  )
              }
              Button {
                self.animate = true
                DispatchQueue.main.asyncAfter(deadline: .now() + self.duration, execute: {
                  self.animate = false
                  viewModel.affirmations[index].isFavourite.toggle()
                  let quote = viewModel.affirmations[index]
                  if quote.isFavourite {
                    viewModel.addToFavorites(model: quote)
                  }else {
                    viewModel.removeFromFavorites(model: quote)
                  }
                })
              } label: {
                Image(systemName: viewModel.affirmations[index].isFavourite ? "heart.fill" : "heart")
                  .font(.title)
                  .fontWeight(.light)
                  .foregroundColor(
                    viewModel.selectedTheme == AppSetting.colorBackground
                    ?
                    Color(hex: viewModel.selectedColorBackground.textColor)
                    :Color(hex: viewModel.selectedThemeBackground.textColor)
                  )
              }
              .scaleEffect(animate ? (viewModel.affirmations[index].isFavourite ? 0.6 : 2.0) : 1)
              .animation(.easeIn(duration: duration), value: animate)
            }
          }
          .padding(.vertical, 120)
        }
        .rotationEffect(.degrees(-90))
        .frame(
          width: proxy.size.width,
          height: proxy.size.height
        )
      }
      .frame(
        width: proxy.size.height,
        height: proxy.size.width
      )
      .rotationEffect(.degrees(90), anchor: .topLeading)
      .offset(x: proxy.size.width)
      .tabViewStyle(
        PageTabViewStyle(indexDisplayMode: .never)
      )
    }
  }
}

struct AffirmationView_Previews: PreviewProvider {
  static var previews: some View {
    AffirmationView(viewModel: HomeViewModel())
  }
}
