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
        guard let  url = URL(string: self.baseUrl + "/quizzes") else {
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
}
