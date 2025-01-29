import Foundation

// Root object containing the "todos" array
struct TodosResponse: Codable {
    let todos: [Task]
    let total: Int
    let skip: Int
    let limit: Int
}
struct Task: Identifiable, Codable{
    let id: Int
    let title: String
    let description: String
    let dateCreated: Date
    var isCompleted: Bool

    var dateCreatedFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dateCreated)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .todo) // The key is "todo" in the dummy JSON
        description = "" // Default to an empty string
        dateCreated = Date() // Use today's date if no date is provided
        isCompleted = try container.decodeIfPresent(Bool.self, forKey: .completed) ?? false
    }
    // Add manual initializer to view the Task in preview
    init(id: Int, title: String, description: String = "", dateCreated: Date = Date(), isCompleted: Bool = false) {
            self.id = id
            self.title = title
            self.description = description
            self.dateCreated = dateCreated
            self.isCompleted = isCompleted
    }

    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .todo) // The key is "todo" in the dummy JSON
        try container.encode(description, forKey: .description)
        try container.encode(isCompleted, forKey: .completed)
    }

    enum CodingKeys: String, CodingKey {
        case id, todo = "todo", description, completed
    }
}
