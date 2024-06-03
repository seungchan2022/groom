import Architecture
import LinkNavigator

struct HomeRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Dashboard.Path.home.rawValue

    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: DashboardEnvironmentUsable = diContainer.resolve() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        HomePage(
          store: .init(
            initialState: HomeReducer.State(),
            reducer: {
              HomeReducer(
                sideEffect: .init(
                  useCase: env,
                  navigator: navigator))
            }),
          exploreStore: .init(
            initialState: ExploreReducer.State(),
            reducer: {
              ExploreReducer(
                sideEffect: .init(
                  useCase: env,
                  navigator: navigator))
            }))
      }
    }
  }
}
