import SwiftUI
import SwiftData

struct Portfolio2: View {
    
    @Query(sort: \OwnedCryptos.quantity) var ownedCC: [OwnedCryptos] = []
    
    var body: some View {
        VStack(alignment:.leading) {
            // Top section for portfolio balance
            VStack(alignment:.leading, spacing: 10) {
                Text("Portfolio")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .padding(.horizontal)

                Text("$5,276.39")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                Text("+192% all time")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)

            // Assets section
            VStack{
                VStack(alignment: .leading, spacing: 10) {
                    Text("Assets")
                        .font(.headline)
                        .padding()

                    // Asset List
                    ScrollView {
                        LazyVStack {
                            ForEach(ownedCC) { asset in
                                CryptoCell(cryptoSymbol: asset.cryptoSymbol, cryptoPrice: asset.priceAtWhichBought, image: asset.image, volume: 0.0, marketCap: 0.0, low: 0.0, high: 0.0, change: 0.0)
                            }
                        }
                        .padding(.bottom,70)
                    }
                }
                Spacer()
            }
            .padding()
            .background()
            .cornerRadius(30)
            .ignoresSafeArea()
        }
        .background(LinearGradient(colors: [Color.blue.opacity(0.5),Color.blue.opacity(0.8),Color.blue,Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

#Preview {
    Portfolio2()
}
