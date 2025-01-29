//
//  TaskDetailView.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 29/01/25.
//

import SwiftUI

import SwiftUI

struct TaskDetailView: View {

    @ObservedObject var presenter: TaskDetailPresenter
    var task: Task
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(task.title)
                .font(.title)
                .fontWeight(.bold)

            Text(task.description)
                .font(.body)
                .foregroundColor(.gray)

            Text("Дата: \(task.dateCreatedFormatted)")
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Задача") // ✅ Adds title
        .navigationBarTitleDisplayMode(.inline) // ✅ Keeps it compact
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTask = Task(
            id: 1,
            title: "Workout",
            description: "Go to the gym or do a home workout. Don't forget to stretch!",
            dateCreated: Date(),
            isCompleted: false
        )

        let interactor = TaskDetailInteractor(task: sampleTask)
        let router = TaskDetailRouter()
        let presenter = TaskDetailPresenter(interactor: interactor, router: router)

        return TaskDetailView(presenter: presenter, task: sampleTask)
    }
}
