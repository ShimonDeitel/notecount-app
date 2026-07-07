import Foundation

struct NotecountItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var category: String
    var value: Double
    var date: Date = Date()
    var notes: String = ""
    var isResolved: Bool = false
}

enum NotecountCategory: String, CaseIterable, Codable {
        case textbook = "Textbook"
    case lecturenotes = "Lecture Notes"
    case slides = "Slides"
    case articles = "Articles"
}
