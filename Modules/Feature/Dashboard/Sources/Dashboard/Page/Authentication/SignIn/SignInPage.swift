import ComposableArchitecture
import SwiftUI

// MARK: - Focus

private enum Focus {
  case email
  case password
}

// MARK: - SignInPage

struct SignInPage {
  @Bindable var store: StoreOf<SignInReducer>

  @FocusState private var isFocus: Focus?
}

extension SignInPage {
  private var isActiveSignIn: Bool {
    Validator.validateEmail(email: store.emailText) && Validator.validatePassword(password: store.passwordText)
  }
}

// MARK: View

extension SignInPage: View {
  var body: some View {
    VStack(spacing: 24) {
      Image(systemName: "paperplane")
        .resizable()
        .frame(width: 150, height: 150)
        .fontWeight(.light)
        .foregroundStyle(.pink)

      TextField(
        "",
        text: $store.emailText,
        prompt: Text("Email"))
        .autocorrectionDisabled(true)
        .focused($isFocus, equals: .email)
        .textInputAutocapitalization(.never)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
          RoundedRectangle(cornerRadius: 10)
            .stroke(!store.isValidEmail ? .red : isFocus == .email ? .blue : .clear, lineWidth: 1)
        }
        .onChange(of: store.emailText) { _, new in
          store.isValidEmail = Validator.validateEmail(email: new)
        }
      if !store.isValidEmail {
        HStack {
          Text("이메일 형식을 따르고, @와 도메인(example.com)이 포함된 주소를 입력하세요.")
            .font(.footnote)
            .foregroundStyle(.red)
            .padding(.top, -12)

          Spacer()
        }
      }

      TextField(
        "",
        text: $store.passwordText,
        prompt: Text("Password"))
        .autocorrectionDisabled(true)
        .focused($isFocus, equals: .password)
        .textInputAutocapitalization(.never)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
          RoundedRectangle(cornerRadius: 10)
            .stroke(!store.isValidPassword ? .red : isFocus == .password ? .blue : .clear, lineWidth: 1)
        }
        .onChange(of: store.passwordText) { _, new in
          store.isValidPassword = Validator.validatePassword(password: new)
        }
      if !store.isValidPassword {
        HStack {
          Text("비밀번호는 최소 8자 이상이어야 하고, 대문자, 숫자, 특수문자를 각각 하나 이상 포함해야 합니다.")
            .font(.footnote)
            .foregroundStyle(.red)
            .padding(.top, -12)

          Spacer()
        }
      }

      HStack {
        Spacer()

        Button(action: { }) {
          Text("Forgot Password?")
            .font(.callout)
            .fontWeight(.bold)
        }
      }

      Button(action: { }) {
        Text("Log In")
          .foregroundStyle(.white)
          .frame(height: 50)
          .frame(maxWidth: .infinity)
          .background(.pink)
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .opacity(isActiveSignIn ? 1.0 : 0.3)
      }
      .disabled(!isActiveSignIn)

      Button(action: { store.send(.routeToSignUp) }) {
        HStack {
          Text("Don't have an account?")

          Text("Sign Up here")
            .fontWeight(.bold)
        }
        .font(.callout)
      }

      Spacer()
    }
    .padding(.horizontal, 16)
    .toolbar(.visible, for: .navigationBar)
    .onAppear {
      isFocus = .email
    }
  }
}

// MARK: - Validator

enum Validator {
  static func validateEmail(email: String) -> Bool {
    let emailRegex = #"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$"#

    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
  }

  static func validatePassword(password: String) -> Bool {
    let passwordRegex = "^(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"

    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    return passwordPredicate.evaluate(with: password)
  }
}
