import Combine

public protocol SearchUseCase {
  var searchCity: (Airbnb.Search.City.Request) -> AnyPublisher<Airbnb.Search.City.Response, CompositeErrorRepository>
  { get }

  var searchCountry: (Airbnb.Search.Country.Request)
    -> AnyPublisher<Airbnb.Search.Country.Response, CompositeErrorRepository> { get }
}
