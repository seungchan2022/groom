import Architecture
import CombineExt
import ComposableArchitecture
import Domain
import Foundation

// MARK: - ExploreSideEffect

struct ExploreSideEffect {
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

extension ExploreSideEffect {
  var getItem: (Airbnb.Listing.Request) -> Effect<ExploreReducer.Action> {
    { request in
      .publisher {
        useCase.airbnbUseCase.listing(request)
          .receive(on: main)
          .mapToResult()
          .map(ExploreReducer.Action.fetchItem)
      }
    }
  }

  var routeToDetail: (Airbnb.Listing.Item) -> Void {
    { item in
      navigator.next(
        linkItem: .init(
          path: Link.Dashboard.Path.detail.rawValue,
          items: item),
        isAnimated: true)
    }
  }
}
