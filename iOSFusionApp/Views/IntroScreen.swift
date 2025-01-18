import SwiftUI

struct IntroScreen: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                Color.white,
                Color(red: 199 / 255, green: 236 / 255, blue: 238 / 255),
                Color(red: 199 / 255, green: 236 / 255, blue: 238 / 255)
                ]),startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            
            VStack{
                
                Text("Step into the future of Finance")
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                    .bold()
                    .padding(.top,100)
                
                
                Image("Card")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350, height: 200)
                    .padding(.top,110)
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 45)
                        .frame(width: 375,height: 280)
                        .foregroundColor(.white)
                        .padding(.bottom,7)
                        .ignoresSafeArea(edges: .bottom)
                    
                    VStack(spacing:20){
                        Text("Your Digital Wallet, One Tap Away")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal,10)
                                            
                        Text("Secure. Simple. Fast")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .padding(.horizontal,10)
                                            
                        Text("Welcome to Dhruv's Crypto! Your gateway to the world of cryptocurrency. Manage, trade, and grow your digital assets with top-notch security.")
                            .font(.system(size: 14))
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal,10)
                        
                        Button(action: {
                            withAnimation {
                                hasSeenOnboarding.toggle()
                            }
                        }) {
                            Text("Get Started")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .semibold))
                                .frame(width: 360,height: 50)
                                .background(Color.black)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    IntroScreen()
}


