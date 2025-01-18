

import Foundation
import SwiftData

@Model
class OwnedCryptos{
    var cryptoSymbol: String
    var quantity: Double
    var priceAtWhichBought: Double
    var image: String
    var volume: Double
    var marketCap: Double
    var low: Double
    var high: Double
    var change: Double
    var totalInvestment: Double
    
    init(cryptoSymbol: String, quantity: Double, priceAtWhichBought: Double, image: String, volume: Double, marketCap: Double, low: Double, high: Double, change: Double, totalInvestment: Double) {
        self.cryptoSymbol = cryptoSymbol
        self.quantity = quantity
        self.priceAtWhichBought = priceAtWhichBought
        self.image = image
        self.volume = volume
        self.marketCap = marketCap
        self.low = low
        self.high = high
        self.change = change
        self.totalInvestment = totalInvestment
    }
}

