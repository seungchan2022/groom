import Combine
import Domain
import Firebase
import FirebaseAuth
import Foundation

// MARK: - AuthUseCasePlatform

public struct AuthUseCasePlatform { }

// MARK: AuthUseCase

extension AuthUseCasePlatform: AuthUseCase {
  public var signUp: (Domain.Auth.Email.Request) -> AnyPublisher<Void, CompositeErrorRepository> {
    { req in
      Future<Void, CompositeErrorRepository> { promise in
        Auth.auth().createUser(withEmail: req.email, password: req.password) { _, error in
          guard let error else { return promise(.success(Void())) }

          promise(.failure(.other(error)))
        }
      }
      .eraseToAnyPublisher()
    }
  }

  public var signIn: (Domain.Auth.Email.Request) -> AnyPublisher<Void, CompositeErrorRepository> {
    { req in
      Future<Void, CompositeErrorRepository> { promise in
        Auth.auth().signIn(withEmail: req.email, password: req.password) { _, error in
          guard let error else { return promise(.success(Void())) }

          promise(.failure(.other(error)))
        }
      }
      .eraseToAnyPublisher()
    }
  }

  public var signOut: () -> AnyPublisher<Void, CompositeErrorRepository> {
    {
      Future<Void, CompositeErrorRepository> { promise in
        do {
          try FirebaseAuth.Auth.auth().signOut()
          return promise(.success(Void()))
        } catch {
          return promise(.failure(.other(error)))
        }
      }
      .eraseToAnyPublisher()
    }
  }

  public var me: () -> AnyPublisher<Domain.Auth.Me.Response?, CompositeErrorRepository> {
    {
      Future<Domain.Auth.Me.Response?, CompositeErrorRepository> { promise in
        guard let me = FirebaseAuth.Auth.auth().currentUser else { return promise(.success(.none)) }

        return promise(.success(me.serialized()))
      }
      .eraseToAnyPublisher()
    }
  }
}

extension User {
  fileprivate func serialized() -> Domain.Auth.Me.Response {
    .init(
      uid: uid,
      email: email,
      photoURL: photoURL?.absoluteString)
  }
}
