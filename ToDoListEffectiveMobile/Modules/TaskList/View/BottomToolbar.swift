//
//  BottomToolbar.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 31/01/25.
//
import SwiftUI

struct BottomToolbar: View {
    @ObservedObject var presenter: TaskListPresenter
    @Binding var isNavigatingToTaskDetail: Bool
    @Binding var selectedTask: Task
    
    let emptyTask: Task = .init(id: -1, title: "", description: "", isCompleted: false)
    var body: some View {
        ZStack{
            HStack{
                Spacer()
                Text("\(presenter.filteredTasks.count) \(pluralizeTask(count: presenter.filteredTasks.count))")
                    .font(.caption).fontWeight(.light).foregroundColor(Color(UIColor.placeholderText))
                Spacer()
            }
           
            HStack{
                Spacer()
                Button(action: {
                    isNavigatingToTaskDetail = true
                    selectedTask = emptyTask
                }) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.yellow)
                }
            }
        }
    }
    private func pluralizeTask(count: Int) -> String {
            // Логика склонения слова задача
            let mod10 = count % 10
            let mod100 = count % 100

            if mod10 == 1 && mod100 != 11 {
                return "задача"
            } else if mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20) {
                return "задачи"
            } else {
                return "задач"
            }
        }
}
