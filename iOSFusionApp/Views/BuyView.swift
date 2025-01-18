import SwiftUI

struct BuyView: View {
    var image: String
    var cryptoSymbol: String
    var cryptoPrice: Double
    var change: Double
    
    @State private var buyQuantity: Double = 0
    @State private var buyAmount: Double = 0
    @State private var showingConfirmation = false
    
    
    @Environment(\.modelContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                cryptoHeader
                
                Divider()
                
                quantitySection
                
                priceSection
                
                Spacer()
                
                balanceSection
                
                buyButton
                
            }
            .padding()
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
        }
        .navigationBarTitle("Buy \(cryptoSymbol)", displayMode: .inline)
    }
    
    private var cryptoHeader: some View {
        HStack {
            AsyncImage(url: URL(string: "https://cryptocompare.com/\(image)")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            
            VStack(alignment: .leading) {
                Text(cryptoSymbol)
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack {
                    Text("$\(String(format: "%.2f", cryptoPrice))")
                        .font(.headline)
                    
                    Text(change > 0 ? "+\(String(format: "%.2f", change))%" : "\(String(format: "%.2f", change))%")
                        .font(.subheadline)
                        .foregroundColor(change > 0 ? .green : .red)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(change > 0 ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            Spacer()
        }
    }
    
    private var quantitySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quantity to Buy")
                .font(.headline)
            
            HStack {
                Button(action: { if buyQuantity > 0 { buyQuantity = max(0, buyQuantity - 0.1) } }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.blue)
                }
                
                TextField("0", value: $buyQuantity, formatter: formatter)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 100)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .onChange(of: buyQuantity) {
                        calculatePrice()
                    }
                   
                
                Button(action: { buyQuantity += 0.1 }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
    private var priceSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Total Cost")
                .font(.headline)
            
            Text("$\(String(format: "%.2f", buyAmount))")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
    }
    
    private var balanceSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Your Balance")
                .font(.headline)
            
            Text("$10,000.00")
                .font(.title3)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
    
    private var buyButton: some View {
        Button(action: {
            showingConfirmation = true
        }) {
            Text("Buy \(cryptoSymbol)")
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
        .alert(isPresented: $showingConfirmation) {
            Alert(
                title: Text("Confirm Purchase"),
                message: Text("Are you sure you want to buy \(formatter.string(from: NSNumber(value: buyQuantity)) ?? "") \(cryptoSymbol) for $\(String(format: "%.2f", buyAmount))?"),
                primaryButton: .default(Text("Confirm")) {
                    let boughtCrypto =  OwnedCryptos(cryptoSymbol: cryptoSymbol, quantity: buyQuantity, priceAtWhichBought: buyAmount, image: image, volume: 0, marketCap: 0, low: 0, high: 0, change: 0, totalInvestment: 0)
                    context.insert(boughtCrypto)
                    
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func calculatePrice() {
        buyAmount = buyQuantity * cryptoPrice
    }
}

struct BuyView_Previews: PreviewProvider {
    static var previews: some View {
        BuyView(image: "media/37746251/btc.png", cryptoSymbol: "BTC", cryptoPrice: 55000.0, change: 1.27)
    }
}


