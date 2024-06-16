import Combine
import Foundation

public protocol AuthUseCase {
  var signUp: (Auth.Email.Request) -> AnyPublisher<Void, CompositeErrorRepository> { get }
  var signIn: (Auth.Email.Request) -> AnyPublisher<Void, CompositeErrorRepository> { get }
  var signOut: () -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var me: () -> AnyPublisher<Auth.Me.Response?, CompositeErrorRepository> { get }

  var resetPassword: (String) -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var updateUserName: (String) -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var updatePassword: (String) -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var updateProfileImage: (Data) -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var deleteProfileImage: () -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var deleteUser: () -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var deleteUserInfo: () -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var googleSignIn: () -> AnyPublisher<Void, CompositeErrorRepository> { get }

}
