

import Foundation

struct CryptoPrice: Identifiable {
    let id = UUID()
    let date: Date
    let close: Double
}
