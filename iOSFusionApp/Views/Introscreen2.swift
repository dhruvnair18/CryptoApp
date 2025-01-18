//
//  Introscreen2.swift
//  iOSFusionApp
//
//  Created by Dhruv Nair 
//


import SwiftUI

struct IntroScreen2: View {
    
    //Visibility Status
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = true
    
    
    
    var body: some View {
        VStack(spacing:15){
            Text("What's New in the\nCrypto App")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top,65)
                .padding(.bottom,35)
            
            
            //Points View
            VStack(alignment: .leading,spacing: 25, content: {
                PointView(imageName: "dollarsign", title: "Transactions", subTitle: "Keep track of the market and your invesments.")
                PointView(imageName: "chart.bar.fill", title: "Visual Charts", subTitle: "View different crypto coins using eye-catching graphic representations.")
                PointView(imageName: "magnifyingglass", title: "Advance Filters", subTitle: "Find the currencies you want by advance search.")
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal,15)
            
            Spacer()
            
            Button(action: {
                hasSeenOnboarding = false
            }, label: {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical,14)
                    .background(.blue.gradient)
                    .cornerRadius(12)
                    .contentShape(.rect)
                
            })
        }
        .padding(15)
    }
    
}

#Preview {
    IntroScreen2()
}


struct PointView: View{
    
    var imageName: String
    var title: String
    var subTitle: String
    
    var body: some View{
        HStack(spacing:20){
            Image(systemName: imageName)
                .font(.largeTitle)
                .foregroundStyle(.blue.gradient)
                .frame(width: 45)
            
            VStack(alignment: .leading, spacing: 6, content: {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(subTitle)
                    .foregroundStyle(.gray)
            })
        }
    }
}
