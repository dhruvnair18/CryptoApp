import SwiftUI
import Charts

struct Cryptocurrency: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
    let amount: Double
    let value: Double
    let change: Double
    let color: Color
}

struct HistoricalData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

struct Portfolio: View {
    @State private var cryptocurrencies: [Cryptocurrency] = [
        Cryptocurrency(name: "Bitcoin", symbol: "BTC", amount: 0.5, value: 15000, change: 2.5, color: .orange),
        Cryptocurrency(name: "Ethereum", symbol: "ETH", amount: 4, value: 8000, change: -1.2, color: .blue),
        Cryptocurrency(name: "Cardano", symbol: "ADA", amount: 1000, value: 500, change: 5.7, color: .indigo)
    ]
    
    @State private var historicalData: [HistoricalData] = [
        HistoricalData(date: Date.from(year: 2023, month: 9, day: 1), value: 20000),
        HistoricalData(date: Date.from(year: 2023, month: 10, day: 1), value: 22000),
        HistoricalData(date: Date.from(year: 2023, month: 11, day: 1), value: 21000),
        HistoricalData(date: Date.from(year: 2023, month: 12, day: 1), value: 23500),
        HistoricalData(date: Date.from(year: 2024, month: 1, day: 1), value: 24000),
        HistoricalData(date: Date.from(year: 2024, month: 2, day: 1), value: 23000),
        HistoricalData(date: Date.from(year: 2024, month: 3, day: 1), value: 25000)
    ]
    
    var totalValue: Double {
        cryptocurrencies.reduce(0) { $0 + $1.value }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 25) {
                        PortfolioSummaryView(totalValue: totalValue)
                        PortfolioChartView(historicalData: historicalData)
                        PortfolioDistributionView(cryptocurrencies: cryptocurrencies)
                        CryptocurrencyListView(cryptocurrencies: cryptocurrencies)
                    }
                    .padding()
                }
            }
            .navigationTitle("Portfolio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }
}

struct PortfolioSummaryView: View {
    let totalValue: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Total Balance")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(totalValue.formatted(.currency(code: "USD")))
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
            Text("+ $1,234.56 (4.32%)")
                .font(.subheadline)
                .foregroundColor(.green)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(20)
    }
}

struct PortfolioChartView: View {
    let historicalData: [HistoricalData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Portfolio Performance")
                .font(.headline)
                .foregroundColor(.white)
            
            Chart(historicalData) { data in
                LineMark(
                    x: .value("Date", data.date),
                    y: .value("Value", data.value)
                )
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
            .frame(height: 200)
            .chartYScale(domain: .automatic(includesZero: false))
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 4))
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(20)
    }
}

struct PortfolioDistributionView: View {
    let cryptocurrencies: [Cryptocurrency]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Portfolio Distribution")
                .font(.headline)
                .foregroundColor(.white)
            Chart(cryptocurrencies) { crypto in
                SectorMark(
                    angle: .value("Value", crypto.value),
                    innerRadius: .ratio(0.6),
                    angularInset: 1.5
                )
                .foregroundStyle(crypto.color)
            }
            .frame(height: 200)
            HStack {
                ForEach(cryptocurrencies) { crypto in
                    HStack {
                        Circle()
                            .fill(crypto.color)
                            .frame(width: 10, height: 10)
                        Text(crypto.symbol)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(20)
    }
}

struct CryptocurrencyListView: View {
    let cryptocurrencies: [Cryptocurrency]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Assets")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(cryptocurrencies) { crypto in
                CryptocurrencyRowView(crypto: crypto)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(20)
    }
}

struct CryptocurrencyRowView: View {
    let crypto: Cryptocurrency
    
    var body: some View {
        HStack {
            Circle()
                .fill(crypto.color)
                .frame(width: 40, height: 40)
                .overlay(
                    Text(crypto.symbol.prefix(1))
                        .font(.headline)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(crypto.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(crypto.symbol)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(crypto.value.formatted(.currency(code: "USD")))
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(crypto.amount, specifier: "%.4f") \(crypto.symbol)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            VStack {
                Text(crypto.change >= 0 ? "+\(crypto.change, specifier: "%.1f")%" : "\(crypto.change, specifier: "%.1f")%")
                    .font(.subheadline)
                    .foregroundColor(crypto.change >= 0 ? .green : .red)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(crypto.change >= 0 ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .cornerRadius(8)
            }
        }
    }
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
    }
}

struct Portfolio_Previews: PreviewProvider {
    static var previews: some View {
    Portfolio()
    }
}
