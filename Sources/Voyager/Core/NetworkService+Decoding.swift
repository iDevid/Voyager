import Foundation

extension NetworkService {
    func decodeData(_ data: Data, response: HTTPURLResponse?, wasCached: Bool) -> FullResultType {
        do {
            let decoder = self.jsonDecoder
            let responseModel = try decoder.decode(ResponseModel.self, from: data)
            let wrapper = NetworkResponse(
                headers: response?.allHeaderFields ?? [:],
                model: responseModel,
                wasCached: wasCached
            )
            return .success(wrapper)
        } catch let error {
            return .failure(NetworkError.decodingError(error))
        }
    }
}
