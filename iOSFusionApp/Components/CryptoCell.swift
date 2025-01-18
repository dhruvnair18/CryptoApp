

import SwiftUI

struct CryptoCell: View {
    var cryptoSymbol: String
    var cryptoName: String = ""
    var cryptoPrice: Double
    var image: String
    var volume: Double
    var marketCap: Double
    var low: Double
    var high: Double
    var change: Double
    
    @State private var height = 150.0
    @State private var isTapped = false
    @State private var detailedView = false
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 365, height: height)
                .foregroundColor(isTapped ? Color(red: 204/255, green: 229/255, blue: 226/255) : Color(red: 30/255, green: 30/255, blue: 30/255))
            
            VStack(alignment:.leading){
                HStack(spacing:15){
                    AsyncImage(url: URL(string: "https://cryptocompare.com/\(image)")) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    
                    VStack(alignment:.leading){
                        Text(cryptoSymbol)
                            .foregroundStyle(isTapped ? .black:.white)
                            .font(.system(size: 25))
                        
                        if(isTapped && !cryptoName.isEmpty){
                            Text(cryptoName)
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    HStack{
                        if(isTapped){
                            Button {
                                //
                                detailedView.toggle()
                            } label: {
                                Image(systemName: "text.alignleft")
                                    .padding(10)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                        }
                        
                        Text("$\(String(format: "%.2f", cryptoPrice))")
                            .foregroundStyle(isTapped ? .black:.white)
                            .font(.system(size: isTapped ? 24:27))
                    }
                }
                .padding([.top,.horizontal])

                HStack(spacing:0){
                    Image(systemName: change>0 ? "chart.line.uptrend.xyaxis" : "chart.line.downtrend.xyaxis")
                        .foregroundColor(change>0 ? .green : .red)
                    Text(" \(String(format: "%.2f", change))%")
                        .font(.headline)
                        .foregroundColor(change>0 ? .green : .red)
                    
                    GraphView(cryptoSymbol: cryptoSymbol, detailedView: true)
                }
                .padding(.horizontal)
                
                if(isTapped){
                    HStack{
                        HStack(spacing:0){
                            Text("Volume:")
                                .foregroundStyle(.gray)
                            Text(" \(volume.formatToAbbreviated())")
                                .foregroundStyle(.black)
                        }
                        .padding(.horizontal,10)
                        .padding(.vertical,5)
                        .overlay(
                            Capsule()
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        Spacer()
                        
                        HStack(spacing:0){
                            Text("Market Cap:")
                                .foregroundStyle(.gray)
                            Text(" \(marketCap.formatToAbbreviated())")
                                .foregroundStyle(.black)
                        }
                        .padding(.horizontal,10)
                        .padding(.vertical,5)
                        .overlay(
                            Capsule()
                                .stroke(Color.gray, lineWidth: 2)
                        )
                    }
                    .padding()
                }
                
                
            }
            .frame(width: 365, height: height)
        }
        .onTapGesture {
            if(height == 150){
                withAnimation {
                    height = 220
                    isTapped.toggle()
                }
            }
            else{
                withAnimation {
                    height = 150
                    isTapped.toggle()
                }
            }
        }
        .sheet(isPresented: $detailedView, content: {
            NavigationView {
                VStack {
                    HStack{
                        AsyncImage(url: URL(string: "https://cryptocompare.com/\(image)")){ image in
                            image.image?.resizable()
                        }
                        .frame(width: 100, height: 100)
                        
                        VStack(alignment:.leading){
                            Text(cryptoSymbol)
                                .font(.title)
                                .bold()
                            
                            Text(cryptoName)
                                .foregroundStyle(.gray)
                                .font(.title3)
                                .bold()
                            
                        }
                        
                        Spacer()
                        
                        VStack(alignment:.trailing){
                            Text("$\(String(format: "%.2f", cryptoPrice))")
                                .font(.title2)
                            HStack(spacing:0){
                                Image(systemName: change>0 ? "chart.line.uptrend.xyaxis" : "chart.line.downtrend.xyaxis")
                                    .foregroundColor(change>0 ? .green : .red)
                                Text(" \(String(format: "%.2f", change))%")
                                    .font(.title2)
                                    .foregroundColor(change>0 ? .green : .red)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    HStack{
                        VStack(alignment:.leading){
                            Text("Low")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.gray)
                            Text("$\(String(format: "%.2f", low))")
                                .font(.system(size: 20))
                        }
                        Spacer()
                        VStack(alignment:.leading){
                            Text("High")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.gray)
                            Text("$\(String(format:"%.2f", high))")
                                .font(.system(size: 20))
                        }
                        Spacer()
                        VStack(alignment:.leading){
                            Text("Vol")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.gray)
                            Text("$\(volume.formatToAbbreviated())")
                                .font(.system(size: 20))
                        }
                    }
                    .padding()
                    
                    GraphView(cryptoSymbol: cryptoSymbol, detailedView: false)
                        .frame(height: 390)
                        .background{
                            Color(red: 204/255, green: 229/255, blue: 226/255)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .padding()
                    
                    HStack{
                        NavigationLink {
                            //
                            BuyView(image: image, cryptoSymbol: cryptoSymbol, cryptoPrice: cryptoPrice, change: change)
                        } label: {
                            Text("Buy")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: 390, maxHeight: 50)
                                .background{
                                    Color.blue
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        })
    }
}

#Preview {
    CryptoCell(cryptoSymbol: "BTC", cryptoName: "Bitcoin", cryptoPrice: 58573.2942865166, image: "media/37746251/btc.png", volume: 100.0, marketCap: 10000.0, low: 58573.2942865166, high: 58573.2942865166, change: 1.27)
}
