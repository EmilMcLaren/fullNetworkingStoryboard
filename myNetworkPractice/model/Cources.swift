//
//  File.swift
//  myNetworkPractice
//
//  Created by Emil on 18.09.2022.
//

import Foundation



struct Cources: Codable {
    let name: String?
    let imageUrl: String?
    let numberOfLessons: String?
    let numberOfTests: String?
    
//    enum CodingKeys: String, CodingKey {
//        case name = "Name"
//        case imageUrl = "ImageUrl"
//        case numberOfLessons = "Number_of_lessons"
//        case numberOfTests = "Number_of_tests"
//    }
    
    init(courseData: [String: Any]) {
        name = courseData["name"] as? String
        imageUrl = courseData["imageUrl"] as? String
        numberOfLessons = courseData["number_of_lessons"] as? String
        numberOfTests = courseData["number_of_tests"] as? String
}
    
    
    //MARK: проверить надо будет
    static func getCourses(from value: Any) -> [Cources] {
        guard let coursesData = value as? [[String: Any]] else { return [] }
        return coursesData.compactMap { Cources(courseData: $0) }
    }
    
}



struct WebDescription: Decodable {
    let cources: [Cources]?
    let websiteDescription: String?
    let websiteName: String?
}

struct CourseV3: Codable {
    let name: String
    let imageUrl: String
    let numberOfLessons: String
    let numberOfTests: String
}



















