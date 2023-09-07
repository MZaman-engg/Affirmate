

import SwiftUI
import AlertToast

struct ReminderView: View {
  @StateObject var viewModel:ReminderViewModel = .init()
  @Binding var isPresented: Bool
  @State var presentToast: Bool = false
  @State var presentLoader: Bool = false
  var body: some View {
    
    NavigationView {
      
      ZStack() {
        Color(hex: "E4D0D0").opacity(0.6).ignoresSafeArea()
        VStack(spacing: 0) {
          screenTop
          List {
            NavigationLink {
              ReminderCategoryListView(viewModel: viewModel)
            } label: {
              HStack {
                Text("Type of affirmations")
                  .font(.title2)
                Spacer()
                Text(viewModel.getSelectedCategory())
                  .fontWeight(.light)
              }
              .padding(.vertical,6)
            }
            
            HStack {
              Text("How many")
                .font(.title2)
              Spacer()
              Image(systemName: "minus.square.fill")
                .foregroundColor(.black)
                .font(.largeTitle)
                .onTapGesture {
                  viewModel.decrementRemaindersCount()
                }
              Text("\(viewModel.getRemaindersCount())X")
                .font(.title2)
                .frame(maxWidth: 60)
              Image(systemName: "plus.square.fill")
                .foregroundColor(.black)
                .font(.largeTitle)
                .onTapGesture {
                  viewModel.incrementRemaindersCount()
                }
            }
            .padding(.vertical,1)
            
            HStack {
              Text(viewModel.getRemaindersCount() == 1 ? "Time" : "Start at")
                .font(.title2)
              Spacer()
              
              Image(systemName: "minus.square.fill")
                .foregroundColor(.black)
                .font(.largeTitle)
                .onTapGesture {
                  viewModel.decrementStartTime()
                }
              Text(viewModel.getStartTime())
                .font(.title2)
                .frame(maxWidth: 60)
              
              Image(systemName: "plus.square.fill")
                .foregroundColor(.black)
                .font(.largeTitle)
                .onTapGesture {
                  viewModel.incrementStartTime()
                }
            }
            .padding(.vertical,1)
            
            if viewModel.getRemaindersCount() > 1 {
              HStack {
                Text("End at")
                  .font(.title2)
                Spacer()
                
                Image(systemName: "minus.square.fill")
                  .foregroundColor(.black)
                  .font(.largeTitle)
                  .onTapGesture {
                    viewModel.decrementEndTime()
                  }
                
                Text(viewModel.getEndTime())
                  .font(.title2)
                  .frame(maxWidth: 60)
                
                Image(systemName: "plus.square.fill")
                  .foregroundColor(.black)
                  .font(.largeTitle)
                  .onTapGesture {
                    viewModel.incrementEndTime()
                  }
              }
              .padding(.vertical,1)
            }
            
            VStack {
              HStack {
                Text("Repeat")
                  .font(.title2)
                Spacer()
              }
              ScrollView(.horizontal,showsIndicators: false) {
                WeekDaysSelectionView(viewModel: viewModel)
              }
            }
            
            NavigationLink {
              ReminderSoundList(viewModel: viewModel)
            } label: {
              HStack {
                Text("Sound")
                  .font(.title2)
                Spacer()
                Text(viewModel.getSelectedSoundName())
                  .fontWeight(.light)
              }
              .padding(.vertical,6)
            }
            
          }
          VStack {
            Button {
              presentLoader = true
              viewModel.scheduleNotifications { isCompleted in
                /// we can present alert in case of failure
                presentToast = isCompleted
                presentLoader = !isCompleted
              }
              
            } label: {
              Label("Schedule Reminders", systemImage: "bell.fill")
            }
            .foregroundColor(.white)
            .padding()
            .padding(.horizontal)
            .background(Color.darkPrimary)
            .cornerRadius(5)
          }
          .toast(isPresenting: $presentToast, offsetY: 25) {
            
            AlertToast(displayMode: .hud
                       , type: .regular, title: "🔔 Reminders Scheduled.",style: .style(backgroundColor: Color.darkPrimary))
            
          }
          .toast(isPresenting: $presentLoader, offsetY: -100) {
            AlertToast(displayMode: .alert, type: .loading, style: .style(backgroundColor: Color.darkPrimary))
          }
          Spacer()
        }
        .scrollContentBackground(.hidden)
        
      }
    }
  }
  
  var screenTop: some View {
    HStack {
      Text("Edit Remainder")
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

struct RemainderView_Previews: PreviewProvider {
  static var previews: some View {
    ReminderView(isPresented: Binding<Bool>.constant(true))
  }
}

