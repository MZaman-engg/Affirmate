

import Foundation
import UserNotifications

class NotificationManager {
  
  static let shared: NotificationManager = .init()
  
  var totalScheduledNotifications = 0
  
  var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyy-MM-dd :hh:mm:ss a"
    dateFormatter.calendar = Calendar.current
    return dateFormatter
  }()
  
  private init() {}
  
  var weekDays: [Bool] = []
  
  func scheduleNotifications(startTime: Date, endTime: Date, weekDays: [Bool], reminderCount: Int, notificationTexts: [String], soundName: String , completion: @escaping (Bool) -> Void) {
    let timeStamps = timeStampsForNotifications(startTime: startTime, endTime: endTime, weekDays: weekDays, reminderCount: reminderCount)
    self.weekDays = weekDays
    scheduleNotification(timeStamps: timeStamps, soundName: soundName, notificationTexts: notificationTexts) { isCompleted in
      completion(isCompleted)
    }
  }
  private func timeStampsForNotifications(startTime: Date, endTime: Date, weekDays: [Bool], reminderCount: Int) -> [Date?] {
    let calendar = Calendar.current
    let endTimeComponents = calendar.dateComponents([.hour, .minute], from: endTime)
    let startTimeComponents = calendar.dateComponents([.hour, .minute], from: startTime)
    let timeDifference = timeDifference(startTimeComponents: startTimeComponents, endTimeComponents: endTimeComponents)
    guard let startHour = startTimeComponents.hour , let startMinute = startTimeComponents.minute, let endHour = endTimeComponents.hour, let endMinute = endTimeComponents.minute else {
      Logger.shared.log(description: "Unable to get date component.")
      return []
    }
    let selectedDays = getSelectedDays(days: weekDays)
    return getNotificationTimestamps(selectedWeekdays: selectedDays, startHour: startHour, startMinute: startMinute, endHour: endHour, endMinute: endMinute, timeDifference: timeDifference, numberOfNotifications: reminderCount)
  }
  
  private func timeDifference(startTimeComponents: DateComponents, endTimeComponents: DateComponents ) -> Int {
    let start: DateComponents = startTimeComponents
    let end: DateComponents = endTimeComponents
    var min = Calendar.current.dateComponents([.minute], from: start, to: end).minute!
    if end.hour! < start.hour! || (end.hour! == start.hour! && end.minute! < start.minute!) {
      min = min + 1440
    }
    return min
  }
  
  private func getSelectedDays(days: [Bool]) -> [Int] {
    var selectedDays: [Int] = []
    for index in 0..<days.count {
      if days[index] == true {
        selectedDays.append(index + 1)
      }
    }
    return selectedDays
  }
  
  private func getNotificationTimestamps(selectedWeekdays: [Int], startHour: Int, startMinute: Int, endHour: Int, endMinute: Int,timeDifference: Int , numberOfNotifications: Int) -> [Date?] {
    let calendar = Calendar.current
    var notificationTimestamps: [Date?] = []
    let notificationDurationInSeconds = timeDifference * 60 / numberOfNotifications
    var currentDate = Date()
    
    var startTime = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .weekday], from: currentDate)
    startTime.hour = startHour
    startTime.minute = startMinute
    startTime.second = 0
    
    for index1 in 1...2 {
      startTime = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .weekday], from: currentDate)
      startTime.hour = startHour
      startTime.minute = startMinute
      startTime.second = 0
      var timeStamp: Date = calendar.date(from: startTime)!
      guard let weekday = startTime.weekday else {
        return notificationTimestamps
      }
      if selectedWeekdays.contains(weekday) {
        for index2 in  0..<numberOfNotifications {
          timeStamp = calendar.date(byAdding: .second, value: notificationDurationInSeconds, to: timeStamp)!
          notificationTimestamps.append(timeStamp)
          print("\(index2) TimeStamp: \(dateFormatter.string(from: timeStamp))")
        }
      }
      print("Day ===>>  \(index1)")
      guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
        Logger.shared.log(description: "Invalid date")
        return notificationTimestamps
      }
      currentDate = nextDate
    }
    
    return notificationTimestamps
  }
  
  private func scheduleNotification(timeStamps: [Date?], soundName: String, notificationTexts: [String], completion: @escaping (Bool) -> Void) {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    let center = UNUserNotificationCenter.current()

    // Request authorization to display notifications
    var notificationsCount = timeStamps.count
    center.requestAuthorization(options: [.alert,.badge, .sound]) { (granted, error) in
      if granted {
        for (index, timeStamp) in timeStamps.enumerated() {
          let content = UNMutableNotificationContent()
          content.title = AppSetting.appName
          content.body = notificationTexts[index]
          if soundName != "default" {
            content.sound = UNNotificationSound(named: UNNotificationSoundName(soundName + ".wav"))
          }

          let calendar = Calendar.current
          let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: timeStamp!)

          let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)


          let identifier = UUID().uuidString
//          let identifier = "Identifier - \(self.dateFormatter.string(from: timeStamp!))"
          let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

          center.add(request) { [weak self] (error) in
            guard let strongSelf = self else {
              return
            }
            if let error = error {
              Logger.shared.log(description: "Error scheduling notification: \(error.localizedDescription)")
              completion(false)
            } else {
              Logger.shared.log(description: "Notification scheduled successfully for \(String(describing: strongSelf.dateFormatter.string(from: timeStamp!)))")
              notificationsCount -= 1
            }
            if notificationsCount == 0 {
              completion(true)
              strongSelf.getPendingNotifications()
            }
          }
        }
      } else {
        completion(false)
        Logger.shared.log(description: "Notification authorization denied")
      }
    }
  }
  
  func removeAllScheduledNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    Logger.shared.log(description: "Remove all pending notification requests at time: \(Date())")
  }
  
  func scheduleLocalNotification(date: Date) {
    // Create a notification content
    let content = UNMutableNotificationContent()
    content.title = "Notification Title \(dateFormatter.string(from: date))"
    content.body = "Notification Body"
    content.sound = UNNotificationSound.default
    
    let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    
    let identifier = UUID().uuidString
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    
    // Schedule the notification
    UNUserNotificationCenter.current().add(request) { (error) in
      if let error = error {
        print("Error scheduling notification: \(error.localizedDescription)")
      } else {
        self.totalScheduledNotifications += 1
        print("Notification scheduled successfully \(self.totalScheduledNotifications)")
      }
    }
  }

  
  func getPendingNotifications() {
    UNUserNotificationCenter.current().getPendingNotificationRequests { notificationRequests in
      Logger.shared.log(description: "Pending notifications request : \(notificationRequests.count)")
      for request in notificationRequests {
        print("Identifier: \(request.identifier)")
        print("Title: \(request.content.title)")
        print("Body: \(request.content.body)")
        print("Trigger: \(String(describing: request.trigger))")
        print("------------------------------------------------")
      }
    }
  }
  
}
