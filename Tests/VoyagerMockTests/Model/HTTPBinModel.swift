import Foundation

struct HTTPBinModel: Decodable, Equatable {
    let origin: String
    let url: String
}
