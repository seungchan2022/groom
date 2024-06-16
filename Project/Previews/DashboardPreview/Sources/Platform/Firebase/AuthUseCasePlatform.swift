import Combine
import Domain
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import Foundation
import GoogleSignIn

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

          var userData: [String: Any] = [
            "email": req.email,
            "created_time": Timestamp(),
          ]

          if let userName = req.userName {
            userData["user_name"] = userName
          }

          Firestore.firestore()
            .collection("users")
            .document(user.uid)
            .setData(userData) { error in
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
              uid: me.uid ,
              email: me.email,
              userName: data["user_name"] as? String,
              photoURL: data["photoURL"] as? String)

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

  public var updateUserName: (String) -> AnyPublisher<Void, CompositeErrorRepository> {
    { name in
      Future<Void, CompositeErrorRepository> { promise in

        guard let me = Auth.auth().currentUser else {
          return promise(.failure(.invalidTypeCasting))
        }

        Firestore.firestore()
          .collection("users")
          .document(me.uid)
          .updateData([
            "user_name": name,
          ]) { error in
            if let error = error {
              return promise(.failure(.other(error)))
            } else {
              return promise(.success(Void()))
            }
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

  public var updateProfileImage: (Data) -> AnyPublisher<Void, CompositeErrorRepository> {
    { imageData in
      Future<Void, CompositeErrorRepository> { promise in
        guard let user = Auth.auth().currentUser else {
          return promise(.failure(.invalidTypeCasting))
        }

        // 참조 만들기 (파일 위치)
        let storageRef = Storage.storage().reference()
        // 기존 참조에 child 메서드를 사용하여 'images/space.jpg'와 같이 하위 위치를 가리키는 참조를 만들 수 있습니다.
        let profileImageRef = storageRef.child("profile_images/\(user.uid).jpg")

        // 참조에 맞게 이미지 업로드
        profileImageRef.putData(imageData, metadata: .none) { _, error in

          if let error = error {
            return promise(.failure(.other(error)))
          }

          // 이미지 업로드에 해당 이미지의 url을 가져옴
          profileImageRef.downloadURL { url, error in
            if let error = error {
              return promise(.failure(.other(error)))
            }

            guard let url = url else {
              return promise(.failure(.invalidTypeCasting))
            }

            // url을 string으로 변환
            let photoURLString = url.absoluteString

            Firestore.firestore()
              .collection("users")
              .document(user.uid)
              .setData(["photoURL": photoURLString], merge: true) { error in
                if let error = error {
                  return promise(.failure(.other(error)))
                } else {
                  return promise(.success(Void()))
                }
              }
          }
        }
      }
      .eraseToAnyPublisher()
    }
  }

  public var deleteProfileImage: () -> AnyPublisher<Void, CompositeErrorRepository> {
    {
      Future<Void, CompositeErrorRepository> { promise in
        guard let user = Auth.auth().currentUser else {
          return promise(.failure(.invalidTypeCasting))
        }

        let storageRef = Storage.storage().reference()

        let profileImageRef = storageRef.child("profile_images/\(user.uid).jpg")

        profileImageRef.delete { error in
          if let error = error {
            promise(.failure(.other(error)))
          } else {
            promise(.success(Void()))
          }
        }

        Firestore.firestore()
          .collection("users")
          .document(user.uid)
          .updateData(["photoURL": ""]) { error in
            if let error = error {
              return promise(.failure(.other(error)))
            } else {
              return promise(.success(Void()))
            }
          }
      }
      .eraseToAnyPublisher()
    }
  }

  public var deleteUser: () -> AnyPublisher<Void, CompositeErrorRepository> {
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

  public var deleteUserInfo: () -> AnyPublisher<Void, CompositeErrorRepository> {
    {
      Future<Void, CompositeErrorRepository> { promise in
        guard let me = Auth.auth().currentUser else {
          return promise(.failure(.userCancelled))
        }

        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(me.uid)
        let wishListRef = userDocRef.collection("wish_list")
        let batch = db.batch()

        wishListRef
          // wish_list 컬렉션의 모든 문서를 가져옴
          .getDocuments { snapshot, error in
            if let error = error {
              return promise(.failure(.other(error)))
            }

            // 해당 문서가 존재하는지 확인
            // documents => wish_list 컬렉션의 문서들
            guard let documents = snapshot?.documents else {
              userDocRef
                .delete { error in
                  if let error = error {
                    return promise(.failure(.other(error)))
                  }
                  return promise(.success(Void()))
                }
              return
            }

            // batch를 사용하여 Wish_list 하위 컬렉션의 모든 문서를 삭제합니다.
            // 서브 컬렉션(wish_list) 먼저 삭제후,
            for document in documents {
//              // Firestore 배치 작업 생성. 배치 작업은 여러 작업을 하나로 묶어 처리할 수 있게 해줌
              batch
                // 각 문서에 대해 삭제 작업 추가
                .deleteDocument(document.reference)
            }

            batch
              // 배치 작업을 Firestore에 커밋하여, 추가된 모든 삭제 작업 실행
              .commit { error in
                if let error = error {
                  return promise(.failure(.other(error)))
                }

                // 유저에 대한 데이터 삭제
                // 배치 작업이 성공적으로 완료된 후, 사용자 문서 삭제
                userDocRef
                  .delete { error in
                    if let error = error {
                      return promise(.failure(.other(error)))
                    }

                    return promise(.success(Void()))
                  }
              }
          }
      }
      .eraseToAnyPublisher()
    }
  }

  public var googleSignIn: () -> AnyPublisher<Void, CompositeErrorRepository> {
    {
      Future<Void, CompositeErrorRepository> { promise in

        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        //        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        //        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }

        guard let rootViewController = UIApplication.shared.firstKeyWindow?.rootViewController else { return }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
          if let error = error {
            return promise(.failure(.other(error)))
          }

          guard
            let user = result?.user,
            let idToken = user.idToken?.tokenString
          else { return }

          let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: user.accessToken.tokenString)

          Auth.auth().signIn(with: credential) { _, error in
            if let error = error {
              promise(.failure(.other(error)))
              return
            }

            guard let me = Auth.auth().currentUser else { return }

            var userData: [String: Any] = [
              "uid": me.uid,
              "created_time": Timestamp(),
            ]

            if let email = me.email {
              userData["email"] = email
            }

            Firestore.firestore()
              .collection("users")
              .document(me.uid)
              .setData(userData) { error in
                if let error = error {
                  promise(.failure(.other(error)))
                } else {
                  promise(.success(Void()))
                }
              }
          }
        }
      }
      .eraseToAnyPublisher()
    }
  }

}

extension UIApplication {
  fileprivate var firstKeyWindow: UIWindow? {
    UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .filter { $0.activationState == .foregroundActive }
      .first?.windows
      .first(where: \.isKeyWindow)
  }
}
