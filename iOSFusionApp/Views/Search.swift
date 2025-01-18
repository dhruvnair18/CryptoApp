//
//  Search.swift
//  iOSFusionApp
//
//  Created by Dhruv Nair
//

import SwiftUI
import Combine

struct Search: View {
    
    @State private var searchText: String = ""
    @State private var filterText: String = ""
    
    @State var cryptoSymbol: String = ""
    @State var cryptoName: String = ""
    @State var cryptoPrice: Double = 0.0
    @State var image: String = ""
    @State var volume: Double = 0.0
    @State var marketCap: Double = 0.0
    @State var low: Double = 0.0
    @State var high: Double = 0.0
    @State var change: Double = 0.0
    
    let searchPublisher = PassthroughSubject<String,Never>()
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical) {
                LazyVStack(spacing:12){
                    // Display the search results here
                    if !cryptoSymbol.isEmpty {
                        CryptoCell(cryptoSymbol: cryptoName, cryptoPrice: cryptoPrice, image: image, volume: volume, marketCap: marketCap, low: low, high: high, change: change)
                    }
                }
                .padding(15)
            }
            .overlay(content:{
                ContentUnavailableView("Search Cryptocurrencies", systemImage: "magnifyingglass")
                    .opacity(filterText.isEmpty ? 1 : 0)
            })
            .onChange(of: searchText, { oldValue, newValue in
                if newValue.isEmpty {
                    filterText = ""
                    clearSearchResults()
                } else {
                    searchPublisher.send(newValue)
                }
            })
            .onReceive(searchPublisher.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main), perform: { text in
                filterText = text
                fetchCryptoData(symbol: text)
            })
            .searchable(text: $searchText)
            .navigationTitle("Search")
        }
    }
    
    // Clear search results when text is cleared
    private func clearSearchResults() {
        cryptoSymbol = ""
        cryptoName = ""
        cryptoPrice = 0.0
        volume = 0.0
        marketCap = 0.0
        image = ""
    }
    
    // Fetch crypto data from API
    func fetchCryptoData(symbol: String) {
        let urlString = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=\(symbol)&tsyms=USD"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                // Parse JSON
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let rawData = json["RAW"] as? [String: Any],
                       let cryptoData = rawData[symbol] as? [String: Any],
                       let usdData = cryptoData["USD"] as? [String: Any] {
                        
                        DispatchQueue.main.async {
                            cryptoSymbol = symbol
                            cryptoName = usdData["FROMSYMBOL"] as? String ?? ""
                            cryptoPrice = usdData["PRICE"] as? Double ?? 0.0
                            volume = usdData["VOLUME24HOUR"] as? Double ?? 0.0
                            marketCap = usdData["MKTCAP"] as? Double ?? 0.0
                            image = usdData["IMAGEURL"] as? String ?? ""
                            low = usdData["LOW24HOUR"] as? Double ?? 0.0
                            high = usdData["HIGH24HOUR"] as? Double ?? 0.0
                            change = usdData["CHANGEPCTDAY"] as? Double ?? 0.0
                        }
                    }
                }
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}

#Preview {
    Search()
}

