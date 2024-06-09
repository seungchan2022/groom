import Foundation
import LinkNavigator
import Combine

@Observable
final class ProfileRouteSubscriber {
  let isRouteEventSubject: PassthroughSubject<ProfileRouteItem, Never> = .init()
  
  
}

extension ProfileRouteSubscriber: LinkNavigatorItemSubscriberProtocol {
  func receive(encodedItemString: String) {
    print("AAA")
    guard let query: ProfileRouteItem = encodedItemString.decoded() else { return }
    isRouteEventSubject.send(query)
  }
}

struct ProfileRouteItem: Equatable, Codable {
  let isLogIn: Bool
}
