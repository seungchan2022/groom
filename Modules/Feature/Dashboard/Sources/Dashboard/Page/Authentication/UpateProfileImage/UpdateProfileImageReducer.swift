import _PhotosUI_SwiftUI
import Architecture
import ComposableArchitecture
import Domain
import Foundation
import SwiftUI

@Reducer
struct UpdateProfileImageReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: UpdateProfileImageSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID

    var isShowPhotoPicker = false
    var selectedImage: PhotosPickerItem?

    var item: Auth.Me.Response = .init(uid: "", email: "", userName: "", photoURL: "")

    var fetchUserInfo: FetchState.Data<Auth.Me.Response?> = .init(isLoading: false, value: .none)
    var fetchUpdateProfileImage: FetchState.Data<Bool> = .init(isLoading: false, value: false)
    var fetchDeleteProfileImage: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestUserInfo
    case requestUpdateProfileImage
    case requestDeleteProfileImage
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case getUserInfo
    case updateProfileImage(Data)
    case deleteProfileImage

    case fetchUserInfo(Result<Auth.Me.Response?, CompositeErrorRepository>)
    case fetchUpdateProfileImage(Result<Bool, CompositeErrorRepository>)
    case fetchDeleteProfileImage(Result<Bool, CompositeErrorRepository>)

    case routeToBack

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
        return sideEffect
          .userInfo()
          .cancellable(pageID: pageID, id: CancelID.requestUserInfo, cancelInFlight: true)

      case .updateProfileImage(let imageData):
        return sideEffect
          .updateProfileImage(imageData)
          .cancellable(pageID: pageID, id: CancelID.requestUpdateProfileImage, cancelInFlight: true)

      case .deleteProfileImage:
        return sideEffect
          .deleteProfileImage()
          .cancellable(pageID: pageID, id: CancelID.requestDeleteProfileImage, cancelInFlight: true)

      case .fetchUserInfo(let result):
        switch result {
        case .success(let item):
          state.item = item ?? .init(uid: "", email: "", userName: "", photoURL: "")
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchUpdateProfileImage(let result):
        switch result {
        case .success:
          sideEffect.useCase.toastViewModel.send(message: "프로필 이미지가 변경되었습니다.")
          sideEffect.routeToBack()
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchDeleteProfileImage(let result):
        switch result {
        case .success:
          sideEffect.useCase.toastViewModel.send(message: "프로필 이미지가 삭제되었습니다.")
          sideEffect.routeToBack()
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .routeToBack:
        sideEffect.routeToBack()
        return .none

      case .throwError(let error):
        return .run { await $0(.throwError(error)) }
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: UpdateProfileImageSideEffect
}
