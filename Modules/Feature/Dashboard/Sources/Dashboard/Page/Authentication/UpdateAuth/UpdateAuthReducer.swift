import Architecture
import ComposableArchitecture
import Domain
import Foundation

@Reducer
struct UpdateAuthReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: UpdateAuthSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {

    // MARK: Lifecycle

    init(id: UUID = UUID()) {
      self.id = id
    }

    // MARK: Internal

    let id: UUID

    var isShowSignOut = false
    var isShowDeleteUser = false
    var isShowUpdateUser = false
    
    var status: LoginStatus = .isLoggedOut

    var userName = ""

    var item: Auth.Me.Response = .init(uid: "", email: "", userName: "", photoURL: "")

    var fetchUserInfo: FetchState.Data<Auth.Me.Response?> = .init(isLoading: false, value: .none)
    var fetchSignOut: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    var fetchUpdateUserName: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    var fetchDeleteUser: FetchState.Data<Bool> = .init(isLoading: false, value: false)
    var fetchDeleteUserInfo: FetchState.Data<Bool> = .init(isLoading: false, value: false)
    var fetchDeleteProfileImage: FetchState.Data<Bool> = .init(isLoading: false, value: false)
  }

  enum CancelID: String, CaseIterable {
    case teardown
    case requestUserInfo
    case requestSignOut
    case requestUpdateUserName
    case requestDeleteUser
    case requestDeleteUserInfo
    case requestDelteProfileImage
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case getUserInfo

    case onTapSignOut
    
    case onTapUpdateUserName

    case onTapDeleteUser
    case onTapDeleteUserInfo
    case deleteProfileImage

    case routeToSignIn
    case routeToUpdatePassword
    case routeToBack

    case fetchUserInfo(Result<Auth.Me.Response?, CompositeErrorRepository>)
    case fetchSignOut(Result<Bool, CompositeErrorRepository>)

    case fetchUpdateUserName(Result<Bool, CompositeErrorRepository>)

    case fetchDeleteUser(Result<Bool, CompositeErrorRepository>)
    case fetchDeleteUserInfo(Result<Bool, CompositeErrorRepository>)
    case fetchDeleteProfileImage(Result<Bool, CompositeErrorRepository>)

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

      case .getUserInfo:
        state.fetchUserInfo.isLoading = true
        return sideEffect
          .userInfo()
          .cancellable(pageID: pageID, id: CancelID.requestUserInfo, cancelInFlight: true)
        
      case .onTapSignOut:
        state.fetchSignOut.isLoading = true
        state.item = .init(uid: "", email: "", userName: "", photoURL: "")
        state.status = .isLoggedOut
        return sideEffect
          .signOut()
          .cancellable(pageID: pageID, id: CancelID.requestSignOut, cancelInFlight: true)


      case .onTapUpdateUserName:
        state.fetchUpdateUserName.isLoading = true
        return sideEffect
          .updateUserName(state.userName)
          .cancellable(pageID: pageID, id: CancelID.requestUpdateUserName, cancelInFlight: true)

      case .onTapDeleteUser:
        state.fetchDeleteUser.isLoading = true
        return sideEffect
          .deleteUser()
          .cancellable(pageID: pageID, id: CancelID.requestDeleteUser, cancelInFlight: true)

      case .onTapDeleteUserInfo:
        state.fetchDeleteUserInfo.isLoading = true
        return sideEffect
          .deleteUserInfo()
          .cancellable(pageID: pageID, id: CancelID.requestDeleteUserInfo, cancelInFlight: true)

      case .deleteProfileImage:
        state.fetchDeleteProfileImage.isLoading = true
        return sideEffect
          .deleteProfileImage()
          .cancellable(pageID: pageID, id: CancelID.requestDelteProfileImage, cancelInFlight: true)

      case .routeToSignIn:
        sideEffect.routeToSignIn()
        return .none

      case .routeToUpdatePassword:
        sideEffect.routeToUpdatePassword()
        return .none

      case .routeToBack:
        sideEffect.routeToBack()
        return .none

      case .fetchUserInfo(let result):
        state.fetchUserInfo.isLoading = false
        switch result {
        case .success(let item):
          state.item = item ?? .init(uid: "", email: "", userName: "", photoURL: "")
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }
        
        
      case .fetchSignOut(let result):
        state.fetchSignOut.isLoading = false
        switch result {
        case .success:
          state.item = .init(uid: "", email: "", userName: "", photoURL: "")
          state.status = .isLoggedOut
          sideEffect.routeToBack()
          sideEffect.routeToSignIn()
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchUpdateUserName(let result):
        state.fetchUpdateUserName.isLoading = false
        switch result {
        case .success:
          sideEffect.useCase.toastViewModel.send(message: "이름이 변경되었습니다.")
          sideEffect.routeToBack()
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchDeleteUser(let result):
        state.fetchDeleteUser.isLoading = false
        switch result {
        case .success:
          sideEffect.useCase.toastViewModel.send(message: "계정이 탈퇴되었습니다.")
          sideEffect.routeToBack()
          sideEffect.routeToSignIn()
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchDeleteUserInfo(let result):
        state.fetchDeleteUserInfo.isLoading = false
        switch result {
        case .success:
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchDeleteProfileImage(let result):
        state.fetchDeleteProfileImage.isLoading = false
        switch result {
        case .success:
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        return .none
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: UpdateAuthSideEffect
}
