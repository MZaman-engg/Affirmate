

import Foundation
import UIKit
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    self.setUp()
    
    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      if let error = error {
        Logger.shared.log(description: error.localizedDescription)
      } else {
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
          Messaging.messaging().delegate = self
        }
      }
    }
    return true
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
//    Logger.shared.log(description: userInfo)
    print(userInfo)
    return .noData
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
    Messaging.messaging().token { token, error in
      if let error = error {
        print("Error fetching FCM registration token: \(error)")
      } else if let token = token {
        print("FCM registration token: \(token)")
//        self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
      }
    }
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    Logger.shared.log(description: error.localizedDescription)
  }
  
  func setUp() {
    FirebaseManager.shared.configure()
    DownloadManager.shared.configure()
    ReachabilityManager.shared.configure()
  }
  
}

extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    Logger.shared.log(description: "FCM Token : \(String(describing: fcmToken))")
    Messaging.messaging().token { token, error in
      if let error = error {
        print("Error fetching FCM registration token: \(error)")
      } else if let token = token {
        print("FCM registration token: \(token)")
//        self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
      }
    }
  }
}
