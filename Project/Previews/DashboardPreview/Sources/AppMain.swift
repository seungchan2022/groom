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
            image: .init(systemName: "magnifyingglass"),
            tag: .zero),
          linkItem: .init(path: Link.Dashboard.Path.home.rawValue),
          prefersLargeTitles: true),

        .init(
          tag: 1,
          tabItem: .init(
            title: "WishList",
            image: .init(systemName: "heart.fill"),
            tag: 1),
          linkItem: .init(path: Link.Dashboard.Path.wishList.rawValue),
          prefersLargeTitles: true),

        .init(
          tag: 2,
          tabItem: .init(
            title: "Profile",
            image: .init(systemName: "person.circle.fill"),
            tag: 2),
          linkItem: .init(path: Link.Dashboard.Path.profile.rawValue),
          prefersLargeTitles: true),
      ])
      .ignoresSafeArea()
      .onAppear {
        viewModel.linkNavigator.moveTab(targetPath: Link.Dashboard.Path.profile.rawValue)
      }
  }
}
