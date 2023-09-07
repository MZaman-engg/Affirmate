

import SwiftUI

struct ThemeColorPickerView: View {
  @ObservedObject var viewModel: ThemeViewModel
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
      ZStack {
        viewModel.backgroundColor
          .ignoresSafeArea()
        VStack {
          Text("I Am")
            .font(Font.font(viewModel.fontDesign, style: .title))
            .foregroundColor(viewModel.textColor)
          Spacer()
          Button {
            viewModel.presentFontDesignList.toggle()
          } label: {
            HStack {
              Text("Select text design")
                .font(.headline)
              Spacer()
              Text(viewModel.fontDesign)
                .font(.headline)
            }
            .padding(20)
            .background(Color.black)
            .cornerRadius(10)
            .foregroundColor(Color.white)
            .padding(.horizontal,30)
          }
          .sheet(isPresented: $viewModel.presentFontDesignList) {
            fontListView
          }
          ColorPicker("Select background Color",selection: $viewModel.backgroundColor, supportsOpacity: true)
            .padding(20)
            .background(Color.black)
            .cornerRadius(10)
            .foregroundColor(Color.white)
            .font(.headline)
            .padding(.horizontal,30)
          ColorPicker("Select text Color",selection: $viewModel.textColor, supportsOpacity: true)
            .padding(20)
            .background(Color.black)
            .cornerRadius(10)
            .foregroundColor(Color.white)
            .font(.headline)
            .padding(.horizontal,30)
          Spacer()
        }
      }
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
          .foregroundColor(Color.white)
          .font(.headline)
        }
      }
    }
  }
  
  var fontListView: some View {
    VStack {
      HStack {
        Text("Font Design")
          .font(.title)
          .fontDesign(.monospaced)
          .padding(.trailing)
        Spacer()
        Button {
          viewModel.presentFontDesignList = false
        } label: {
          Image(systemName: "x.circle.fill")
            .font(.title)
            .padding(.leading)
            .foregroundColor(.black)
        }
      }
      ForEach(viewModel.availableFonts, id: \.self, content: { font in
        HStack {
          Text(font.capitalizingFirstLetter())
          Spacer()
          if viewModel.fontDesign == font {
            Image(systemName: "checkmark.rectangle.fill")
          }
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(10)
        .onTapGesture {
          viewModel.fontDesign = font
        }
      })
    }
    .padding()
    .overlay {
      GeometryReader { geometry in
        Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
      }
    }
    .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
      viewModel.sheetHeight = newHeight
    }
    .presentationDetents([.height(viewModel.sheetHeight)])
  }
}

struct ThemeColorPickerView_Previews: PreviewProvider {
  static var previews: some View {
    ThemeColorPickerView(viewModel: .init(selectedTheme: AppSetting.colorBackground, textColor: "#9FC088", fontDesign: "monospaced", backgroundColor: "#CC704B"))
  }
}

struct InnerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
