//
//  QuestionView.swift
//  QuizApp
//
//  Created by Toma Puljak on 30/05/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import UIKit
import PureLayout

class QuestionView : UIView {
    
    var titleLabel: UILabel!
    var buttonStackView: UIStackView!
    var parentQuizViewController: SingleQuizViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(question: Question) {
        DispatchQueue.main.async {
            self.titleLabel = UILabel()
            self.titleLabel.font = UIFont.systemFont(ofSize: 20)
            self.titleLabel.textColor = UIColor.darkGray
            self.titleLabel.text = question.question
            self.titleLabel.numberOfLines = 0
            self.titleLabel.textAlignment = .center
            
            self.addSubview(self.titleLabel)
            
            self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
            self.titleLabel.autoPinEdge(.top, to: .top, of: self, withOffset: 16.0)
            self.titleLabel.autoAlignAxis(.vertical, toSameAxisOf: self)
            self.titleLabel.autoSetDimension(.width, toSize: self.bounds.size.width * 0.8)
            
            self.buttonStackView = UIStackView()
            
            self.addSubview(self.buttonStackView)
            
            self.buttonStackView.translatesAutoresizingMaskIntoConstraints = false
            self.buttonStackView.autoPinEdge(.top, to: .bottom, of: self.titleLabel, withOffset: 16.0)
            self.buttonStackView.autoAlignAxis(.vertical, toSameAxisOf: self)
            self.buttonStackView.autoSetDimensions(to: CGSize(width: self.bounds.size.width * 0.8, height: self.bounds.size.height * 0.7))
            
            var previous: UIButton?
            question.answers.enumerated().forEach{ index, answer in
                let answerButton = UIButton()
                answerButton.setTitle(answer, for: .normal)
                answerButton.setTitleColor(UIColor.init(rgb: 0x007AFF), for: .normal)
                answerButton.tag = index == question.correct_answer ? 1 : 0
                answerButton.addTarget(self, action: #selector(self.answerButtonAction), for: UIControl.Event.touchUpInside)
                
                self.buttonStackView.addSubview(answerButton)
                
                answerButton.translatesAutoresizingMaskIntoConstraints = false
                answerButton.centerXAnchor.constraint(equalTo: self.buttonStackView.centerXAnchor).isActive = true
                answerButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
                answerButton.widthAnchor.constraint(equalTo: self.buttonStackView.widthAnchor).isActive = true
                
                if let previous = previous {
                    answerButton.autoPinEdge(.top, to: .bottom, of: previous, withOffset: 10)
                } else {
                    answerButton.autoPinEdge(.top, to: .top, of: self.buttonStackView, withOffset: 10)
                }
                
                previous = answerButton
            }
        }
    }
    
    @objc func answerButtonAction(sender: UIButton) {
        if sender.tag == 1 {
            sender.backgroundColor = UIColor.green
            parentQuizViewController?.correctAnswers += 1
        } else {
            sender.backgroundColor = UIColor.red
        }
        
        let newOffset = CGPoint(x: (parentQuizViewController?.scrollView.contentOffset.x ?? 0) + CGFloat(self.bounds.size.width), y: 0)
        
        if (newOffset.x >= parentQuizViewController?.scrollView.contentSize.width ?? 0) {
            parentQuizViewController?.quizEnded()
        }
        
        parentQuizViewController?.scrollView.setContentOffset(newOffset, animated: true)
    }
}
