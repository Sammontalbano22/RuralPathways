// CollegeDetailView.swift
import SwiftUI

struct CollegeDetailView: View {
    let college: CollegeData
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(college.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom)
                
                Group {
                    if let city = college.city, let state = college.state, let zip = college.zip {
                        Text("Location: \(city), \(state) \(zip)")
                            .font(.title2)
                    } else if let city = college.city, let state = college.state {
                        Text("Location: \(city), \(state)")
                            .font(.title2)
                    } else {
                        Text("Location: N/A")
                            .font(.title2)
                    }
                    
                    if let urlString = college.url, let url = URL(string: urlString) {
                        Link("Visit Website", destination: url)
                            .font(.headline)
                            .foregroundColor(.blue)
                    } else {
                        Text("Website: N/A")
                            .font(.headline)
                    }
                    
                    if let rate = college.admissionRate {
                        Text("Admission Rate: \((rate * 100).formatted(.number.precision(.fractionLength(1))))%")
                            .font(.headline)
                    } else {
                        Text("Admission Rate: N/A")
                            .font(.headline)
                    }
                    
                    if let size = college.studentSize {
                        Text("Student Size: \(size)")
                            .font(.headline)
                    } else {
                        Text("Student Size: N/A")
                            .font(.headline)
                    }
                    
                    if let sat = college.satAverage {
                        Text("Average SAT Score: \(sat)")
                            .font(.headline)
                    } else {
                        Text("Average SAT Score: N/A")
                            .font(.headline)
                    }
                }
                .padding(.vertical, 2)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(college.name)
    }
}

struct CollegeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample data for preview
        let sampleCollege = CollegeData(
            unitId: 12345,
            name: "Sample University",
            city: "Sample City",
            state: "SC",
            zip: "12345",
            url: "www.sampleuniversity.edu",
            admissionRate: 0.45,
            studentSize: 5000,
            satAverage: 1200
        )
        
        NavigationView {
            CollegeDetailView(college: sampleCollege)
        }
    }
}


