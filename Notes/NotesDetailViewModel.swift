//
//  NotesDetailViewModel.swift
//  Notes
//
//  Created by MAHESHWARAN on 10/06/23.
//

import SwiftUI
import Observation

@Observable class NotesDetailViewModel {
  
  enum PriorityType: Int, CaseIterable {
    case low, medium, high, veryHigh
    
    var index: Int {
      switch self {
      case .low: return 0
      case .medium: return 1
      case .high: return 2
      case .veryHigh: return 3
      }
    }
    
    var title: String {
      switch self {
      case .low: return "Low"
      case .medium: return "Medium"
      case .high: return "High"
      case .veryHigh: return "Very High"
      }
    }
    
    var color: Color {
      switch self {
      case .low: return .gray
      case .medium: return .blue
      case .high: return .yellow
      case .veryHigh: return .red
      }
    }
  }
  
  var title = String()
  var desc = String()
  var startDate = Date()
  var priority: Int = 0
  var endDate = Date()
  var isCompleted: Bool = false
  
  let priorityType = PriorityType.allCases
  
  private var item: Item? = nil
  
  init(item: Item? = nil) {
    guard let item else { return }
    self.item = item
    self.title = item.title
    self.desc = item.desc ?? ""
    self.startDate = item.startDate
    self.endDate = item.endDate ?? item.startDate
    self.priority = item.priority
    self.isCompleted = item.isCompleted
  }
  
  func fetchSelectedItem() -> Item {
    let selectedItem = Item(privateID: item?.privateID ?? UUID().uuidString,
                            title: title, desc: desc, priority: priority,
                            startDate: startDate, endDate: endDate, isCompleted: isCompleted)
    return selectedItem
  }
}
