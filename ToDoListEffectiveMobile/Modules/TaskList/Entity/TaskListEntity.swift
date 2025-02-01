//
//  TaskListEntity.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 31/01/25.
//

import Foundation

// Декларация основных структур данных, используемых в приложении
struct TodosResponse: Codable {
    // Для API запроса
    let todos: [Task]
    let total: Int
    let skip: Int
    let limit: Int
}
struct Task: Identifiable, Codable, Equatable{
    // Главная структура приложения
    let id: Int
    var title: String
    var descriptionData: String
    var dateCreated: Date
    var isCompleted: Bool

    var dateCreatedFormatted: String {
        // Для вывода в UI
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: dateCreated)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .todo)
        descriptionData = "" // Если нет описания
        dateCreated = Date() // Если нет даты
        isCompleted = try container.decodeIfPresent(Bool.self, forKey: .completed) ?? false
    }
    init(id: Int, title: String, description: String = "", dateCreated: Date = Date(), isCompleted: Bool = false) {
            self.id = id
            self.title = title
            self.descriptionData = description
            self.dateCreated = dateCreated
            self.isCompleted = isCompleted
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .todo)
        try container.encode(descriptionData, forKey: .description)
        try container.encode(isCompleted, forKey: .completed)
    }

    enum CodingKeys: String, CodingKey {
        case id, todo = "todo", description, completed
    }
}
