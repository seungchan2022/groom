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

            Text(store.item.email ?? "")
          }

          Spacer()
        }
        .padding(.horizontal, 16)

        Divider()

        HStack {
          VStack(alignment: .leading, spacing: 12) {
            Text("이름")
            Text(store.item.userName ?? "")
          }

          Spacer()

          Button(action: {
            store.userName = ""
            store.isShowUpdateUser = true
          }) {
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
      "이름을 변경하시겠습니까?",
      isPresented: $store.isShowUpdateUser,
      actions: {
        TextField("이름", text: $store.userName)
          .autocorrectionDisabled(true)

        Button(role: .cancel, action: { }) {
          Text("취소")
        }

        Button(action: { store.send(.onTapUpdateUserName) }) {
          Text("확인")
        }
      },
      message: {
        Text("이름을 변경하시고 싶으면, 변경하고 싶으신 이름을 작성하시고 확인을 눌러주세요.")
      })
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
    .onAppear {
      store.send(.getUserInfo)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
