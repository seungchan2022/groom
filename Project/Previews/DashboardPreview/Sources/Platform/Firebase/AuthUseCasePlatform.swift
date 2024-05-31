import Combine
import Domain
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

// MARK: - AuthUseCasePlatform

public struct AuthUseCasePlatform { }

// MARK: AuthUseCase

extension AuthUseCasePlatform: AuthUseCase {
  public var signUp: (Domain.Auth.Email.Request) -> AnyPublisher<Void, CompositeErrorRepository> {
    { req in
      Future<Void, CompositeErrorRepository> { promise in
        Auth.auth().createUser(withEmail: req.email, password: req.password) { result, error in
          if let error = error {
            return promise(.failure(.other(error)))
          }

          guard let user = result?.user else {
            return promise(.failure(.userCancelled))
          }

          Firestore.firestore()
            .collection("users")
            .document(user.uid)
            .setData([
              "email": req.email,
              "userName": req.userName ?? "",
              "createdTime": Timestamp(),
            ]) { error in
              if let error = error {
                return promise(.failure(.other(error)))
              } else {
                return promise(.success(Void()))
              }
            }
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
          try Auth.auth().signOut()
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
        guard let me = Auth.auth().currentUser else {
          return promise(.success(.none))
        }

        Firestore.firestore()
          .collection("users")
          .document(me.uid)
          .getDocument { document, error in
            if let error = error {
              return promise(.failure(.other(error)))
            }

            /// 가지고 오려는 데이터의 document가 존재 하지 않을 수도 있으므로
            guard let document = document, document.exists, let data = document.data() else {
              return promise(.failure(.userCancelled))
            }

            let response = Domain.Auth.Me.Response(
              uid: me.uid,
              email: me.email,
              userName: data["userName"] as? String,
              photoURL: me.photoURL?.absoluteString)

            return promise(.success(response))
          }
      }
      .eraseToAnyPublisher()
    }
  }

  public var resetPassword: (String) -> AnyPublisher<Void, CompositeErrorRepository> {
    { email in
      Future<Void, CompositeErrorRepository> { promise in
        Auth.auth().sendPasswordReset(withEmail: email) { error in
          guard let error else { return promise(.success(Void())) }

          return promise(.failure(.other(error)))
        }
      }
      .eraseToAnyPublisher()
    }
  }

  public var updatePassword: (String) -> AnyPublisher<Void, CompositeErrorRepository> {
    { newPassword in
      Future<Void, CompositeErrorRepository> { promise in
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
          guard let error else { return promise(.success(Void())) }

          return promise(.failure(.other(error)))
        }
      }
      .eraseToAnyPublisher()
    }
  }

  public var delete: () -> AnyPublisher<Void, CompositeErrorRepository> {
    {
      Future<Void, CompositeErrorRepository> { promise in
        Auth.auth().currentUser?.delete { error in
          guard let error else { return promise(.success(Void())) }

          return promise(.failure(.other(error)))
        }
      }
      .eraseToAnyPublisher()
    }
  }
}
