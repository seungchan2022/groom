import Combine
import Domain

// MARK: - SearchUseCasePlatform

public struct SearchUseCasePlatform {
  let baseURL: String

  public init(baseURL: String = "https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/air-bnb-listings/records") {
    self.baseURL = baseURL
  }
}

// MARK: SearchUseCase

extension SearchUseCasePlatform: SearchUseCase {
  public var searchCity: (Airbnb.Search.City.Request) -> AnyPublisher<Airbnb.Search.City.Response, CompositeErrorRepository> {
    {
      Endpoint(
        baseURL: baseURL,
        pathList: [],
        httpMethod: .get,
        content: .queryItemPath($0))
        .fetch(isDebug: true)
    }
  }

  public var searchCountry: (Airbnb.Search.Country.Request) -> AnyPublisher<
    Airbnb.Search.Country.Response,
    CompositeErrorRepository
  > {
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
