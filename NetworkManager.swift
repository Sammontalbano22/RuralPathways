// NetworkManager.swift
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let apiKey = Config.College_Scorecard
    private let baseURL = "https://api.data.gov/ed/collegescorecard/v1/schools"
    
    /// Fetches colleges based on search query and state filter.
    /// - Parameters:
    ///   - searchQuery: Optional search term for college name.
    ///   - stateFilter: Optional comma-separated state abbreviations to filter colleges.
    ///   - completion: Completion handler with Result containing array of `CollegeData` or `Error`.
    func fetchColleges(searchQuery: String?, stateFilter: String?, completion: @escaping (Result<[CollegeData], Error>) -> Void) {
        var queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "fields", value: "id,school.name,school.city,school.state,school.zip,school.url,latest.admissions.admission_rate.overall,latest.student.size,latest.admissions.sat_scores.average.overall"),
            URLQueryItem(name: "per_page", value: "100")
        ]
        
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            queryItems.append(URLQueryItem(name: "school.name", value: searchQuery))
        }
        
        if let stateFilter = stateFilter, !stateFilter.isEmpty {
            queryItems.append(URLQueryItem(name: "school.state", value: stateFilter))
        }
        
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            print("Invalid URL components.")
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle network error
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            // Validate data
            guard let data = data else {
                print("No data received from College API.")
                completion(.failure(NetworkError.noData))
                return
            }
            
            // Decode the response
            do {
                let decoder = JSONDecoder()
                let collegeResponse = try decoder.decode(CollegeResponse.self, from: data)
                completion(.success(collegeResponse.results))
            } catch {
                print("Error decoding College API response: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

// Define Network Errors
enum NetworkError: Error {
    case invalidURL
    case noData
}

