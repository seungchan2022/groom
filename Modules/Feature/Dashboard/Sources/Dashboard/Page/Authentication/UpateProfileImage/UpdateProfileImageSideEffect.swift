import Architecture
import ComposableArchitecture
import Foundation

// MARK: - UpdateProfileImageSideEffect

struct UpdateProfileImageSideEffect {
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

extension UpdateProfileImageSideEffect {
  var userInfo: () -> Effect<UpdateProfileImageReducer.Action> {
    {
      .publisher {
        useCase.authUseCase.me()
          .receive(on: main)
          .mapToResult()
          .map(UpdateProfileImageReducer.Action.fetchUserInfo)
      }
    }
  }

  var updateProfileImage: (Data) -> Effect<UpdateProfileImageReducer.Action> {
    { imageData in
      .publisher {
        useCase.authUseCase.updateProfileImage(imageData)
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(UpdateProfileImageReducer.Action.fetchUpdateProfileImage)
      }
    }
  }

  var deleteProfileImage: () -> Effect<UpdateProfileImageReducer.Action> {
    {
      .publisher {
        useCase.authUseCase.deleteProfileImage()
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(UpdateProfileImageReducer.Action.fetchDeleteProfileImage)
      }
    }
  }

  var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }

}
