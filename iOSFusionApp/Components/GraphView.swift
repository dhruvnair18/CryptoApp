

import SwiftUI
import Charts

struct GraphView: View {
    var cryptoSymbol: String
    @State private var cryptoPrices: [CryptoPrice] = []
    @State private var visibleRange: ClosedRange<Date>? = nil
    var detailedView: Bool
    
    var body: some View {
        HStack(spacing:0) {
            if cryptoPrices.isEmpty {
                Text("Loading...")
            } else {
                // Chart with dynamic date range and no axis labels
                // Display percentage growth between the first and last values                
                Chart(cryptoPrices) { price in
                    LineMark(
                        x: .value("Date", price.date),
                        y: .value("Close Price", price.close)
                    )
                    .foregroundStyle(.gray)
                }
                .chartXScale(domain: visibleRange!)
                .chartYAxis(detailedView ? .hidden : .visible)
                .chartXAxis(detailedView ? .hidden : .visible)
                .chartYScale(domain: (minValue() - 10)...(maxValue() + 10))  // Manually adjust Y-axis
                .chartXAxis {
                    AxisMarks() {
                        AxisGridLine()
                            .foregroundStyle(.black)  // Change the x-axis grid line color
                        AxisTick()
                            .foregroundStyle(.black)  // Change the x-axis tick marks color
                        AxisValueLabel()
                            .foregroundStyle(.black)  // Change the x-axis label text color
                    }
                }
                .chartYAxis {
                    AxisMarks() {
                        AxisGridLine()
                            .foregroundStyle(.black)  // Change the x-axis grid line color
                        AxisTick()
                            .foregroundStyle(.black)  // Change the x-axis tick marks color
                        AxisValueLabel()
                            .foregroundStyle(.black)  // Change the x-axis label text color
                    }
                }
                .padding()
            }
        }
        .onAppear {
            fetchCryptoData()
        }
    }

    // Fetch data from the API
    func fetchCryptoData() {
        FetchGraphDetails().fetchData(cryptoSymbol: cryptoSymbol) { prices in
            DispatchQueue.main.async {
                self.cryptoPrices = prices
                // Set the default visible range to be the entire dataset
                if let firstDate = prices.first?.date, let lastDate = prices.last?.date {
                    self.visibleRange = firstDate...lastDate
                }
            }
        }
    }

    // Calculate min and max values of the data
    func minValue() -> Double {
        return cryptoPrices.map { $0.close }.min() ?? 0
    }

    func maxValue() -> Double {
        return cryptoPrices.map { $0.close }.max() ?? 100
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(cryptoSymbol: "BTC",detailedView: false)
    }
}

