import Combine
import Foundation
import LinkNavigator

// MARK: - WishListRouteSubscriber

@Observable
final class WishListRouteSubscriber {
  let isRouteEventSubject: PassthroughSubject<WishListRouteItem, Never> = .init()
}

// MARK: LinkNavigatorItemSubscriberProtocol

extension WishListRouteSubscriber: LinkNavigatorItemSubscriberProtocol {
  func receive(encodedItemString: String) {
    guard let query: WishListRouteItem = encodedItemString.decoded() else { return }
    isRouteEventSubject.send(query)
  }
}

// MARK: - WishListRouteItem

struct WishListRouteItem: Equatable, Codable {
  let isLogIn: Bool
}
