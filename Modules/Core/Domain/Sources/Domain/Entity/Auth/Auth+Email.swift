import Foundation

// MARK: - Auth.Email

extension Auth {
  public enum Email { }
}

// MARK: - Auth.Email.Request

extension Auth.Email {
  public struct Request: Equatable, Sendable, Codable {
    public let email: String
    public let password: String
    public let userName: String?

    public init(
      email: String,
      password: String,
      userName: String? = .none)
    {
      self.email = email
      self.password = password
      self.userName = userName
    }

  }
}
