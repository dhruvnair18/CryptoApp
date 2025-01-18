

import Foundation

// MARK: - API Response Models
struct ApiResponse: Codable {
    let Data: [CoinData]
}

struct CoinData: Codable {
    let CoinInfo: CoinInfo
    let RAW: RawData?
}

struct CoinInfo: Codable {
    let Name: String
    let FullName: String
    let ImageUrl: String
}

struct RawData: Codable {
    let USD: CurrencyData
}

struct CurrencyData: Codable {
    let PRICE: Double
    let VOLUME24HOUR: Double
    let MKTCAP: Double
    let LOW24HOUR: Double
    let HIGH24HOUR: Double
    let CHANGEPCTDAY: Double
}

class FetchTopCrypto {
    func fetchTopCrypto(completion: @escaping ([CryptoCurrencyData]) -> () ){
        
        guard let url = URL(string: "https://min-api.cryptocompare.com/data/top/mktcapfull?limit=20&tsym=USD") else{
            print("Invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url){ data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else{
                print("No data received")
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(ApiResponse.self, from: data)
                let apiData = apiResponse.Data.compactMap { coinData -> CryptoCurrencyData? in
                    guard let rawData = coinData.RAW else {
                        print("RAW data missing for \(coinData.CoinInfo.Name)")
                        return nil
                    }
                    return CryptoCurrencyData(
                        symbolName: coinData.CoinInfo.Name,
                        fullName: coinData.CoinInfo.FullName,
                        imageUrl: coinData.CoinInfo.ImageUrl,
                        price: rawData.USD.PRICE,
                        vol24Hour: rawData.USD.VOLUME24HOUR,
                        mktCap: rawData.USD.MKTCAP,
                        low: rawData.USD.LOW24HOUR,
                        high: rawData.USD.HIGH24HOUR,
                        changepct: rawData.USD.CHANGEPCTDAY
                    )
                }

                completion(apiData)
            }
            catch let decodingError{
                print("Error decoding data \(decodingError)")
            }
        }
        task.resume()
    }
}


