import SwiftUI
import ComposableArchitecture
import DesignSystem

// MARK: - ExplorePage

struct ExplorePage {
  @Bindable var store: StoreOf<ExploreReducer>
}

// MARK: View

extension ExplorePage: View {
  var body: some View {
    VStack {
      if store.isShowSearchDestination {
        VStack {
          
          HStack {
            Button(action: {
              withAnimation(.snappy) {
                store.isShowSearchDestination = false
              }
            }) {
              Image(systemName: "xmark.circle")
                .imageScale(.large)
                .foregroundStyle(.black)
            }
            
            Spacer()
            
            Button(action: {
              store.destinationText = ""
              store.peopleCount = .zero
              store.fromDate = .now
              store.toDate = .now
              withAnimation(.snappy) {
                store.isSelectedOption = .location
              }
            }) {
              Text("Clear")
                .font(.title2)
                .foregroundStyle(.black)
            }
          }
          .padding(.horizontal, 16)
          
          // Where to? <=> Where
          VStack(alignment: .leading) {
            if store.isSelectedOption == .location {
              
              Text("Where to?")
                .font(.title2)
                .fontWeight(.semibold)
              
              HStack {
                Image(systemName: "magnifyingglass")
                  .imageScale(.small)
                
                TextField("Search destinations", text: $store.destinationText)
                  .font(.subheadline)
              }
              .padding(8)
              .overlay {
                RoundedRectangle(cornerRadius: 10)
                  .stroke(lineWidth: 1)
                  .foregroundStyle(Color(.systemGray4))
              }
            } else {
              HStack {
                Text("Where")
                  .foregroundStyle(.gray)
                
                Spacer()
                
                Text("Add destination")
              }
              .fontWeight(.semibold)
              .font(.subheadline)
            }
          }
          .padding()
          .background(.white)
          .clipShape(RoundedRectangle(cornerRadius: 10))
          .padding()
          .shadow(radius: 10)
          .onTapGesture {
            withAnimation(.snappy) {
              store.isSelectedOption = .location
            }
          }
          
          
          // When's you trip? <=> When
          VStack(alignment: .leading) {
            if store.isSelectedOption == .date {
              Text("When's your trip?")
                .font(.title2)
                .fontWeight(.semibold)
              
              DatePicker(
                "Form",
                selection: $store.fromDate,
                displayedComponents: [.date])
              .datePickerStyle(.compact)
              
              Divider()
              
              DatePicker(
                "To",
                selection: $store.toDate,
                displayedComponents: [.date])
              .datePickerStyle(.compact)
              
              
            } else {
              HStack {
                Text("When")
                  .foregroundStyle(.gray)
                
                Spacer()
                
                Text("Add dates")
              }
              .fontWeight(.semibold)
              .font(.subheadline)
            }
          }
          .padding()
          .background(.white)
          .clipShape(RoundedRectangle(cornerRadius: 10))
          .padding()
          .shadow(radius: 10)
          .onTapGesture {
            withAnimation(.snappy) {
              store.isSelectedOption = .date
            }
          }
          
          
          // Who's coming? <=> Who
          VStack(alignment: .leading) {
            if store.isSelectedOption == .guest {
              Text("Who's coming?")
                .font(.title2)
                .fontWeight(.semibold)
              
              Stepper(
                "\(store.peopleCount) Adults",
                onIncrement: {
                  store.peopleCount += 1
                }, onDecrement: {
                  store.peopleCount += 1
                })
            } else {
              HStack {
                Text("Who")
                  .foregroundStyle(.gray)
                
                Spacer()
                
                Text("Add guests")
              }
              .fontWeight(.semibold)
              .font(.subheadline)
            }
          }
          .padding()
          .background(.white)
          .clipShape(RoundedRectangle(cornerRadius: 10))
          .padding()
          .shadow(radius: 10)
          .onTapGesture {
            withAnimation(.snappy) {
              store.isSelectedOption = .guest
            }
          }
          
          Spacer()
        }
      }
      
      else {
        HStack {
          Image(systemName: "magnifyingglass")
          
          VStack(alignment: .leading) {
            Text("Where to?")
              .font(.footnote)
              .fontWeight(.semibold)
            
            Text("Anywhere - Any Week - Add guests")
              .font(.caption2)
              .foregroundStyle(.gray)
          }
          
          Spacer()
          
          Button(action: { }) {
            Image(systemName: "line.3.horizontal.decrease.circle")
              .foregroundStyle(.black)
          }
        }
        .onTapGesture {
          withAnimation(.snappy) {
            store.isShowSearchDestination = true
          }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .overlay {
          Capsule()
            .stroke(lineWidth: 0.5)
            .foregroundStyle(.gray.opacity(0.4))
        } // Search Bar
        .padding()
        
        
        ScrollView {
          LazyVStack(spacing: 48) {
            ForEach(0..<5) { _ in
              Button(action:  { store.send(.routeToDetail) }) {
                VStack(spacing: 8) {
                  TabView {
                    ForEach(DesignSystemImage.allCases.prefix(4), id: \.self) { item in
                      item.image
                        .resizable()
                        .scaledToFill()
                    }
                  }
                  .frame(height: 320)
                  .clipShape(RoundedRectangle(cornerRadius: 10))
                  .tabViewStyle(.page)
                  
                  HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                      Text("Miami, Florida")
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                      
                      Text("12 mi away")
                        .foregroundStyle(.gray)
                      
                      HStack {
                        Text("$567")
                        
                          .fontWeight(.semibold)
                        
                        Text("night")
                      }
                      .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    HStack {
                      Image(systemName: "star.fill")
                      
                      Text("4.86")
                    }
                    .foregroundStyle(.black)
                  }
                  .font(.footnote)
                }
              }
            }
          }
          .padding(.horizontal, 16)
        }
      }
      
    }
    .toolbar(.hidden, for: .navigationBar)
  }
}
