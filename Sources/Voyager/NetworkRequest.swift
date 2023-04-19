import Foundation

public protocol NetworkRequest: Encodable {
    var queryRequestArrayEncoding: QueryRequestArrayEncoding? { get }
}

public extension NetworkRequest {
    var queryRequestArrayEncoding: QueryRequestArrayEncoding? { .default }
}

public extension NetworkRequest {

    internal func getData() throws -> Data {
        try JSONEncoder().encode(self)
    }

    internal func getDictionary() -> [String: Any] {
        guard
          let data = try? JSONEncoder().encode(self),
          let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }

    internal var asQueryItems: [URLQueryItem] {
        getDictionary().flatMap { element in
            if let sequence = element.value as? any Sequence {
                return queryItems(key: element.key, sequence: sequence)
            } else {
                return [URLQueryItem(name: element.key, value: "\(element.value)")]
            }
        }
    }
    
    internal func queryItems(key: String, sequence: any Sequence) -> [URLQueryItem] {
        let encodingType = queryRequestArrayEncoding ?? .default
        let encodedKey = encodingType.encodedKey(key)
        return sequence.map { URLQueryItem(name: encodedKey, value: "\($0)") }
    }
}

extension Never: NetworkRequest {
    public func encode(to encoder: Encoder) throws {}
}
