
import SwiftUI

struct HomeView: View {
    
    @State private var topCryptoNames: [CryptoCurrencyData] = []
    
    var body: some View {
        
        VStack(alignment:.leading){
            NavigationView{
                if topCryptoNames.isEmpty{
                    Text("Loading...")
                }
                else{
                    ScrollView{
                        LazyVStack{
                            ForEach(0..<topCryptoNames.count, id: \.self){index in
                                CryptoCell(cryptoSymbol: topCryptoNames[index].symbolName, cryptoName: topCryptoNames[index].fullName, cryptoPrice: topCryptoNames[index].price, image: topCryptoNames[index].imageUrl,volume: topCryptoNames[index].vol24Hour, marketCap: topCryptoNames[index].mktCap, low: topCryptoNames[index].low, high: topCryptoNames[index].high, change: topCryptoNames[index].changepct)
                            }
                        }
                    }
                    .navigationBarTitle("Cryptos", displayMode: .large)
                }
            }
            .onAppear{
                fetchTopCryptos()
            }
        }
    }
    
    func fetchTopCryptos(){
        FetchTopCrypto().fetchTopCrypto { cryptoInfo in
            DispatchQueue.main.async{
                self.topCryptoNames = cryptoInfo
            }
        }
    }
}

#Preview {
    HomeView()
}
