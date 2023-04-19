import Foundation

struct HTTPBinModel<JSONModel: Decodable & Equatable, ArgsModel: Decodable & Equatable>: Decodable, Equatable {
    let args: ArgsModel
    let origin: String
    let url: String
    
    let json: JSONModel?
}
