import Architecture
import LinkNavigator

struct WishListRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Dashboard.Path.wishList.rawValue

    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: DashboardEnvironmentUsable = diContainer.resolve() else { return .none }
      let routeSubscriber: WishListRouteSubscriber = .init()

      return DebugWrappingController(
        matchPath: matchPath,
        eventSubscriber: routeSubscriber)
      {
        WishListPage(
          store: .init(
            initialState: WishListReducer.State(),
            reducer: {
              WishListReducer(
                sideEffect: .init(
                  useCase: env,
                  navigator: navigator))
            }),
          routeSubscriber: routeSubscriber)
      }
    }
  }
}
