//
//  SingleQuizViewController.swift
//  QuizApp
//
//  Created by Toma Puljak on 31/05/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import Foundation
import UIKit

class SingleQuizViewController : UIViewController, QuestionAnsweredDelegate {
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var startQuizButton: UIButton!
    @IBOutlet weak var showLeaderBoardButton: UIButton!
    
    @IBAction func startQuizAction(_ sender: UIButton) {
        self.scrollView.isHidden = false
        self.quizStartTime = Date()
        sender.isEnabled = false
        self.showLeaderBoardButton.isEnabled = false
    }
    
    private var apiClient = ApiClient(baseUrl: "https://iosquiz.herokuapp.com/api")
    
    var quiz: Quiz? = nil
    var quizStartTime = Date()
    var quizEndTime = Date()
    var correctAnswers = 0
    
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizTitleLabel.text = quizTitle
        
        if imageUrl != nil {
            quizImageView.load(url: imageUrl!)
        } else {
            quizImageView.isHidden = true
        }
        
        scrollView.autoSetDimensions(to: CGSize(width: view.bounds.size.width * 0.9, height: view.bounds .size.height * 0.4))
        
        questions.enumerated().forEach{ (index, question) in
            let qv = QuestionView(frame: CGRect(x: CGFloat(index) * scrollView.frame.size.width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
            
            qv.questionAnsweredDelegate = self
            qv.setup(question: question)
            
            scrollView.addSubview(qv)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(questions.count) * scrollView.frame.size.width, height: scrollView.frame.size.height)
        
        showLeaderBoardButton.addTarget(self, action: #selector(self.showLeaderboardAction), for: UIControl.Event.touchUpInside)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            quizTitleLabel.autoSetDimension(.width, toSize: view.bounds.size.width * 0.8)
            quizTitleLabel.autoPinEdge(.top, to: .top, of: view, withOffset: 120)
            quizTitleLabel.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            quizImageView.autoSetDimensions(to: CGSize(width: 150, height: 150))
            quizImageView.autoPinEdge(.top, to: .bottom, of: quizTitleLabel, withOffset: 20)
            quizImageView.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            showLeaderBoardButton.autoPinEdge(.top, to: .bottom, of: quizImageView, withOffset: 20)
            showLeaderBoardButton.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            startQuizButton.autoPinEdge(.top, to: .bottom, of: showLeaderBoardButton, withOffset: 20)
            startQuizButton.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            scrollView.autoPinEdge(.top, to: .bottom, of: startQuizButton, withOffset: 20)
            scrollView.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
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
    
    @objc func showLeaderboardAction(_ sender: UIButton) {
        
    }
    
    func gameEnded() {
        quizEndTime = Date()
        
        let result = apiClient.sendQuizResults(quizId: quiz?.id ?? -1, time: DateInterval(start: quizStartTime, end: quizEndTime).duration , nOfCorrect: correctAnswers)
        print(result.statusCode)
        
        navigationController?.popViewController(animated: true)
    }
    
    func anwsered(_ correct: Bool) {
        if correct {
            correctAnswers += 1
        }
        
        let newOffset = CGPoint(x: scrollView.contentOffset.x + CGFloat(scrollView.frame.size.width), y: 0)
        
        if newOffset.x >= scrollView.contentSize.width - scrollView.frame.size.width {
            gameEnded()
            return
        }
        
        scrollView.setContentOffset(newOffset, animated: true)
    }
}
