import Foundation

public enum QueryRequestArrayEncoding: Equatable {
    case `default`
    case parenthesis
    
    func encodedKey(_ key: String) -> String {
        switch self {
        case .default:
            return key
        case .parenthesis:
            return key + "[]"
        }
    }
}
