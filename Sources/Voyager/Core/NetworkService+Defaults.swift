import Foundation

public extension NetworkService {
    
    var acceptedStatusCodes: Set<Int> { .init(200..<300) }
    var additionalHeaders: [String: String] { [:] }
    var cachePolicy: CachePolicy { .useProtocolCachePolicy }
    var jsonDecoder: JSONDecoder { JSONDecoder() }
    var method: HTTPMethod { .get }
    var sessionConfiguration: URLSessionConfiguration { .default }
    var shouldReturnCachedResponseOnError: Bool { false }
    var timeoutInterval: TimeInterval { 10 }
    var urlSession: URLSession { URLSession(configuration: sessionConfiguration) }

    func endpoint() -> String { "" }
    func endpoint(parameters: EndpointParameters) -> String { "" }
    func log(request: URLRequest?, result: FullResultType) {}
}
