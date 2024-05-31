import Foundation

// MARK: - Auth.Email

extension Auth {
  public enum Email { }
}

// MARK: - Auth.Email.Request

extension Auth.Email {
  public struct Request: Equatable, Sendable {
    public let email: String
    public let userName: String?
    public let password: String

    public init(
      email: String,
      userName: String? = .none,
      password: String)
    {
      self.email = email
      self.userName = userName
      self.password = password
    }

  }
}
