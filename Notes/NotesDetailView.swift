//
//  NotesDetailView.swift
//  Notes
//
//  Created by MAHESHWARAN on 10/06/23.
//

import SwiftUI
import SwiftData

struct NotesDetailView: View {
  
  @Environment(\.dismiss) var dismiss
  @State var viewModel: NotesDetailViewModel
  
  var selectedItem: ((Item?) -> Void)?
  
  init(item: Item? = nil) {
    _viewModel = State(initialValue: NotesDetailViewModel(item: item))
  }
  
  var body: some View {
    
    Form {
      Section("Title") {
        TextField("Enter your Title", text: $viewModel.title)
          .keyboardType(.default)
      }
      Section("Detail") {
        TextEditor(text: $viewModel.desc)
          .textEditorStyle(.automatic)
      }.frame(minWidth: 20)
      
      Section("Event Date") {
        DatePicker("Start Date", selection: $viewModel.startDate, in: ...Date.now)
          .datePickerStyle(.automatic)
      }
      Section {
        DatePicker("End Date", selection: $viewModel.endDate, in: Date.now...)
          .datePickerStyle(.automatic)
      }
      
      Section("Priority") {
        Picker("Priority", selection: $viewModel.priority) {
          ForEach(viewModel.priorityType, id: \.index) { item in
            HStack {
              Text(item.title)
              
              Color(item.color)
            }
          }
        }
      }
      
      Section("Completed") {
        Toggle("Completed", isOn: $viewModel.isCompleted)
      }
    }
    .toolbar {
      ToolbarItem(placement: .navigation) {
        Button(action: {
          saveButtonClicked()
        }, label: {
          Text("Save")
        })
      }
    }
    .navigationBarTitleDisplayMode(.inline)
  }
  
  private func saveButtonClicked() {
    selectedItem?(viewModel.fetchSelectedItem())
    dismiss()
  }
}

#Preview {
  NotesDetailView()
}
