import Architecture
import ComposableArchitecture
import Domain
import Foundation

@Reducer
struct SignUpReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: SignUpSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID

    var emailText = ""
    var passwordText = ""
    var confirmPasswordText = ""

    var isValidEmail = true
    var isValidPassword = true
    var isValidConfirmPassword = true

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case routeToBack
  }

  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { _, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })

      case .routeToBack:
        sideEffect.routeToBack()
        return .none
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: SignUpSideEffect
}
