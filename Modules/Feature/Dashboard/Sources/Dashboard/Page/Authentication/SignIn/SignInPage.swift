import AuthenticationServices
import ComposableArchitecture
import GoogleSignIn
import GoogleSignInSwift
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
  @Environment(\.colorScheme) private var colorScheme
}

extension SignInPage {
  private var isActiveSignIn: Bool {
    !store.emailText.isEmpty && !store.emailText.isEmpty
  }

  private var isLoading: Bool {
    store.fetchSignIn.isLoading
      || store.fetchResetPassword.isLoading
      || store.fetchGoogleSignIn.isLoading
  }
}

// MARK: View

extension SignInPage: View {
  var body: some View {
    ScrollView {
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
              .stroke(isFocus == .email ? .blue : .clear, lineWidth: 1)
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
            .stroke(isFocus == .password ? .blue : .clear, lineWidth: 1)
        }

        .overlay(alignment: .trailing) {
          Button(action: { store.isShowPassword.toggle() }) {
            Image(systemName: store.isShowPassword ? "eye" : "eye.slash")
              .foregroundStyle(.black)
              .padding(.trailing, 12)
          }
        }

        HStack {
          Spacer()

          Button(action: {
            store.state.checkToEmail = ""
            store.isShowReset = true
          }) {
            Text("Forgot Password?")
              .font(.callout)
              .fontWeight(.bold)
          }
        }

        Button(action: { store.send(.onTapSignIn) }) {
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

        GoogleSignInButton(
          viewModel: GoogleSignInButtonViewModel(
            scheme: .dark,
            style: .wide,
            state: .normal))
        {
          store.send(.onTapGoogleSignIn)
        }

        Button(action: { }) {
          SignWithAppleButtonViewRepresentable(
            buttonType: .default,
            buttonStyle: .black)
            .allowsHitTesting(false)
            .frame(height: 45)
        }
      }
    }
    .alert(
      "Reset Password",
      isPresented: $store.isShowReset,
      actions: {
        TextField("이메일", text: $store.checkToEmail)
          .autocorrectionDisabled(true)

        Button(role: .cancel, action: { }) {
          Text("취소")
        }

        Button(action: { store.send(.onTapResetPassword) }) {
          Text("확인")
        }
      },
      message: {
        Text("계정과 연결된 이메일 주소를 입력하면, 비밀번호 재설정 링크가 이메일로 전송됩니다.")
      })
    .padding(.horizontal, 16)
    .toolbar(.visible, for: .navigationBar)
    .setRequestFlightView(isLoading: isLoading)
    .onAppear {
      isFocus = .email
    }
  }
}

// MARK: - SignWithAppleButtonViewRepresentable

struct SignWithAppleButtonViewRepresentable: UIViewRepresentable {
  let buttonType: ASAuthorizationAppleIDButton.ButtonType
  let buttonStyle: ASAuthorizationAppleIDButton.Style

  func makeUIView(context _: Context) -> some UIView {
    ASAuthorizationAppleIDButton(authorizationButtonType: buttonType, authorizationButtonStyle: buttonStyle)
  }

  func updateUIView(_: UIViewType, context _: Context) { }
}
