// CollegeListView.swift
import SwiftUI

struct CollegeListView: View {
    // Filter States
    @State private var searchQuery: String = ""
    @State private var selectedStates: Set<String> = []
    @State private var admissionRateRange: ClosedRange<Double> = 20.0...80.0
    @State private var studentSizeRange: ClosedRange<Int> = 1000...10000
    @State private var minimumSATScore: Int = 1000

    // Data States
    @State private var colleges: [CollegeData] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationView {
            VStack {
                // Search and Filter View
                CollegeSearchView(
                    searchQuery: $searchQuery,
                    selectedStates: $selectedStates,
                    admissionRateRange: $admissionRateRange,
                    studentSizeRange: $studentSizeRange,
                    minimumSATScore: $minimumSATScore
                )
                .frame(maxHeight: 400) // Adjust as needed

                // Search Button
                Button(action: fetchColleges) {
                    Text("Search")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding([.horizontal, .bottom])

                // Results
                Group {
                    if isLoading {
                        Spacer()
                        ProgressView("Loading Colleges...")
                        Spacer()
                    } else if let error = errorMessage {
                        Spacer()
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    } else if colleges.isEmpty {
                        Spacer()
                        Text("No colleges found with the selected criteria.")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    } else {
                        List(colleges) { college in
                            NavigationLink(destination: CollegeDetailView(college: college)) {
                                VStack(alignment: .leading) {
                                    Text(college.name)
                                        .font(.headline)
                                    if let city = college.city, let state = college.state {
                                        Text("\(city), \(state)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search Colleges")
            .onAppear(perform: fetchColleges)
        }
    }

    func fetchColleges() {
        isLoading = true
        errorMessage = nil

        // Prepare filter parameters
        let stateFilter = selectedStates.isEmpty ? nil : Array(selectedStates).joined(separator: ",")
       

        NetworkManager.shared.fetchColleges(
            searchQuery: searchQuery.isEmpty ? nil : searchQuery,
            stateFilter: stateFilter
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let fetchedColleges):
                    // Apply additional client-side filters
                    colleges = fetchedColleges.filter { college in
                        let admissionRateMatch = (college.admissionRate ?? 0) * 100 >= admissionRateRange.lowerBound &&
                            (college.admissionRate ?? 100) * 100 <= admissionRateRange.upperBound

                        let studentSizeMatch = (college.studentSize ?? 0) >= studentSizeRange.lowerBound &&
                            (college.studentSize ?? 0) <= studentSizeRange.upperBound

                        let satScoreMatch = (college.satAverage ?? 0) >= minimumSATScore

                        return admissionRateMatch && studentSizeMatch && satScoreMatch
                    }
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct CollegeListView_Previews: PreviewProvider {
    static var previews: some View {
        CollegeListView()
    }
}

