

import SwiftUI

@main
struct AffirmateApp: App {
  
  @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
          HomeView()
        }
    }
}
