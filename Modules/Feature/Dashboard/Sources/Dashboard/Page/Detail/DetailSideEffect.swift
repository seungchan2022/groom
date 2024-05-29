import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - DetailSideEffect

struct DetailSideEffect {
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

extension DetailSideEffect {
  var getItem: (Airbnb.Listing.Item) -> Effect<DetailReducer.Action> {
    { item in
      .publisher {
        useCase.airbnbDetailUseCase.detail(item.serialized())
          .receive(on: main)
          .mapToResult()
          .map(DetailReducer.Action.fetchItem)
      }
    }
  }

  var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }
}

extension Airbnb.Listing.Item {
  fileprivate func serialized() -> Airbnb.Detail.Request {
    .init()
  }
}
