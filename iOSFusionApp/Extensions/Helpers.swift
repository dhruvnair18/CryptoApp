

import Foundation

extension Double {
    func formatToAbbreviated() -> String {
        let number = self
        let thousand = number / 1_000
        let million = number / 1_000_000
        let billion = number / 1_000_000_000

        if billion >= 1 {
            return String(format: "%.1fB", billion) // Billion format
        } else if million >= 1 {
            return String(format: "%.1fM", million) // Million format
        } else if thousand >= 1 {
            return String(format: "%.1fK", thousand) // Thousand format
        } else {
            return String(format: "%.0f", number) // No abbreviation needed
        }
    }
}

