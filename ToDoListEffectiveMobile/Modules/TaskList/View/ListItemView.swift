//
//  ListItemView.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 29/01/25.
//
import SwiftUI

struct ListItemView: View {
    let task: Task
    var body: some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading) {
                HStack{
                    Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                        .foregroundColor(.yellow)
                        .imageScale(.large)
                    Text(task.title)
                        .font(.headline)
                        .strikethrough(task.isCompleted, color: Color(UIColor.placeholderText))
                        .foregroundColor(task.isCompleted ? Color(UIColor.placeholderText) : .primary)
                }
                HStack{
                    Image(systemName: "checkmark.circle")
                        .imageScale(.large)
                        .opacity(0)
                    VStack(alignment: .leading) {
                        Text(task.dateCreatedFormatted)
                            .font(.footnote)
                            .foregroundColor(Color(UIColor.placeholderText))
                        Text(task.description)
                            .font(.subheadline)
                            .foregroundColor(task.isCompleted ? Color(UIColor.placeholderText) : .primary)
                    }
                }
                Spacer()
            }
            .padding(0)
            Divider()
                .frame(height: 1)
                .background(Color(UIColor.placeholderText))
                .padding(0)
        }
    }
}
