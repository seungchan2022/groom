import Combine

public protocol LikeUseCase {
  var likeDetail: (Airbnb.Detail.Item) -> AnyPublisher<Void, CompositeErrorRepository> { get }
  var likeCityDetail: (Airbnb.SearchCityDetail.Item) -> AnyPublisher<Void, CompositeErrorRepository> { get }
  var likeCountryDetail: (Airbnb.SearchCountryDetail.Item) -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var unLikeDetail: (Airbnb.Detail.Item) -> AnyPublisher<Void, CompositeErrorRepository> { get }
  var unLikeCityDetail: (Airbnb.SearchCityDetail.Item) -> AnyPublisher<Void, CompositeErrorRepository> { get }
  var unLikeCountryDetail: (Airbnb.SearchCountryDetail.Item) -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var getIsLike: (String) -> AnyPublisher<Void, CompositeErrorRepository> { get }
}
