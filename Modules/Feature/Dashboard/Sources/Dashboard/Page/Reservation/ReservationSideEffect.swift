import Architecture
import ComposableArchitecture
import Foundation

// MARK: - ReservationSideEffect

struct ReservationSideEffect {
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

extension ReservationSideEffect {
  var getReservationItemList: () -> Effect<ReservationReducer.Action> {
    {
      .publisher {
        useCase.reservationUseCase.getReservationList()
          .receive(on: main)
          .mapToResult()
          .map(ReservationReducer.Action.fetchReservationItemList)
      }
    }
  }

  var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }
}
