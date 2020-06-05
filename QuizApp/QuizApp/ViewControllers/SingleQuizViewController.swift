//
//  SingleQuizViewController.swift
//  QuizApp
//
//  Created by Toma Puljak on 31/05/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import Foundation
import UIKit

class SingleQuizViewController : UIViewController {
    
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func startQuizAction(_ sender: UIButton) {
        self.scrollView.isHidden = false
        self.quizStartTime = Date()
        sender.isEnabled = false
    }
    
    private var apiClient = ApiClient(baseUrl: "https://iosquiz.herokuapp.com/api")
    
    var quiz: Quiz? = nil
    var quizStartTime = Date()
    var quizEndTime = Date()
    var correctAnswers = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizTitleLabel.text = quizTitle
        
        if imageUrl != nil {
            quizImageView.load(url: imageUrl!)
        } else {
            quizImageView.isHidden = true
        }
        
        questions.enumerated().forEach{ (index, question) in
            let qv = QuestionView(frame: CGRect(x: CGFloat(index) * scrollView.bounds.size.width, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height))
            
            qv.parentQuizViewController = self
            qv.setup(question: question)
            
            scrollView.addSubview(qv)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(questions.count) * scrollView.frame.size.width, height: scrollView.frame.size.height)
    }
    
    var quizTitle: String {
        return quiz?.title ?? ""
    }
    
    var imageUrl: URL? {
        return quiz?.image ?? nil
    }
    
    var questions: [Question] {
        return quiz?.questions ?? []
    }
    
    func quizEnded() {
        quizEndTime = Date()
        
        let result = apiClient.sendQuizResults(quizId: quiz?.id ?? -1, time: DateInterval(start: quizStartTime, end: quizEndTime).duration , nOfCorrect: correctAnswers)
        print(result.statusCode)
        
        navigationController?.popViewController(animated: true)
    }
}
