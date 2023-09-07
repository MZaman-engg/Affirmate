

import Foundation
import SwiftUI

class ReminderViewModel: ObservableObject {
  
  static private var calendar = {
    var calendar = Calendar.current
//    calendar.timeZone = TimeZone(identifier: "UTC")!
    return calendar
  }()
  
  private var database: DataBase = .shared
  private var soundPlayer: SoundPlayer = .shared
  private var notificationManager: NotificationManager = .shared
  lazy var categories: [ReminderCategory] = categoryList()
  
  @Published private var startTime = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
  @Published private var endTime = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
  @Published private var remindersCount = 1
  
  @AppStorage("selectedDays") private var selectedDays: [Bool] = [true, true, true, true, true, true, true]
  @AppStorage("remaindersCount") private var selectedReminderCount = 30
  
  @AppStorage("endTime") private var selectedEndTime: Date = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
  
  @AppStorage("startTime") private var selectedStartTime: Date = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
  @AppStorage("reminderCategory") private var selectedCategory = "General"
  @AppStorage("reminderSound") private var selectedSound = "default"
  
  
  init() {
    remindersCount = selectedReminderCount
    endTime = selectedEndTime
    startTime = selectedStartTime
  }
  
  private var weekDays: [String] = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ]
  
  var availableSounds: [ReminderSound] = [
    ReminderSound(fileName:   "default", name:  "Default"  ) ,
    ReminderSound(fileName:        "bell", name:  "Bell"    ),
    ReminderSound(fileName:   "doorBell", name:  "Door Bell"),
    ReminderSound(fileName:         "dry", name:  "Dry"     ),
    ReminderSound(fileName:      "guitar", name:  "Guitar"  ),
    ReminderSound(fileName:       "light", name:  "Light"   ),
    ReminderSound(fileName:   "longPop", name:  "Long Pop" )
  ]
  
  let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
//    formatter.calendar = Calendar.current
    return formatter
  }()
  
  func getRemaindersCount() -> Int {
    return selectedReminderCount
  }
  
  func incrementRemaindersCount() {
    remindersCount = remindersCount == 30 ? remindersCount  : remindersCount + 1
    selectedReminderCount = remindersCount
  }
  
  func decrementRemaindersCount() {
    remindersCount = remindersCount == 1 ? remindersCount  : remindersCount - 1
    selectedReminderCount = remindersCount
  }
  
  func incrementStartTime() {
    startTime = ReminderViewModel.calendar.date(byAdding: .minute, value: 30, to: startTime)!
    selectedStartTime = startTime
  }
  
  func incrementEndTime() {
    endTime = ReminderViewModel.calendar.date(byAdding: .minute, value: 30, to: endTime)!
    selectedEndTime = endTime
  }
  
  func decrementStartTime() {
    startTime = ReminderViewModel.calendar.date(byAdding: .minute, value: -30, to: startTime)!
    selectedStartTime = startTime
  }
  
  func decrementEndTime() {
    endTime = ReminderViewModel.calendar.date(byAdding: .minute, value: -30, to: endTime)!
    selectedEndTime = endTime
  }
  
  func getStartTime() -> String {
    return timeFormatter.string(from: selectedStartTime)
  }
  
  func getEndTime() -> String {
    return timeFormatter.string(from: selectedEndTime)
  }
  
  func setSelectedCategory(category: String) {
    selectedCategory = category
  }
  
  func getSelectedCategory() -> String {
    selectedCategory
  }
  
  func setSelectedSound(name: String) {
    selectedSound = name
  }
  
  func getSelectedSound() -> String {
    selectedSound
  }
  
  func getSelectedSoundName() -> String {
    var soundName = ""
    for sound in availableSounds {
      if sound.fileName == selectedSound {
        soundName = sound.name
      }
    }
    return soundName
  }
  
  func getRemaindersDays() -> [RemainderDayModel] {
    var remainderDays: [RemainderDayModel] = []
    for index in 0..<self.weekDays.count {
      remainderDays.append(RemainderDayModel(isSelected: selectedDays[index] , name:  self.weekDays[index],number: index))
    }
    return remainderDays
  }
  
  func setDaySelection(day: Int) {
    selectedDays[day].toggle()
  }
  
}

extension ReminderViewModel {
  func categoryList() -> [ReminderCategory] {
    let categories = database.affirmations()?.categories
    let generalCategory = database.affirmations()?.generalCategory
    guard let categories , let generalCategory else {
      return []
    }
    var reminderCategories =  categories.map { categoryElement in
      let section = categoryElement.title
      let categories = categoryElement.subCategories.map({$0.name})
      return ReminderCategory(section: section, categories: categories)
    }
    reminderCategories.insert(ReminderCategory(section: generalCategory.name, categories: [generalCategory.name]), at: 0)
    return reminderCategories
  }
}

extension ReminderViewModel {
  func playSound(name: String) {
    soundPlayer.playSound(fileName: name)
  }
}

extension ReminderViewModel {
  func getNotificationText(for category: String) -> [String] {
    let affirmations = database.affirmations()
    guard let affirmations else {
      return []
    }
    if category == affirmations.generalCategory.name {
      return affirmations.generalCategory.quotes
    }
    let result = affirmations.categories.map({ $0.subCategories.filter({$0.name == category }) }).flatMap({ $0 }).map({ $0.quotes }).flatMap({ $0 })
    return result
  }
  
  func reminderTexts(count: Int) -> [String] {
    let notificationTexts = getNotificationText(for: selectedCategory)
    var result: [String] = []
    (0..<count).forEach { _ in
      result.append(notificationTexts.randomElement()!)
    }
    return result
  }
  
  //TODO: -
  /// don't show the category that has zero quotes.👨‍💻
  func scheduleNotifications(completion: @escaping (Bool) -> Void) {
    notificationManager.removeAllScheduledNotifications()
    let notificationTexts = reminderTexts(count: (selectedReminderCount * (selectedDays.count * 2)))
    if selectedReminderCount == 1 {
      notificationManager.scheduleNotifications(startTime: selectedStartTime, endTime: selectedStartTime, weekDays: selectedDays, reminderCount: selectedReminderCount, notificationTexts: notificationTexts, soundName: selectedSound) { isCompleted in
        completion(isCompleted)
      }
    }else {
      notificationManager.scheduleNotifications(startTime: selectedStartTime, endTime: selectedEndTime, weekDays: selectedDays, reminderCount: selectedReminderCount, notificationTexts: notificationTexts, soundName: selectedSound) { isCompleted in
        completion(isCompleted)
      }
    }
  }
}
