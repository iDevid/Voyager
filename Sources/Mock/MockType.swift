import Foundation

public enum MockType<Model: Decodable, ErrorType: Error> {
    case json(name: String, bundle: Bundle = .main)
    case model(_ model: Model)
    case failure(_ error: ErrorType)
}
