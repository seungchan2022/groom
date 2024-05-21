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

      TextField(
        "",
        text: $store.confirmPasswordText,
        prompt: Text("Confirm Password"))
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

      Button(action: { }) {
        Text("Sign Up")
          .foregroundStyle(.white)
          .frame(height: 50)
          .frame(maxWidth: .infinity)
          .background(.pink)
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .opacity(isActiveSignUp ? 1.0 : 0.3)
      }
      .disabled(!isActiveSignUp)

      Button(action: { store.send(.routeToBack) }) {
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
