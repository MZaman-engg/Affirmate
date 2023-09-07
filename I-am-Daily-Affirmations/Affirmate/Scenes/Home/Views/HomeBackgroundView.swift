

import SwiftUI
/*
 This view return all type of backgrounds
 */
struct HomeBackgroundView: View {
  
  @ObservedObject var viewModel: HomeViewModel
  
    var body: some View {
      if viewModel.selectedTheme == AppSetting.colorBackground {
        Color(hex: viewModel.backgroundColor)
      }
      else{
        Image(uiImage: UIImage(data: viewModel.selectedThemeBackground.imageData) ?? UIImage())
          .resizable()
      }
    }
}

struct HomeBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
      HomeBackgroundView(viewModel: .init())
    }
}
