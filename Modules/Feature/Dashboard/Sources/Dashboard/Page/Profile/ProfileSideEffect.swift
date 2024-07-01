import Architecture
import CombineExt
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
  var user: () -> Effect<ProfileReducer.Action> {
    {
      .publisher {
        useCase.authUseCase.me()
          .map { $0 != .none }
          .receive(on: main)
          .mapToResult()
          .map(ProfileReducer.Action.fetchUser)
      }
    }
  }

  var userInfo: () -> Effect<ProfileReducer.Action> {
    {
      .publisher {
        useCase.authUseCase.me()
          .receive(on: main)
          .mapToResult()
          .map(ProfileReducer.Action.fetchUserInfo)
      }
    }
  }

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

  var routeToUpdateProfileImage: () -> Void {
    {
      navigator.next(
        linkItem: .init(path: Link.Dashboard.Path.updateProfileImage.rawValue),
        isAnimated: true)
    }
  }

  var routeToUpdateAuth: () -> Void {
    {
      navigator.next(
        linkItem: .init(path: Link.Dashboard.Path.updateAuth.rawValue),
        isAnimated: true)
    }
  }

  var routeToReservation: () -> Void {
    {
      navigator.next(
        linkItem: .init(path: Link.Dashboard.Path.reservation.rawValue),
        isAnimated: true)
    }
  }

  var routeToTabBarItem: (String) -> Void {
    { path in
      guard path != Link.Dashboard.Path.profile.rawValue else { return }
      navigator.replace(linkItem: .init(path: path), isAnimated: false)
    }
  }
}
