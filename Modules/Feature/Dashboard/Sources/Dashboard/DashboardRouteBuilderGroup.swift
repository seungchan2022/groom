import Architecture
import LinkNavigator

// MARK: - DashboardRouteBuilderGroup

public struct DashboardRouteBuilderGroup<RootNavigator: RootNavigatorType> {
  public init() { }
}

extension DashboardRouteBuilderGroup {
  public static var release: [RouteBuilderOf<RootNavigator>] {
    [
      ExploreRouteBuilder.generate(),
      DetailRouteBuilder.generate(),
      WishListRouteBuilder.generate(),
      ProfileRouteBuilder.generate(),
      SignInRouteBuilder.generate(),
      SignUpRouteBuilder.generate(),
    ]
  }
}
