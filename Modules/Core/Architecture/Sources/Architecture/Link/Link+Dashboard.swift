import Foundation

// MARK: - Link.Dashboard

extension Link {
  public enum Dashboard { }
}

// MARK: - Link.Dashboard.Path

extension Link.Dashboard {
  public enum Path: String, Equatable {
    case explore
    case detail
    case wishList
    case profile
    case signIn
    case signUp
    case resetPassword
  }
}
