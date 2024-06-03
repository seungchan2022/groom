import Architecture
import LinkNavigator

// MARK: - DashboardRouteBuilderGroup

public struct DashboardRouteBuilderGroup<RootNavigator: RootNavigatorType> {
  public init() { }
}

extension DashboardRouteBuilderGroup {
  public static var release: [RouteBuilderOf<RootNavigator>] {
    [
      HomeRouteBuilder.generate(),
      ExploreRouteBuilder.generate(),
      DetailRouteBuilder.generate(),
      WishListRouteBuilder.generate(),
      ProfileRouteBuilder.generate(),
      SignInRouteBuilder.generate(),
      SignUpRouteBuilder.generate(),
      UpdatePasswordRouteBuilder.generate(),
      UpdateProfileRouteBuilder.generate(),
    ]
  }
}
