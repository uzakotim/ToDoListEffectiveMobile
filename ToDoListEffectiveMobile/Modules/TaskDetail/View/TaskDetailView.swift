//
//  TaskDetailView.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 29/01/25.
//

import SwiftUI
struct TaskDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var presenter: TaskDetailPresenter
    var task: Task
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Текстовое поле для ввода названия задачи
            TextField("Введите название", text:$presenter.task.title,  axis: .vertical)
                .font(.title)
                .fontWeight(.bold)
                .contentShape(Rectangle())
                .accessibilityIdentifier("text.field")
            // Отображение даты создания задачи
            Text("\(task.dateCreatedFormatted)")
                .font(.caption)
                .foregroundColor(.secondary)
            // Текстовое поле для ввода описания задачи
            TextField("Введите описание", text:$presenter.task.descriptionData, axis: .vertical)
                .font(.body)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            // Проверяем, создается ли новая задача
            if (task.id == -1) && (presenter.task.title != ""){
                presenter.addNewTask(title: presenter.task.title, descriptionData: presenter.task.descriptionData)
            }
            else{
                // Обновление существующей задачи
                presenter.updateTask(task: task, title: presenter.task.title, descriptionData: presenter.task.descriptionData)
            }
            dismiss()
           }) {
               HStack( spacing: 0.0){
                   Image(systemName: "chevron.left")
                   Text("Назад")
               }
               
               .foregroundColor(.yellow)
           })
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Пример задачи для предварительного просмотра
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
