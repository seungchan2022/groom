import ComposableArchitecture
import DesignSystem
import PhotosUI
import SwiftUI

// MARK: - UpdateProfileImagePage

struct UpdateProfileImagePage {
  @Bindable var store: StoreOf<UpdateProfileImageReducer>
}

// MARK: View

extension UpdateProfileImagePage: View {
  var body: some View {
    ScrollView {
      VStack {
        Button(action: {
          store.isShowPhotoPicker = true
        }) {
          VStack {
            RemoteImage(
              url: store.item.photoURL ?? "",
              placeholder: {
                Image(systemName: "person.circle")
                  .resizable()
                  .frame(width: 200, height: 200)
              })
              .scaledToFill()
              .frame(width: 200, height: 200)
              .clipShape(Circle())
          }
        }
        VStack {
          Text("이메일: \(store.item.email ?? "")")

          Text("이름: \(store.item.userName ?? "")")
        }
        .padding(.top, 32)
      }

      Divider()
        .padding(.top, 32)
    }
    .navigationTitle("")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden()
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button(action: { store.send(.routeToBack) }) {
          Image(systemName: "chevron.left")
            .imageScale(.large)
        }
      }

      ToolbarItem(placement: .topBarTrailing) {
        Button(action: { store.send(.deleteProfileImage) }) {
          Text("프로필 이미지 삭제")
            .font(.callout)
        }
      }
    }
    .photosPicker(
      isPresented: $store.isShowPhotoPicker,
      selection: $store.selectedImage)
    .onChange(of: store.selectedImage) { _, new in
      Task {
        guard let item = new else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }

        store.send(.updateProfileImage(data))
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
