import ComposableArchitecture
import SwiftUI

// MARK: - ResetPasswordPage

struct ResetPasswordPage {
  @Bindable var store: StoreOf<ResetPasswordReducer>

  @FocusState private var isFocus: Bool
}

extension ResetPasswordPage {
  private var isActive: Bool {
    !store.emailText.isEmpty
  }
}

// MARK: View

extension ResetPasswordPage: View {
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
        .focused($isFocus)
        .textInputAutocapitalization(.never)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
          RoundedRectangle(cornerRadius: 10)
            .stroke(isFocus ? .blue : .clear, lineWidth: 1)
        }

      Button(action: { }) {
        Text("Send Password Rest")
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
}
