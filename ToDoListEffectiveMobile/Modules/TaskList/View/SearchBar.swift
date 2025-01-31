//
//  SearchBar.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 31/01/25.
//
import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @ObservedObject var presenter: TaskListPresenter
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "magnifyingglass") // Search icon
                .foregroundColor(Color(UIColor.placeholderText))

            TextField("Поиск", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle()) // Plain style for custom background
                .cornerRadius(6)
                .padding(.vertical, 8)  // Adjust vertical padding
                .padding(.horizontal, 6)  // Adjust horizontal padding
                .frame(maxWidth: .infinity)  // Set a fixed width for the TextField
                .onChange(of: searchText) { oldValue, newValue in
                    presenter.searchTasks(query: newValue)
                }
                .disableAutocorrection(true)  // Disable autocorrect for dictation

            Button(action: {
//                if speechManager.isDictating {
//                    speechManager.stopDictation()
//                } else {
//                    speechManager.startDictation()
//                }
            }) {
                Image(systemName: "mic.fill") // Microphone icon
                    .foregroundColor(Color(UIColor.placeholderText))
            }
            Spacer()
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
   
}
