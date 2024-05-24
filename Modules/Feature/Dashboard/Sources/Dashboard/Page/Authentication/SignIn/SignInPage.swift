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
    !store.emailText.isEmpty && !store.emailText.isEmpty
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
            .stroke(isFocus == .email ? .blue : .clear, lineWidth: 1)
        }

      SecureField(
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
            .stroke(isFocus == .password ? .blue : .clear, lineWidth: 1)
        }

      HStack {
        Spacer()

        Button(action: { }) {
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

      Spacer()
    }
    .padding(.horizontal, 16)
    .toolbar(.visible, for: .navigationBar)
    .onAppear {
      isFocus = .email
    }
  }
}
