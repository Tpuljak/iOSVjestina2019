//
//  Types.swift
//  QuizApp
//
//  Created by Toma Puljak on 09/05/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import UIKit

enum NetworkError: Error {
    case url, server
}

struct UserIdTokenResponse: Codable {
    let user_id: Int
    let token: String
}

enum Category: String, CaseIterableDefaultsLast, Codable {
    case sports = "SPORTS", science = "SCIENCE", unkown
}

struct Question: Codable {
    let id: Int
    let question: String
    let answers: Array<String>
    let correct_answer: Int
}

struct Quiz: Codable {
    let id: Int
    let title: String
    let description: String
    let category: Category
    let level: Int
    let image: URL
    let questions: [Question]
    
    init(id: Int, title: String, description: String, category: Category, level: Int, image: URL, questions: [Question]) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.level = level
        self.image = image
        self.questions = questions
    }
}

final class LeaderboardScore : Codable {
    let username: String
    let score: Double?
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try map.decode(String.self, forKey: .username)
        
        let scoreString = try map.decode(String?.self, forKey: .score)
        self.score = Double(scoreString ?? "0")
    }
    
    private enum CodingKeys: CodingKey {
        case username
        case score
    }
}

struct GetQuizzesResponse: Codable {
    let quizzes: Array<Quiz>
}

func categoryToColor(category: Category) -> UIColor {
    switch category {
    case Category.sports:
        return UIColor.yellow
    case Category.science:
        return UIColor.cyan
    default:
        return UIColor.gray
    }
}

protocol QuestionAnsweredDelegate {
    func anwsered(_ correct: Bool)
}
