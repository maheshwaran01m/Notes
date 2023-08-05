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
  @Query(sort: \Item.title, order: .forward) private var items: [Item]
  
  @State private var searchText = ""
  
  private var filteredRecords: [Item] {
    guard !searchText.isEmpty else { return items }
    let searchKeyPaths: [KeyPath<Item, String>] = [\.title]
    return items.filter { item in
      searchKeyPaths.compactMap { item[keyPath: $0] }.first(where: { $0.lowercased().localizedCaseInsensitiveContains(searchText) }) != nil
    }
  }
  
  var body: some View {
    NavigationStack {
      mainView
        .searchable(text: $searchText)
        .navigationTitle("Notes")
    }
  }
  
  @ViewBuilder
  private var mainView: some View {
    if !filteredRecords.isEmpty {
      listView
    } else {
      placeholderView
    }
  }
  
  private var listView: some View {
    List {
      ForEach(filteredRecords) { item in
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
  }
}

// MARK: - Placeholder View

extension ContentView {
  
  private var placeholderView: some View {
    ZStack {
      Color.secondary.opacity(0.1)
      VStack(spacing: 16) {
        iconView
        titleView
      }
    }
    .ignoresSafeArea(.container, edges: .bottom)
  }
  
  private var titleView: some View {
    Text("No Items")
      .font(.title3)
      .frame(minHeight: 22)
      .multilineTextAlignment(.center)
      .foregroundStyle(.secondary)
  }
  
  private var iconView: some View {
    Image(systemName: "square.on.square.badge.person.crop")
      .font(.title3)
      .foregroundStyle(Color.secondary)
      .frame(minWidth: 20, minHeight: 20)
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
