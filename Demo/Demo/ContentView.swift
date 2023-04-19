import SwiftUI
import Voyager

struct ContentView: View {
    
    @StateObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: ContentViewModel(
                getService: HTTPBinGetService(),
                putAnythingService: HTTPBinPutAnythingService()
            )
        )
    }
}


class ContentViewModel: ObservableObject {
    let getService: any HTTPBinGetServiceInterface
    let putAnythingService: any HTTPBinPutAnythingServiceInterface
    
    init(getService: any HTTPBinGetServiceInterface, putAnythingService: any HTTPBinPutAnythingServiceInterface) {
        self.getService = getService
        self.putAnythingService = putAnythingService
        
        test(testService: putAnythingService)
    }
    
    func test(testService: some HTTPBinPutAnythingServiceInterface) {
        testService.perform(bodyRequest: .init(test: "Hello World!")) { result in
            print(result)
        }
    }

    func test(testService: some HTTPBinGetServiceInterface) {
        testService.perform { result in
            print(result)
        }
    }
}
