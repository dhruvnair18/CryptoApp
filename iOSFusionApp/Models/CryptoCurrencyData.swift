
import Foundation

struct CryptoCurrencyData: Identifiable {
    let id = UUID()
    let symbolName: String
    let fullName: String
    let imageUrl: String
    let price: Double
    let vol24Hour: Double
    let mktCap: Double
    let low: Double
    let high: Double
    let changepct: Double
}
