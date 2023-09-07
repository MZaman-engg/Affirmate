
import Foundation
import RealmSwift

class RealmDataManager {
  
  static let shared = RealmDataManager()
  
  private init() {
  }
  
  var realm = try! Realm()
  
  func objects<T: Object>(_ object: T.Type) -> [T] {
    return Array(realm.objects(T.self))
  }
  
  func create<T:Object>(_ object:T){
    do{
      try realm.write {
        realm.add(object)
      }
    }catch {
      Logger.shared.log(description: error.localizedDescription)
    }
  }
  
  func update<T:Object>(_ object:T, with dictionary:[String:Any]){
    do {
      try realm.write {
        for (key, value) in dictionary {
          object.setValue(value, forKey: key)
        }
      }
    } catch {
      Logger.shared.log(description: error.localizedDescription)
    }
  }
  
  func delete<T:Object>(_ object:T) {
    do {
      try realm.write {
        realm.delete(object)
      }
    }catch {
      Logger.shared.log(description: error.localizedDescription)
    }
  }
  
  func deleteUsingPrimaryKey<T:Object>(_ object: T.Type, primaryKey: UUID) {
    do {
      try realm.write {
        let object = realm.object(ofType: T.self, forPrimaryKey: primaryKey)
        if let object {
          realm.delete(object)
        }
      }
    } catch {
      Logger.shared.log(description: error.localizedDescription)
    }
  }
  
  func objectForAttribute<T:Object> (_ object: T.Type, attribute: String ,value: String) -> [T] {
    Array(realm.objects(T.self).filter("\(attribute) = %@", "\(value)"))
  }
  
}

