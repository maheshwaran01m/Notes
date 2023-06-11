//
//  NotesApp.swift
//  Notes
//
//  Created by MAHESHWARAN on 07/06/23.
//

import SwiftUI
import SwiftData

@main
struct NotesApp: App {
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .onAppear {
          print("Path: \(URL.libraryDirectory)")
        }
    }
    .modelContainer(for: Item.self, isUndoEnabled: true)
  }
}
