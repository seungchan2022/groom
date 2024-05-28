import Combine
import Domain

// MARK: - AirbnbUseCasePlatform

public struct AirbnbUseCasePlatform {
  let baseURL: String

  public init(baseURL: String = "https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/air-bnb-listings/records") {
    self.baseURL = baseURL
  }
}

// MARK: AirbnbUseCase

extension AirbnbUseCasePlatform: AirbnbUseCase {
  public var listing: (Airbnb.Listing.Request) -> AnyPublisher<Airbnb.Listing.Response, CompositeErrorRepository> {
    {
      Endpoint(
        baseURL: baseURL,
        pathList: [],
        httpMethod: .get,
        content: .queryItemPath($0))
        .fetch(isDebug: true)
    }
  }
}
