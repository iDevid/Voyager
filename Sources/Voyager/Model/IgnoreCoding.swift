import Foundation

public protocol IgnoreCodable {
    associatedtype WrappedType: ExpressibleByNilLiteral
    init(wrappedValue: WrappedType)
}

@propertyWrapper
public struct IgnoreCoding<T>: Codable, IgnoreCodable {
    public var wrappedValue: T?

    public init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }

    public func encode(to encoder: Encoder) throws {}
    
    public init(from decoder: Decoder) throws {}
}

extension KeyedDecodingContainer {
    public func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T: Decodable, T: IgnoreCodable {
        return try decodeIfPresent(T.self, forKey: key) ?? T(wrappedValue: nil)
    }
}
