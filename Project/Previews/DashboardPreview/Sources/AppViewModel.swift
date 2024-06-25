import Architecture
import Domain
import Foundation
import LinkNavigator

@Observable
final class AppViewModel {

  let linkNavigator: SingleLinkNavigator
  
  init(linkNavigator: SingleLinkNavigator) {
    self.linkNavigator = linkNavigator
  }
}
