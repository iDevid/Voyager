import Foundation

public enum NetworkError: Error, Equatable {
    case noData
    case invalidMethod(_ description: String)
    case invalidURL(_ urlString: String)
    case invalidStatusCode(_ statusCode: Int)
    case decodingError(_ error: Error)
    case networkingError(_ error: Error)
    case genericError(_ error: Error)

    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.noData, .noData):
            return true
        case let (.invalidMethod(lhsDescription), .invalidMethod(rhsDescription)):
            return lhsDescription == rhsDescription
        case let (.invalidURL(lhsURL), .invalidURL(rhsURL)):
            return lhsURL == rhsURL
        case let (.invalidStatusCode(lhsCode), .invalidStatusCode(rhsCode)):
            return lhsCode == rhsCode
        case
          let (.decodingError(lhsError), .decodingError(rhsError)),
          let (.networkingError(lhsError), .networkingError(rhsError)),
          let (.genericError(lhsError), .genericError(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
    
    public var wrappedError: Error? {
        switch self {
        case
          let .genericError(error),
          let .networkingError(error),
          let .decodingError(error):
            return error
        case .noData, .invalidMethod, .invalidStatusCode, .invalidURL:
            return nil
        }
    }
}
