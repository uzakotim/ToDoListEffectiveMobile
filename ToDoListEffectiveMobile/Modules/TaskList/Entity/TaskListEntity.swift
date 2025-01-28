import Foundation

struct Task: Identifiable, Codable {
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
}