import Architecture
import LinkNavigator

struct ResetPasswordRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Dashboard.Path.resetPassword.rawValue

    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in

      guard let env: DashboardEnvironmentUsable = diContainer.resolve() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        ResetPasswordPage(
          store: .init(
            initialState: ResetPasswordReducer.State(),
            reducer: {
              ResetPasswordReducer(
                sideEffect: .init(
                  useCase: env,
                  navigator: navigator))
            }))
      }
    }
  }
}
