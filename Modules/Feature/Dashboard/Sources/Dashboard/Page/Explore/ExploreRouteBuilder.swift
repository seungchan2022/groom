import Architecture
import LinkNavigator

struct ExploreRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Dashboard.Path.explore.rawValue

    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: DashboardEnvironmentUsable = diContainer.resolve() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        ExplorePage(store: .init(
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
