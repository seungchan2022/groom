import ComposableArchitecture
import SwiftUI

// MARK: - UpdateProfilePage

struct UpdateProfilePage {
  @Bindable var store: StoreOf<UpdateProfileReducer>
}

// MARK: View

extension UpdateProfilePage: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        Image(systemName: "person.circle")
          .resizable()
          .frame(width: 200, height: 200)

        Divider()
          .padding(.top, 32)

        HStack {
          VStack(alignment: .leading, spacing: 12) {
            Text("이메일")

            Text("test@test.com")
          }

          Spacer()
        }
        .padding(.horizontal, 16)

        Divider()

        HStack {
          VStack(alignment: .leading, spacing: 12) {
            Text("이름")
            Text("User Name")
          }

          Spacer()

          Button(action: { }) {
            Text("변경")
          }
        }
        .padding(.horizontal, 16)

        Divider()

        HStack {
          VStack(alignment: .leading, spacing: 12) {
            Text("비밀번호")
            Text("************")
          }

          Spacer()

          Button(action: { store.send(.routeToUpdatePassword) }) {
            Text("변경")
          }
        }
        .padding(.horizontal, 16)

        Divider()

        Button(action: { store.isShowDeleteUser = true }) {
          Text("계정 탈퇴")
        }
        .padding(.top, 64)
      }
    }
    .alert(
      "계정을 탈퇴 하시겠습니까?",
      isPresented: $store.isShowDeleteUser,
      actions: {
        Button(role: .cancel, action: { }) {
          Text("취소")
        }

        Button(action: { store.send(.onTapDeleteUser) }) {
          Text("계정 탈퇴")
        }
      })
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button(action: { store.send(.onTapClose) }) {
          Image(systemName: "xmark")
            .imageScale(.large)
        }
      }
    }
  }
}
