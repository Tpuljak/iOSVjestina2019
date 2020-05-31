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
    let questions: Array<Question>
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
