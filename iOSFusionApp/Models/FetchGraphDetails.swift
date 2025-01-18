

import Foundation

struct CryptoGraphDataResponse: Codable {
    let Data: DataArray
}

struct DataArray: Codable {
    let Data: [PriceData]
}

struct PriceData: Codable {
    let time: Int
    let close: Double
}

class FetchGraphDetails {
    func fetchData(cryptoSymbol: String, completion: @escaping ([CryptoPrice]) -> ()) {
        guard let url = URL(string: "https://min-api.cryptocompare.com/data/v2/histoday?fsym=\(cryptoSymbol)&tsym=USD&limit=20#") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else { return }

            do {
                let decodedResponse = try JSONDecoder().decode(CryptoGraphDataResponse.self, from: data)
                let prices = decodedResponse.Data.Data.map {
                    CryptoPrice(date: Date(timeIntervalSince1970: TimeInterval($0.time)), close: $0.close)
                }
                completion(prices)
            } catch {
                print("Failed to decode JSON: \(error)")
                completion([])
            }
        }.resume()
    }
}
