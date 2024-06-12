import Combine

public protocol WishListUseCase {
  var getItemList: () -> AnyPublisher<[Airbnb.WishList.Item], CompositeErrorRepository> { get }

}
