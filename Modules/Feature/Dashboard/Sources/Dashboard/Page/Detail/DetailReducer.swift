import Architecture
import ComposableArchitecture
import Domain
import Foundation

@Reducer
struct DetailReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: DetailSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {

    // MARK: Lifecycle

    init(
      id: UUID = UUID(),
      item: Airbnb.Listing.Item,
      searchCityItem: Airbnb.Search.City.Item,
      searchCountryItem: Airbnb.Search.Country.Item)
    {
      self.id = id
      self.item = item
      self.searchCityItem = searchCityItem
      self.searchCountryItem = searchCountryItem
    }

    // MARK: Internal

    let id: UUID

    var isLike = false

    var selectedDateList: Set<DateComponents> = []

    var isShowCalendar = false

    var selectedDate = "날짜를 선택해주세요"

    let item: Airbnb.Listing.Item
    let searchCityItem: Airbnb.Search.City.Item
    let searchCountryItem: Airbnb.Search.Country.Item

    var fetchItem: FetchState.Data<Airbnb.Detail.Response?> = .init(isLoading: false, value: .none)
    var fetchSearchCityItem: FetchState.Data<Airbnb.SearchCityDetail.Response?> = .init(isLoading: false, value: .none)
    var fetchSearchCountryItem: FetchState.Data<Airbnb.SearchCountryDetail.Response?> = .init(isLoading: false, value: .none)

    var fetchIsLike: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    var fetchLikeDetail: FetchState.Data<Bool> = .init(isLoading: false, value: false)
    var fetchLikeCityDetail: FetchState.Data<Bool> = .init(isLoading: false, value: false)
    var fetchLikeCountryDetail: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    var fetchUnLikeDetail: FetchState.Data<Bool> = .init(isLoading: false, value: false)
    var fetchUnLikeCityDetail: FetchState.Data<Bool> = .init(isLoading: false, value: false)
    var fetchUnLikeCountryDetail: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    var fetchReservationDetail: FetchState.Data<Bool> = .init(isLoading: false, value: false)
    var fetchReservationCityDetail: FetchState.Data<Bool> = .init(isLoading: false, value: false)
    var fetchReservationCountryDetail: FetchState.Data<Bool> = .init(isLoading: false, value: false)
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestItem
    case requestSearchCityItem
    case requestSearchCountryItem
    case requestLikeDetail
    case requestLikeCityDetail
    case requestLikeCountryDetail
    case requestIsLike
    case requestReservationDetail
    case requestReservationCityDetail
    case requestReservationCountryDetail
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case getItem(Airbnb.Listing.Item)

    case getSearchCityItem(Airbnb.Search.City.Item)
    case getSearchCountryItem(Airbnb.Search.Country.Item)

    case getIsLike

    case onTapLikeDetail(Airbnb.Detail.Item)
    case onTapUnLikeDetail(Airbnb.Detail.Item)

    case onTapLikeCityDetail(Airbnb.SearchCityDetail.Item)
    case onTapUnLikeCityDetail(Airbnb.SearchCityDetail.Item)

    case onTapLikeCountryDetail(Airbnb.SearchCountryDetail.Item)
    case onTapUnLikeCountryDetail(Airbnb.SearchCountryDetail.Item)

    case fetchItem(Result<Airbnb.Detail.Response, CompositeErrorRepository>)
    case fetchSearchCityItem(Result<Airbnb.SearchCityDetail.Response, CompositeErrorRepository>)
    case fetchSearchCountryItem(Result<Airbnb.SearchCountryDetail.Response, CompositeErrorRepository>)

    case fetchIsLike(Result<Bool, CompositeErrorRepository>)

    case fetchLikeDetail(Result<Bool, CompositeErrorRepository>)
    case fetchLikeCityDetail(Result<Bool, CompositeErrorRepository>)
    case fetchLikeCountryDetail(Result<Bool, CompositeErrorRepository>)

    case fetchUnLikeDetail(Result<Bool, CompositeErrorRepository>)
    case fetchUnLikeCityDetail(Result<Bool, CompositeErrorRepository>)
    case fetchUnLikeCountryDetail(Result<Bool, CompositeErrorRepository>)

    case onTapReservationDetail(Airbnb.Detail.Item, [Date])
    case fetchReservationDetail(Result<Bool, CompositeErrorRepository>)

    case onTapReservationCityDetail(Airbnb.SearchCityDetail.Item, [Date])
    case fetchReservationCityDetail(Result<Bool, CompositeErrorRepository>)

    case onTapReservationCountryDetail(Airbnb.SearchCountryDetail.Item, [Date])
    case fetchReservationCountryDetail(Result<Bool, CompositeErrorRepository>)

    case routeToBack
    case routeToSignIn

