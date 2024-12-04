import SwiftUI

struct CollegeSearchView: View {
    // Filter States
    @Binding var searchQuery: String
    @Binding var selectedStates: Set<String>
    @Binding var admissionRateRange: ClosedRange<Double>
    @Binding var studentSizeRange: ClosedRange<Int>
    @Binding var minimumSATScore: Int

    // Available States (You can customize this list)
    let states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA",
                 "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
                 "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
                 "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
                 "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]

    var body: some View {
        Form {
            // Search by Name
            Section(header: Text("Search by Name")) {
                TextField("Enter college name", text: $searchQuery)
                    .autocapitalization(.words)
            }

            // Filter by State
            Section(header: Text("Filter by State")) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(states, id: \.self) { state in
                            Button(action: {
                                if selectedStates.contains(state) {
                                    selectedStates.remove(state)
                                } else {
                                    selectedStates.insert(state)
                                }
                            }) {
                                Text(state)
                                    .padding(8)
                                    .background(selectedStates.contains(state) ? Color.blue : Color.gray.opacity(0.3))
                                    .foregroundColor(selectedStates.contains(state) ? .white : .black)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }

            // Filter by Admission Rate
            Section(header: Text("Admission Rate (%)")) {
                VStack {
                    RangeSlider(
                        value: $admissionRateRange,
                        inRange: 0...100,
                        step: 0.1,
                        format: "%.1f"
                    )
                    Text("Range: \(admissionRateRange.lowerBound, specifier: "%.1f")% - \(admissionRateRange.upperBound, specifier: "%.1f")%")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }

            // Filter by Student Size
            Section(header: Text("Student Size")) {
                VStack {
                    RangeSlider(
                        value: Binding(
                            get: {
                                ClosedRange<Double>(
                                    uncheckedBounds: (
                                        Double(studentSizeRange.lowerBound),
                                        Double(studentSizeRange.upperBound)
                                    )
                                )
                            },
                            set: {
                                studentSizeRange = Int($0.lowerBound)...Int($0.upperBound)
                            }
                        ),
                        inRange: 0...100000,
                        step: 100,
                        format: "%.0f"
                    )
                    Text("Range: \(studentSizeRange.lowerBound) - \(studentSizeRange.upperBound)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }

            // Filter by Minimum SAT Score
            Section(header: Text("Minimum Average SAT Score")) {
                Stepper(value: $minimumSATScore, in: 400...1600, step: 10) {
                    Text("\(minimumSATScore)")
                }
            }
        }
    }
}

struct CollegeSearchView_Previews: PreviewProvider {
    static var previews: some View {
        CollegeSearchView(
            searchQuery: .constant(""),
            selectedStates: .constant(Set<String>()),
            admissionRateRange: .constant(20.0...80.0),
            studentSizeRange: .constant(1000...10000),
            minimumSATScore: .constant(1000)
        )
    }
}

