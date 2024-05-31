import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - UpdateProfileSideEffect

struct UpdateProfileSideEffect {
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

extension UpdateProfileSideEffect {
  var userInfo: () -> Effect<UpdateProfileReducer.Action> {
    {
      .publisher {
        useCase.authUseCase.me()
          .receive(on: main)
          .mapToResult()
          .map(UpdateProfileReducer.Action.fetchUserInfo)
      }
    }
  }

  var deleteUser: () -> Effect<UpdateProfileReducer.Action> {
    {
      .publisher {
        useCase.authUseCase.delete()
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(UpdateProfileReducer.Action.fetchDeleteUser)
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

  var routeToUpdatePassword: () -> Void {
    {
      navigator.next(
        linkItem: .init(path: Link.Dashboard.Path.updatePassword.rawValue),
        isAnimated: true)
    }
  }

  var close: () -> Void {
    {
      navigator.close(
        isAnimated: true,
        completeAction: { })
    }
  }
}
