import Combine

public protocol AirbnbUseCase {
  var listing: (Airbnb.Listing.Request) -> AnyPublisher<Airbnb.Listing.Response, CompositeErrorRepository> { get }
}
