

import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false

    var body: some View {
        Group {
            if hasSeenOnboarding{
                TabView{
                    HomeView()
                        .tag(Tab.home)
                        .tabItem { Tab.home.tabContent }
                    Search()
                        .tag(Tab.search)
                        .tabItem { Tab.search.tabContent }
                    Portfolio2()
                        .tag(Tab.portfolio)
                        .tabItem { Tab.portfolio.tabContent }
                }
                .transition(.opacity)
            }
            else{
                IntroScreen()
                    .transition(.opacity)
            }
        }
        .animation(.easeIn, value: hasSeenOnboarding)
    }
}

#Preview {
    ContentView()
}
