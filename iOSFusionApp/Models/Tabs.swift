

import SwiftUI

enum Tab: String{
    case home = "Home"
    case search = "Search"
    case portfolio = "Portfolio"
    
    @ViewBuilder
    var tabContent: some View{
        switch self{
        case .home:
            Image(systemName: "house.fill")
            Text(self.rawValue)
        case .search:
            Image(systemName: "magnifyingglass")
            Text(self.rawValue)
        case .portfolio:
            Image(systemName: "creditcard.fill")
            Text(self.rawValue)
        }
    }
}
