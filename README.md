# Voyager

A lightweight and testable protocol oriented network layer


## Installation

### Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding Voyager as a dependency is as easy as adding it to the dependencies value of your Package.swift.
```swift
dependencies: [
    .package(url: "https://github.com/iDevid/Voyager.git", .upToNextMajor(from: "1.0.0"))
]
```
    
## Usage/Examples

Using Voyager for your networking calls it's really easy, you should just define a service that inherits from `NetworkService`

```swift
import Voyager

struct PokemonListService: NetworkService {

    typealias ResponseModel = PokemonListResponse
    
    var rootEndpoint: String { "https://pokeapi.co/api/v2/" }
    var endpoint: String { "pokemon" }
}

// MARK: - Response Models

struct PokemonListResponse: Decodable {
    let count: Int
    let results: [PokemonReference]
}

struct PokemonReference: Decodable {
    let name: String
    let url: String
}
```

### Using the service

```swift
let service = PokemonListService()
service.perform { result in
    switch result {
    case let .failure(error):
        print("Error: \(error)")
    
    case let .success(responseModel):
        print("Response: \(responseModel)")
    }
}
```

### How to perform query requests

To perform a query request you have to just define a `typealias QueryRequestModel` inside your service like this:
```swift
struct PokemonListService: NetworkService {
    typealias QueryRequestModel = PokemonListQueryRequest
}

struct PokemonListQueryRequest: NetworkRequest {
    let limit: Int
    let offset: Int
}
```
And then you should call the `perform` method with the defined query model, it will be converted automatically to query items:
```swift
let service = PokemonListService()
service.perform(queryRequest: PokemonListQueryRequest(limit: 1000, offset: 5)) { result in
    ...
}
```
### How to perform body requests

This applies also for body request, just define a `typealias BodyRequestModel = MyModel` and then use it in the perform method:

```swift
service.perform(bodyRequest: MyModel()) {
    ...
}
```

## Mocking a service

To mock a service in your unit tests you should use the protocol approach to define them. Let's consider the previous PokemonListService, it should be defined in this way:
```swift
protocol PokemonListServiceProtocol: NetworkService where ResponseModel == PokemonListResponse {}
extension PokemonListServiceProtocol {
    var rootEndpoint: String { "https://pokeapi.co/api/v2/" }
    var endpoint: String { "pokemon" }
}

// Concrete Type:
struct PokemonListService: PokemonListServiceProtocol {}

class ClassToTest {
    let service: any PokemonListServiceProtocol
    
    init(service: any PokemonListServiceProtocol) {
        self.service = service
    }
}
```

Now in your app you can instantiate the class just in this way:
```swift
ClassToTest(service: PokemonListService())
```

To create a mock you should import `VoyagerMock` framework and declaring a new service (it should be an object) that inherits from `PokemonListServiceProtocol` and also `MockedService`, this will automatically mock the `perform` method of the network service

```swift
import VoyagerMock

class PokemonListMockService: MockedService, PokemonListServiceProtocol {}
```

The `MockedService` has the following APIs to set the response:
```swift
let service = PokemonListMockService()
service.setNextResponse(MockType)
```
where `MockType` it's defined in this way:

```swift
public enum MockType {
    case json(name: String, bundle: Bundle = .main)
    case model(_ model: ResponseModel)
    case failure(_ error: Error)
}
```
