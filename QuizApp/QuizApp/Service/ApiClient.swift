//
//  ApiClient.swift
//  QuizApp
//
//  Created by Toma Puljak on 09/05/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import UIKit

class ApiClient {
    private var baseUrl: String = ""
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    public func getQuizData() -> Result<GetQuizzesResponse?, NetworkError> {
        guard let url = URL(string: self.baseUrl + "/quizzes") else {
            return .failure(.url)
        }
        
        var result: Result<GetQuizzesResponse?, NetworkError>!
        
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                do {
                    let res = try JSONDecoder().decode(GetQuizzesResponse.self, from: data)
                    
                    result = .success(res)
                } catch _ {
                    result = .failure(.server)
                }
            } else {
                result = .failure(.server)
            }
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        return result
    }
    
    public func authorize(username: String, password: String) -> Result<UserIdTokenResponse?, NetworkError> {
        guard let url = URL(string: self.baseUrl + "/session") else {
            return .failure(.url)
        }
        
        let json: [String: Any] = ["username": username, "password": password]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var result: Result<UserIdTokenResponse?, NetworkError>!
        
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                do {
                    let res = try JSONDecoder().decode(UserIdTokenResponse.self, from: data)
                    
                    UserDefaults.standard.set(res.token, forKey: "token")
                    UserDefaults.standard.set(res.user_id, forKey: "userId")
                    result = .success(res)
                } catch _ {
                    result = .failure(.server)
                }
            } else {
                result = .failure(.server)
            }
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        return result
    }
    
    public func sendQuizResults(quizId: Int, time: TimeInterval, nOfCorrect: Int) -> HTTPURLResponse {
        let url = URL(string: self.baseUrl + "/result")!
        
        let userId = UserDefaults.standard.integer(forKey: "userId")
        let json: [String: Any] = ["quiz_id": quizId, "user_id": userId, "time": time, "n_of_correct": nOfCorrect]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let token = UserDefaults.standard.string(forKey: "token")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        var result: HTTPURLResponse!
        
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            result = response as? HTTPURLResponse
            
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        return result
    }
    
    public func getQuizLeaderboard(quizId: Int) -> Result<[LeaderboardScore]?, NetworkError> {
        guard let url = URL(string: self.baseUrl + "/score?quiz_id=" + String(quizId)) else {
            return .failure(.url)
        }
        
        var result: Result<[LeaderboardScore]?, NetworkError>!
        
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                do {
                    let res = try JSONDecoder().decode([LeaderboardScore].self, from: data)
                    
                    result = .success(res)
                } catch _ {
                    result = .failure(.server)
                }
            } else {
                result = .failure(.server)
            }
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        return result
    }
}
