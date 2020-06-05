//
//  QuizTableCell.swift
//  QuizApp
//
//  Created by Toma Puljak on 31/05/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class QuizTableCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var difficultyIcon3: UIImageView!
    @IBOutlet weak var difficultyIcon2: UIImageView!
    @IBOutlet weak var difficultyIcon1: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.brown
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = UIColor.gray
        descriptionLabel.numberOfLines = 0
        
        quizImageView.autoPinEdge(.leading, to: .leading, of: self, withOffset: 5)
        quizImageView.autoPinEdge(.top, to: .top, of: self, withOffset: 10)
        quizImageView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: 10)
        quizImageView.autoSetDimension(.width, toSize: 150)
        quizImageView.autoSetDimension(.height, toSize: 150)
        
        titleLabel.autoPinEdge(.leading, to: .trailing, of: quizImageView, withOffset: 15)
        titleLabel.autoPinEdge(.top, to: .top, of: self, withOffset: 20)
        titleLabel.autoSetDimension(.width, toSize: self.bounds.size.width * 0.4)
        
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 20)
        descriptionLabel.autoPinEdge(.leading, to: .trailing, of: quizImageView, withOffset: 15)
        descriptionLabel.autoSetDimension(.width, toSize: self.bounds.size.width * 0.6)
        
        difficultyIcon1.autoSetDimensions(to: CGSize(width: 20, height: 20))
        difficultyIcon1.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -10)
        difficultyIcon1.autoPinEdge(.top, to: .top, of: self, withOffset: 20)
        difficultyIcon1.image = UIImage(systemName: "checkmark")
        
        difficultyIcon2.autoSetDimensions(to: CGSize(width: 20, height: 20))
        difficultyIcon2.autoPinEdge(.trailing, to: .leading, of: difficultyIcon1, withOffset: -5)
        difficultyIcon2.autoPinEdge(.top, to: .top, of: self, withOffset: 20)
        difficultyIcon2.image = UIImage(systemName: "checkmark")
        
        difficultyIcon3.autoSetDimensions(to: CGSize(width: 20, height: 20))
        difficultyIcon3.autoPinEdge(.trailing, to: .leading, of: difficultyIcon2, withOffset: -5)
        difficultyIcon3.autoPinEdge(.top, to: .top, of: self, withOffset: 20)
        difficultyIcon3.image = UIImage(systemName: "checkmark")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        descriptionLabel.text = ""
    }
    
    func setup(withQuiz quiz: Quiz) {
        titleLabel.text = quiz.title
        descriptionLabel.text = quiz.description
        
        if (quiz.image.absoluteString == "") {
            quizImageView.isHidden = true
        } else {
            quizImageView.load(url: quiz.image)
            quizImageView.backgroundColor = categoryToColor(category: quiz.category)
        }
        
        if quiz.level > 0 {
            difficultyIcon1.isHidden = false
        }
        
        if quiz.level > 1 {
            difficultyIcon2.isHidden = false
        }
        
        if quiz.level > 2 {
            difficultyIcon3.isHidden = false
        }
    }
}
