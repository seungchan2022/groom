import Architecture
import ComposableArchitecture
import Domain
import Foundation

@Reducer
struct SampleReducer {
  
  private let pageID: String
  private let sideEffect: SampleSideEffect
  
  init(
    pageID: String = UUID().uuidString,
    sideEffect: SampleSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }
  
  @ObservableState
  struct State: Equatable {
    let id: UUID
    
    init(id: UUID = UUID()) {
      self.id = id
    }
  }
  
  enum  CancelID: Equatable, CaseIterable {
    case teardown
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) } 
        )
      }
    }
    
  }
}
