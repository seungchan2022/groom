import Architecture
import LinkNavigator

struct HomeRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Dashboard.Path.home.rawValue
    
    return .init(matchPath: matchPath) { navigator, items, diContainer -> RouteViewController? in
      guard let env: DashboardEnvironmentUsable = diContainer.resolve() else { return .none }
      
      return DebugWrappingController(matchPath: matchPath) {
        HomePage(store: .init(
          initialState: HomeReducer.State(),
          reducer: {
            HomeReducer(
              sideEffect: .init(
              useCase: env,
              navigator: navigator))
          }))
      }
    }
  }
}
