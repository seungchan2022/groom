import Combine

public protocol AirbnbDetailUseCase {
  var detail: (Airbnb.Detail.Request) -> AnyPublisher<Airbnb.Detail.Response, CompositeErrorRepository> { get }

  var searchCityDetail: (Airbnb.SearchCityDetail.Request) -> AnyPublisher<
    Airbnb.SearchCityDetail.Response,
    CompositeErrorRepository
  > { get }

  var searchCountryDetail: (Airbnb.SearchCountryDetail.Request) -> AnyPublisher<
    Airbnb.SearchCountryDetail.Response,
    CompositeErrorRepository
  > { get }
}
