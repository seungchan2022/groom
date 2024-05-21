import Architecture
import ComposableArchitecture
import Foundation

// MARK: - ProfileSideEffect

struct ProfileSideEffect {
  let useCase: DashboardEnvironmentUsable
  let main: AnySchedulerOf<DispatchQueue>
  let navigator: RootNavigatorType

  init(
    useCase: DashboardEnvironmentUsable,
    main: AnySchedulerOf<DispatchQueue> = .main,
    navigator: RootNavigatorType)
  {
    self.useCase = useCase
    self.main = main
    self.navigator = navigator
  }
}

extension ProfileSideEffect {
  var routeToSignIn: () -> Void {
    {
      navigator.sheet(
        linkItem: .init(path: Link.Dashboard.Path.signIn.rawValue),
        isAnimated: true)
    }
  }

  var routeToSignUp: () -> Void {
    {
      navigator.sheet(
        linkItem: .init(
          pathList: [
            Link.Dashboard.Path.signIn.rawValue,
            Link.Dashboard.Path.signUp.rawValue,
          ]),
        isAnimated: true)
    }
  }
}
