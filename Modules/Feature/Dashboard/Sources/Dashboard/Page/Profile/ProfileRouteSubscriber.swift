import Combine
import Foundation
import LinkNavigator

// MARK: - ProfileRouteSubscriber

@Observable
final class ProfileRouteSubscriber {
  let isRouteEventSubject: PassthroughSubject<ProfileRouteItem, Never> = .init()
}

// MARK: LinkNavigatorItemSubscriberProtocol

extension ProfileRouteSubscriber: LinkNavigatorItemSubscriberProtocol {
  func receive(encodedItemString: String) {
    guard let query: ProfileRouteItem = encodedItemString.decoded() else { return }
    isRouteEventSubject.send(query)
  }
}

// MARK: - ProfileRouteItem

struct ProfileRouteItem: Equatable, Codable {
  let isLogIn: Bool
}
