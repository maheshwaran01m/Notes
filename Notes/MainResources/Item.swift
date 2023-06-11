//
//  Item.swift
//  Notes
//
//  Created by MAHESHWARAN on 07/06/23.
//

import Foundation
import SwiftData

@Model
final class Item {
  
  @Attribute(.unique) var privateID: String
  var title: String
  var desc: String?
  var priority: Int
  var startDate: Date
  var endDate: Date?
  var isCompleted: Bool
  
  init(privateID: String = UUID().uuidString, title: String,
       desc: String? = nil, priority: Int = 0, startDate: Date,
       endDate: Date? = nil, isCompleted: Bool = false) {
    
    self.privateID = privateID
    self.title = title
    self.desc = desc
    self.priority = priority
    self.startDate = startDate
    self.endDate = endDate
    self.isCompleted = isCompleted
  }
}
