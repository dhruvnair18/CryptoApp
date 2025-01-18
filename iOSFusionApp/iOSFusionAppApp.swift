

import SwiftUI
import SwiftData

@main
struct iOSFusionAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [OwnedCryptos.self])
    }
}
