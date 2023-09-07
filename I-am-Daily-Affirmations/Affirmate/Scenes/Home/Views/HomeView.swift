

import SwiftUI

struct HomeView: View {
  @StateObject var viewModel = HomeViewModel()
  var body: some View {
    ZStack {
      // background
      HomeBackgroundView(viewModel: viewModel).ignoresSafeArea()
      // content
      AffirmationView(viewModel: viewModel)
      HomeActionsView(viewModel: viewModel)
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
