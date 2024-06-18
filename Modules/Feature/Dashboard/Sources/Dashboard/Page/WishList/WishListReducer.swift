import Architecture
import ComposableArchitecture
import Domain
import Foundation

@Reducer
struct WishListReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: WishListSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID

    var isGridLayout = false

    var status: LoginStatus = .isLoggedOut

    var item: Auth.Me.Response = .init(uid: "", email: "", userName: "", photoURL: "")

    var wishList: [Airbnb.WishList.Item] = []

    var fetchUser: FetchState.Data<Bool> = .init(isLoading: false, value: false)
    var fetchUserInfo: FetchState.Data<Auth.Me.Response?> = .init(isLoading: false, value: .none)

    var fetchWishList: FetchState.Data<[Airbnb.WishList.Item]?> = .init(isLoading: false, value: .none)

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestUser
    case requestUserInfo
    case requestWishList

  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case getUser
    case getUserInfo

    case getWishList

    case fetchUser(Result<Bool, CompositeErrorRepository>)
    case fetchUserInfo(Result<Auth.Me.Response?, CompositeErrorRepository>)
    case fetchWishList(Result<[Airbnb.WishList.Item], CompositeErrorRepository>)

    case routeToSignIn

    case routeToDetail(Airbnb.WishList.Item)

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

      case .getUser:
        state.fetchUser.isLoading = true
        return sideEffect
          .user()
          .cancellable(pageID: pageID, id: CancelID.requestUser, cancelInFlight: true)

      case .getUserInfo:
        state.fetchUserInfo.isLoading = true
        return sideEffect
          .userInfo()
          .cancellable(pageID: pageID, id: CancelID.requestUserInfo, cancelInFlight: true)

      case .getWishList:
        state.fetchWishList.isLoading = true
        return sideEffect
          .getWishList()
          .cancellable(pageID: pageID, id: CancelID.requestWishList, cancelInFlight: true)

      case .fetchUser(let result):
        state.fetchUser.isLoading = false
        switch result {
        case .success(let isLoggedIn):
          switch isLoggedIn {
          case true: state.status = .isLoggedIn
          case false: state.status = .isLoggedOut
          }

          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchUserInfo(let result):
        state.fetchUserInfo.isLoading = false
        switch result {
        case .success(let item):
          state.item = item ?? .init(uid: "", email: "", userName: "", photoURL: "")
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchWishList(let result):
        state.fetchWishList.isLoading = false
        switch result {
        case .success(let itemList):
          state.wishList = itemList
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .routeToSignIn:
        sideEffect.routeToSignIn()
        return .none

      case .routeToDetail(let item):
        sideEffect.routeToDetail(item)
        return .none

      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        return .none
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: WishListSideEffect
}