    case throwError(CompositeErrorRepository)
  }

  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })

      case .getIsLike:
        state.fetchIsLike.isLoading = true
        return sideEffect
          .getIsLike("\(state.item.id)")
          .cancellable(pageID: pageID, id: CancelID.requestIsLike, cancelInFlight: true)

      case .getItem(let item):
        state.fetchItem.isLoading = true
        return sideEffect
          .getItem(item)
          .cancellable(pageID: pageID, id: CancelID.requestItem, cancelInFlight: true)

      case .getSearchCityItem(let item):
        state.fetchSearchCityItem.isLoading = true
        return sideEffect
          .getSearchCityItem(item)
          .cancellable(pageID: pageID, id: CancelID.requestSearchCityItem, cancelInFlight: true)

      case .getSearchCountryItem(let item):
        state.fetchSearchCountryItem.isLoading = true
        return sideEffect
          .getSearchCountryItem(item)
          .cancellable(pageID: pageID, id: CancelID.requestSearchCountryItem, cancelInFlight: true)

      case .onTapLikeDetail(let item):
        state.fetchLikeDetail.isLoading = true
        return sideEffect
          .likeDetail(item)
          .cancellable(pageID: pageID, id: CancelID.requestLikeDetail, cancelInFlight: true)

      case .onTapUnLikeDetail(let item):
        state.fetchUnLikeDetail.isLoading = true
        return sideEffect
          .unLikeDetail(item)
          .cancellable(pageID: pageID, id: CancelID.requestLikeDetail, cancelInFlight: true)

      case .onTapLikeCityDetail(let item):
        state.fetchLikeCityDetail.isLoading = true
        return sideEffect
          .likeCityDetail(item)
          .cancellable(pageID: pageID, id: CancelID.requestLikeCityDetail, cancelInFlight: true)

      case .onTapUnLikeCityDetail(let item):
        state.fetchUnLikeCityDetail.isLoading = true
        return sideEffect
          .unLikeCityDetail(item)
          .cancellable(pageID: pageID, id: CancelID.requestLikeCityDetail, cancelInFlight: true)

      case .onTapLikeCountryDetail(let item):
        state.fetchLikeCountryDetail.isLoading = true
        return sideEffect
          .likeCountryDetail(item)
          .cancellable(pageID: pageID, id: CancelID.requestLikeCountryDetail, cancelInFlight: true)

      case .onTapUnLikeCountryDetail(let item):
        state.fetchUnLikeCountryDetail.isLoading = true
        return sideEffect
          .unLikeCountryDetail(item)
          .cancellable(pageID: pageID, id: CancelID.requestLikeCountryDetail, cancelInFlight: true)

      case .onTapReservationDetail(let item, let dateList):
        state.fetchReservationDetail.isLoading = true
        return sideEffect
          .reservationDetail(item, dateList)
          .cancellable(pageID: pageID, id: CancelID.requestReservationDetail, cancelInFlight: true)

      case .fetchReservationDetail(let result):
        state.fetchReservationDetail.isLoading = false
        switch result {
        case .success(let item):
          state.fetchReservationDetail.value = item
          sideEffect.routeToBack()
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .onTapReservationCityDetail(let item, let dateList):
        state.fetchReservationCityDetail.isLoading = true
        return sideEffect
          .reservationCityDetail(item, dateList)
          .cancellable(pageID: pageID, id: CancelID.requestReservationCityDetail, cancelInFlight: true)

      case .fetchReservationCityDetail(let result):
        state.fetchReservationCityDetail.isLoading = false
        switch result {
        case .success(let item):
          state.fetchReservationCityDetail.value = item
          sideEffect.routeToBack()
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .onTapReservationCountryDetail(let item, let dateList):
        state.fetchReservationCountryDetail.isLoading = true
        return sideEffect
          .reservationCountryDetail(item, dateList)
          .cancellable(pageID: pageID, id: CancelID.requestReservationCountryDetail, cancelInFlight: true)

      case .fetchReservationCountryDetail(let result):
        state.fetchReservationCountryDetail.isLoading = false
        switch result {
        case .success(let item):
          state.fetchReservationCountryDetail.value = item
          sideEffect.routeToBack()
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchItem(let result):
        state.fetchItem.isLoading = false
        switch result {
        case .success(let item):
          state.fetchItem.value = item
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchSearchCityItem(let result):
        state.fetchSearchCityItem.isLoading = false
        switch result {
        case .success(let item):
          state.fetchSearchCityItem.value = item
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchSearchCountryItem(let result):
        state.fetchSearchCountryItem.isLoading = false
        switch result {
        case .success(let item):
          state.fetchSearchCountryItem.value = item
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchIsLike(let result):
        state.fetchIsLike.isLoading = false
        switch result {
        case .success(let isLike):
          state.isLike = isLike
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchLikeDetail(let result):
        state.fetchLikeDetail.isLoading = false
        switch result {
        case .success:
          state.isLike = true
          return .none

        case .failure(let error):
          sideEffect.routeToSignIn()
          return .run { await $0(.throwError(error)) }
        }

      case .fetchUnLikeDetail(let result):
        state.fetchUnLikeDetail.isLoading = false
        switch result {
        case .success:
          state.isLike = false
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchLikeCityDetail(let result):
        state.fetchLikeCityDetail.isLoading = false
        switch result {
        case .success:
          state.isLike = true
          return .none

        case .failure(let error):
          sideEffect.routeToSignIn()
          return .run { await $0(.throwError(error)) }
        }

      case .fetchUnLikeCityDetail(let result):
        state.fetchUnLikeCityDetail.isLoading = false
        switch result {
        case .success:
          state.isLike = false
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchLikeCountryDetail(let result):
        state.fetchLikeCountryDetail.isLoading = false
        switch result {
        case .success:
          state.isLike = true
          return .none

        case .failure(let error):
          sideEffect.routeToSignIn()
          return .run { await $0(.throwError(error)) }
        }

      case .fetchUnLikeCountryDetail(let result):
        state.fetchUnLikeCountryDetail.isLoading = false
        switch result {
        case .success:
          state.isLike = false
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .routeToBack:
        sideEffect.routeToBack()
        return .none

      case .routeToSignIn:
        sideEffect.routeToSignIn()
        return .none

      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        return .none
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: DetailSideEffect
}
