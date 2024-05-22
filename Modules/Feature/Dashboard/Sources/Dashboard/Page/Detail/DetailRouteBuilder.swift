import Architecture
import LinkNavigator

struct DetailRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Dashboard.Path.detail.rawValue

    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: DashboardEnvironmentUsable = diContainer.resolve() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        DetailPage(store: .init(
          initialState: DetailReducer.State(),
          reducer: {
            DetailReducer(
              sideEffect: .init(
                useCase: env,
                navigator: navigator))
          }))
      }
    }
  }
}
