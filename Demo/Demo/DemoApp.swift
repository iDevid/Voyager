import SwiftUI

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: ContentViewModel(
                    getService: HTTPBinGetService(),
                    putAnythingService: HTTPBinPutAnythingService()
                )
            )
        }
    }
}
