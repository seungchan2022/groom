import Architecture
import LinkNavigator

struct MusicRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Dashboard.Path.music.rawValue
    
    return .init(matchPath: matchPath) { navigator, items, diContainer -> RouteViewController? in
      guard let env: DashboardEnvironmentUsable = diContainer.resolve() else { return .none }
      
      return DebugWrappingController(matchPath: matchPath) {
        MusicPage(store: .init(
          initialState: MusicReducer.State(),
          reducer: {
            MusicReducer(
              sideEffect: .init(
                useCase: env,
                navigator: navigator))
          }))
      }
    }
  }
}
