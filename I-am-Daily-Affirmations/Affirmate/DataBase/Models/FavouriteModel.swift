

import Foundation
import RealmSwift

class FavouriteModel: Object , Identifiable {
  @Persisted(primaryKey: true) var _id: UUID
  @Persisted var quote: String = ""
  @Persisted var categoryName: String = ""
}
