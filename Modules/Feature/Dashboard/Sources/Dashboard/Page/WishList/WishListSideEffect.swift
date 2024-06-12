import Architecture
import CombineExt
import ComposableArchitecture
import Domain
import Foundation

// MARK: - WishListSideEffect

struct WishListSideEffect {
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

extension WishListSideEffect {
  var user: () -> Effect<WishListReducer.Action> {
    {
      .publisher {
        useCase.authUseCase.me()
          .map { $0 != .none }
          .receive(on: main)
          .mapToResult()
          .map(WishListReducer.Action.fetchUser)
      }
    }
  }

  var userInfo: () -> Effect<WishListReducer.Action> {
    {
      .publisher {
        useCase.authUseCase.me()
          .receive(on: main)
          .mapToResult()
          .map(WishListReducer.Action.fetchUserInfo)
      }
    }
  }

  var getWishList: () -> Effect<WishListReducer.Action> {
    {
      .publisher {
        useCase.wishListUseCase.getItemList()
          .receive(on: main)
          .mapToResult()
          .map(WishListReducer.Action.fetchWishList)
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
}
