

import SwiftUI

struct HomeActionsView: View {
  // MARK: - ViewModel
  @ObservedObject var viewModel: HomeViewModel
  
  // MARK: - State variables
  @State private var presentCategoryView = false 
  @State private var presentBackgroundView = false
  @State private var presentRemainderView = false
  
    var body: some View {
      VStack {
        HStack {
          Spacer()
          Button {
            // will fix
          } label: {
            Image(systemName: "crown.fill")
              .font(.title2)
              .fontWeight(.light)
              .foregroundColor(.white)
          }
          .padding(.all)
          .background(
            Color.homeActionColor
          )
          .cornerRadius(5)
        }
        .padding(.horizontal)
        Spacer()
          .padding(.bottom)
        HStack {
          Button {
            presentCategoryView = true
          } label: {
            Image(systemName: "square.grid.2x2.fill")
              .foregroundColor(.white)
            Text(viewModel.selectedCategory)
              .foregroundColor(.white)
          }
          .padding(.all)
          .background(
            Color.homeActionColor
          )
          .cornerRadius(5)
          .sheet(isPresented: $presentCategoryView,onDismiss: {
            viewModel.getAffirmations()
          }) {
            CategoryView(isPresented: $presentCategoryView, viewModel: .init(selectedCategoryName: viewModel.selectedCategory)) { subCategory in
              viewModel.selectedCategory = subCategory.name
            }
          }
          Button {
            presentBackgroundView = true
          } label: {
            Image(systemName: "paintbrush.fill")
              .foregroundColor(.white)
          }
          .padding(.all)
          .background(
            Color.homeActionColor
          )
          .cornerRadius(5)
          .sheet(isPresented: $presentBackgroundView) {
            // update background if it changes
          } content: {
            ThemeView(isPresented: $presentBackgroundView, viewModel: .init(selectedTheme: viewModel.selectedTheme, textColor: viewModel.textColor, fontDesign: viewModel.fontDesign, backgroundColor: viewModel.backgroundColor)) {
              selectedTheme in
              switch selectedTheme {
              case .image(let backgroundImagesModel):
                viewModel.setTheme(theme: backgroundImagesModel)
                viewModel.selectedTheme = backgroundImagesModel.name
              case .color(let colorBackground):
                viewModel.setColorBackground(colorBackground: colorBackground)
                viewModel.selectedTheme = colorBackground.name
              }
            }
          }
          
          Spacer()
          Button {
            presentRemainderView = true
          } label: {
            Image(systemName: "bell.fill")
              .foregroundColor(.white)
              .font(.title3)
          }
          .padding(.all)
          .background(
            Color.homeActionColor
          )
          .cornerRadius(5)
          .sheet(isPresented: $presentRemainderView) {
            ReminderView(isPresented: $presentRemainderView)
          }
          Button {
            // will fix
          } label: {
            Image(systemName: "person.fill")
              .foregroundColor(.white)
              .font(.title3)

          }
          .padding(.all)
          .background(
            Color.homeActionColor
          )
          .cornerRadius(5)
        }
      }
      .padding()
    }
}

struct HomeActionsView_Previews: PreviewProvider {
    static var previews: some View {
      HomeActionsView(viewModel: HomeViewModel())
    }
}
