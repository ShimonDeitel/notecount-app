import SwiftUI

/// Bespoke palette for Notecount: Track how many pages or chapters of notes you've reviewed per class.
enum Theme {
    static let accent = Color(red: 0.541, green: 0.388, blue: 0.824)
    static let background = Color(red: 0.059, green: 0.043, blue: 0.102)
    static let card = Color(red: 0.106, green: 0.078, blue: 0.188)
    static let ink = Color(white: 0.95)
    static let mutedInk = Color(white: 0.65)

    static func titleFont(_ size: CGFloat = 28) -> Font {
        .system(size: size, weight: .bold, design: .serif)
    }
    static func bodyFont(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .serif)
    }
    static func labelFont(_ size: CGFloat = 13) -> Font {
        .system(size: size, weight: .semibold, design: .serif)
    }

    static let cornerRadius: CGFloat = 18
}
