import Combine
import Domain

// MARK: - AirbnbDetailUseCasePlatform

public struct AirbnbDetailUseCasePlatform {
  let baseURL: String

  public init(baseURL: String = "https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/air-bnb-listings/records") {
    self.baseURL = baseURL
  }
}

// MARK: AirbnbDetailUseCase

extension AirbnbDetailUseCasePlatform: AirbnbDetailUseCase {
  public var detail: (Airbnb.Detail.Request) -> AnyPublisher<Airbnb.Detail.Response, CompositeErrorRepository> {
    {
      Endpoint(
        baseURL: baseURL,
        pathList: [],
        httpMethod: .get,
        content: .queryItemPath($0))
        .fetch(isDebug: true)
    }
  }

  public var searchCityDetail: (Airbnb.SearchCityDetail.Request) -> AnyPublisher<
    Airbnb.SearchCityDetail.Response,
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

  public var searchCountryDetail: (Airbnb.SearchCountryDetail.Request) -> AnyPublisher<
    Airbnb.SearchCountryDetail.Response,
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
