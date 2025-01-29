//
//  TaskDetailView.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 29/01/25.
//

import SwiftUI

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var presenter: TaskDetailPresenter
    var task: Task
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("Введите название", text:$presenter.task.title)
                .font(.title)
                .fontWeight(.bold)
            Text("\(task.dateCreatedFormatted)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            TextField("Введите описание", text:$presenter.task.description, axis: .vertical)
                .font(.body)
                .foregroundColor(.primary)
            

            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
                   dismiss() // Dismiss the view when back button is pressed
               }) {
                   HStack{
                       Image(systemName: "chevron.left")
                       Text(" Назад")
                   }
                   .foregroundColor(.yellow)
               })
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
