import Architecture
import LinkNavigator
import SwiftUI

// MARK: - AppMain

struct AppMain {
  let viewModel: AppViewModel
}

// MARK: View

extension AppMain: View {

  var body: some View {
    TabLinkNavigationView(
      linkNavigator: viewModel.linkNavigator,
      isHiddenDefaultTabbar: false,
      tabItemList: [
        .init(
          tag: .zero,
          tabItem: .init(
            title: "Home",
            image: .init(systemName: "house"),
            tag: .zero),
          linkItem: .init(path: Link.Dashboard.Path.home.rawValue),
          prefersLargeTitles: true),
        
          .init(
            tag: 1,
            tabItem: .init(
              title: "Sample",
              image: .init(systemName: "shippingbox.fill"),
              tag: 1),
            linkItem: .init(path: Link.Dashboard.Path.sample.rawValue),
            prefersLargeTitles: true),
      ])
    .ignoresSafeArea()
  }
}
