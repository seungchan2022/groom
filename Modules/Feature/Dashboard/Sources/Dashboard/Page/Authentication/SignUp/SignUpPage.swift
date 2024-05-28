import ComposableArchitecture
import SwiftUI

// MARK: - Focus

private enum Focus {
  case email
  case password
  case confirmPassword
}

// MARK: - SignUpPage

struct SignUpPage {
  @Bindable var store: StoreOf<SignUpReducer>
  @FocusState private var isFocus: Focus?
}

extension SignUpPage {
  private var isActiveSignUp: Bool {
    Validator.validateEmail(email: store.emailText) && Validator
      .validatePassword(password: store.passwordText) && isValidConfirm(text: store.confirmPasswordText)
  }

  private func isValidConfirm(text: String) -> Bool {
    store.passwordText == text
  }
}

// MARK: View

extension SignUpPage: View {
  var body: some View {
    VStack(spacing: 24) {
      Text("Create Account")
        .font(.largeTitle)
        .foregroundStyle(.pink)
        .padding(.bottom, 36)

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
          Text("유효한 이메일 주소가 아닙니다.")
            .font(.footnote)
            .foregroundStyle(.red)
            .padding(.top, -12)

          Spacer()
        }
      }

      HStack {
        if store.isShowPassword {
          TextField(
            "",
            text: $store.passwordText,
            prompt: Text("Password"))
        } else {
          SecureField(
            "",
            text: $store.passwordText,
            prompt: Text("Password"))
        }
      }
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
      .overlay(alignment: .trailing) {
        Button(action: { store.isShowPassword.toggle() }) {
          Image(systemName: store.isShowPassword ? "eye" : "eye.slash")
            .foregroundStyle(.black)
            .padding(.trailing, 12)
        }
      }
      .onChange(of: store.passwordText) { _, new in
        store.isValidPassword = Validator.validatePassword(password: new)
      }
      if !store.isValidPassword {
        HStack {
          Text("영어대문자, 숫자, 특수문자를 모두 사용하여 8 ~ 20자리로 설정해주세요.")
            .font(.footnote)
            .foregroundStyle(.red)
            .padding(.top, -12)

          Spacer()
        }
      }

      HStack {
        if store.isShowConfirmPassword {
          TextField(
            "",
            text: $store.confirmPasswordText,
            prompt: Text("Confirm Password"))
        } else {
          SecureField(
            "",
            text: $store.confirmPasswordText,
            prompt: Text("Confirm Password"))
        }
      }
      .autocorrectionDisabled(true)
      .focused($isFocus, equals: .confirmPassword)
      .textInputAutocapitalization(.never)
      .padding()
      .background(.thinMaterial)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .overlay {
        RoundedRectangle(cornerRadius: 10)
          .stroke(!store.isValidConfirmPassword ? .red : isFocus == .confirmPassword ? .blue : .clear, lineWidth: 1)
      }
      .overlay(alignment: .trailing) {
        Button(action: { store.isShowConfirmPassword.toggle() }) {
          Image(systemName: store.isShowConfirmPassword ? "eye" : "eye.slash")
            .foregroundStyle(.black)
            .padding(.trailing, 12)
        }
      }
      .onChange(of: store.confirmPasswordText) { _, new in
        store.isValidConfirmPassword = isValidConfirm(text: new)
      }
      if !store.isValidConfirmPassword {
        HStack {
          Text("비밀번호가 일치하지 않습니다.")
            .font(.footnote)
            .foregroundStyle(.red)
            .padding(.top, -12)

          Spacer()
        }
      }

      Button(action: {
        store.send(.onTapSignUp)
      }) {
        Text("Sign Up")
          .foregroundStyle(.white)
          .frame(height: 50)
          .frame(maxWidth: .infinity)
          .background(.pink)
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .opacity(isActiveSignUp ? 1.0 : 0.3)
      }
      .disabled(!isActiveSignUp)

      Button(action: { store.send(.routeToSignIn) }) {
        HStack {
          Text("Already have an account?")

          Text("Log In here")
            .fontWeight(.bold)
        }
        .font(.callout)
      }

      Spacer()
    }
    .padding(.horizontal, 16)
    .padding(.top, 72)
    .toolbar(.hidden, for: .navigationBar)
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
    let passwordRegex = "^(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,20}$"

    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    return passwordPredicate.evaluate(with: password)
  }
}
