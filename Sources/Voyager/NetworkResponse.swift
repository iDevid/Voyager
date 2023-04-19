import Foundation

public struct NetworkResponse<T> {
    public let headers: [AnyHashable: Any]
    public let model: T
    public let wasCached: Bool
    
    public init(model: T) {
        self.model = model
        self.headers = [:]
        self.wasCached = false
    }
    
    init(headers: [AnyHashable: Any], model: T, wasCached: Bool) {
        self.headers = headers
        self.model = model
        self.wasCached = wasCached
    }
}
