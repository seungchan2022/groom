import ComposableArchitecture
import SwiftUI

// MARK: - Focus

private enum Focus {
  case password
  case confirmPassword
}

// MARK: - UpdatePasswordPage

struct UpdatePasswordPage {
  @Bindable var store: StoreOf<UpdatePasswordReducer>

  @FocusState private var isFocus: Focus?
}

extension UpdatePasswordPage {
  private var isActive: Bool {
    Validator
      .validatePassword(password: store.passwordText) && isValidConfirm(text: store.confirmPasswordText)
  }

  private func isValidConfirm(text: String) -> Bool {
    store.passwordText == text
  }

}

// MARK: View

extension UpdatePasswordPage: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        Image(systemName: "paperplane")
          .resizable()
          .frame(width: 150, height: 150)
          .fontWeight(.light)
          .foregroundStyle(.pink)

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

        Button(action: { store.send(.onTapUpdatePassword) }) {
          Text("Update Password")
            .foregroundStyle(.white)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(.pink)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .opacity(isActive ? 1.0 : 0.3)
        }
        .disabled(!isActive)
      }
      .padding(.horizontal, 16)
    }
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle("비밀번호 변경")
    .onAppear {
      isFocus = .password
    }
  }
}
