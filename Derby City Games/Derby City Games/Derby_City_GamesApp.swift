import SwiftUI

@main
struct Derby_City_GamesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            RootViewDC()
                .preferredColorScheme(.light)
        }
    }
}
