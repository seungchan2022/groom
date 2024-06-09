import Architecture
import LinkNavigator

struct ProfileRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Dashboard.Path.profile.rawValue
    
    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: DashboardEnvironmentUsable = diContainer.resolve() else { return .none }
      let routeSubscriber: ProfileRouteSubscriber = .init()
      
      return DebugWrappingController(
        matchPath: matchPath,
        eventSubscriber: routeSubscriber) {
          ProfilePage(
            store: .init(
              initialState: ProfileReducer.State(),
              reducer: {
                ProfileReducer(
                  sideEffect: .init(
                    useCase: env,
                    navigator: navigator))
              }),
            routeSubscriber: routeSubscriber)
        }
    }
  }
}
