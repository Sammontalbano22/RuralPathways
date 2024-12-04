// CollegeData.swift
import Foundation

struct CollegeResponse: Decodable {
    let results: [CollegeData]
}

struct CollegeData: Identifiable, Decodable {
    var id: Int {
        unitId
    }
    let unitId: Int
    let name: String
    let city: String?
    let state: String?
    let zip: String?
    let url: String?
    let admissionRate: Double?
    let studentSize: Int?
    let satAverage: Int?

    enum CodingKeys: String, CodingKey {
        case unitId = "id"
        case name = "school.name"
        case city = "school.city"
        case state = "school.state"
        case zip = "school.zip"
        case url = "school.url"
        case admissionRate = "latest.admissions.admission_rate.overall"
        case studentSize = "latest.student.size"
        case satAverage = "latest.admissions.sat_scores.average.overall"
    }
}

