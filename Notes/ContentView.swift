//
//  ContentView.swift
//  Notes
//
//  Created by MAHESHWARAN on 07/06/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \.title, order: .forward, animation: .spring) private var items: [Item]
  
  var body: some View {
    NavigationStack {
      
      List {
        ForEach(items) { item in
         showDetailView(item)
        }
        .onDelete(perform: deleteItems)
      }
      
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
        ToolbarItem() {
          NavigationLink {
            createNewItem()
          } label: {
            Image(systemName: "plus")
          }
        }
      }
      .navigationTitle("Notes")
    }
  }
}

// MARK: - Custom Methods

extension ContentView {
  
  private func showDetailView(_ item: Item) -> some View {
    NavigationLink {
      createNewItem(item)
    } label: {
      notesListView(using: item)
    }
  }
  
  private func notesListView(using item: Item) -> some View {
    VStack(alignment: .leading) {
      HStack {
        Text(item.title)
        Spacer()
        Image(systemName: "flag.circle.fill")
          .foregroundStyle(NotesDetailViewModel.PriorityType.allCases[item.priority].color)
          .font(.title3)
      }
      Text(item.desc ?? "")
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .lineLimit(2)
    }
  }
  
  private func createNewItem(_ item: Item? = nil) -> some View {
    var noteView = NotesDetailView(item: item)
    noteView.selectedItem = { item in
      if let item {
        if let existingItem = fetchItems(item.privateID) {
          existingItem.privateID = item.privateID
          existingItem.desc = item.desc
          existingItem.title = item.title
          existingItem.startDate = item.startDate
          existingItem.endDate = item.endDate
          existingItem.priority = item.priority
          existingItem.isCompleted = item.isCompleted
        } else {
          modelContext.insert(item)
        }
      }
    }
    return noteView
  }
  
  private func fetchItems(_ privateID: String) -> Item? {
    
    let predicate = #Predicate<Item> { $0.privateID == privateID }
    let fetchDescriptor = FetchDescriptor(predicate: predicate)
    
    let item = try? modelContext.fetch(fetchDescriptor)
    return item?.first
  }
  
  private func deleteItems(offsets: IndexSet) {
    offsets.forEach{
      modelContext.delete(items[$0])
    }
  }
}

// MARK: - Preview

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
}
