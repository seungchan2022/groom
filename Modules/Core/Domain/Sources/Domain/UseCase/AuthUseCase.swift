import Combine

public protocol AuthUseCase {
  var signUp: (Auth.Email.Request) -> AnyPublisher<Void, CompositeErrorRepository> { get }
  var signIn: (Auth.Email.Request) -> AnyPublisher<Void, CompositeErrorRepository> { get }
  var signOut: () -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var me: () -> AnyPublisher<Auth.Me.Response?, CompositeErrorRepository> { get }

  var resetPassword: (String) -> AnyPublisher<Void, CompositeErrorRepository> { get }
  
  var updatePassword: (String) -> AnyPublisher<Void, CompositeErrorRepository> { get }
}
