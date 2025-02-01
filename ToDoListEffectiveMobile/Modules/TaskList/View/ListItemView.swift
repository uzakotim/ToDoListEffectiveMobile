//
//  ListItemView.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 29/01/25.
//
import SwiftUI

struct ListItemView: View {
    var task: Task
    let isLast : Bool
    var body: some View {
        Section{
            VStack(alignment: .leading, spacing: 0){
                VStack(alignment: .leading, spacing: 0) {
                    HStack{
                        Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                            .foregroundColor(.yellow)
                            .imageScale(.large)
                        Text(task.title)
                            .font(.headline)
                            .strikethrough(task.isCompleted, color: Color(UIColor.placeholderText))
                            .foregroundColor(task.isCompleted ? Color(UIColor.placeholderText) : .primary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    HStack{
                        Image(systemName: "checkmark.circle")
                            .imageScale(.large)
                            .opacity(0)
                            .frame(height: 0)
                        VStack(alignment: .leading) {
                            if !task.descriptionData.isEmpty
                            {
                                Text(task.descriptionData)
                                    .font(.subheadline)
                                    .foregroundColor(task.isCompleted ? Color(UIColor.placeholderText) : .primary)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Text(task.dateCreatedFormatted)
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.placeholderText))
                            
                            if task.descriptionData.isEmpty {
                                Spacer()
                            }
                        }
                    }
                }
                if !task.descriptionData.isEmpty {
                    Spacer()
                }
                if !isLast {
                    Divider()
                        .frame(height: 1)
                        .background(Color(UIColor.placeholderText))
                        .padding(0)
                }
            }
        }
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTask = Task(
            id: 1,
            title: "Workout",
            description: "",
            dateCreated: Date(),
            isCompleted: false
        )


        return ListItemView(task: sampleTask, isLast: false)
    }
}
