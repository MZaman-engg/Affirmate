

import SwiftUI

enum Theme {
  case image(BackgroundImagesModel)
  case color(BackgroundModel)
}

struct ThemeView: View {
  @Binding var isPresented: Bool
  @ObservedObject var viewModel: ThemeViewModel
  var onDidSelectTheme : ((Theme) -> ())
  var body: some View {
    NavigationView {
      ZStack {
        // background
        Color(hex: "E4D0D0").opacity(0.6).ignoresSafeArea()
        // content
        VStack(spacing: 10) {
          screenTop
          ScrollView(.vertical,showsIndicators: false) {
            ScrollView(.horizontal,showsIndicators: false) {
              HStack {
                ForEach(viewModel.selectedBackgroundImage) { background in
                  ThemeCardView(isSelected: background.isSelected, imageData: background.imageData, textColor: background.textColor, fontDesign: background.fontDesign)
                    .onTapGesture {
                      onDidSelectTheme(.image(background))
                    }
                }
                ThemeColorPickerCardView(viewModel: viewModel)
                  .onTapGesture {
                    onDidSelectTheme(.color(viewModel.getSelectedBackground()))
                  }
              }
              .padding(.horizontal)
            }
            ForEach(viewModel.backgrounds) {  backgrounds in
              VStack {
                sectionTitle(sectionTitle: "\(backgrounds.title)")
                ScrollView(.horizontal,showsIndicators: false) {
                  HStack {
                    ForEach(backgrounds.backgroundImages) { background in
                      ThemeCardView(isSelected: background.isSelected, imageData: background.imageData, textColor: background.textColor, fontDesign: background.fontDesign)
                        .onTapGesture {
                          onDidSelectTheme(.image(background))
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
      Text("Themes")
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

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
      ThemeView(isPresented: .constant(true), viewModel: .init(selectedTheme: AppSetting.colorBackground, textColor: "#9FC088", fontDesign: "monospaced", backgroundColor: "#CC704B")) { _ in
      }
    }
}
