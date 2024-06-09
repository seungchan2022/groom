import Foundation
import LinkNavigator
import Combine

@Observable
final class WishListRouteSubscriber {
  let isRouteEventSubject: PassthroughSubject<WishListRouteItem, Never> = .init()
}

extension WishListRouteSubscriber: LinkNavigatorItemSubscriberProtocol {
  func receive(encodedItemString: String) {
    guard let query: WishListRouteItem = encodedItemString.decoded() else { return }
    isRouteEventSubject.send(query)
  }
}

struct WishListRouteItem: Equatable, Codable {
  let isLogIn: Bool
}
