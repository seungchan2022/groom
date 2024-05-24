import ComposableArchitecture
import DesignSystem
import MapKit
import SwiftUI

// MARK: - DetailPage

struct DetailPage {
  @Bindable var store: StoreOf<DetailReducer>
}

// MARK: View

extension DetailPage: View {
  var body: some View {
    ScrollView {
      TabView {
        ForEach(DesignSystemImage.allCases.prefix(4), id: \.self) { item in
          item.image
            .resizable()
            .scaledToFill()
        }
      }
      .frame(height: 320)
      .tabViewStyle(.page)
      .overlay(alignment: .topLeading) {
        Button(action: { store.send(.routeToBack) }) {
          Image(systemName: "chevron.left")
            .foregroundStyle(.black)
            .background {
              Circle()
                .fill(.white)
                .frame(width: 32, height: 32)
            }
            .padding(.horizontal, 24)
            .padding(.top, 64)
        }
      }

      VStack(spacing: 16) {
        VStack(alignment: .leading, spacing: 8) {
          Text("Miami Villa")
            .font(.title)
            .fontWeight(.semibold)

          VStack(alignment: .leading) {
            HStack {
              Image(systemName: "star.fill")

              Text("4.86 - ")

              Button(action: { }) {
                Text("28 reviews")
                  .underline()
                  .fontWeight(.semibold)
              }
            }
            .foregroundStyle(.black)

            Text("Miami, Florida")
          }
          .font(.caption)
        }
        .padding(.horizontal, 16)

        .frame(maxWidth: .infinity, alignment: .leading)

        Divider()

        HStack {
          VStack(alignment: .leading) {
            Text("Entire villa hosted by John Smith")
              .font(.headline)
              .multilineTextAlignment(.leading)

            HStack {
              Text("4 guests -")
              Text("4 bedromms -")
              Text("4 beds -")
              Text("3 baths")
            }
            .font(.caption)
            .textScale(.secondary)
          }

          Spacer()

          DesignSystemImage.host.image
            .resizable()
            .scaledToFill()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
        }
        .padding(.horizontal, 16)

        Divider()

        VStack(alignment: .leading, spacing: 16) {
          HStack {
            Image(systemName: "door.left.hand.open")

            VStack(alignment: .leading) {
              Text("Self check-in")
                .font(.footnote)
                .fontWeight(.semibold)

              Text("Chcek yourself in with the keypad.")
                .font(.caption)
                .foregroundStyle(.gray)
            }

            Spacer()
          }

          HStack(spacing: 8) {
            Image(systemName: "medal")

            VStack(alignment: .leading) {
              Text("Superhose")
                .font(.footnote)
                .fontWeight(.semibold)

              Text("Superhosts are experienced, highly rated hosts who are commited to providing grate stars for guests.")
                .font(.caption)
                .foregroundStyle(.gray)
            }

            Spacer()
          }
        }
        .padding(.horizontal, 16)

        Divider()

        VStack(alignment: . leading, spacing: 16) {
          Text("Where you'll sleep")
            .font(.headline)

          ScrollView(.horizontal) {
            HStack(spacing: 16) {
              ForEach(1..<5) { item in
                VStack {
                  Image(systemName: "bed.double")

                  Text("Badroom \(item)")
                }
              }
              .padding()
              .overlay {
                RoundedRectangle(cornerRadius: 10)
                  .stroke(lineWidth: 1)
                  .foregroundStyle(.gray)
              }
            }
          }
          .scrollIndicators(.hidden)
          .scrollTargetBehavior(.paging)
          .scrollClipDisabled()
        }
        .padding(.horizontal, 16)

        Divider()

        VStack(alignment: .leading, spacing: 16) {
          Text("What this place offers")
            .font(.headline)

          HStack {
            Image(systemName: "wifi")

            Text("Wifi")
              .font(.footnote)

            Spacer()
          }

          HStack {
            Image(systemName: "shield.checkered")

            Text("Alarm System")
              .font(.footnote)

            Spacer()
          }

          HStack {
            Image(systemName: "building")

            Text("Balcony")
              .font(.footnote)

            Spacer()
          }

          HStack {
            Image(systemName: "washer")

            Text("Laundry")
              .font(.footnote)

            Spacer()
          }

          HStack {
            Image(systemName: "tv")

            Text("TV")
              .font(.footnote)

            Spacer()
          }
        }
        .padding(.horizontal, 16)

        Divider()

        VStack(alignment: .leading, spacing: 16) {
          Text("Where you'll be")
            .font(.headline)

          Map()
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal, 16)
      }
      .padding(.bottom, 100)
    }
    .ignoresSafeArea()
//    .overlay(alignment: .bottom) {
//      VStack {
//        Divider()
//          .padding(.bottom)
//
//        HStack {
//          VStack(alignment: .leading) {
//            Text("$500")
//              .font(.subheadline)
//              .fontWeight(.semibold)
//
//            Text("Total before taxes")
//              .font(.footnote)
//
//            Text("Oct 15 - 20")
//              .font(.footnote)
//              .fontWeight(.semibold)
//              .underline()
//          }
//
//          Spacer()
//
//          Button(action: { }) {
//            Text("Reserve")
//              .foregroundStyle(.white)
//              .font(.subheadline)
//              .fontWeight(.semibold)
//              .frame(width: 140, height: 40)
//              .background(.pink)
//              .clipShape(RoundedRectangle(cornerRadius: 10))
//          }
//
//        }
//        .padding(.horizontal, 32)
//
//      }
//      .background(.white)
//
//    }
    .toolbar(.hidden, for: .navigationBar)
  }
}
