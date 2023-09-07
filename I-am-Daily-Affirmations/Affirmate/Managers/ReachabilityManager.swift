

import Foundation
import Reachability

class ReachabilityManager {
 
  static let shared: ReachabilityManager = .init()
  private var reachability: Reachability?
  
  init() {
    self.reachability = try? Reachability()
  }
  
  func configure() {
    reachability?.whenReachable = { reachability in
      NotificationCenter.default.post(name: AppSetting.NotificationName.internetAvailable, object: nil)
      Logger.shared.log(description: " internet available ")
    }
    
    reachability?.whenUnreachable = { _ in
      // Do something when no network is available.
      Logger.shared.log(description: " internet not available ")
    }
    
    self.startNotifier()
  }
  
  private func startNotifier() {
    do {
      try reachability?.startNotifier()
    }catch {
      Logger.shared.log(description: "Error is thrown while starting reachability: \(error)")
    }
  }
  
  func stopNotifier() {
    reachability?.stopNotifier()
  }
}
