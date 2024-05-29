import Combine

public protocol AirbnbDetailUseCase {
  var detail: (Airbnb.Detail.Request) -> AnyPublisher<Airbnb.Detail.Response, CompositeErrorRepository> { get }
}
