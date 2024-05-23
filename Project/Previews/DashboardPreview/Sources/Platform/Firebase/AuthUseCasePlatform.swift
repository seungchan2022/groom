import Combine
import Domain
import Firebase
import FirebaseAuth
import Foundation

public struct AuthUseCasePlatform { }

extension AuthUseCasePlatform: AuthUseCase {
  public var signUp: (Domain.Auth.Email.Request) -> AnyPublisher<Void, CompositeErrorRepository> {
    { req in
      Future<Void, CompositeErrorRepository> { promise in
        Auth.auth().createUser(withEmail: req.email, password: req.password) { result, error in
          guard let error else { return promise(.success(Void()))}
          
          promise(.failure(.other(error)))
        }
      }
      .eraseToAnyPublisher()
    }
  }
}
