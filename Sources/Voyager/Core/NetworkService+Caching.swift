import Foundation

public extension NetworkService {
    func getCachedResponse(
        queryRequest: QueryRequestModel? = nil,
        bodyRequest: BodyRequestModel? = nil,
        endpointParameters: EndpointParameters? = nil
    ) -> ResponseModel? {
        guard
          let request = try? self.asURLRequest(queryRequest: queryRequest, bodyRequest: bodyRequest, endpointParameters: endpointParameters),
          let cachedData = URLCache.shared.cachedResponse(for: request)?.data,
          let decodedData = try? decodeData(cachedData, response: nil, wasCached: true).get() else {
            return nil
        }
        return decodedData.model
    }
    
    func cleanCachedData(
        queryRequest: QueryRequestModel? = nil,
        bodyRequest: BodyRequestModel? = nil,
        endpointParameters: EndpointParameters? = nil
    ) {
        guard let request = try? self.asURLRequest(
            queryRequest: queryRequest,
            bodyRequest: bodyRequest,
            endpointParameters: endpointParameters
        ) else {
            return
        }
        URLCache.shared.removeCachedResponse(for: request)
    }
}
