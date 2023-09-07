

import SwiftUI

struct CategoryView: View {
  @Binding var isPresented: Bool
  @ObservedObject var viewModel: CategoryViewModel
  var onDidSelectCategory: ((SubCategoryModel) -> ())
  
  var body: some View {
    ZStack {
      // background
      Color(hex: "E4D0D0").opacity(0.6).ignoresSafeArea()
      // content
      VStack(spacing: 10) {
        screenTop
        ScrollView(.vertical,showsIndicators: false) {
          ScrollView(.horizontal,showsIndicators: false) {
            HStack {
              if let selectedCategory = viewModel.selectedCategoryModel{
                CategoryCard(isSelected: selectedCategory.isSelected, name: selectedCategory.name)
                  .onTapGesture {
                    onDidSelectCategory(selectedCategory)
                  }
              }
              
              ForEach(viewModel.generalCategories) { subCategory in
                CategoryCard(isSelected: subCategory.isSelected, name: subCategory.name)
                  .onTapGesture {
                    onDidSelectCategory(subCategory)
                  }
              }
            }
            .padding(.horizontal)
          }
          ForEach(viewModel.categories) { category in
            VStack {
              sectionTitle(sectionTitle: "\(category.name)")
              ScrollView(.horizontal,showsIndicators: false) {
                HStack {
                  ForEach(category.subCategoryModel) { subCategory in
                    CategoryCard(isSelected: subCategory.isSelected, name: subCategory.name)
                      .onTapGesture {
                        onDidSelectCategory(subCategory)
                      }
                  }
                }
                .padding(.horizontal)
              }
            }
          }
        }
      }
    }
  }
  
  func sectionTitle(sectionTitle: String) -> some View {
    HStack {
      Text(sectionTitle)
        .font(.title2)
        .fontDesign(.monospaced)
        .padding(.leading, 30)
      Spacer()
    }
  }
  
  var screenTop: some View {
    HStack {
      Text("Categories")
        .font(.largeTitle)
        .fontDesign(.monospaced)
        .padding(.top)
        .padding(.horizontal)
      Spacer()
      Button {
        isPresented = false
      } label: {
        Image(systemName: "x.circle.fill")
          .font(.title)
          .padding(.horizontal)
          .padding(.top)
          .foregroundColor(.black)
      }
    }
  }
}

struct CategoryView_Previews: PreviewProvider {
  static var previews: some View {
    CategoryView(isPresented: .constant(false), viewModel: .init(selectedCategoryName: "")) { _ in
    }
  }
}
