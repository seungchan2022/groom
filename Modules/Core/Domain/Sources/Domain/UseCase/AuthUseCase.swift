import Combine

public protocol AuthUseCase {
  var signUp: (Auth.Email.Request) -> AnyPublisher<Void, CompositeErrorRepository> { get }
}
