import Combine

public protocol SearchUseCase {
  var searchCity: (Airbnb.Search.City.Request) -> AnyPublisher<Airbnb.Search.City.Response, CompositeErrorRepository>
  { get }
}
