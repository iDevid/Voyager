
import Foundation

public extension Swift.Result {
    func getModel<Model>() -> Result<Model, Failure> where Success == NetworkResponse<Model> {
        map { $0.model }
    }
}
